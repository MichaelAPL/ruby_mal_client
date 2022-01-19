# frozen_string_literal: true

module RubyMalClient
  class Error < StandardError; end
  class ClientError < Error; end
  class ServerError < Error; end
  
  class ExpiredTokenError < Error
    def initialize(msg = "Access token has expired. Try with RubyMalClient::AuthenticatedUser.renovate_authorization!")
      super
    end
  end

  class MissingCredentialsError < Error
    def initialize(msg = "MAL Client ID or Client Secret are missing. Request and add your Client ID in configurations")
      super
    end
  end

  class AccessTokenNotFoundError < Error
    def initialize(msg = "Access Token has not been generated yet. Try with RubyMalClient::AuthenticatedUser.authorize!")
      super
    end
  end
end
