# frozen_string_literal: true

require "date"

module RubyMalClient
  class Anime < Endpoint
    def all(params = { q: "two", limit: "10" })
      authorized!

      @http.get("anime", headers, params)
    end

    def list_for(username, params: {})
      authorized!

      @http.get("users/#{username}/animelist", headers, params)
    end

    def find(anime_id, params = { fields: RubyMalClient::Configurations.formatted_anime_details_fields })
      authorized!

      @http.get("anime/#{anime_id}", headers, params)
    end

    def ranking(params = {})
      authorized!

      @http.get("anime/ranking", headers, params)
    end

    def seasonal(year: nil, season: nil)
      authorized!

      a_year = year.nil? ? Date.today.year : year.to_i.to_s
      raise RubyMalClient::InvalidYearError if a_year.to_i > Date.today.year || a_year.to_i < 1917

      a_season = season.nil? ? current_season(Date::MONTHNAMES[Date.today.month]) : season.to_s
      raise RubyMalClient::InvalidSeasonError unless RubyMalClient::Configurations::SEASONS_MONTHS.key?(a_season.to_sym)

      @http.get("anime/season/#{a_year}/#{a_season}", headers)
    end

    protected

    def headers
      @headers ||= {
        "X-MAL-CLIENT-ID" => RubyMalClient.configuration.client_id,
        "Content-Type" => "application/json",
        "Accept" => "application/json"
      }
    end

    private

    def authorized!
      raise RubyMalClient::AccessTokenNotFoundError if RubyMalClient.configuration.client_id.nil?
    end

    def current_season(month)
      RubyMalClient::Configurations::SEASONS_MONTHS.find { |_k, v| v.include? month }[0].to_s
    end
  end
end
