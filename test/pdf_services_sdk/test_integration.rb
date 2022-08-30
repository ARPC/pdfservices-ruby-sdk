require "test_helper"
require "json"
require "credentials_builder"
require "document_merge/operation"

class IntegrationTest < Minitest::Test

  def test_it_works
    stub_valid_response_sequence

    # Initial setup, create credentials instance.
    credentials = valid_credentials

    # Data for the document merge process
    json_string = file_fixture("sample_data.json")
    json_data_for_merge = JSON.parse(json_string)

    # template source file
    template_path = File.join(Dir.pwd, "test", "fixtures", "files", "sample_template.docx")

    operation = ::PdfServicesSdk::DocumentMerge::Operation.new(
      credentials,
      template_path,
      json_data_for_merge,
      :pdf
    )
    # Execute the operation
    result = operation.execute()

    assert result.success?
  end

  private

    def stub_valid_response_sequence
      stub_request(:post, "https://ims-na1.adobelogin.com/ims/exchange/jwt/")
        .to_return(status: 200, body: json_fixture("valid_jwt_response"))

      stub_request(:post, "https://cpf-ue1.adobe.io/ops/:create?respondWith=%7B%22reltype%22:%20%22http://ns.adobe.com/rel/primary%22%7D")
        .to_return(
          status: 202,
          headers: { "Location" => "https://cpf-ue1.adobe.io/ops/id/some-document-token" }.merge(json_headers),
          body: json_fixture("merge_request_in_progress")
        )

      stub_request(:get, "https://cpf-ue1.adobe.io/ops/id/some-document-token")
        .to_return(status: 202, headers: json_headers, body: json_fixture("merge_request_in_progress"))
        .to_return(status: 202, headers: json_headers, body: json_fixture("merge_request_in_progress"))
        .to_return(status: 200, headers: multipart_headers, body: multipart_fixture("merge_request_response"))
    end

    def json_headers
      { "Content-Type" => "application/json;charset=UTF-8" }
    end

    def multipart_headers
      { "Content-Type" => "multipart/mixed; boundary=Boundary_962026_575353369_1661875317362;charset=UTF-8" }
    end
end
