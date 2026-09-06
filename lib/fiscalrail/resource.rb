# frozen_string_literal: true

require "securerandom"

module FiscalRail
  class Resource
    def initialize(transport)
      @transport = transport
    end

    private

    def request(operation_id, path: {}, params: {}, body: nil, retry_safe: false, idempotency_key: nil, headers: {}, binary: false)
      operation = Generated::OPERATIONS.fetch(operation_id)
      route = operation.fetch("path").gsub(/\{([^}]+)\}/) do
        value = path.fetch(Regexp.last_match(1).to_sym)
        raise ArgumentError, "Path identifiers must be nonempty strings" unless value.is_a?(String) && !value.empty?

        URI.encode_www_form_component(value).gsub("+", "%20")
      end
      headers = headers.merge("Accept" => "application/pdf") if binary
      response = @transport.request(method: operation.fetch("method"), path: route, params: params,
        body: body, retry_safe: retry_safe, idempotency_key: idempotency_key, headers: headers)
      metadata = { request_id: response.headers["request-id"], idempotent_replayed: response.headers["idempotent-replayed"], idempotency_key: idempotency_key }
      unless operation.fetch("responses").key?(response.status.to_s)
        raise ResponseParseError.new("unexpected HTTP #{response.status}", model: operation_id, field: "$", **metadata.slice(:request_id, :idempotency_key))
      end
      return BinaryContent.new(response) if binary

      schema = operation.fetch("responses").fetch(response.status.to_s)
      return nil unless schema

      Decoder.decode(schema, JSON.parse(response.body), metadata: metadata)
    rescue JSON::ParserError => error
      raise ResponseParseError.new("invalid JSON", model: operation_id, field: "$", **metadata.slice(:request_id, :idempotency_key)), cause: error
    end

    def request_key(key)
      return SecureRandom.uuid if key.nil?
      raise ArgumentError, "idempotency_key must be a nonempty string of at most 255 bytes" unless key.is_a?(String) && key.bytesize.between?(1, 255)

      key
    end
  end

  module AutoPagination
    # Iteration always proceeds forward; reverse cursors belong to #list.
    def auto_paging_each(page_size: 100, **filters)
      return enum_for(__method__, page_size: page_size, **filters) unless block_given?
      raise ArgumentError, "Use list for explicit pagination cursors" unless (filters.keys & %i[limit starting_after ending_before]).empty?

      cursor = nil
      loop do
        page = list(**filters, limit: page_size, starting_after: cursor)
        page.each { |item| yield item }
        break unless page.has_more && !page.data.empty?

        next_cursor = page.data.last.id
        raise ResponseParseError.new("pagination cursor did not advance", model: "Page", field: "$.data", request_id: page.request_id) if next_cursor == cursor

        cursor = next_cursor
      end
      nil
    end
  end
end
