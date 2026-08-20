# frozen_string_literal: true

require "json"
require "pdfservices/credentials"

module PdfServices
  class CredentialsBuilder
    def initialize
      @client_id = nil
      @client_secret = nil
    end

    def with_client_id(client_id)
      @client_id = client_id
      self
    end

    def with_client_secret(client_secret)
      @client_secret = client_secret
      self
    end

    def from_file(file_path)
      credentials = JSON.parse(File.read(file_path))
      with_client_id(credentials["client_id"])
      with_client_secret(credentials["client_secret"])
      self
    end

    def build
      ::PdfServices::Credentials.new(
        client_id: @client_id,
        client_secret: @client_secret
      )
    end
  end
end
