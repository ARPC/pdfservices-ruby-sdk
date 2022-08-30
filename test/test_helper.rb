# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "minitest/autorun"
require "webmock/minitest"

def json_fixture(name)
  path = File.join(Dir.pwd, "test", "fixtures", "#{name}.json")
  File.read(path)
end

def multipart_fixture(name)
  path = File.join(Dir.pwd, "test", "fixtures", "#{name}.multipart")
  IO.binread(path)
end

def file_fixture(file_name)
  path = File.join(Dir.pwd, "test", "fixtures", "files", file_name)
  File.read(path)
end

def valid_credentials
  ::PdfServicesSdk::CredentialsBuilder.new.from_file("test/fixtures/files/pdfservices-api-credentials.json").build()
end
