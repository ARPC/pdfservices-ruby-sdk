# frozen_string_literal: true

require "test_helper"
require "credentials"

class CredentialsTest < Minitest::Test
  def test_it_has_the_fields
    credentials = ::PdfServicesSdk::Credentials.new(
      client_id: "client_id",
      client_secret: "client_secret",
      organization_id: "organization_id",
      account_id: "account_id",
      private_key: "private_key"
    )

    assert credentials.client_id == "client_id"
    assert credentials.client_secret == "client_secret"
    assert credentials.organization_id == "organization_id"
    assert credentials.account_id == "account_id"
    assert credentials.private_key == "private_key"
  end
end
