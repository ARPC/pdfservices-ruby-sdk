# frozen_string_literal: true

require "test_helper"

class CredentialsBuildTest < Minitest::Test
  def test_it_is_empty_when_initialized
    builder = ::PdfServices::CredentialsBuilder.new

    assert builder.instance_variable_get(:@client_id).nil?
    assert builder.instance_variable_get(:@client_secret).nil?
  end

  def test_with_client_id_sets_client_id
    builder = ::PdfServices::CredentialsBuilder.new.with_client_id("123someclientid")

    assert builder.instance_variable_get(:@client_id) == "123someclientid"
  end

  def test_with_client_secret_sets_client_secret
    builder = ::PdfServices::CredentialsBuilder.new.with_client_secret("123someclientsecret")

    assert builder.instance_variable_get(:@client_secret) == "123someclientsecret"
  end

  def test_from_file_sets_all_fields
    builder = ::PdfServices::CredentialsBuilder.new.from_file("test/fixtures/files/pdfservices-api-credentials.json")

    assert builder.instance_variable_get(:@client_id) == "123someclientid"
    assert builder.instance_variable_get(:@client_secret) == "123-somesecret!"
  end

  def test_chaining_method
    builder = ::PdfServices::CredentialsBuilder.new
      .with_client_id("123someclientid")
      .with_client_secret("123someclientsecret")

    assert builder.instance_variable_get(:@client_id) == "123someclientid"
    assert builder.instance_variable_get(:@client_secret) == "123someclientsecret"
  end
end
