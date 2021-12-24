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

        def get_anime(params = { q:"two", limit: "10" })
            @http.get(RubyMalClient::Configurations::GET_ANIME_PATH, @headers, params)
        end

        def get_anime_list(username = nil, params = {})
            path = username == nil ? RubyMalClient::Configurations::GET_AUTH_USER_ANILIST_PATH : RubyMalClient::Configurations.username_anilist_path(username)
            @http.get(RubyMalClient::Configurations::GET_ANIME_PATH, @headers, params)
        end

        def get_anime_details(anime_id, fields)
            path = "#{RubyMalClient::Configurations::GET_ANIME_PATH}/#{anime_id}?fields=#{fields.select{ |_, v| v }.keys.join(",")}"
            @http.get(path, @headers)
        end

        def get_anime_ranking(params = {})
            path = RubyMalClient::Configurations::GET_ANIME_RANKING_PATH
            @http.get(path, @headers, params)
        end

        def get_seasonal_anime(year = nil, season = nil)
            a_year = year == nil ? Date.today.year : year
            a_season = season == nil ? current_season(Date::MONTHNAMES[Date.today.month]) : season
            path = "#{RubyMalClient::Configurations::GET_ANIME_SEASON_PATH}/#{a_year}/#{a_season}"
            @http.get(path, @headers)
        end

        def get_suggested_anime(params = {})
            @http.get(RubyMalClient::Configurations::GET_ANIME_SUGGESTIONS_PATH, params)
        end 
        
        private

        def current_season(month)
            RubyMalClient::Configurations::ANIME_SEASONS.find { |k, v| v.include? month }[0].to_s
        end
    end
end