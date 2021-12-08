require_relative '../http/http_client'
require_relative '../configurations'

class Anime
    include Configurations
    @http    
     
    def initialize
        @http = HttpClient.new(MAL_API_URL, true)        
    end

    def get_anime(params = { q:"two", limit: "10" })
        get_anime_path = "/anime"
        headers = {"X-MAL-CLIENT-ID" => MAL_CLIENT_ID, "Content-Type" => "application/json", "Accept" => "application/json"}

        anime = @http.get(get_anime_path, headers, params)
    end
end