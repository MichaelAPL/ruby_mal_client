# frozen_string_literal: true

require_relative "ruby_mal_client/version"
require_relative "ruby_mal_client/errors"
require_relative "ruby_mal_client/configuration"
require_relative "ruby_mal_client/http_client"
require_relative "ruby_mal_client/auth_client"
require_relative "ruby_mal_client/endpoint"
require_relative "ruby_mal_client/anime"
require_relative "ruby_mal_client/manga"
require_relative "ruby_mal_client/forum"
require_relative "ruby_mal_client/authenticated_user"

module RubyMalClient
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end
  end

  def self.configure
    yield(configuration)
  end
end
