# frozen_string_literal: true

module FiscalRail
  class BinaryContent
    attr_reader :content, :content_type, :request_id

    def initialize(response)
      @content = response.body.b.freeze
      @content_type = response.headers["content-type"]&.freeze
      @request_id = response.headers["request-id"]&.freeze
      freeze
    end

    def write_to_file(path)
      File.binwrite(path, content)
    end
  end
end
