# frozen_string_literal: true

require "http"
require "jwt_provider"
require "pdfservices/document_merge/result"
require "yaml"

module PdfServices
  module DocumentMerge
    class Operation
      ENDPOINT = "https://cpf-ue1.adobe.io/ops/:create?respondWith=%7B%22reltype%22%3A%20%22http%3A%2F%2Fns.adobe.com%2Frel%2Fprimary%22%7D"
      DOCUMENT_GENERATION_ASSET_ID = "urn:aaid:cpf:Service-52d5db6097ed436ebb96f13a4c7bf8fb"

      def initialize(credentials = nil, template_path = nil, json_data_for_merge = nil, output_format = nil)
        @credentials = credentials
        @template_path = template_path
        @json_data_for_merge = json_data_for_merge
        @output_format = output_format
      end

      def execute
        form = {
          contentAnalyzerRequests: build_content_analyzer_requests.to_json,
          InputFile0: build_input_file
        }
        response = api.post(ENDPOINT, form: form)
        if response.status == 202
          document_url = response.headers["Location"]
          poll_document_result(document_url)
        else
          Result.new(nil, "Unexpected response status: #{response.status}")
        end
      end

      private

      def build_content_analyzer_requests
        {
          "cpf:engine": {
            "repo:assetId": DOCUMENT_GENERATION_ASSET_ID
          },
          "cpf:inputs": {
            documentIn: {
              "dc:format": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
              "cpf:location": "InputFile0"
            },
            params: {
              "cpf:inline": {
                outputFormat: @output_format,
                jsonDataForMerge: @json_data_for_merge
              }
            }
          },
          "cpf:outputs": {
            documentOut: {
              "dc:format": mime_type(@output_format),
              "cpf:location": "multipartLabel"
            }
          }
        }
      end

      def build_headers
        {
          Authorization: "Bearer #{JwtProvider.get_jwt(@credentials)}",
          "x-api-key": @credentials.client_id,
          Prefer: "respond-async,wait=0"
        }
      end

      def build_input_file
        HTTP::FormData::File.new(@template_path)
      end

      def api
        @api ||= HTTP.headers(build_headers)
      end

      def poll_document_result(url)
        sleep(1)
        document_response = api.get(url)
        case document_response.content_type.mime_type
        when "application/json"
          poll_document_result(url)
        when "multipart/mixed"
          Result.from_multipart_response(document_response)
        else
          Result.new(nil, "Unexpected response content type: #{document_response.content_type.mime_type}; status: #{document_response.status}")
        end
      end

      def mime_type(format)
        case format
        when :docx
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        when :pdf
          "application/pdf"
        else
          "text/plain"
        end
      end
    end
  end
end
