# frozen_string_literal: true

module RubyMalClient
  class Error < StandardError; end
  class ClientError < Error; end
  class ServerError < Error; end
  class InvalidTokenError < Error; end
  class ExpiredTokenError < Error; end

  class MissingCredentialsError < Error
    def initialize(msg = "MAL Client ID or Client Secret are missing. Request and add your Client ID in configurations")
      super
    end
  end

  class AccessTokenNotFoundError < Error
    def initialize(msg = "Access Token has not been generated yet. Try with RubyMalClient::MALClient.authorize")
      super
    end
  end

  class InvalidYearError < Error
    def initialize(msg = "Year is not valid, use a valid year")
      super
    end
  end

  class InvalidSeasonError < Error
    def initialize(msg = "Season is not valid, check in RubyMalClient::Configurations::SEASONS_MONTHS for valid seasons")
      super
    end
  end
end
