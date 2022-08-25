# frozen_string_literal: true

require "test_helper"
require "pdf_services_sdk/credentials_builder"

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
end
