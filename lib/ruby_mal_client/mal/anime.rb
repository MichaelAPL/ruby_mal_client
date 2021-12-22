require_relative '../http/http_client'
require_relative '../configurations'

class Anime
    @http    
     
    def initialize
        @http = HttpClient.new(MAL_API_URL)        
    end

    def get_anime(params = { q:"two", limit: "10" })
        headers = {"X-MAL-CLIENT-ID" => MAL_CLIENT_ID, "Content-Type" => "application/json", "Accept" => "application/json"}
        @http.get(GET_ANIME_PATH, headers, params)
    end
end