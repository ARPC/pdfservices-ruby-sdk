require "json"
require "multipart_parser/reader"

module PdfServices
  module HtmlToPdf
    class Result
      attr_accessor :document, :error

      def initialize(document, error)
        @document = document
        @error = error
      end

      def success?
        @document != nil
      end

      def save_as_file(file_path)
        location = File.join(Dir.pwd, file_path)
        File.write(location, @document)
      end

      def self.from_multipart_response(response)
        parts = parse_multipart(response)[:parts]
        if parts.length == 2
          document = parts[1][:body].join
          Result.new(document, nil)
        else
          Result.new(nil, "Not 2 parts")
        end
      end

      private_class_method def self.parse_multipart(response)
        content_type = response.headers.get("Content-Type").join(";")
        boundary = MultipartParser::Reader.extract_boundary_value(content_type)
        reader = MultipartParser::Reader.new(boundary)
        body = response.body.to_s

        result = {errors: [], parts: []}
        def result.part(name)
          hash = self[:parts].detect { |h| h[:part].name == name }
          [hash[:part], hash[:body].join]
        end

        reader.on_part do |part|
          result[:parts] << thispart = {
            part: part,
            body: []
          }
          part.on_data do |chunk|
            thispart[:body] << chunk
          end
        end
        reader.on_error do |msg|
          result[:errors] << msg
        end
        reader.write(body)
        result
      end
    end
  end
end
