# frozen_string_literal: true

require "test_helper"
require "vcr"

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
      RubyMalClient.configuration.client_id = nil
      auth_client = RubyMalClient::AuthClient.new
      auth_client.generate_access_token
    end
  end

  def test_generate_access_token_needs_client_secret
    assert_raises(RubyMalClient::ClientSecretNotFoundError) do
      RubyMalClient.configuration.client_id = "ab75fe72617c2d1ab411e46bb31c144f"
      RubyMalClient.configuration.client_secret = nil
      auth_client = RubyMalClient::AuthClient.new
      auth_client.generate_access_token
    end
  end

  def test_generate_access_token_needs_auth_code
    assert_raises(RubyMalClient::AuthCodeNotFoundError) do
      RubyMalClient.configuration.client_id = "ab75fe72617c2d1ab411e46bb31c144f"
      RubyMalClient.configuration.client_secret = "38b7e9b0a3398486f06f201904fa3622c7f19f66809fc98b1d2c8e362c3276da"
      auth_client = RubyMalClient::AuthClient.new
      auth_client.generate_access_token
    end
  end

  def test_refresh_cant_be_called_if_access_token_is_nil
    RubyMalClient.configuration.client_id = "ab75fe72617c2d1ab411e46bb31c144f"
    RubyMalClient.configuration.client_secret = "38b7e9b0a3398486f06f201904fa3622c7f19f66809fc98b1d2c8e362c3276da"
    assert_raises(RubyMalClient::AccessTokenNotFoundError) do
      auth_client = RubyMalClient::AuthClient.new
      auth_client.refresh_access_token
    end
  end

  def test_refresh_tokens_brings_a_new_access_token
    RubyMalClient.configuration.client_id = "ab75fe72617c2d1ab411e46bb31c144f"
    RubyMalClient.configuration.client_secret = "38b7e9b0a3398486f06f201904fa3622c7f19f66809fc98b1d2c8e362c3276da"
    auth_code = "def502003f48abfd472bdf9874f09da4194ae3cbe51eeb2e63f3a995929d53b92c73ac99e3453dbcee5ac04e23cf709d6c3a33aa0fa4203dc862cb81128e247be9e038b5f904a1312af5f42c6e42208fe2f61571df4c2c8b938ea68513693f4f79092e044c783087f32292e8932686359fb1d0d9b2c9602e0fde103da60ef7c3d06e28d1c5978e9945414ee42ec1c966763b19bfd287ec7e10875f8e8bdb6fa703fad0e8f8f1c1fd82f3e70136d6a1bccea604d8bb007c0685c946d0c1fd3862a57d13a908290412d24b0201fc2af67eb3fc38febc8bce096cd38fbb2ae6cae24014f46efb9841ded1ccb0968f86883fac23a6b54c1429ca49d9d5588f21c1032a706baf4f7f988f0d10b9be5be08c2d4a44705f938627cb3dbcde712a81352fd70b8e400258f017702b2fbd6f07ea816648865474845e6ce407015fcbc16bacb94f24fa7b8ccbdb914c28c2cfa1c6b84e7f028c910136cbd3e338de341cd761dd6e6d8c968186b492ab88f0768d6a7640b1797ba3aaafc842c2653c9970897cdac2c19ca6e7e11bff0c1f6b330dac46eff23d6e013f4ce5bc616115ee3d9505a0d2c22e326f62e589bbc7c32402c86d21f016844b3d066f37953d9a750ba8dd157c97077408e0eaecde6042de"
    auth_client = RubyMalClient::AuthClient.new

    VCR.use_cassette("mal_client_authorize", match_requests_on: [:host], record: :new_episodes) do
      auth_client.generate_access_token(auth_code)
    end

    previous_access_token = auth_client.access_token

    VCR.use_cassette("refresh_access_token", match_requests_on: [:host]) do
      auth_client.refresh_access_token
    end

    assert previous_access_token != auth_client.access_token
  end
end
