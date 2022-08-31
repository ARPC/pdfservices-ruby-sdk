# frozen_string_literal: true

require "http"
require "json"
require "jwt"
require "multipart_parser/reader"
require "yaml"

module PdfServices
  autoload :CredentialsBuilder, "pdfservices/credentials_builder"
  autoload :Credentials, "pdfservices/credentials"
  autoload :JwtProvider, "pdfservices/jwt_provider"

  module DocumentMerge
    autoload :Operation, "pdfservices/document_merge/operation"
    autoload :Result, "pdfservices/document_merge/result"
  end
end
