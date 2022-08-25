# frozen_string_literal: true
require "json"
require_relative "version"

module PdfServicesSdk
  class Credentials
    attr_accessor :client_id

    def initialize(client_id: nil)
      @client_id = client_id
    end

    def self.from_file(json_filepath)
      json = File.read(json_filepath)
      credentials = JSON.parse(json)
      Credentials.new(client_id: credentials["client_credentials"]["client_id"])
    end
  end
end
