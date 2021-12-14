# frozen_string_literal: true

require_relative "ruby_mal_client/version"
require_relative "ruby_mal_client/mal/anime"
require_relative "ruby_mal_client/mal/anime_list"

module RubyMalClient
  class Error < StandardError; end

  anime_list = AnimeList.new

  puts "Welcome to Ruby MAL Client"
  puts "Please grant the GEM access to your profile using the following url: "

  puts anime_list.auth_url
end
