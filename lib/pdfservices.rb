# frozen_string_literal: true

require "http"
require "json"
require "multipart_parser/reader"
require "yaml"
require "pdfservices/version"

module PdfServices
  autoload :CredentialsBuilder, "pdfservices/credentials_builder"
  autoload :Credentials, "pdfservices/credentials"
  autoload :OauthProvider, "pdfservices/oauth_provider"

  module DocumentMerge
    autoload :Operation, "pdfservices/document_merge/operation"
    autoload :Result, "pdfservices/document_merge/result"
  end

  module Ocr
    autoload :Operation, "pdfservices/ocr/operation"
    autoload :Result, "pdfservices/ocr/result"
  end

  module HtmlToPdf
    autoload :Operation, "pdfservices/html_to_pdf/operation"
    autoload :Result, "pdfservices/html_to_pdf/result"
  end
end
