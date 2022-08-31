# frozen_string_literal: true

require "test_helper"

class CredentialsBuildTest < Minitest::Test
  def test_it_is_empty_when_initialized
    builder = ::PdfServices::CredentialsBuilder.new

    assert builder.instance_variable_get(:@client_id).nil?
    assert builder.instance_variable_get(:@client_secret).nil?
    assert builder.instance_variable_get(:@organization_id).nil?
    assert builder.instance_variable_get(:@account_id).nil?
    assert builder.instance_variable_get(:@private_key).nil?
  end

  def test_with_client_id_sets_client_id
    builder = ::PdfServices::CredentialsBuilder.new.with_client_id("123someclientid")

    assert builder.instance_variable_get(:@client_id) == "123someclientid"
  end

  def test_with_client_secret_sets_client_secret
    builder = ::PdfServices::CredentialsBuilder.new.with_client_secret("123someclientsecret")

    assert builder.instance_variable_get(:@client_secret) == "123someclientsecret"
  end

  def test_with_organization_id_sets_organization_id
    builder = ::PdfServices::CredentialsBuilder.new.with_organization_id("123someorganizationid")

    assert builder.instance_variable_get(:@organization_id) == "123someorganizationid"
  end

  def test_with_account_id_sets_account_id
    builder = ::PdfServices::CredentialsBuilder.new.with_account_id("123someaccountid")

    assert builder.instance_variable_get(:@account_id) == "123someaccountid"
  end

  def test_with_private_key_sets_private_key
    builder = ::PdfServices::CredentialsBuilder.new.with_private_key("123someprivatekey")

    assert builder.instance_variable_get(:@private_key) == "123someprivatekey"
  end

  def test_from_file_sets_all_fields
    builder = ::PdfServices::CredentialsBuilder.new.from_file("test/fixtures/files/pdfservices-api-credentials.json")

    assert builder.instance_variable_get(:@client_id) == "123someclientid"
    assert builder.instance_variable_get(:@client_secret) == "123-somesecret!"
    assert builder.instance_variable_get(:@organization_id) == "123@AdobeOrg"
    assert builder.instance_variable_get(:@account_id) == "456@techacct.adobe.com"
    assert !builder.instance_variable_get(:@private_key).nil?
  end

  def test_chaining_method
    builder = ::PdfServices::CredentialsBuilder.new
      .with_client_id("123someclientid")
      .with_client_secret("123someclientsecret")
      .with_organization_id("123someorganizationid")
      .with_account_id("123someaccountid")
      .with_private_key("123someprivatekey")

    assert builder.instance_variable_get(:@client_id) == "123someclientid"
    assert builder.instance_variable_get(:@client_secret) == "123someclientsecret"
    assert builder.instance_variable_get(:@organization_id) == "123someorganizationid"
    assert builder.instance_variable_get(:@account_id) == "123someaccountid"
    assert builder.instance_variable_get(:@private_key) == "123someprivatekey"
  end
end
