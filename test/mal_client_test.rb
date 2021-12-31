require "test_helper"
require "vcr"
require_relative "../lib/ruby_mal_client/mal/mal_client"

class MALClientTest < Minitest::Test
    def test_access_token_is_required_for_retrieving_data
        assert_raises(RubyMalClient::AccessTokenNotFoundError) do
            mal_client = init_mal_client
            mal_client.get_user_info
        end             
    end
    
    def test_headers_should_be_setted_after_access_token_is_generated
        mal_client = init_mal_client
        VCR.use_cassette("mal_client_authorize", match_requests_on: [:host], record: :new_episodes) do
            authorize_mal_client(mal_client)
        end
        assert !mal_client.headers.empty?
    end

    def test_get_user_info_returns_a_valid_hash

    end
    
    def test_suggested_anime_returns_a_valid_hash
        mal_client = init_mal_client
        VCR.use_cassette("mal_client_authorize", match_requests_on: [:host], record: :new_episodes) do
            authorize_mal_client(mal_client)
        end

        VCR.use_cassette("get_suggested_anime") do
            suggested_animes = mal_client.get_suggested_anime
            assert suggested_animes[:data].first.key?(:node)
        end
    end

    private 

    def init_mal_client
        RubyMalClient.configurations.client_id = "ab75fe72617c2d1ab411e46bb31c144f"
        RubyMalClient.configurations.client_secret = "38b7e9b0a3398486f06f201904fa3622c7f19f66809fc98b1d2c8e362c3276da"
        RubyMalClient::MALClient.new
    end

    def authorize_mal_client(mal_client)
        auth_code = "def502003f48abfd472bdf9874f09da4194ae3cbe51eeb2e63f3a995929d53b92c73ac99e3453dbcee5ac04e23cf709d6c3a33aa0fa4203dc862cb81128e247be9e038b5f904a1312af5f42c6e42208fe2f61571df4c2c8b938ea68513693f4f79092e044c783087f32292e8932686359fb1d0d9b2c9602e0fde103da60ef7c3d06e28d1c5978e9945414ee42ec1c966763b19bfd287ec7e10875f8e8bdb6fa703fad0e8f8f1c1fd82f3e70136d6a1bccea604d8bb007c0685c946d0c1fd3862a57d13a908290412d24b0201fc2af67eb3fc38febc8bce096cd38fbb2ae6cae24014f46efb9841ded1ccb0968f86883fac23a6b54c1429ca49d9d5588f21c1032a706baf4f7f988f0d10b9be5be08c2d4a44705f938627cb3dbcde712a81352fd70b8e400258f017702b2fbd6f07ea816648865474845e6ce407015fcbc16bacb94f24fa7b8ccbdb914c28c2cfa1c6b84e7f028c910136cbd3e338de341cd761dd6e6d8c968186b492ab88f0768d6a7640b1797ba3aaafc842c2653c9970897cdac2c19ca6e7e11bff0c1f6b330dac46eff23d6e013f4ce5bc616115ee3d9505a0d2c22e326f62e589bbc7c32402c86d21f016844b3d066f37953d9a750ba8dd157c97077408e0eaecde6042de"
        mal_client.authorize(auth_code)
    end
end