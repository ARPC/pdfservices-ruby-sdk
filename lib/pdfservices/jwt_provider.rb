# frozen_string_literal: true

require "http"
require "json"
require "jwt"
require "yaml"

module PdfServices
  class JwtProvider
    ROOT = "https://ims-na1.adobelogin.com/"
    ENDPOINT = "#{ROOT}ims/exchange/jwt/"
    SCOPE = "#{ROOT}s/ent_documentcloud_sdk"

    def self.get_jwt(credentials)
      payload = {
        :exp => Time.now.to_i + 3600,
        :iss => credentials.organization_id,
        :sub => credentials.account_id,
        :aud => "#{ROOT}c/#{credentials.client_id}",
        SCOPE => true
      }
      key = OpenSSL::PKey::RSA.new(credentials.private_key)
      jwt = JWT.encode(payload, key, "RS256")
      url = ENDPOINT
      form = {
        client_id: credentials.client_id,
        client_secret: credentials.client_secret,
        jwt_token: jwt
      }
      response = HTTP.post(url, form: form)
      if response.status == 200
        response_json = JSON.parse(response.body.to_s)
        response_json["access_token"]
      else
        error_description = JSON.parse(response.body.to_s).fetch("error_description", "unknown error")
        raise error_description
      end
    end
  end
end
