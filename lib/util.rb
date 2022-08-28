require 'multipart_parser/reader'

module Util
  extend self

  # parse a multipart MIME message, returning a hash of any multipart errors
  def parse_multipart(response)
    body = response.body.to_s
    boundary = body.lines.first
    reader = MultipartParser::Reader.new(boundary)

    result = { errors: [], parts: [] }
    def result.part(name)
      hash = self[:parts].detect { |h| h[:part].name == name }
      [hash[:part], hash[:body].join]
    end

    reader.on_part do |part|
      result[:parts] << thispart = {
        part: part,
        body: []
      }
      part.on_data do |chunk|
        thispart[:body] << chunk
      end
    end
    reader.on_error do |msg|
      result[:errors] << msg
    end
    reader.write(body)
    result
  end

  def parse_multipart_hash(event)
    event_parts = parse_multipart(event)[:parts]
    event_parts.inject({}) do |hash, part|
      if part[:part].filename.nil?
        hash.merge({part[:part].name => part[:body]})
      else
        hash.merge({part[:part].name => {mime: part[:part].mime, filename: part[:part].filename, data: part[:body].join}})
      end
    end
  end

end
