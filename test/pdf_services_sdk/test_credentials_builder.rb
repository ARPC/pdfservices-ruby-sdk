# frozen_string_literal: true

require "test_helper"
require "credentials_builder"

class CredentialsBuildTest < Minitest::Test
  def test_it_is_empty_when_initialized
    builder = ::PdfServicesSdk::CredentialsBuilder.new

    assert nil == builder.instance_variable_get(:@client_id)
    assert nil == builder.instance_variable_get(:@client_secret)
    assert nil == builder.instance_variable_get(:@organization_id)
    assert nil == builder.instance_variable_get(:@account_id)
    assert nil == builder.instance_variable_get(:@private_key)
  end

  def test_with_client_id_sets_client_id
    builder = ::PdfServicesSdk::CredentialsBuilder.new.with_client_id("123someclientid")

    assert "123someclientid" == builder.instance_variable_get(:@client_id)
  end

  def test_with_client_secret_sets_client_secret
    builder = ::PdfServicesSdk::CredentialsBuilder.new.with_client_secret("123someclientsecret")

    assert "123someclientsecret" == builder.instance_variable_get(:@client_secret)
  end

  def test_with_organization_id_sets_organization_id
    builder = ::PdfServicesSdk::CredentialsBuilder.new.with_organization_id("123someorganizationid")

    assert "123someorganizationid" == builder.instance_variable_get(:@organization_id)
  end

  def test_with_account_id_sets_account_id
    builder = ::PdfServicesSdk::CredentialsBuilder.new.with_account_id("123someaccountid")

    assert "123someaccountid" == builder.instance_variable_get(:@account_id)
  end

  def test_with_private_key_sets_private_key
    builder = ::PdfServicesSdk::CredentialsBuilder.new.with_private_key("123someprivatekey")

    assert "123someprivatekey" == builder.instance_variable_get(:@private_key)
  end

  def test_from_file_sets_all_fields
    builder = ::PdfServicesSdk::CredentialsBuilder.new.from_file("test/fixtures/files/pdfservices-api-credentials.json")

    assert "123someclientid" == builder.instance_variable_get(:@client_id)
    assert "123-somesecret!" == builder.instance_variable_get(:@client_secret)
    assert "123@AdobeOrg" == builder.instance_variable_get(:@organization_id)
    assert "456@techacct.adobe.com" == builder.instance_variable_get(:@account_id)
    assert "-----BEGIN RSA PRIVATE KEY-----\nthiskeyisgarbage\n-----END RSA PRIVATE KEY-----\n" == builder.instance_variable_get(:@private_key), builder.instance_variable_get(:@private_key)
  end

  def test_chaining_method
    builder = ::PdfServicesSdk::CredentialsBuilder.new
      .with_client_id("123someclientid")
      .with_client_secret("123someclientsecret")
      .with_organization_id("123someorganizationid")
      .with_account_id("123someaccountid")
      .with_private_key("123someprivatekey")

    assert "123someclientid" == builder.instance_variable_get(:@client_id)
    assert "123someclientsecret" == builder.instance_variable_get(:@client_secret)
    assert "123someorganizationid" == builder.instance_variable_get(:@organization_id)
    assert "123someaccountid" == builder.instance_variable_get(:@account_id)
    assert "123someprivatekey" == builder.instance_variable_get(:@private_key)
  end
end
