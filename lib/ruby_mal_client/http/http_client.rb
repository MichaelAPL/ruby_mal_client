require 'net/http'
require 'json'

class HttpClient 
    class ClientError < StandardError; end
    class ServerError < StandardError; end

    @base_url
    @http

    attr_accessor :base_url

    def initialize(base_url, use_ssl = true)
        @base_url = base_url
        
        uri = URI.parse(@base_url)
        @http = Net::HTTP.new(uri.host, uri.port)
        @http.use_ssl = use_ssl
    end

    def get(path, headers = {}, params = {})
        path = path_with_params(path, params) if params.size > 0
        uri = URI.join(@base_url, path)
        request = Net::HTTP::Get.new(uri, headers)
        http_response = @http.request(request)
        handle(http_response)
    rescue StandardError => error
        error.message
    end

    def post()
    end

    def patch()
    end

    private 

    def handle(http_response)
        case http_response
        when Net::HTTPSuccess
            response = JSON.parse(http_response.body, :symbolize_names => true)
        when Net::HTTPClientError
            raise ClientError, "[#{http_response.code}] #{http_response.class}"
        when Net::HTTPServerError
            raise ServerError, "[#{http_response.code}] #{http_response.class}"
        end        
    end

    def path_with_params(path, params)
        encoded_params = URI.encode_www_form(params)
        [path, encoded_params].join("?")
    end
end