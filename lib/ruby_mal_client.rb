# frozen_string_literal: true

require_relative "ruby_mal_client/version"
require_relative "ruby_mal_client/mal/anime"

module RubyMalClient
  class Error < StandardError; end

  anime = Anime.new

  animes = anime.get_anime
  puts animes  
end
