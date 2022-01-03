# frozen_string_literal: true

require "securerandom"
require_relative "../configurations"
require_relative "../../errors"

module RubyMalClient
  class AuthClient
    attr_reader :code_verifier, :access_token, :refresh_token
    attr_accessor :auth_code

    def initialize
      @auth_code = nil
      @access_token = nil
      @refresh_token = nil
      @http = HttpClient.new(RubyMalClient::Configurations::MAL_AUTH_URL)
      @code_verifier = SecureRandom.alphanumeric(100)
    end

    def generate_access_token(auth_code = nil)
      @auth_code = auth_code unless auth_code.nil?
      headers = urlencoded_header
      data = data_body("authorization_code")
      response = @http.post(RubyMalClient::Configurations::GET_ACCESS_TOKEN_PATH, headers, data,
                            data)
      @refresh_token = response[:refresh_token]
      @access_token = response[:access_token]
    end

    def refresh_access_token
      raise RubyMalClient::AccessTokenNotFoundError if @access_token.nil?

      headers = urlencoded_header
      data = data_body("refresh_token")
      response = @http.post(RubyMalClient::Configurations::GET_ACCESS_TOKEN_PATH, headers, data, data)
      @access_token = response[:access_token]
    end

    def auth_url
      "#{RubyMalClient::Configurations::MAL_AUTH_URL}authorize?response_type=code&client_id=#{RubyMalClient.configurations.client_id}&code_challenge=#{@code_verifier}"
    end

    private

    def urlencoded_header
      { "Content-Type" => "application/x-www-form-urlencoded" }
    end

    def data_body(grant_type)
      client_id = RubyMalClient.configurations.client_id
      client_secret = RubyMalClient.configurations.client_secret

      raise ClientIdNotFoundError if client_id.nil?
      raise ClientSecretNotFoundError if client_secret.nil?

      data = {
        "client_id" => client_id,
        "client_secret" => client_secret,
        "grant_type" => grant_type
      }

      case grant_type
      when "authorization_code"
        if @auth_code.nil?
          raise(AuthCodeNotFoundError,
                "Auth Code is missing, generate it by using the following URL - #{auth_url}")
        end

        data["code"] = @auth_code
        data["code_verifier"] = @code_verifier
      when "refresh_token"
        data["refresh_token"] = @refresh_token
      end

      data
    end
  end
end
