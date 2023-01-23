require "json"
require "multipart_parser/reader"

module PdfServices
  module Ocr
    class Result
      attr_accessor :document_body, :error

      def initialize(document_body, error)
        @document_body = document_body
        @error = error
      end

      def success?
        @document_body != nil
      end

      def save_as_file(file_path)
        location = File.join(Dir.pwd, file_path)
        File.write(location, @document_body)
      end
    end
  end
end
