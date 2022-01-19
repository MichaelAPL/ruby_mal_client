# frozen_string_literal: true

require "test_helper"
require "vcr"
require_relative "../lib/ruby_mal_client"

class AnimeTest < Minitest::Test
  def test_client_id_is_required
    assert_raises(RubyMalClient::MissingCredentialsError) do
      RubyMalClient.configuration.client_id = nil
      anime = RubyMalClient::Anime.new
      VCR.use_cassette("get_anime_page") do
        anime.all
      end
    end
  end

  def test_once_client_id_is_setted_data_can_be_retrieved
    anime = init_anime
    VCR.use_cassette("get_anime_page") do
      animes = anime.all
      assert_instance_of Hash, animes
    end
  end

  def test_all_returns_a_valid_hash
    anime = init_anime
    VCR.use_cassette("get_anime_page") do
      animes = anime.all
      assert animes[:data].size.positive?
    end
  end

  def test_list_for_returns_a_valid_hash
    anime = init_anime
    VCR.use_cassette("get_custom_anime_list", match_requests_on: [:host]) do
      anime_list = anime.list_for("michael_apl")
      assert anime_list[:data].size.positive?
    end
  end

  def test_custom_fields_anime_list_returns_a_valid_hash
    anime = init_anime
    params = { fields: "list_status", limit: "100", status: "completed" }
    VCR.use_cassette("get_custom_anime_list") do
      anime_list = anime.list_for("michael_apl", params: params)
      random_anime = anime_list[:data].last
      assert random_anime.key?(:list_status)
    end
  end

  def test_find_returns_a_valid_hash
    anime = init_anime
    VCR.use_cassette("get_anime_details") do
      anime = anime.find("1")
      expected_fields = RubyMalClient::Configuration::ANIME_DETAILS_FIELDS.map(&:to_sym)
      assert_equal anime.keys, expected_fields
    end
  end

  def test_seasonal_anime_returns_a_valid_hash
    anime = init_anime
    VCR.use_cassette("seasonal_anime") do
      seasonal_animes = anime.seasonal(year: "2021", season: "fall")[:data]
      assert seasonal_animes.first.key?(:node)
    end
  end

  def test_seasonal_anime_validates_year
    anime = init_anime
    assert_raises(ArgumentError) do
      anime.seasonal(year: 3000)
    end
  end

  def test_seasonal_anime_validates_season
    anime = init_anime
    assert_raises(ArgumentError) do
      anime.seasonal(season: "winterfell")
    end
  end

  def test_seasonal_anime_accepts_floats_for_years
    anime = init_anime
    VCR.use_cassette("get_seasonal_anime") do
      season = anime.seasonal(year: 2021.9, season: "fall")[:season]
      assert_equal season[:year], 2021
    end
  end

  def test_seasonal_anime_accepts_symbols_for_seasons
    anime = init_anime
    VCR.use_cassette("get_seasonal_anime") do
      season = anime.seasonal(year: 2021, season: :fall)[:season]
      assert_equal season[:season], "fall"
    end
  end

  def init_anime
    RubyMalClient.configuration.client_id = "ab75fe72617c2d1ab411e46bb31c144f"
    RubyMalClient::Anime.new
  end
end
