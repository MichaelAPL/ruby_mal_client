require "test_helper"
require "vcr"
require_relative "../lib/ruby_mal_client/auth/auth_client"

class AuthClientTest < Minitest::Test
    def test_auth_client_must_exists
        refute_nil RubyMalClient::AuthClient.new
    end

    def test_code_verifier_lenght
        auth_client = RubyMalClient::AuthClient.new
        assert_equal auth_client.code_verifier.size, 100
    end

    def test_generate_access_token_needs_client_id
        assert_raises(RubyMalClient::ClientIdNotFoundError) do
            RubyMalClient.configurations.client_id = nil
            auth_client = RubyMalClient::AuthClient.new
            auth_client.generate_access_token
        end        
    end

    def test_generate_access_token_needs_client_secret
        assert_raises(RubyMalClient::ClientSecretNotFoundError) do
            RubyMalClient.configurations.client_id = "ab75fe72617c2d1ab411e46bb31c144f"
            RubyMalClient.configurations.client_secret = nil
            auth_client = RubyMalClient::AuthClient.new
            auth_client.generate_access_token
        end
    end

    def test_generate_access_token_needs_auth_code
        assert_raises(RubyMalClient::AuthCodeNotFoundError) do
            RubyMalClient.configurations.client_id = "ab75fe72617c2d1ab411e46bb31c144f"
            RubyMalClient.configurations.client_secret = "38b7e9b0a3398486f06f201904fa3622c7f19f66809fc98b1d2c8e362c3276da"
            auth_client = RubyMalClient::AuthClient.new
            auth_client.generate_access_token
        end
    end
    
    def test_generate_access_tokens_brings_a_token
        assert true
    end

    def test_refresh_tokens_brings_a_new_access_token
        assert true
    end
    
end