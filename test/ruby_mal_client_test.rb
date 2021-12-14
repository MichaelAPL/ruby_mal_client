# frozen_string_literal: true

require "test_helper"
require "vcr"

class RubyMalClientTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RubyMalClient::VERSION
  end 
  
  def test_http_client_must_exists
    refute_nil HttpClient.new("https://example.com")
  end

  def test_use_ssl_is_true_by_default
    client = HttpClient.new("https://example.com")
    assert_equal client.use_ssl?, true
  end

  def test_get_anime_returns_a_hash
    VCR.use_cassette("get_anime") do
      animes = Anime.new.get_anime
      assert_instance_of Hash, animes
    end
  end

end
