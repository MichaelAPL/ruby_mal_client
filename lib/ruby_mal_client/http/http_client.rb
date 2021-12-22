require 'net/http'
require 'json'

module RubyMalClient
    class HttpClient 
        @base_url
        @http

        attr_reader :base_url 

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
            http_response = request_response(request)
            handle(http_response)    
        end

        def post(path, headers = {}, params = {}, data)
            path = path_with_params(path, params) if params.size > 0
            uri = URI.join(@base_url, path)
            request = Net::HTTP::Post.new(uri, headers)
            request.set_form_data(data)
            http_response = request_response(request)
            handle(http_response) 
        end

        def patch()
        end

        def use_ssl?
            @http.use_ssl?
        end

        private

        def handle(http_response)
            JSON.parse(http_response.body, :symbolize_names => true)              
        rescue ClientError, ServerError, JSON::ParserError => error
            { error: error.name } 
        end

        
        def request_response(request)
            http_response = @http.request(request)
            case http_response
            when Net::HTTPSuccess
                http_response
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
end