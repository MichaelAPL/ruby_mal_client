module RubyMalClient
    class Configurations  
        #URLs
        MAL_API_URL = "https://api.myanimelist.net/v2/"
        MAL_AUTH_URL = "https://myanimelist.net/v1/oauth2/"    
        
        #Auth non-required paths
        GET_ANIME_PATH = "anime"
        GET_ANIME_RANKING_PATH = "#{GET_ANIME_PATH}/ranking"
        GET_ANIME_SEASON_PATH = "#{GET_ANIME_PATH}/season"
        GET_ANIME_SUGGESTIONS_PATH = "#{GET_ANIME_PATH}/suggestions"

        
        #Auth paths
        GET_ACCESS_TOKEN_PATH = "token"
        GET_AUTH_USER_INFO_PATH = "users/@me"
        GET_AUTH_USER_ANILIST_PATH = "#{GET_AUTH_USER_INFO_PATH}/animelist"      

        #ID and Secret
        MAL_CLIENT_ID = "ab75fe72617c2d1ab411e46bb31c144f"
        MAL_CLIENT_SECRET = "38b7e9b0a3398486f06f201904fa3622c7f19f66809fc98b1d2c8e362c3276da"

        #Others
        ANIME_DETAILS_FIELDS = [
            :id, :title, :main_picture, :alternative_titles, :start_date, :end_date, 
            :synopsis, :mean, :rank, :popularity, :num_list_users, :num_scoring_users, 
            :nsfw, :created_at, :created_at, :updated_at, :media_type, :status, :genres,
            :num_episodes, :start_season, :broadcast, :source, :average_episode_duration,
            :rating, :pictures, :background, :related_anime, :related_manga, :recommendations,
            :studios, :statistics
        ]

        SEASONS_MONTHS = {
            winter: ["January", "February", "March"], 
            spring: ["April", "May", "June"],
            summer: ["July", "August", "September"],
            fall: ["October", "November", "December"]
        }
        
        attr_accessor :client_id, :client_secret
        
        def initialize
          @client_id = nil
          @client_secret = nil
        end  
        
        def self.username_anilist_path(username)
            "users/#{username}/animelist"
        end

        def self.anime_details_fields 
            fields = {}
            ANIME_DETAILS_FIELDS.each { |field| fields[field] = true }
            fields
        end
    end

    def self.configurations
        @configurations ||= Configurations.new 
    end
end