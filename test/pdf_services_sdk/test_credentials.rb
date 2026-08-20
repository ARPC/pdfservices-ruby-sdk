# frozen_string_literal: true

require "test_helper"

class CredentialsTest < Minitest::Test
  def test_it_has_the_fields
    credentials = ::PdfServices::Credentials.new(
      client_id: "client_id",
      client_secret: "client_secret"
    )

    assert credentials.client_id == "client_id"
    assert credentials.client_secret == "client_secret"
  end
end
