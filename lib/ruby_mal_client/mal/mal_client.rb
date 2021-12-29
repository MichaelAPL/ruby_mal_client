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
            @user = @http.get(RubyMalClient::Configurations::GET_AUTH_USER_INFO_PATH, @headers)
        end
        
        def add_anime_to_list(anime_id, anime_info)
            @http.patch(RubyMalClient::Configurations.my_list_status_path(anime_id), @headers, anime_info)            
        end

        def delete_anime_from_list(anime_id)
            @http.delete(RubyMalClient::Configurations.my_list_status_path(anime_id), @headers) 
        end

        private
        
        def bearer_token_header(access_token)
            {"Authorization" => "Bearer #{access_token}"}
        end
    end
end