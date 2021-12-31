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

        #Others        
        ANIME_DETAILS_FIELDS = [
            "id", "title", "main_picture", "alternative_titles", "start_date", "end_date", 
            "synopsis", "mean", "rank", "popularity", "num_list_users", "num_scoring_users", 
            "nsfw", "created_at", "updated_at", "media_type", "status", "genres",
            "num_episodes", "start_season", "broadcast", "source", "average_episode_duration",
            "rating", "pictures", "background", "related_anime", "related_manga", "recommendations",
            "studios", "statistics"
        ]

        SEASONS_MONTHS = {
            winter: ["January", "February", "March"], 
            spring: ["April", "May", "June"],
            summer: ["July", "August", "September"],
            fall: ["October", "November", "December"]
        }

        ANIME_LIST_ITEM_STATUSES = {
            watching: "watching",
            completed: "completed",
            on_hold: "on_hold",
            dropped: "dropped",
            plan_to_watch: "plan_to_watch"
        }
        
        attr_accessor :client_id, :client_secret
        
        def initialize
          @client_id = nil
          @client_secret = nil
        end  
        
        def self.username_anilist_path(username)
            "users/#{username}/animelist"
        end

        def self.my_list_status_path(anime_id)
            "anime/#{anime_id}/my_list_status"
        end

        def self.formatted_anime_details_fields(fields = ANIME_DETAILS_FIELDS) 
            fields.join(",")
        end
    end

    def self.configurations
        @configurations ||= Configurations.new 
    end
end