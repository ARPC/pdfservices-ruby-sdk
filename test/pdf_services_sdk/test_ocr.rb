# frozen_string_literal: true

require "test_helper"

class OcrTest < Minitest::Test
  def test_it_works
    stub_valid_response_sequence

    # Initial setup, create credentials instance.
    credentials = valid_credentials

    # source file
    source_pdf_path = File.join(Dir.pwd, "test", "fixtures", "files", "not_yet_ocr.pdf")

    operation = ::PdfServices::Ocr::Operation.new(credentials)

    # Execute the operation
    result = operation.execute(source_pdf_path)

    assert result.success?
    assert_equal "this is fake ocr'd pdf\n", result.document_body.to_s
  end

  private

  def stub_valid_response_sequence
    # get JWT for requests
    stub_request(:post, "https://ims-na1.adobelogin.com/ims/exchange/jwt/")
      .to_return(status: 200, body: json_fixture("valid_jwt_response"))

    # get a presigned url to upload the source pdf
    stub_request(:post, "https://pdf-services.adobe.io/assets")
      .with(headers: secured_headers)
      .to_return(
        status: 200,
        headers: json_headers,
        body: json_fixture("presigned_upload_url_response")
      )

    # upload the source pdf
    stub_request(:put, "https://a.presigned.url").to_return(status: 200)

    # request the OCR operation
    stub_request(:post, "https://pdf-services.adobe.io/operation/ocr")
      .with(headers: secured_headers)
      .to_return(
        status: 201,
        headers: {"location" => "https://some.polling.url"}.merge(json_headers)
      )

    # poll for the result
    stub_request(:get, "https://some.polling.url")
      .with(headers: secured_headers)
      .to_return(status: 200, headers: json_headers, body: json_fixture("ocr_in_progress"))
      .to_return(status: 200, headers: json_headers, body: json_fixture("ocr_in_progress"))
      .to_return(status: 200, headers: json_headers, body: json_fixture("ocr_done"))

    # download the ocr'd pdf
    stub_request(:get, "https://ocr.file.url")
      .to_return(status: 200, headers: pdf_headers, body: file_fixture("fake_ocr_done.pdf"))

    # delete the original asset
    stub_request(:delete, "https://pdf-services.adobe.io/assets/urn:a-real-long-asset-asset-id")
      .with(headers: secured_headers)
      .to_return(status: 200, body: "", headers: {})

    # delete the ocr'd asset
    stub_request(:delete, "https://pdf-services.adobe.io/assets/ocr'd:asset-id")
      .with(headers: secured_headers)
      .to_return(status: 200, body: "", headers: {})
  end

  def secured_headers
    {
      "Authorization": "Bearer fake1.fake2.fake3",
      "Content-Type": "application/json",
      "X-Api-Key": "123someclientid"
    }
  end

  def json_headers
    {"Content-Type" => "application/json;charset=UTF-8"}
  end

  def pdf_headers
    {"Content-Type" => "application/pdf"}
  end
end
