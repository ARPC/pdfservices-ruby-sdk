# frozen_string_literal: true

require "http"
require "json"
require "jwt"
require "multipart_parser/reader"
require "pdfservices/document_merge/operation"
require "pdfservices/document_merge/result"
require "pdfservices/credentials_builder"
require "pdfservices/credentials"
require "pdfservices/jwt_provider"
require "pdfservices/version"
require "yaml"

module PdfServices
end
