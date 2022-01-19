module RubyMalClient
  class Forum < Endpoint
    def boards
      authorized!
      @http.get("forum/boards", headers)
    end

    def topics(board_id, params = {})
      authorized!
      params[:board_id] = board_id
      @http.get("forum/topics", headers, params)
    end

    def topic_details(topic_id, params = {})
      authorized!
      @http.get("forum/topic/#{topic_id}", headers, params)
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