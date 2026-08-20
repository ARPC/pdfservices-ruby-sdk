# frozen_string_literal: true

require "test_helper"

class OauthProviderTest < Minitest::Test
  def test_it_returns_an_access_token
    stub_valid_response
    token = ::PdfServices::OauthProvider.get_token(valid_credentials)
    assert_equal "fake1.fake2.fake3", token
  end

  def test_it_raises_an_error_if_other_than_200
    stub_invalid_response
    error = assert_raises RuntimeError do
      _token = ::PdfServices::OauthProvider.get_token(valid_credentials)
    end
    assert_equal "The client credentials are invalid", error.message
  end

  private

  def stub_token_request
    stub_request(:post, "https://ims-na1.adobelogin.com/ims/token/v3")
  end

  def stub_valid_response
    stub_token_request.to_return(status: 200, body: json_fixture("valid_oauth_response"))
  end

  def stub_invalid_response
    stub_token_request.to_return(status: 400, body: json_fixture("invalid_oauth_response"))
  end
end
