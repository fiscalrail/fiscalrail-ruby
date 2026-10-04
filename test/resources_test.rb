# frozen_string_literal: true

require_relative "test_helper"
require "stringio"

class ResourcesTest < SDKTest
  # The expected wire methods and paths are independent of the generated registry.
  CASES = [
    [:accounts, :retrieve, [], {}, "GET", "/account", "Account"],
    [:accounts, :update, [], { name: "Next" }, "PATCH", "/account", "Account"],
    [:account_invoicing, :retrieve, [], {}, "GET", "/account/invoicing", "AccountInvoicing"],
    [:account_invoicing, :update, [], { numbering_scope: "customer" }, "PATCH", "/account/invoicing", "AccountInvoicing"],
    [:balances, :retrieve, [], {}, "GET", "/account/balance", "Balance"],
    [:account_tax_regimes, :retrieve, [], {}, "GET", "/account/tax-regime", "SpanishAccountTaxRegime"],
    ["account_tax_regimes.es", :upload_certificate, [], { certificate_file: StringIO.new("binary") }, "POST", "/account/tax-regime/es/certificate", "SpanishAccountTaxRegime"],
    ["account_tax_regimes.es", :verify_representation, [], {}, "POST", "/account/tax-regime/es/representation/verify", "SpanishAccountTaxRegime"],
    ["account_tax_regimes.es", :verify_submission, [], {}, "POST", "/account/tax-regime/es/submission/verify", "SpanishAccountTaxRegime"],
    ["account_tax_regimes.es", :cancel_submission_change, [], {}, "DELETE", "/account/tax-regime/es/submission/pending", "SpanishAccountTaxRegime"],
    [:api_keys, :list, [], {}, "GET", "/api-keys", "ApiKey", true],
    [:api_keys, :create, [], { name: "Test" }, "POST", "/api-keys", "ApiKey"],
    [:api_keys, :retrieve, ["key_1"], {}, "GET", "/api-keys/key_1", "ApiKey"],
    [:api_keys, :delete, ["key_1"], {}, "DELETE", "/api-keys/key_1", nil],
    [:customers, :list, [], {}, "GET", "/customers", "Customer", true],
    [:customers, :create, [], { name: "Test" }, "POST", "/customers", "Customer"],
    [:customers, :retrieve, ["cus_1"], {}, "GET", "/customers/cus_1", "Customer"],
    [:customers, :update, ["cus_1"], { email: nil }, "PATCH", "/customers/cus_1", "Customer"],
    [:customers, :delete, ["cus_1"], {}, "DELETE", "/customers/cus_1", nil],
    [:invoice_series, :list, [], {}, "GET", "/invoice-series", "InvoiceSeries", true],
    [:invoice_series, :create, [], { prefix: "TEST" }, "POST", "/invoice-series", "InvoiceSeries"],
    [:invoice_series, :retrieve, ["ser_1"], {}, "GET", "/invoice-series/ser_1", "InvoiceSeries"],
    [:invoice_series, :update, ["ser_1"], { prefix: "NEXT" }, "PATCH", "/invoice-series/ser_1", "InvoiceSeries"],
    [:invoice_series, :delete, ["ser_1"], {}, "DELETE", "/invoice-series/ser_1", nil],
    [:payment_instructions, :list, [], {}, "GET", "/payment-instructions", "PaymentInstruction", true],
    [:payment_instructions, :create, [], { label: "Bank", type: "bank_transfer" }, "POST", "/payment-instructions", "PaymentInstruction"],
    [:payment_instructions, :retrieve, ["pay_1"], {}, "GET", "/payment-instructions/pay_1", "PaymentInstruction"],
    [:payment_instructions, :update, ["pay_1"], { label: "Next" }, "PATCH", "/payment-instructions/pay_1", "PaymentInstruction"],
    [:payment_instructions, :delete, ["pay_1"], {}, "DELETE", "/payment-instructions/pay_1", nil],
    [:invoices, :list, [], {}, "GET", "/invoices", "Invoice", true],
    [:invoices, :issue, [], { lines: [] }, "POST", "/invoices", "Invoice"],
    [:invoices, :retrieve, ["inv_1"], {}, "GET", "/invoices/inv_1", "Invoice"],
    [:invoices, :amend, ["inv_1"], { reason: "issued_by_mistake" }, "POST", "/invoices/inv_1/amendments", "InvoiceAmendment"],
    [:invoice_pdfs, :retrieve, ["inv_1"], {}, "GET", "/invoices/inv_1/pdf", "InvoicePdf"],
    [:invoice_pdfs, :render, ["inv_1"], {}, "POST", "/invoices/inv_1/pdf", "InvoicePdf"],
    [:tax_ids, :retrieve, ["tax_1"], {}, "GET", "/tax-ids/tax_1", "TaxId"],
    [:tax_regimes, :list, [], {}, "GET", "/tax-regimes", "TaxRegime", true],
    [:tax_regimes, :retrieve, ["es"], {}, "GET", "/tax-regimes/es", "TaxRegime"],
    [:events, :list, [], {}, "GET", "/events", "Event", true],
    [:events, :retrieve, ["evt_1"], {}, "GET", "/events/evt_1", "Event"],
    [:event_destinations, :list, [], {}, "GET", "/event-destinations", "EventDestination", true],
    [:event_destinations, :create, [], { url: "https://example.com/hook" }, "POST", "/event-destinations", "EventDestination"],
    [:event_destinations, :retrieve, ["dest_1"], {}, "GET", "/event-destinations/dest_1", "EventDestination"],
    [:event_destinations, :update, ["dest_1"], { name: "Next" }, "PATCH", "/event-destinations/dest_1", "EventDestination"],
    [:event_destinations, :delete, ["dest_1"], {}, "DELETE", "/event-destinations/dest_1", nil],
    [:event_destinations, :enable, ["dest_1"], {}, "POST", "/event-destinations/dest_1/enable", "EventDestination"],
    [:event_destinations, :disable, ["dest_1"], {}, "POST", "/event-destinations/dest_1/disable", "EventDestination"]
  ].freeze

  def test_all_operations_through_real_resource_methods
    covered = []
    CASES.each do |resource, action, args, kwargs, method, path, model, is_page|
      operation_id, operation = FiscalRail::Generated::OPERATIONS.find do |_, op|
        op["method"] == method && Regexp.new("\\A" + op["path"].gsub(/\{[^}]+\}/, "[^/]+") + "\\z").match?(path)
      end
      refute_nil operation, "Missing #{method} #{path}"
      covered << operation_id
      payload = model ? fixture(model) : nil
      payload = page([payload]) if is_page
      status = operation["responses"].keys.first.to_i
      sdk = client do |req|
        assert_equal method, req[:method], "#{resource}.#{action}"
        assert_equal "/v1#{path}", req[:uri].path
        if !kwargs.empty? && %w[POST PATCH].include?(method) && action != :upload_certificate
          assert_equal FiscalRail::Serialization.json_value(kwargs), JSON.parse(req[:body])
        end
        response(payload, status: status)
      end
      result = resource.to_s.split(".").reduce(sdk) { |object, name| object.public_send(name) }.public_send(action, *args, **kwargs)
      if model
        actual = is_page ? result.first : result
        assert_instance_of FiscalRail::Models.const_get(model), actual
        assert_equal "req_test", result.request_id
      else
        assert_nil result
      end
    end
    assert_equal FiscalRail::Generated::OPERATIONS.keys.sort, covered.sort
  end

  def test_multipart_preserves_binary_password_and_response_metadata
    content = "\x00\xffPKCS12\r\n".b
    file = StringIO.new(content)
    sdk = client do |req|
      assert_equal "POST", req[:method]
      assert_equal "/v1/account/tax-regime/es/certificate", req[:uri].path
      boundary = req[:headers].fetch("Content-Type").split("boundary=").last
      assert_includes req[:body], content
      assert_includes req[:body], "name=\"certificate_password\"\r\n\r\n@secret;é\r\n".b
      assert req[:body].end_with?("--#{boundary}--\r\n")
      payload = fixture("SpanishAccountTaxRegime")
      payload["es"]["pending_submission"] = { "kind" => "direct", "status" => "pending_verification", "error_code" => nil, "last_checked_at" => nil, "certificate_expires_at" => "2027-10-01T00:00:00Z" }
      response(payload, status: 202)
    end
    result = sdk.account_tax_regimes.es.upload_certificate(certificate_file: file, certificate_password: "@secret;é")
    refute file.closed?
    assert_equal "req_test", result.request_id
    assert_equal "pending_verification", result.es.pending_submission.status
    assert result.es.submission.ready
  end

  def test_upload_without_password_does_not_retry
    sdk = client(max_retries: 2) do |req|
      refute_includes req[:body], "certificate_password"
      response({ error: { code: "unavailable", message: "Unavailable" } }, status: 503)
    end
    assert_raises(FiscalRail::APIError) do
      sdk.account_tax_regimes.es.upload_certificate(certificate_file: StringIO.new("cert"))
    end
    assert_equal 1, @adapter.requests.length
  end

  def test_pagination_is_lazy_and_preserves_filters
    calls = 0
    sdk = client do |req|
      calls += 1
      params = URI.decode_www_form(req[:uri].query).to_h
      assert_equal "Acme", params["q"]
      assert_equal "2", params["limit"]
      customer = fixture("Customer").merge("id" => "cus_#{calls}")
      assert_equal "cus_1", params["starting_after"] if calls == 2
      response(page([customer], has_more: calls == 1))
    end
    enumerator = sdk.customers.auto_paging_each(q: "Acme", page_size: 2)
    assert_instance_of Enumerator, enumerator
    assert_equal 0, calls
    assert_equal %w[cus_1 cus_2], enumerator.map(&:id)
    assert_equal 2, calls
    assert_raises(ArgumentError) { sdk.customers.auto_paging_each(ending_before: "cus_1").to_a }
  end

  def test_empty_page_stops_and_repeated_cursor_raises
    sdk = client { response(page([], has_more: true)) }
    assert_empty sdk.customers.auto_paging_each.to_a
    assert_equal 1, @adapter.requests.size
    sdk = client { response(page([fixture("Customer")], has_more: true)) }
    assert_raises(FiscalRail::ResponseParseError) { sdk.customers.auto_paging_each.to_a }
    assert_equal 2, @adapter.requests.size
  end

  def test_filters_path_escaping_and_body_values
    sdk = client { response(page([])) }
    sdk.events.list(types: %w[invoice.issued customer.created], ending_before: "evt_1")
    assert_equal({ "types" => "invoice.issued,customer.created", "ending_before" => "evt_1" }, URI.decode_www_form(@adapter.requests.last[:uri].query).to_h)
    sdk.invoices.list(issue_date_from: Date.new(2026, 9, 1), issue_date_to: "2026-09-30")
    assert_equal "2026-09-01", URI.decode_www_form(@adapter.requests.last[:uri].query).to_h["issue_date_from"]
    sdk = client { response(fixture("Customer")) }
    sdk.customers.retrieve("cus/a ?#")
    assert_equal "/v1/customers/cus%2Fa%20%3F%23", @adapter.requests.last[:uri].path
    assert_raises(ArgumentError) { sdk.customers.retrieve("") }
    sdk.customers.update("cus_1", email: nil, address: { line_2: nil })
    assert_equal({ "email" => nil, "address" => { "line_2" => nil } }, JSON.parse(@adapter.requests.last[:body]))
  end

  def test_pdf_bytes_and_language_are_preserved
    sdk = client do |req|
      assert_equal "application/pdf", req[:headers]["Accept"]
      FiscalRail::NetHTTPAdapter::Response.new(status: 200, body: "%PDF-1.7\n\xFF".b,
        headers: { "content-type" => "application/pdf", "request-id" => "req_pdf" })
    end
    pdf = sdk.invoice_pdfs.render_content("inv_1", locale: "en")
    assert_equal "en", @adapter.requests.last[:headers]["Accept-Language"]
    assert_equal "req_pdf", pdf.request_id
    Dir.mktmpdir do |dir|
      path = File.join(dir, "invoice.pdf")
      pdf.write_to_file(path)
      assert_equal "%PDF-1.7\n\xFF".b, File.binread(path)
    end
    sdk.invoice_pdfs.retrieve_content("inv_1")
    assert_equal "GET", @adapter.requests.last[:method]
  end
end
