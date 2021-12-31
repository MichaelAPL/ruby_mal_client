require 'net/http'
require 'json'

module RubyMalClient
    class HttpClient 
        attr_reader :base_url 

        def initialize(base_url, use_ssl = true)
            @base_url = base_url
            
            uri = URI.parse(@base_url)
            @http = Net::HTTP.new(uri.host, uri.port)
            @http.use_ssl = use_ssl
        end

        def get(path, headers = {}, params = {})
            request_type = Net::HTTP::Get
            request_data = {
                path: path,
                headers: headers,
                params: params
            }
            request_response(request_type, request_data)
        end

        def post(path, headers = {}, params = {}, data)
            request_type = Net::HTTP::Post
            request_data = {
                path: path,
                headers: headers,
                params: params,
                data: data
            }
            request_response(request_type, request_data)
        end

        def patch(path, headers = {}, params = {}, data)
            request_type = Net::HTTP::Patch
            request_data = {
                path: path,
                headers: headers,
                params: params,
                data: data
            }
            request_response(request_type, request_data)
        end

        def delete(path, headers = {}, params = {}, data = nil)
            request_type = Net::HTTP::Delete
            request_data = {
                path: path,
                headers: headers,
                params: params,
                data: data
            }
            request_response(request_type, request_data)
        end

        def use_ssl?
            @http.use_ssl?
        end

        private
        
        def request_response(request_type, request_data)
            path = path_with_params(request_data[:path], request_data[:params]) if request_data[:params].size > 0
            uri = URI.join(@base_url, path != nil ? path : request_data[:path])
            request = request_type.new(uri, request_data[:headers])
            request.set_form_data(request_data[:data]) if request_data[:data] != nil
            handle(request)
        end        
        
        def handle(request)
            http_response = @http.request(request)
            case http_response
            when Net::HTTPSuccess
                JSON.parse(http_response.body, :symbolize_names => true)   
            when Net::HTTPClientError
                raise ClientError, "Error code: [#{http_response.code}]. Message: #{http_response.class}"
            when Net::HTTPServerError
                raise ServerError, "Error code: [#{http_response.code}]. Message: #{http_response.class}"
            when Net::HTTPNotFound
                raise ServerError, "Error code: [#{http_response.code}]. Message: #{http_response.class}"
            end  
        end

        def path_with_params(path, params)
            encoded_params = URI.encode_www_form(params)
            [path, encoded_params].join("?")
        end
    end
end