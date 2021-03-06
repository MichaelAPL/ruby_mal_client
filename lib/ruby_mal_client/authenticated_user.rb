# frozen_string_literal: true

module RubyMalClient
  class AuthenticatedUser < Endpoint
    def initialize
      super
      @auth = RubyMalClient::AuthClient.new
    end

    def authorization_url
      auth.auth_url
    end

    def authorize!(auth_code)
      @access_token = auth.generate_access_token(auth_code)
    end

    def renovate_authorization!
      @access_token = auth.refresh_access_token
    end

    def current_user
      authorized!
      @current_user ||= @http.get("users/@me", headers)
    end

    def my_anime_list(params: {})
      authorized!
      @http.get("users/@me/animelist", headers, params)
    end

    def suggested_anime(params = {})
      authorized!
      @http.get("anime/suggestions", params)
    end

    def upsert_anime_to_list(anime_id, anime_details)
      authorized!
      @http.patch("anime/#{anime_id}/my_list_status", headers, anime_details)
    end

    def delete_anime_from_list(anime_id)
      authorized!
      @http.delete("anime/#{anime_id}/my_list_status", headers)
    end

    def my_manga_list(params: {})
      authorized!
      @http.get("users/@me/mangalist", headers, params)
    end

    def upsert_manga_to_list(manga_id, manga_details)
      authorized!
      @http.patch("manga/#{manga_id}/my_list_status", headers, manga_details)
    end

    def delete_manga_from_list(manga_id)
      authorized!
      @http.delete("manga/#{manga_id}/my_list_status", headers)
    end

    def access_token=(access_token)
      @access_token = access_token
      auth.access_token = access_token
    end

    def access_token
      @access_token
    end

    def refresh_token=(refresh_token)
      auth.refresh_token = refresh_token
    end

    def refresh_token
      auth.refresh_token
    end

    private

    attr_reader :auth

    def headers
      @headers ||= { "Authorization" => "Bearer #{access_token}" }
    end

    def authorized!
      raise RubyMalClient::AccessTokenNotFoundError unless authorized?
    end

    def authorized?
      !access_token.nil?
    end        
  end
end
