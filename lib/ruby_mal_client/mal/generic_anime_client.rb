require "date"
require_relative "../http/http_client"
require_relative "../configurations"
require_relative "../../errors"

module RubyMalClient
    class GenericAnimeClient
        attr_accessor :headers

        def initialize(headers)
            @headers = headers
            @http = RubyMalClient::HttpClient.new(RubyMalClient::Configurations::MAL_API_URL)
        end

        def get_anime(params = { q: "two", limit: "10" })
            raise RubyMalClient::AccessTokenNotFoundError if @headers.empty?
            @http.get(RubyMalClient::Configurations::GET_ANIME_PATH, @headers, params)
        end

        def get_anime_list(username: nil, params: {})
            raise RubyMalClient::AccessTokenNotFoundError if @headers.empty?
            path = username == nil ? RubyMalClient::Configurations::GET_AUTH_USER_ANILIST_PATH : RubyMalClient::Configurations.username_anilist_path(username)
            @http.get(path, @headers, params)
        end

        def get_anime_details(anime_id, params = { fields: RubyMalClient::Configurations.formatted_anime_details_fields })
            raise RubyMalClient::AccessTokenNotFoundError if @headers.empty?
            path = "#{RubyMalClient::Configurations::GET_ANIME_PATH}/#{anime_id}"
            @http.get(path, @headers, params)
        end

        def get_anime_ranking(params = {})
            raise RubyMalClient::AccessTokenNotFoundError if @headers.empty?
            path = RubyMalClient::Configurations::GET_ANIME_RANKING_PATH
            @http.get(path, @headers, params)
        end

        def get_seasonal_anime(year: nil, season: nil)
            raise RubyMalClient::AccessTokenNotFoundError if @headers.empty?            
            a_year = year == nil ? Date.today.year : year.to_i.to_s
            raise RubyMalClient::InvalidYearError if (a_year.to_i > Date.today.year || a_year.to_i < 1917) #oldest anime registered on MAL is from 1917
            a_season = season == nil ? current_season(Date::MONTHNAMES[Date.today.month]) : season.to_s
            raise RubyMalClient::InvalidSeasonError if !RubyMalClient::Configurations::SEASONS_MONTHS.key?(a_season.to_sym)
            path = "#{RubyMalClient::Configurations::GET_ANIME_SEASON_PATH}/#{a_year}/#{a_season}"
            @http.get(path, @headers)
        end        
        
        private

        def current_season(month)
            RubyMalClient::Configurations::SEASONS_MONTHS.find { |k, v| v.include? month }[0].to_s
        end
    end
end