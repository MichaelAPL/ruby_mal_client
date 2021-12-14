require 'securerandom'
require_relative '../http/http_client'

class AnimeList
    include Configurations
    @http
    @code_verifier
    @auth_code
    @acces_token
    @refresh_token 

    attr_reader :code_verifier, :access_token, :refresh_token
    attr_accessor :auth_code    

    def initialize
        @http = HttpClient.new(MAL_API_URL)
        @code_verifier = SecureRandom.alphanumeric(100)        
    end

    def generate_access_token(auth_code = nil)
        @auth_code = auth_code if auth_code != nil
        http = HttpClient.new(MAL_AUTH_URL)
        headers = {"Content-Type" => "application/x-www-form-urlencoded"}
        data = { 
            "client_id" => MAL_CLIENT_ID,
            "client_secret" => MAL_CLIENT_SECRET,
            "code" => @auth_code,
            "code_verifier" => @code_verifier,
            "grant_type" => "authorization_code"
        }
        response = http.post(GET_ACCESS_TOKEN_PATH, headers, data, data)                
        @refresh_token = response[:refresh_token]
        @access_token = response[:access_token]
    end

    def get_user_info 
        headers = {"Authorization" => "Bearer #{@access_token}"}
        @http.get(GET_AUTH_USER_INFO_PATH, headers)
    end

    def get_anime_list(params = {})
        #@http.get(GET_AUTH_USER_ANILIST_PATH)
    end

    def refresh_access_token
    end

    def auth_url
        "#{MAL_AUTH_URL}authorize?response_type=code&client_id=#{MAL_CLIENT_ID}&code_challenge=#{@code_verifier}"
    end
end