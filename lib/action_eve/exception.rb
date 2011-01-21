module ActionEve
  module Exceptions
    class BaseException < Exception
    end
    class OptionsException < BaseException
    end
    class InputException < BaseException
    end
    class CredentialsException < BaseException
    end
    class APIException < BaseException
    end
    class AttributeException < BaseException
    end
  end
end