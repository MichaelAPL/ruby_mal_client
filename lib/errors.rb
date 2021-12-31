module RubyMalClient
    class ClientError < StandardError; end
    class ServerError < StandardError; end    
    class AuthCodeNotFoundError < StandardError; end
    class InvalidTokenError < StandardError; end
    class ExpiredTokenError < StandardError; end
    
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

    class AccessTokenNotFoundError < StandardError
        def initialize(msg = "Access Token has not been generated yet. Try with RubyMalClient::MALClient.authorize")
            super
        end
    end

    class InvalidYearError < StandardError
        def initialize(msg = "Year is not valid, use a valid year")
            super
        end
    end

    class InvalidSeasonError < StandardError
        def initialize(msg = "Season is not valid, check in RubyMalClient::Configurations::SEASONS_MONTHS for valid seasons")
            super
        end
    end
end