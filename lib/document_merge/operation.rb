# frozen_string_literal: true
require "jwt_provider"
require "http"
require "document_merge/result"

module PdfServicesSdk
  module DocumentMerge
    class Operation
      ENDPOINT = "https://cpf-ue1.adobe.io/ops/:create".freeze
      DOCUMENT_GENERATION_ASSET_ID = "urn:aaid:cpf:Service-52d5db6097ed436ebb96f13a4c7bf8fb".freeze

      def initialize(options)
        @options = options
      end

      def set_input(file_ref)
        @input = file_ref
      end

      def execute(context, &block)
        file_path = File.join(Dir.pwd, @input.file_path)
        url = "#{ENDPOINT}?respondWith=%7B%22reltype%22%3A%20%22http%3A%2F%2Fns.adobe.com%2Frel%2Fprimary%22%7D"
        headers = {
          "Authorization": "Bearer #{JwtProvider.get_jwt(context.credentials)}",
          "x-api-key": context.credentials.client_id,
          "Prefer": "respond-async,wait=0"
        }
        content_analyzer_requests = {
          "cpf:engine": {
            "repo:assetId": DOCUMENT_GENERATION_ASSET_ID
          },
          "cpf:inputs": {
            "documentIn": {
              "dc:format": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
              "cpf:location": "InputFile0"
            },
            "params": {
              "cpf:inline": {
                "outputFormat": @options.output_format,
                "jsonDataForMerge": @options.json_data_for_merge
              }
            }
          },
          "cpf:outputs": {
            "documentOut": {
              "dc:format": mime_type(@options.output_format),
              "cpf:location": "multipartLabel"
            }
          }
        }
        data = {
          contentAnalyzerRequests: content_analyzer_requests.to_json,
          "InputFile0": HTTP::FormData::File.new(file_path)
        }
        http = HTTP.headers(headers)
        res = http.post(url, form: data)
        if res.status == 202
          document_url = res.headers["Location"]
          puts "Document URL: #{document_url}"
          result = poll_document_result(http, document_url)
          yield result if block_given?
        else
          result = Result.new(nil, "Unexpected response status: #{res.status}")
          yield result if block_given?
        end
      end


      private
        def poll_document_result(http, url)
          sleep(1)
          document_response = http.get(url)
          case document_response.content_type.mime_type
          when "application/json"
            puts "not yet ready..."
            poll_document_result(http, url)
          when "multipart/mixed"
            Result.from_multipart_response(document_response)
          else
            Result.new(nil, "Unexpected response content type: #{document_response.content_type.mime_type}; status: #{document_response.status}")
          end
        end

        def mime_type(format)
          case format
          when "docx"
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
          when "pdf"
            "application/pdf"
          else
            "text/plain"
          end
        end
    end
  end
end
