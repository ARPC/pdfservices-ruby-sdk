# frozen_string_literal: true

require "http"
require "pdfservices/jwt_provider"
require "pdfservices/ocr/result"
require "yaml"

module PdfServices
  module Ocr
    class Operation
      PRESIGNED_URL_ENDPOINT = "https://pdf-services.adobe.io/assets"
      OCR_ENDPOINT = "https://pdf-services.adobe.io/operation/ocr"
      ASSETS_ENDPOINT = "https://pdf-services.adobe.io/assets"

      def initialize(credentials = nil)
        @credentials = credentials
      end

      def get_presigned_url
        response = api.post(PRESIGNED_URL_ENDPOINT, json: { mediaType: "application/pdf" })
        if response.status == 200
          JSON.parse(response.body.to_s)
        else
          Result.new(nil, "Unexpected response status from get presigned url: #{response.status}")
        end
      end

      def upload_asset(source_pdf)
        presigned_url = get_presigned_url()
        upload_uri = presigned_url["uploadUri"]
        asset_id = presigned_url["assetID"]
        aws = HTTP.headers({ "Content-Type": "application/pdf" })
        response = aws.put(upload_uri, body: File.open(source_pdf))
        if response.status == 200
          asset_id
        else
          Result.new(nil, "Unexpected response status from asset upload: #{response.status}")
        end
      end

      def delete_the_asset(asset_id)
        api.delete("#{ASSETS_ENDPOINT}/#{asset_id}")
      end

      def execute(source_pdf)
        asset_id = upload_asset(source_pdf)
        response = api.post(OCR_ENDPOINT, json: { "assetID": asset_id })
        if response.status == 201
          document_url = response.headers["location"]
          poll_document_result(document_url, asset_id)
        else
          Result.new(nil, "Unexpected response status from ocr endpoint: #{response.status}\nasset_id: #{asset_id}")
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
          json_response =  JSON.parse(response.body.to_s)
          ocr_asset_id = json_response&.[]("asset")&.[]("assetID")
          case json_response["status"]
          when "in progress"
            poll_document_result(url, original_asset_id)
          when "done"
            # download_the_asset
            response = HTTP.get(json_response["asset"]["downloadUri"])
            # delete the assets
            delete_the_asset(original_asset_id) if original_asset_id.present?
            delete_the_asset(ocr_asset_id) if ocr_asset_id.present?
            # return the result
            Result.new(response.body, nil)
          when "failed"
            # delete the original asset
            delete_the_asset(original_asset_id) if original_asset_id.present?
            Result.new(nil, "OCR Failed")
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
