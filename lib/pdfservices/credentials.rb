# frozen_string_literal: true

require "json"

module PdfServices
  class Credentials
    attr_accessor :client_id, :client_secret

    def initialize(client_id: nil, client_secret: nil)
      @client_id = client_id
      @client_secret = client_secret
    end
  end
end
