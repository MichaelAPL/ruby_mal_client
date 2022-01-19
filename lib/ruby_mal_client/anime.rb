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

    def find(anime_id, params = { fields: RubyMalClient::Configuration.formatted_anime_details_fields })
      authorized!
      @http.get("anime/#{anime_id}", headers, params)
    end

    def ranking(params = {})
      authorized!
      @http.get("anime/ranking", headers, params)
    end

    def seasonal(year: nil, season: nil)
      authorized!

      year = year.nil? ? Date.today.year : year.to_i.to_s
      raise ArgumentError.new "Invalid year" if year.to_i > Date.today.year || year.to_i < 1917 #oldest anime registered on MAL is from 1917

      if(season.nil? && year.to_i == Date.today.year)
        season = current_season(Date::MONTHNAMES[Date.today.month])
      else
        validate_season!(season)        
      end

      @http.get("anime/season/#{year}/#{season}", headers)
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

    def validate_season!(season)
      raise ArgumentError.new "Missing season" if season.nil? 
      raise ArgumentError.new "Invalid season" unless RubyMalClient::Configuration::SEASONS_MONTHS.key?(season.to_sym)
    end

    def authorized!
      raise RubyMalClient::MissingCredentialsError if RubyMalClient.configuration.client_id.nil?
    end

    def current_season(month)
      RubyMalClient::Configuration::SEASONS_MONTHS.find { |_k, v| v.include? month }[0].to_s
    end
  end
end
