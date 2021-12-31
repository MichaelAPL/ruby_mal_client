require_relative "./generic_anime_client"
require_relative "../auth/auth_client"

module RubyMalClient
    class SimpleMALClient < GenericAnimeClient
        def initialize
            raise RubyMalClient::ClientIdNotFoundError if RubyMalClient.configurations.client_id == nil
            headers = {"X-MAL-CLIENT-ID" => RubyMalClient.configurations.client_id, "Content-Type" => "application/json", "Accept" => "application/json"}
            super(headers)                         
        end
    end
end