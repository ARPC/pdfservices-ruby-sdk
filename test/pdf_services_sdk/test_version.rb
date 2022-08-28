# frozen_string_literal: true

require "test_helper"
require "version"

class PdfServicesSdkTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PdfServicesSdk::VERSION
  end
end
