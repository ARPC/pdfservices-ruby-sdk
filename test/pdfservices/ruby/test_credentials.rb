# frozen_string_literal: true

require "test_helper"
require "pdf_services_sdk/credentials"

class CredentialsTest < Minitest::Test
  def test_it_has_the_client_id
    credentials = ::PdfServicesSdk::Credentials.from_file("test/fixtures/files/pdfservices-api-credentials.json")

    assert credentials.client_id == "123someclientid"
  end
end
