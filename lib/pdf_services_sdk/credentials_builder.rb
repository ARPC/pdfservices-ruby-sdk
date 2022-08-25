# frozen_string_literal: true
require "json"
require_relative "version"

module PdfServicesSdk
  class CredentialsBuilder
    def initialize()
      @client_id = nil
      @client_secret = nil
      @organization_id = nil
      @account_id = nil
      @private_key = nil
    end

    def with_client_id(client_id)
      @client_id = client_id
      self
    end

    def with_client_secret(client_secret)
      @client_secret = client_secret
      self
    end
  end
end
