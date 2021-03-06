# frozen_string_literal: true

require "test_helper"

class HttpClientTest < Minitest::Test
  def test_http_client_must_exists
    refute_nil RubyMalClient::HttpClient.new("https://example.com")
  end

  def test_use_ssl_is_true_by_default
    client = RubyMalClient::HttpClient.new("https://example.com")
    assert_equal client.use_ssl?, true
  end
end
