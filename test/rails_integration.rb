# frozen_string_literal: true

# Optional, database-backed verification against a local FiscalRail checkout.
# Run from the Rails checkout using its bundle:
#   FISCALRAIL_APP_ROOT="$PWD" bundle exec ruby /path/to/ruby/test/rails_integration.rb
# The app's test transaction rolls back every created record.
app_root = ENV.fetch("FISCALRAIL_APP_ROOT")
ENV["RAILS_ENV"] = "test"
require File.join(app_root, "test/test_helper")
require_relative "../lib/fiscalrail"

class RubySDKIntegrationTest < ApiIntegrationTest
  parallelize(workers: 1)

  class RackAdapter
    def initialize(session)
      @session = session
    end

    def call(method:, uri:, headers:, body:)
      @session.process(method.downcase.to_sym, uri.request_uri, params: body, headers: headers)
      result = @session.response
      FiscalRail::NetHTTPAdapter::Response.new(status: result.status, headers: result.headers.to_h, body: result.body)
    end
  end

  test "Ruby client creates, issues, replays, downloads and amends through the Rails API" do
    live_account = Account.create!(**account_attributes(name: "Ruby SDK verification"))
    account = live_account.test_accounts.sole
    secret = Api::AccountKey.issue!(account: account).secret
    sdk = FiscalRail::Client.new(api_key: secret, adapter: RackAdapter.new(self), max_retries: 0)
    customer = sdk.customers.create(name: "Ruby SDK customer", email: "sdk@example.test",
      tax_id: { country: "ES", type: "es_nif", value: "B87654323" }, address: {
      line_1: "Example 1", city: "Madrid", postal_code: "28001", country: "ES"
    })
    assert_not customer.live
    sdk.customers.update(customer.id, email: nil)
    assert_nil sdk.customers.retrieve(customer.id).email
    assert_equal [customer.id], sdk.customers.auto_paging_each.map(&:id)

    payment = sdk.payment_instructions.create(label: "Example bank", type: "bank_transfer", bank_transfer: {
      beneficiary: "Ruby SDK verification", iban: "ES9121000418450200051332", bic: "CAIXESBBXXX"
    })
    sdk.accounts.update(account.id, default_payment_instructions: [payment.id])
    assert_equal "es", sdk.account_tax_regimes.retrieve(account.id).key
    key = SecureRandom.uuid
    params = {
      customer: customer.id,
      lines: [{ description: "Ruby SDK test", unit_price: BigDecimal("100.00"), taxes: [FiscalRail::TaxRegimes::ES::VAT.general] }],
      payment_terms: { due_date: Date.current + 30 }
    }
    invoice = sdk.invoices.issue(idempotency_key: key, **params)
    assert_not invoice.live
    assert_equal BigDecimal("121.00"), invoice.totals.payable
    assert_equal payment.id, invoice.payment_terms.options.first.payment_instruction
    replay = sdk.invoices.issue(idempotency_key: key, **params)
    assert_equal invoice.id, replay.id
    assert_equal invoice.request_id, replay.idempotent_replayed
    assert_equal invoice.id, sdk.invoices.retrieve(invoice.id).id
    assert_equal [invoice.id], sdk.invoices.auto_paging_each(customer: customer.id).map(&:id)

    pdf = sdk.invoice_pdfs.render_content(invoice.id, locale: "en")
    assert pdf.content.start_with?("%PDF-")
    assert_equal pdf.content, sdk.invoice_pdfs.retrieve_content(invoice.id).content
    assert_equal "en", sdk.invoice_pdfs.retrieve(invoice.id).locale
    pdf.write_to_file(ENV.fetch("FISCALRAIL_SDK_PDF")) if ENV["FISCALRAIL_SDK_PDF"]

    amendment = sdk.invoices.amend(invoice.id, reason: "issued_by_mistake")
    assert_equal invoice.id, amendment.original.id
    assert_nil amendment.credit_note
    assert_nil amendment.replacement
    assert_raises(FiscalRail::InvalidInvoiceError) { sdk.invoices.issue(lines: []) }
  end
end
