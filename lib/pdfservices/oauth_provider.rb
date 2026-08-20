# frozen_string_literal: true

require "http"
require "json"

module PdfServices
  class OauthProvider
    IMS_ROOT = "https://ims-na1.adobelogin.com/"
    TOKEN_ENDPOINT = "#{IMS_ROOT}ims/token/v3"
    SCOPE = "openid,AdobeID,DCAPI,additional_info.projectedProductContext"

    def self.get_token(credentials)
      response = HTTP.post(TOKEN_ENDPOINT, form: {
        grant_type: "client_credentials",
        client_id: credentials.client_id,
        client_secret: credentials.client_secret,
        scope: SCOPE
      })
      if response.status == 200
        JSON.parse(response.body.to_s)["access_token"]
      else
        error_description = JSON.parse(response.body.to_s).fetch("error_description", "unknown error")
        raise error_description
      end
    end
  end
end
