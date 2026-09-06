# frozen_string_literal: true

require "minitest/autorun"
require "fiscalrail"
require "tmpdir"

class FakeAdapter
  attr_reader :requests
  attr_accessor :closed

  def initialize(&handler)
    @handler = handler
    @requests = []
  end

  def call(**request)
    @requests << request
    @handler.call(request)
  end

  def close
    @closed = true
  end
end

class SDKTest < Minitest::Test
  def fixture(name)
    JSON.parse(File.read(File.join(__dir__, "fixtures", "#{name}.json")))
  end

  def response(body, status: 200, headers: {})
    FiscalRail::NetHTTPAdapter::Response.new(status: status, body: JSON.generate(body),
      headers: { "Request-Id" => "req_test", "Content-Type" => "application/json" }.merge(headers))
  end

  def client(max_retries: 0, &handler)
    @adapter = FakeAdapter.new(&handler)
    FiscalRail::Client.new(api_key: "ak_test_example", adapter: @adapter, max_retries: max_retries)
  end

  def decode(name, value)
    FiscalRail::Decoder.decode({ "$ref" => "#/components/schemas/#{name}" }, value)
  end

  def page(value, has_more: false)
    { "object" => "list", "has_more" => has_more, "data" => value }
  end
end
