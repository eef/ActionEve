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
      if @options.has_key?(method.to_sym)
        return(@options[method.to_sym])
      end
      raise(Exceptions::AttributeException,"That method is missing, check under the cushion")
    end
    
  end
  
end