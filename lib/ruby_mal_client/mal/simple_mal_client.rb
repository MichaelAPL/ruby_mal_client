require_relative "./generic_anime_client"
require_relative "../auth/auth_client"

module RubyMalClient
    class SimpleMALClient < GenericAnimeClient
        def initialize             
            @auth = RubyMalClient::AuthClient.new
            super({})
        end
    end
end