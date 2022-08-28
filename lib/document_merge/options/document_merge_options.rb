module PdfServicesSdk
  module DocumentMerge
    module Options
      class DocumentMergeOptions
        attr_accessor :json_data_for_merge, :output_format

        def initialize(json_data_for_merge, output_format)
          @json_data_for_merge = json_data_for_merge
          @output_format = output_format
        end
      end
    end
  end
end
