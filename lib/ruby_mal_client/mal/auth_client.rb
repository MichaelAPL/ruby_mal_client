require 'securerandom'
require_relative "../../errors"

module RubyMalClient
    class AuthClient        
        attr_reader :code_verifier, :access_token, :refresh_token
        attr_accessor :auth_code    

        def initialize
            @auth_code = nil
            @access_token = nil
            @refresh_token = nil
            @http = HttpClient.new(RubyMalClient::Configurations::MAL_AUTH_URL)
            @code_verifier = SecureRandom.alphanumeric(100)        
        end

        def generate_access_token(auth_code = nil)
            @auth_code = auth_code if auth_code != nil
            headers = urlencoded_header
            data = data_body("authorization_code")            
            response = @http.post(RubyMalClient::Configurations::GET_ACCESS_TOKEN_PATH, headers, data, data)                
            @refresh_token = response[:refresh_token]
            @access_token = response[:access_token]
        end

        def refresh_access_token
            headers = urlencoded_header
            data = data_body("refresh_token")
            @access_token = response[:access_token]
        end

        def get_user_info 
            header = bearer_token_header
            @http.get(RubyMalClient::Configurations::GET_AUTH_USER_INFO_PATH, header)
        end

        def auth_url
            configurations = RubyMalClient::Configurations
            "#{configurations::MAL_AUTH_URL}authorize?response_type=code&client_id=#{configurations::MAL_CLIENT_ID}&code_challenge=#{@code_verifier}"
        end

        private 

        def bearer_token_header
            {"Authorization" => "Bearer #{@access_token}"}
        end

        def urlencoded_header 
            {"Content-Type" => "application/x-www-form-urlencoded"}
        end

        def data_body(grant_type)
            client_id = RubyMalClient.configurations.client_id
            client_secret = RubyMalClient.configurations.client_secret
            
            raise ClientIdNotFoundError if client_id == nil
            raise ClientSecretNotFoundError if client_secret == nil

            data = { 
                "client_id" => client_id,
                "client_secret" => client_secret,
                "grant_type" => grant_type
            }

            if grant_type == "authorization_code"
                raise(AuthCodeNotFoundError, "Auth Code is missing, generate it by using the following URL - #{auth_url}") if @auth_code == nil
                data["code"] = @auth_code
                data["code_verifier"] = @code_verifier
            elsif grant_type == "refresh_token"
                data["refresh_token"] = @refresh_token
            end
            
            data
        end        
    end
end
