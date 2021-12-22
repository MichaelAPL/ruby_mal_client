module RubyMalClient
    class ClientError < StandardError; end
    class ServerError < StandardError; end    
    class AuthCodeNotFoundError < StandardError; end
    
    class ClientIdNotFoundError < StandardError
        def initialize(msg = "MAL Client ID is missing. Request and add your Client ID in configurations")
            super
        end
    end

    class ClientSecretNotFoundError < StandardError
        def initialize(msg = "MAL Client Secret is missing. Request and add your Client Secret in configurations")
            super
        end
    end
end