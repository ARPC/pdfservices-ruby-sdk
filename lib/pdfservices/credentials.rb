# frozen_string_literal: true

require "json"

module PdfServices
  class Credentials
    attr_accessor :client_id, :client_secret, :organization_id, :account_id, :private_key

    def initialize(client_id: nil, client_secret: nil, organization_id: nil, account_id: nil, private_key: nil)
      @client_id = client_id
      @client_secret = client_secret
      @organization_id = organization_id
      @account_id = account_id
      @private_key = private_key
    end
  end
end
