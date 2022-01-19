# frozen_string_literal: true

require "date"

module RubyMalClient
  class Endpoint
    MAL_API_URL = "https://api.myanimelist.net/v2/"

    def initialize
      @http = RubyMalClient::HttpClient.new(MAL_API_URL)
    end

    protected

    attr_reader :http

    def headers
      @headers ||= {}
    end
  end
end
