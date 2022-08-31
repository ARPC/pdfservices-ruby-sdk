# frozen_string_literal: true

require "test_helper"

class JwtProviderTest < Minitest::Test
  def test_it_returns_a_jwt_token
    stub_valid_response
    jwt = ::PdfServices::JwtProvider.get_jwt(valid_credentials)
    assert_equal "fake1.fake2.fake3", jwt
  end

  def test_it_raises_an_error_if_other_than_200
    stub_invalid_response
    error = assert_raises RuntimeError do
      _jwt = ::PdfServices::JwtProvider.get_jwt(valid_credentials)
    end
    assert_equal "The JWT subject is invalid", error.message
  end

  private

  def stub_jwt_request
    stub_request(:post, "https://ims-na1.adobelogin.com/ims/exchange/jwt/")
  end

  def stub_valid_response
    stub_jwt_request.to_return(status: 200, body: json_fixture("valid_jwt_response"))
  end

  def stub_invalid_response
    stub_jwt_request.to_return(status: 400, body: json_fixture("invalid_jwt_response"))
  end

  def valid_credentials
    ::PdfServices::CredentialsBuilder.new.from_file("test/fixtures/files/pdfservices-api-credentials.json").build
  end
end
