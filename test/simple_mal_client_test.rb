# frozen_string_literal: true

require "test_helper"
require "vcr"
require_relative "../lib/ruby_mal_client/mal/simple_mal_client"

class SimpleMALClientTest < Minitest::Test
  def test_client_id_is_required
    assert_raises(RubyMalClient::ClientIdNotFoundError) do
      RubyMalClient.configurations.client_id = nil
      RubyMalClient::SimpleMALClient.new
    end
  end

  def test_once_client_id_is_setted_data_can_be_retrieved
    simple_client = init_simple_client
    VCR.use_cassette("simple_mal_client_get_anime") do
      animes = simple_client.get_anime
      assert_instance_of Hash, animes
    end
  end

  def test_get_anime_returns_a_valid_hash
    simple_client = init_simple_client
    VCR.use_cassette("get_anime") do
      animes = simple_client.get_anime
      assert animes[:data].size.positive?
    end
  end

  def test_get_anime_list_returns_a_valid_hash
    simple_client = init_simple_client
    VCR.use_cassette("get_anime") do
      animes = simple_client.get_anime
      assert animes[:data].size.positive?
    end
  end

  def test_get_custom_fields_anime_list_returns_a_valid_hash
    simple_client = init_simple_client
    params = { fields: "list_status", limit: "100", status: "completed" }
    VCR.use_cassette("get_custom_anime_list") do
      animes = simple_client.get_anime_list(username: "michael_apl", params: params)
      random_anime = animes[:data].last
      assert random_anime.key?(:list_status)
    end
  end

  def test_get_anime_details_returns_a_valid_hash
    simple_client = init_simple_client
    VCR.use_cassette("get_anime_details") do
      anime = simple_client.get_anime_details("1")
      expected_fields = RubyMalClient::Configurations::ANIME_DETAILS_FIELDS.map(&:to_sym)
      assert_equal anime.keys, expected_fields
    end
  end

  def test_get_seasonal_anime_returns_a_valid_hash
    simple_client = init_simple_client
    VCR.use_cassette("get_seasonal_anime") do
      seasonal_animes = simple_client.get_seasonal_anime(year: "2021", season: "fall")[:data]
      assert seasonal_animes.first.key?(:node)
    end
  end

  def test_get_seasonal_anime_validates_year
    simple_client = init_simple_client
    assert_raises(RubyMalClient::InvalidYearError) do
      simple_client.get_seasonal_anime(year: 3000)
    end
  end

  def test_get_seasonal_anime_validates_season
    simple_client = init_simple_client
    assert_raises(RubyMalClient::InvalidSeasonError) do
      simple_client.get_seasonal_anime(season: "winterfell")
    end
  end

  def test_get_seasonal_anime_accepts_floats_for_years
    simple_client = init_simple_client
    VCR.use_cassette("get_seasonal_anime") do
      season = simple_client.get_seasonal_anime(year: 2021.9, season: "fall")[:season]
      assert_equal season[:year], 2021
    end
  end

  def test_get_seasonal_anime_accepts_symbols_for_seasons
    simple_client = init_simple_client
    VCR.use_cassette("get_seasonal_anime") do
      season = simple_client.get_seasonal_anime(year: 2021, season: :fall)[:season]
      assert_equal season[:season], "fall"
    end
  end

  private

  def init_simple_client
    RubyMalClient.configurations.client_id = "ab75fe72617c2d1ab411e46bb31c144f"
    RubyMalClient::SimpleMALClient.new
  end
end
