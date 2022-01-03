# frozen_string_literal: true

require_relative "./generic_anime_client"

module RubyMalClient
  class MALClient < GenericAnimeClient
    attr_reader :user

    def initialize
      @auth = RubyMalClient::AuthClient.new
      @user = nil
      super({})
    end

    def authorize(auth_code)
      access_token = @auth.generate_access_token(auth_code)
      @headers = bearer_token_header(access_token)
      @user = get_user_info
    end

    def mal_authorization_url
      @auth.auth_url
    end

    def get_user_info
      raise RubyMalClient::AccessTokenNotFoundError if @headers.empty?

      @user = @http.get(RubyMalClient::Configurations::GET_AUTH_USER_INFO_PATH, @headers)
    end

    def get_suggested_anime(params = {})
      raise RubyMalClient::AccessTokenNotFoundError if @headers.empty?

      @http.get(RubyMalClient::Configurations::GET_ANIME_SUGGESTIONS_PATH, params)
    end

    def add_or_update_anime_to_list(anime_id, anime_details)
      raise RubyMalClient::AccessTokenNotFoundError if @headers.empty?

      @http.patch(RubyMalClient::Configurations.my_list_status_path(anime_id), @headers,
                  anime_details)
    end

    def delete_anime_from_list(anime_id)
      raise RubyMalClient::AccessTokenNotFoundError if @headers.empty?

      @http.delete(RubyMalClient::Configurations.my_list_status_path(anime_id), @headers)
    end

    private

    def bearer_token_header(access_token)
      { "Authorization" => "Bearer #{access_token}" }
    end
  end
end
