# frozen_string_literal: true

require "securerandom"

module RubyMalClient
  class AuthClient
    AUTH_URL = "https://myanimelist.net/v1/oauth2/"

    attr_reader :code_verifier, :access_token, :refresh_token
    attr_accessor :auth_code

    def initialize
      raise MissingCredentialsError if RubyMalClient.configuration.credentials?

      @auth_code = nil
      @access_token = nil
      @refresh_token = nil
      @http = HttpClient.new(AUTH_URL)
      @code_verifier = SecureRandom.alphanumeric(100)
    end

    def generate_access_token(auth_code = nil)
      data = authorization_data(auth_code)

      response = @http.post("token", default_headers, data, data)
      @refresh_token = response[:refresh_token]
      @access_token = response[:access_token]
    end

    def refresh_access_token
      data = refresh_token_data

      response = @http.post("token", default_headers, data, data)
      @access_token = response[:access_token]
    end

    def auth_url
      "#{AUTH_URL}authorize?response_type=code&client_id=#{RubyMalClient.configuration.client_id}&code_challenge=#{code_verifier}"
    end

    private

    def default_headers
      @default_headers ||= { "Content-Type" => "application/x-www-form-urlencoded" }
    end

    def authorization_data(auth_code)
      if auth_code.nil?
        raise(ArgumentError, "Auth Code is missing, generate it by using the following URL - #{auth_url}")
      end

      default_data.merge({
                           code: auth_code,
                           code_verifier: code_verifier
                         })
    end

    def refresh_token_data
      raise(ArgumentError, "Access token is nil") if access_token.nil?

      default_data.merge(refresh_token: refresh_token)
    end

    def default_data
      @default_data ||= {
        client_id: RubyMalClient.configuration.client_id,
        client_secret: RubyMalClient.configuration.client_secret
      }
    end
  end
end
