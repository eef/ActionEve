require 'date'
require 'net/http'
require 'uri'

module ActionEve
  
  module Comms
    
    class API

      include Common
      
      def initialize(*args)
        @options = options_from_args!(args)
        @comms = Request.new(@options)
      end

      def characters
        result = {}
        doc = @comms.call('account/Characters.xml.aspx')
        doc.css('rowset[name="characters"] > row').each do |row|
          character = {
            :id => row['characterID'].to_i,
            :name => row['name'],
            :corporation_id => row['corporationID'].to_i,
            :corporation_name => row['corporationName']
          }
          result[character[:id]] = character
        end
        result
      end
      
      def character_info(character_id)
        result = {}
        doc = @comms.call('eve/CharacterInfo.xml.aspx', :characterID => character_id)
        rows = doc.css('result').first.children
        rows.each {|row| result[row.name.underscore.to_sym] = row.text}
        result
      end
    end
    
    class Request
      
      include Common
    
      def initialize(*args)
        options = options_from_args!(args)
        @initial_params = {}
        @initial_params[:userID] = options[:id] or raise Exceptions::OptionsException, "User ID is missing"
        @initial_params[:apiKey] = options[:api_key] or raise Exceptions::OptionsException, "API Key is missing"
      end
    
      def call(uri, *args)
        # TODO: This really could do with being refactored, instead of passing in a URL string have a hash {:scope => "eve", :method => "characterinfo"}
        params = options_from_args!(args).merge(@initial_params)
        res = Net::HTTP.post_form(URI.parse("#{API_HOST}#{uri}"), params)
        xml = res.body
        doc = Nokogiri::XML(xml)
        error = doc.css("error")
        unless error.length.eql?(0)
          case error.first['code'][0,1]
            when '1'
              raise Exceptions::InputException, error.text
            when '2'
              raise Exceptions::CredentialsException, error.text
            else
              raise Exceptions::APIException, error.text
          end
        end
        doc
      end
  
    end

  end
  
end