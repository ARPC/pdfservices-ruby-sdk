# frozen_string_literal: true

require "http"
require "pdfservices/jwt_provider"
require "pdfservices/html_to_pdf/result"
require "yaml"

module PdfServices
  module HtmlToPdf
    class Operation
      PRESIGNED_URL_ENDPOINT = "https://pdf-services.adobe.io/assets"
      OPERATION_ENDPOINT = "https://pdf-services.adobe.io/operation/htmltopdf"
      ASSETS_ENDPOINT = "https://pdf-services.adobe.io/assets"

      def initialize(credentials = nil, zip_file_path = nil, json_data_for_merge = nil)
        @credentials = credentials
        @zip_file_path = zip_file_path
        @json_data_for_merge = json_data_for_merge
      end

      def get_presigned_url
        response = api.post(PRESIGNED_URL_ENDPOINT, json: {mediaType: "application/zip"})
        if response.status == 200
          JSON.parse(response.body.to_s)
        else
          Result.new(nil, "Unexpected response status from get presigned url: #{response.status}")
        end
      end

      def upload_asset(zip_file_path)
        presigned_url = get_presigned_url
        upload_uri = presigned_url["uploadUri"]
        asset_id = presigned_url["assetID"]
        aws = HTTP.headers({"Content-Type": "application/zip"})
        response = aws.put(upload_uri, body: File.open(zip_file_path))
        if response.status == 200
          asset_id
        else
          Result.new(nil, "Unexpected response status from asset upload: #{response.status}")
        end
      end

      def delete_the_asset(asset_id)
        api.delete("#{ASSETS_ENDPOINT}/#{asset_id}")
      end

      def execute
        asset_id = upload_asset(@zip_file_path)
        response = api.post(OPERATION_ENDPOINT, json: {
          assetID: asset_id,
          json: @json_data_for_merge&.to_json,
          pageLayout: { "pageWidth": 8.5, "pageHeight": 11},
          includeHeaderFooter: false
        })
        if response.status == 201
          document_url = response.headers["location"]
          poll_document_result(document_url, asset_id)
        else
          Result.new(nil, "Unexpected response status from html to pdf endpoint: #{response.status}\nasset_id: #{asset_id}")
        end
      end

      private

      def api_headers
        {
          Authorization: "Bearer #{JwtProvider.get_jwt(@credentials)}",
          "x-api-key": @credentials.client_id,
          "Content-Type": "application/json"
        }
      end

      def api
        @api ||= HTTP.headers(api_headers)
      end

      def poll_document_result(url, original_asset_id)
        sleep(1)
        response = api.get(url)
        if response.status == 200
          json_response = JSON.parse(response.body.to_s)
          document_generated_asset_id = json_response&.[]("asset")&.[]("assetID")
          case json_response["status"]
          when "in progress"
            poll_document_result(url, original_asset_id)
          when "done"
            # download_the_asset
            response = HTTP.get(json_response["asset"]["downloadUri"])
            # delete the assets
            delete_the_asset(original_asset_id) if !original_asset_id.nil?
            delete_the_asset(document_generated_asset_id) if !document_generated_asset_id.nil?
            # return the result
            Result.new(response.body, nil)
          when "failed"
            # delete the original asset
            message = json_response["error"]["message"]
            delete_the_asset(original_asset_id) if !original_asset_id.nil?
            Result.new(nil, message)
          else
            # delete the original asset
            delete_the_asset(original_asset_id) if original_asset_id.present?
            Result.new(nil, "Unexpected status from polling: #{json_response["status"]}")
          end
        else
          # delete the original asset
          delete_the_asset(original_asset_id) if original_asset_id.present?
          Result.new(nil, "Unexpected response status from polling: #{json_response["status"]}")
        end
      end
    end
  end
end
