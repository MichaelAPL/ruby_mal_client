# frozen_string_literal: true

require "test_helper"
require "vcr"

class RubyMalClientTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RubyMalClient::VERSION
  end
end
