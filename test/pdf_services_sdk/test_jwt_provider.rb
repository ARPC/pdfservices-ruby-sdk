require "test_helper"
require "credentials_builder"
require "http"
require "jwt_provider"

class JwtProviderTest < Minitest::Test
  def test_it_returns_a_jwt_token
    HTTP.stub :post, valid_response do
      jwt = ::PdfServicesSdk::JwtProvider.get_jwt(valid_credentials)
      assert_equal "fake1.fake2.fake3", jwt
    end
  end

  def test_it_raises_an_error_if_other_than_200
    error = assert_raises RuntimeError do
      HTTP.stub :post, invalid_response do
        _jwt = ::PdfServicesSdk::JwtProvider.get_jwt(valid_credentials)
      end
    end
    assert_equal "The JWT subject is invalid", error.message
  end

  private
    def valid_response
      ::HTTP::Response.new({
        status: 200,
        version: "1.1",
        headers: {},
        encoding: "UTF-8",
        body: "{\"token_type\":\"bearer\",\"access_token\":\"fake1.fake2.fake3\",\"expires_in\":86399998}",
        request: ::HTTP::Request.new({
          verb: :post,
          uri: ::PdfServicesSdk::JwtProvider::ENDPOINT
        })
      })
    end

    def invalid_response
      ::HTTP::Response.new({
        status: 400,
        version: "1.1",
        headers: {},
        encoding: "UTF-8",
        body: "{\"error_description\":\"The JWT subject is invalid\",\"error\":\"invalid_token\"}",
        request: ::HTTP::Request.new({
          verb: :post,
          uri: ::PdfServicesSdk::JwtProvider::ENDPOINT
        })
      })
    end

    def valid_credentials
      ::PdfServicesSdk::CredentialsBuilder.new.from_file("test/fixtures/files/pdfservices-api-credentials.json").build()
    end
end
