# frozen_string_literal: true

require_relative "test_helper"

class ModelsTest < SDKTest
  def test_all_documented_examples_decode
    Dir[File.join(__dir__, "fixtures", "*.json")].each do |path|
      name = File.basename(path, ".json")
      assert_instance_of FiscalRail::Models.const_get(name), decode(name, fixture(name))
    end
  end

  def test_invoice_values_are_precise_and_nested_objects_are_typed
    invoice = decode("Invoice", fixture("Invoice"))
    assert_instance_of Date, invoice.issue_date
    assert_instance_of Time, invoice.created_at
    assert_instance_of BigDecimal, invoice.lines.first.unit_price
    assert_instance_of FiscalRail::Models::InvoiceTaxTotal, invoice.tax_totals.first
    assert_instance_of BigDecimal, invoice.tax_totals.first.amount
    assert_equal BigDecimal(fixture("Invoice").dig("totals", "payable")), invoice.totals.payable
    assert_equal invoice.totals.payable, decode("Invoice", FiscalRail::Serialization.json_value(invoice.to_h)).totals.payable
  end

  def test_precision_is_not_lost_to_float
    value = decode("Decimal", "999999999999.999999")
    assert_equal "999999999999.999999", value.to_s("F")
    %w[NaN Infinity 1e4 junk].each do |invalid|
      assert_raises(FiscalRail::ResponseParseError) { decode("Money", invalid) }
    end
  end

  def test_unknown_fields_and_enums_are_forward_compatible_and_deeply_frozen
    payload = fixture("Customer").merge("future" => { "values" => ["new"] })
    customer = decode("Customer", payload)
    assert_equal({ "values" => ["new"] }, customer.future)
    assert_equal customer.future, customer.extra_fields["future"]
    assert_equal customer.future, customer.to_h["future"]
    assert_raises(FrozenError) { customer.future["values"] << "changed" }
    assert_raises(FrozenError) { customer.name.replace("changed") }
    assert_raises(FrozenError) { customer.address.instance_variable_set(:@attributes, {}) }
    customer.to_h["future"]["values"] << "copy"
    assert_equal ["new"], customer.future["values"]
    assert_raises(NoMethodError) { customer.missing_field }
    invoice = fixture("Invoice")
    invoice["kind"] = "future_kind"
    assert_equal "future_kind", decode("Invoice", invoice).kind
  end

  def test_invalid_required_nested_values_report_the_field_and_request
    payload = fixture("Invoice")
    payload["totals"].delete("payable")
    sdk = client { response(payload, status: 201) }
    error = assert_raises(FiscalRail::ResponseParseError) { sdk.invoices.issue(lines: []) }
    assert_equal "$.totals.payable", error.field
    assert_equal "req_test", error.request_id
    assert_match(/\A[\da-f-]{36}\z/, error.idempotency_key)
    payload = fixture("Customer")
    payload["live"] = "false"
    assert_raises(FiscalRail::ResponseParseError) { decode("Customer", payload) }
  end

  def test_nullable_and_omitted_fields_remain_distinct
    model = decode("CustomerUpdate", { "email" => nil })
    assert_equal({ "email" => nil }, model.to_h)
    assert_nil model.phone
    refute model.to_h.key?("phone")
  end

  def test_discriminated_variants_and_invalid_branch
    %w[SpanishAccountTaxRegime GlobalAccountTaxRegime].each do |name|
      assert_instance_of FiscalRail::Models.const_get(name), decode("AccountTaxRegime", fixture(name))
    end
    assert_raises(FiscalRail::ResponseParseError) { decode("AccountTaxRegime", { "object" => "account_tax_regime", "key" => "es" }) }
    global = fixture("Invoice")
    global["tax_regime"] = { "key" => "global" }
    assert_equal "global", decode("Invoice", global).tax_regime.key
  end

  def test_serialization_preserves_false_nil_empty_and_decimal
    data = { due_date: Date.new(2026, 9, 30), amount: BigDecimal("12.50"), options: [], email: nil, enabled: false }
    assert_equal({ "due_date" => "2026-09-30", "amount" => "12.5", "options" => [], "email" => nil, "enabled" => false }, FiscalRail::Serialization.json_value(data))
    assert_raises(ArgumentError) { FiscalRail::Serialization.json_value({ name: "a", "name" => "b" }) }
    assert_raises(ArgumentError) { FiscalRail::Serialization.json_value(BigDecimal("NaN")) }
  end
end
