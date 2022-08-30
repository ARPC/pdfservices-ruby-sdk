# frozen_string_literal: true

require "json"
require "credentials"

module PdfServicesSdk
  class CredentialsBuilder
    def initialize
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

    def with_organization_id(organization_id)
      @organization_id = organization_id
      self
    end

    def with_account_id(account_id)
      @account_id = account_id
      self
    end

    def with_private_key(private_key)
      @private_key = private_key
      self
    end

    def from_file(file_path)
      credentials = JSON.parse(File.read(file_path))
      private_key = File.read(credentials["service_account_credentials"]["private_key_file"])
      with_client_id(credentials["client_credentials"]["client_id"])
      with_client_secret(credentials["client_credentials"]["client_secret"])
      with_organization_id(credentials["service_account_credentials"]["organization_id"])
      with_account_id(credentials["service_account_credentials"]["account_id"])
      with_private_key(private_key)
      self
    end

    def build
      ::PdfServicesSdk::Credentials.new(
        client_id: @client_id,
        client_secret: @client_secret,
        organization_id: @organization_id,
        account_id: @account_id,
        private_key: @private_key
      )
    end
  end
end
