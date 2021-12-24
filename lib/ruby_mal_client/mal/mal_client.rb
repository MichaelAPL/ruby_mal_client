require_relative "./generic_anime_client"

module RubyMalClient
    class MALClient < GenericAnimeClient
        def initialize
            headers = {"X-MAL-CLIENT-ID" => RubyMalClient.configurations.client_id, "Content-Type" => "application/json", "Accept" => "application/json"}
            super(headers)
        end
    end
end