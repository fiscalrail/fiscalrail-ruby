# frozen_string_literal: true

require_relative "test_helper"

class TransportTest < SDKTest
  def test_issuance_preserves_key_and_body_across_retries
    attempts = 0
    sdk = client(max_retries: 1) do |req|
      attempts += 1
      assert_equal "Bearer ak_test_example", req[:headers]["Authorization"]
      assert_equal "application/json", req[:headers]["Content-Type"]
      assert_equal "fiscalrail-ruby/#{FiscalRail::VERSION}", req[:headers]["User-Agent"]
      attempts == 1 ? response({}, status: 503, headers: { "Retry-After" => "0" }) : response(fixture("Invoice"), status: 201, headers: { "Idempotent-Replayed" => "req_original" })
    end
    invoice = sdk.invoices.issue(lines: [{ unit_price: BigDecimal("2500.00"), taxes: [FiscalRail::TaxRegimes::ES::VAT.general] }])
    first, second = @adapter.requests
    assert_equal first[:headers]["Idempotency-Key"], second[:headers]["Idempotency-Key"]
    assert_equal first[:body], second[:body]
    assert_equal first[:headers]["Idempotency-Key"], invoice.idempotency_key
    assert_equal "req_original", invoice.idempotent_replayed
    assert_equal "2500.0", JSON.parse(first[:body]).dig("lines", 0, "unit_price")
    assert_equal({ "tax" => "vat", "rule" => "general" }, JSON.parse(first[:body]).dig("lines", 0, "taxes", 0))
    sdk.invoices.issue(idempotency_key: "durable", lines: [])
    assert_equal "durable", @adapter.requests.last[:headers]["Idempotency-Key"]
    sdk.invoices.issue(lines: [])
    refute_equal invoice.idempotency_key, @adapter.requests.last[:headers]["Idempotency-Key"]
    assert_raises(ArgumentError) { sdk.invoices.issue(idempotency_key: "", lines: []) }
  end

  def test_amendment_uses_same_guarantees
    sdk = client { response(fixture("InvoiceAmendment"), status: 201) }
    sdk.invoices.amend("inv_1", reason: "incorrect_lines", replacement: { lines: [] }, idempotency_key: "amend-workflow")
    req = @adapter.requests.last
    assert_equal "amend-workflow", req[:headers]["Idempotency-Key"]
    assert_equal({ "reason" => "incorrect_lines", "replacement" => { "lines" => [] } }, JSON.parse(req[:body]))
  end

  def test_unprotected_mutations_are_never_retried
    actions = [
      ->(sdk) { sdk.customers.create(name: "Test") },
      ->(sdk) { sdk.customers.update("cus_1", email: nil) },
      ->(sdk) { sdk.customers.delete("cus_1") }
    ]
    actions.each do |action|
      sdk = client(max_retries: 2) { response({}, status: 503) }
      assert_raises(FiscalRail::APIError) { action.call(sdk) }
      assert_equal 1, @adapter.requests.size
      sdk = client(max_retries: 2) { raise Net::ReadTimeout }
      assert_raises(FiscalRail::APITimeoutError) { action.call(sdk) }
      assert_equal 1, @adapter.requests.size
    end
  end

  def test_retry_statuses_and_exhaustion
    [408, 429, 500, 503].each do |status|
      sdk = client(max_retries: 1) { response({}, status: status, headers: { "Retry-After" => "0" }) }
      error = assert_raises(FiscalRail::APIError) { sdk.invoices.issue(idempotency_key: "durable", lines: []) }
      assert_equal status, error.status_code
      assert_equal "durable", error.idempotency_key
      assert_equal 2, @adapter.requests.size
    end
    [400, 401, 402, 404, 409, 422].each do |status|
      sdk = client(max_retries: 2) { response({}, status: status) }
      assert_raises(FiscalRail::APIError) { sdk.invoices.issue(lines: []) }
      assert_equal 1, @adapter.requests.size
    end
  end

  def test_connection_failures_are_typed_and_retried_only_when_safe
    [Net::ReadTimeout.new, Errno::ECONNRESET.new].each do |failure|
      requests, delays = [], []
      adapter = FakeAdapter.new { |req| requests << req; raise failure }
      transport = FiscalRail::Transport.new(api_key: "test", base_url: "https://example.test/v1", max_retries: 2, adapter: adapter, sleeper: delays.method(:push))
      error = assert_raises(FiscalRail::APIConnectionError) do
        transport.request(method: "POST", path: "/invoices", body: {}, retry_safe: true, idempotency_key: "durable")
      end
      assert_equal "durable", error.idempotency_key
      assert_equal [0.25, 0.5], delays
      assert_equal 3, requests.size
      assert_equal failure, error.cause
    end
  end

  def test_retry_after_handles_dates_negative_and_invalid_values
    { "-5" => 0, "100" => 30, "nonsense" => 0.25, "NaN" => 0.25, "Infinity" => 0.25 }.each do |header, expected|
      delays = []
      adapter = FakeAdapter.new { response({}, status: 503, headers: { "Retry-After" => header }) }
      transport = FiscalRail::Transport.new(api_key: "test", base_url: "https://example.test", max_retries: 1, adapter: adapter, sleeper: delays.method(:push))
      assert_raises(FiscalRail::APIError) { transport.request(method: "GET", path: "/test", retry_safe: true) }
      assert_equal [expected], delays
    end
    delays = []
    adapter = FakeAdapter.new { response({}, status: 503, headers: { "Retry-After" => (Time.now + 10).httpdate }) }
    transport = FiscalRail::Transport.new(api_key: "test", base_url: "https://example.test", max_retries: 1, adapter: adapter, sleeper: delays.method(:push))
    assert_raises(FiscalRail::APIError) { transport.request(method: "GET", path: "/test", retry_safe: true) }
    assert_in_delta 10, delays.first, 1
  end

  def test_typed_errors_retain_details_and_unexpected_payloads
    sdk = client do
      response({ "error" => { "code" => "invalid_invoice", "message" => "Invalid invoice", "details" => [{ "field" => "lines.0.unit_price", "message" => "is invalid", "code" => "invalid" }] } }, status: 422)
    end
    error = assert_raises(FiscalRail::InvalidInvoiceError) { sdk.invoices.issue(lines: []) }
    assert_equal "invalid_invoice", error.code
    assert_equal "req_test", error.request_id
    assert_equal "lines.0.unit_price", error.details.first["field"]
    assert_match(/req_test/, error.message)
    [[], { "error" => nil }, { "error" => "unexpected" }].each do |payload|
      sdk = client { response(payload, status: 502) }
      error = assert_raises(FiscalRail::APIError) { sdk.accounts.retrieve }
      assert_equal payload, error.body
    end
    sdk = client { FiscalRail::NetHTTPAdapter::Response.new(status: 502, headers: {}, body: "bad gateway") }
    error = assert_raises(FiscalRail::APIError) { sdk.accounts.retrieve }
    assert_equal "bad gateway", error.body
  end

  def test_redirects_are_not_followed_and_bad_success_bodies_are_not_retried
    sdk = client { response({}, status: 302, headers: { "Location" => "https://elsewhere.test" }) }
    assert_raises(FiscalRail::APIError) { sdk.accounts.retrieve }
    assert_equal 1, @adapter.requests.size
    sdk = client(max_retries: 2) { FiscalRail::NetHTTPAdapter::Response.new(status: 201, headers: { "request-id" => "req_bad" }, body: "<html>bad</html>") }
    error = assert_raises(FiscalRail::ResponseParseError) { sdk.invoices.issue(idempotency_key: "durable", lines: []) }
    assert_equal "durable", error.idempotency_key
    assert_equal "req_bad", error.request_id
    assert_equal 1, @adapter.requests.size
  end

  def test_client_configuration_and_adapter_ownership
    assert_raises(ArgumentError) { FiscalRail::Client.new(api_key: "") }
    assert_raises(ArgumentError) { FiscalRail::Client.new(api_key: "test", max_retries: -1) }
    assert_raises(ArgumentError) { FiscalRail::Client.new(api_key: "test", timeout: 0) }
    assert_raises(ArgumentError) { FiscalRail::Client.new(api_key: "test", base_url: "https://user:password@example.com") }
    sdk = client { response(page([])) }
    sdk.close
    refute @adapter.closed
    refute_includes sdk.inspect, "ak_test"
    adapter = @adapter
    assert_equal :done, FiscalRail::Client.open(api_key: "test", adapter: adapter) { :done }
    refute adapter.closed
  end
end
