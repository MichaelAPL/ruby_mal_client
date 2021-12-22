module RubyMalClient
    class Configurations  
        #URLs
        MAL_API_URL = "https://api.myanimelist.net/v2/"
        MAL_AUTH_URL = "https://myanimelist.net/v1/oauth2/"    
        
        #Auth non-required paths
        GET_ANIME_PATH = "anime"
        
        #Auth paths
        GET_ACCESS_TOKEN_PATH = "token"
        GET_AUTH_USER_INFO_PATH = "users/@me"
        GET_AUTH_USER_ANILIST_PATH = "#{GET_AUTH_USER_INFO_PATH}/animelist"      

        #ID and Secret
        MAL_CLIENT_ID = "ab75fe72617c2d1ab411e46bb31c144f"
        MAL_CLIENT_SECRET = "38b7e9b0a3398486f06f201904fa3622c7f19f66809fc98b1d2c8e362c3276da"
        
        attr_accessor :client_id, :client_secret
        
        def initialize
          @client_id = nil
          @client_secret = nil
        end                    
    end

    def self.configurations
        @configurations ||= Configurations.new 
    end
end