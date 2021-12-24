require_relative "./generic_anime_client"

module RubyMalClient
    class MALClient < GenericAnimeClient
        def initialize
            @auth = RubyMalClient::AuthClient.new
            super({})
        end
    end
end