module PdfServicesSdk
  class ExecutionContext
    attr_reader :credentials

    def initialize(credentials)
      @credentials = credentials
    end
  end
end
