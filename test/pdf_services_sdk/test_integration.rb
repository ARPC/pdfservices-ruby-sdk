require "test_helper"
require "json"
require "credentials_builder"
require "execution_context"
require "file_ref"
require "document_merge/operation"
require "document_merge/options/document_merge_options"
require "document_merge/options/output_format"

class IntegrationTest < Minitest::Test

  def test_it_works
    # Initial setup, create credentials instance.
    credentials = ::PdfServicesSdk::CredentialsBuilder.new.from_file("integration_test_files/pdfservices-api-credentials.json").build()

    # Setup input data for the document merge process
    json_string = File.read("integration_test_files/sample_claim.json")
    json_data_for_merge = JSON.parse(json_string)

    # Create an ExecutionContext using credentials
    execution_context = ::PdfServicesSdk::ExecutionContext.new(credentials)

    # Create a new DocumentMerge options instance
    document_merge = ::PdfServicesSdk::DocumentMerge
    document_merge_options = document_merge::Options
    options = document_merge_options::DocumentMergeOptions.new(json_data_for_merge, document_merge_options::OutputFormat::PDF)

    # Create a new operation instance using the options instance
    document_merge_operation = document_merge::Operation.new(options)

    # Set operation input document template from a source file
    input = ::PdfServicesSdk::FileRef.create_from_file("integration_test_files/claim_template.docx")
    document_merge_operation.set_input(input)

    # Execute the operation and Save the result to the specified location
    document_merge_operation.execute(execution_context) do |result|
      if result.success?
        result.save_as_file("integration_test_files/output.pdf")
      else
        error = result.error
        # if error.is_a?(::PdfServicesSdk::Error::ServiceApiError) || error.is_a?(::PdfServicesSdk::Error::ServiceUsageError)
        #   puts "Exception encountered while executing operation"
        #   puts error
        # else
          puts "Exception encountered while executing operation"
          puts error
        # end
      end
    end
  end

end
