# frozen_string_literal: true

require "lib/pdfservices"

credentials = ::PdfServices::CredentialsBuilder.new
  .with_client_id(ENV["PDF_SERVICES_CLIENT_ID"])
  .with_client_secret(ENV["PDF_SERVICES_CLIENT_SECRET"])
  .with_organization_id(ENV["PDF_SERVICES_ORGANIZATION_ID"])
  .with_account_id(ENV["PDF_SERVICES_ACCOUNT_ID"])
  .with_private_key(ENV["PDF_SERVICES_PRIVATE_KEY"])
  .build

json = { message: "World"}
word_file = File.join(Dir.pwd, "test", "fixtures", "files", "sample_template.docx")
operation = ::PdfServices::DocumentMerge::Operation.new(credentials, word_file, json, "pdf")

result = operation.execute()

puts(result.error)

result.save_as_file("tmp/document_merge_result.pdf")
