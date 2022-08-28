module PdfServicesSdk
  class FileRef
    attr_reader :file_path

    def initialize(file_path)
      @file_path = file_path
    end

    def self.create_from_file(file_path)
      FileRef.new(file_path)
    end
  end
end
