module ActionEve
  
  class Base
    
    include Common
    
    def initialize(options, api=nil)
      @api ||= api
      @api ||= Comms::API.new(options)
      @options = options
    end
    
    def id
      @options[:id]
    end
    
    def type
      @options[:type]
    end
    
    def method_missing(method, *args)
      if @options.has_key?(method)
        @options[method]
      end
      raise(Exceptions::AttributeException,"That method is fucking missing, check under the cushion")
    end
    
  end
  
  class API < Base
    
    def initialize(*args)
      @store = Store.new
      @store << User.new(options_from_args!(args)) if args.length > 0
    end
    
    def store
      @store
    end
    
    def users
      @store.users
    end
    
    def <<(user)
      @store << user
    end
    
  end
  
  class Store
    # TODO: !!IMPORTANT!! - Implenet some sort of caching redis or mysql
    def initialize(*args)
      @users = {}
      args.each do |user|
        users[user.id] = user
      end
    end
    
    def <<(user)
      @users[user.id] = user
    end
    
    def users
      @users.values
    end
    
    def [](id)
      @users[id]
    end
    
  end

  class User < Base
    
    def initialize(*args)
      super(options_from_args!(args))
      raise(Exceptions::InputException, "ID is missing") unless @options[:id]
      raise(Exceptions::InputException, "API Key is missing") unless @options[:api_key]
    end
    
    def characters
      characters = []
      @api.characters.each do |character_id, character|
        characters << Character.new(character, @api)
      end
      characters
    end
    
  end
    
  class Character < Base

    def corporation
      Corporation.new({:id => corporation_id, :name => corporation_name}, @api, self)
    end
    
    def info
      character_info = @api.character_info(self.id)
      Character.new(character_info, @api)
    end
    
  end

  class Corporation < Base
    # TODO: More corporation stuff, actually pull the API data instead of just the name and ID
    def initialize(options, api, character)
      super(options, api)
      options[:character] = character
      @character = character
    end
    
  end
  
end