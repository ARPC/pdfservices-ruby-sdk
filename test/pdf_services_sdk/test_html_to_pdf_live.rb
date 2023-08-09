require "test_helper_live"
class HtmlToPdfLive < Minitest::Test
  def test_live_call
    private_key = ENV["PDF_SERVICES_PRIVATE_KEY"]
    client_id =ENV["PDF_SERVICES_CLIENT_ID"]
    client_secret = ENV["PDF_SERVICES_CLIENT_SECRET"]
    organization_id = ENV["PDF_SERVICES_ORGANIZATION_ID"]
    account_id = ENV["PDF_SERVICES_ACCOUNT_ID"]
    credentials = ::PdfServices::CredentialsBuilder.new
      .with_client_id(client_id)
      .with_client_secret(client_secret)
      .with_organization_id(organization_id)
      .with_account_id(account_id)
      .with_private_key(private_key)
      .build
    json_string = file_fixture("sample_data.json")
    json_data_for_merge = JSON.parse(json_string)
    zip_file_path = File.join(Dir.pwd, "test", "fixtures", "files", "sample.zip")
    operation = ::PdfServices::HtmlToPdf::Operation.new(
      credentials,
      zip_file_path,
      json_data_for_merge
    )
    result = operation.execute
    puts result.success?
  end
end
