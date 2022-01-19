module RubyMalClient
  class Manga < Endpoint
    def all(params = { q: "two", limit: "10" })
      authorized!
      @http.get("manga", headers, params)
    end

    def list_for(username, params: {})
      authorized!
      @http.get("users/#{username}/mangalist", headers, params)
    end

    def find(manga_id, params: {})
      authorized!
      @http.get("manga/#{manga_id}", headers, params)
    end

    def ranking(params: {ranking_type: "all"})
      authorized!
      @http.get("manga/ranking", headers, params)
    end

    protected

    def headers
      @headers ||= {
        "X-MAL-CLIENT-ID" => RubyMalClient.configuration.client_id,
        "Content-Type" => "application/json",
        "Accept" => "application/json"
      }
    end

    private

    def authorized!
      raise RubyMalClient::MissingCredentialsError if RubyMalClient.configuration.client_id.nil?
    end
  end
end