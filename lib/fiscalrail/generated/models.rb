# frozen_string_literal: true
# Generated from FiscalRail's OpenAPI contract. Do not edit by hand.

module FiscalRail
  module Models
    class Account < Model
      def address = self["address"]
      def created_at = self["created_at"]
      def default_payment_instructions = self["default_payment_instructions"]
      def default_series = self["default_series"]
      def email = self["email"]
      def id = self["id"]
      def invoice_locale = self["invoice_locale"]
      def invoice_numbering_scope = self["invoice_numbering_scope"]
      def live = self["live"]
      def name = self["name"]
      def object = self["object"]
      def phone = self["phone"]
      def tax_id = self["tax_id"]
      def tax_regime = self["tax_regime"]
      def timezone = self["timezone"]
      def updated_at = self["updated_at"]
    end

    class AccountDefaultSeries < Model
      def amendment = self["amendment"]
      def credit_note = self["credit_note"]
      def invoice = self["invoice"]
    end

    class AccountList < Page
      def data = self["data"]
      def has_more = self["has_more"]
      def object = self["object"]
    end

    class AccountNotConfiguredError < Model
      def code = self["code"]
      def message = self["message"]
    end

    class AccountNotConfiguredErrorResponse < Model
      def error = self["error"]
    end

    class AccountUpdate < Model
      def address = self["address"]
      def default_payment_instructions = self["default_payment_instructions"]
      def default_series = self["default_series"]
      def invoice_numbering_scope = self["invoice_numbering_scope"]
    end

    class Address < Model
      def city = self["city"]
      def country = self["country"]
      def line_1 = self["line_1"]
      def line_2 = self["line_2"]
      def postal_code = self["postal_code"]
      def state = self["state"]
    end

    class AddressCreate < Model
      def city = self["city"]
      def country = self["country"]
      def line_1 = self["line_1"]
      def line_2 = self["line_2"]
      def postal_code = self["postal_code"]
      def state = self["state"]
    end

    class AddressUpdate < Model
      def city = self["city"]
      def country = self["country"]
      def line_1 = self["line_1"]
      def line_2 = self["line_2"]
      def postal_code = self["postal_code"]
      def state = self["state"]
    end

    class ApiKey < Model
      def account = self["account"]
      def created_at = self["created_at"]
      def id = self["id"]
      def live = self["live"]
      def name = self["name"]
      def object = self["object"]
      def secret = self["secret"]
      def suffix = self["suffix"]
    end

    class ApiKeyCreate < Model
      def name = self["name"]
    end

    class ApiKeyList < Page
      def data = self["data"]
      def has_more = self["has_more"]
      def object = self["object"]
    end

    class AuthenticationError < Model
      def code = self["code"]
      def message = self["message"]
    end

    class AuthenticationErrorResponse < Model
      def error = self["error"]
    end

    class Balance < Model
      def account = self["account"]
      def amount = self["amount"]
      def currency = self["currency"]
      def id = self["id"]
      def live = self["live"]
      def object = self["object"]
      def updated_at = self["updated_at"]
    end

    class BalanceExhaustedError < Model
      def code = self["code"]
      def message = self["message"]
    end

    class BalanceExhaustedErrorResponse < Model
      def error = self["error"]
    end

    class BalanceTransaction < Model
      def account = self["account"]
      def amount_cents = self["amount_cents"]
      def created_at = self["created_at"]
      def currency = self["currency"]
      def id = self["id"]
      def kind = self["kind"]
      def live = self["live"]
      def object = self["object"]
      def source_event = self["source_event"]
    end

    class BasicValidationDetail < Model
      def field = self["field"]
      def message = self["message"]
    end

    class Customer < Model
      def address = self["address"]
      def created_at = self["created_at"]
      def email = self["email"]
      def id = self["id"]
      def invoice_prefix = self["invoice_prefix"]
      def live = self["live"]
      def name = self["name"]
      def object = self["object"]
      def phone = self["phone"]
      def tax_id = self["tax_id"]
      def updated_at = self["updated_at"]
    end

    class CustomerCreate < Model
      def address = self["address"]
      def email = self["email"]
      def invoice_prefix = self["invoice_prefix"]
      def name = self["name"]
      def phone = self["phone"]
      def tax_id = self["tax_id"]
    end

    class CustomerList < Page
      def data = self["data"]
      def has_more = self["has_more"]
      def object = self["object"]
    end

    class CustomerNotFoundError < Model
      def code = self["code"]
      def message = self["message"]
    end

    class CustomerNotFoundErrorResponse < Model
      def error = self["error"]
    end

    class CustomerUpdate < Model
      def address = self["address"]
      def email = self["email"]
      def invoice_prefix = self["invoice_prefix"]
      def name = self["name"]
      def phone = self["phone"]
      def tax_id = self["tax_id"]
    end

    class Event < Model
      def account = self["account"]
      def actor = self["actor"]
      def data = self["data"]
      def id = self["id"]
      def live = self["live"]
      def object = self["object"]
      def occurred_at = self["occurred_at"]
      def related_object = self["related_object"]
      def type = self["type"]
    end

    class EventActor < Model
      def id = self["id"]
      def request_id = self["request_id"]
      def type = self["type"]
    end

    class EventData < Model
      def object = self["object"]
      def previous_attributes = self["previous_attributes"]
    end

    class EventDestination < Model
      def account = self["account"]
      def created_at = self["created_at"]
      def disabled_reason = self["disabled_reason"]
      def enabled_events = self["enabled_events"]
      def id = self["id"]
      def live = self["live"]
      def name = self["name"]
      def object = self["object"]
      def status = self["status"]
      def type = self["type"]
      def updated_at = self["updated_at"]
      def webhook = self["webhook"]
    end

    class EventDestinationCreate < Model
      def enabled_events = self["enabled_events"]
      def name = self["name"]
      def url = self["url"]
    end

    class EventDestinationList < Page
      def data = self["data"]
      def has_more = self["has_more"]
      def object = self["object"]
    end

    class EventDestinationUpdate < Model
      def enabled_events = self["enabled_events"]
      def name = self["name"]
      def url = self["url"]
    end

    class EventDestinationWebhook < Model
      def signing_secret = self["signing_secret"]
      def url = self["url"]
    end

    class EventList < Page
      def data = self["data"]
      def has_more = self["has_more"]
      def object = self["object"]
    end

    class GlobalAccountTaxRegime < Model
      def account = self["account"]
      def key = self["key"]
      def object = self["object"]
    end

    class GlobalInvoiceTaxRegime < Model
      def key = self["key"]
    end

    class IdempotencyConflictError < Model
      def code = self["code"]
      def message = self["message"]
    end

    class IdempotencyConflictErrorResponse < Model
      def error = self["error"]
    end

    class InvalidCustomerError < Model
      def code = self["code"]
      def details = self["details"]
      def message = self["message"]
    end

    class InvalidCustomerErrorResponse < Model
      def error = self["error"]
    end

    class InvalidInvoiceError < Model
      def code = self["code"]
      def details = self["details"]
      def message = self["message"]
    end

    class InvalidInvoiceErrorResponse < Model
      def error = self["error"]
    end

    class InvalidRequestError < Model
      def code = self["code"]
      def message = self["message"]
    end

    class InvalidRequestErrorResponse < Model
      def error = self["error"]
    end

    class InvalidResourceError < Model
      def code = self["code"]
      def details = self["details"]
      def message = self["message"]
    end

    class InvalidResourceErrorResponse < Model
      def error = self["error"]
    end

    class Invoice < Model
      def account = self["account"]
      def amendments = self["amendments"]
      def code = self["code"]
      def created_at = self["created_at"]
      def currency = self["currency"]
      def customer = self["customer"]
      def id = self["id"]
      def issue_date = self["issue_date"]
      def kind = self["kind"]
      def lines = self["lines"]
      def live = self["live"]
      def object = self["object"]
      def payment_terms = self["payment_terms"]
      def preceding_invoice = self["preceding_invoice"]
      def series = self["series"]
      def supplier = self["supplier"]
      def supply_period = self["supply_period"]
      def tax_regime = self["tax_regime"]
      def tax_totals = self["tax_totals"]
      def totals = self["totals"]
    end

    class InvoiceAmendment < Model
      def created_at = self["created_at"]
      def credit_note = self["credit_note"]
      def id = self["id"]
      def live = self["live"]
      def object = self["object"]
      def original = self["original"]
      def reason = self["reason"]
      def replacement = self["replacement"]
    end

    class InvoiceAmendmentCreate < Model
      def reason = self["reason"]
      def replacement = self["replacement"]
    end

    class InvoiceCreate < Model
      def customer = self["customer"]
      def issue_date = self["issue_date"]
      def lines = self["lines"]
      def payment_terms = self["payment_terms"]
      def series = self["series"]
      def supply_period = self["supply_period"]
    end

    class InvoiceLine < Model
      def description = self["description"]
      def index = self["index"]
      def quantity = self["quantity"]
      def subtotal = self["subtotal"]
      def taxes = self["taxes"]
      def unit_price = self["unit_price"]
    end

    class InvoiceLineCreate < Model
      def description = self["description"]
      def quantity = self["quantity"]
      def taxes = self["taxes"]
      def unit_price = self["unit_price"]
    end

    class InvoiceList < Page
      def data = self["data"]
      def has_more = self["has_more"]
      def object = self["object"]
    end

    class InvoiceParty < Model
      def address = self["address"]
      def email = self["email"]
      def name = self["name"]
      def phone = self["phone"]
      def source = self["source"]
      def tax_id = self["tax_id"]
    end

    class InvoicePartySource < Model
      def id = self["id"]
      def type = self["type"]
    end

    class InvoicePaymentOption < Model
      def bank_transfer = self["bank_transfer"]
      def payment_instruction = self["payment_instruction"]
      def reference = self["reference"]
      def type = self["type"]
    end

    class InvoicePaymentTerms < Model
      def due_date = self["due_date"]
      def options = self["options"]
    end

    class InvoicePaymentTermsCreate < Model
      def due_date = self["due_date"]
      def options = self["options"]
    end

    class InvoicePdf < Model
      def id = self["id"]
      def invoice = self["invoice"]
      def live = self["live"]
      def locale = self["locale"]
      def object = self["object"]
      def rendered_at = self["rendered_at"]
      def status = self["status"]
      def url = self["url"]
      def url_expires_at = self["url_expires_at"]
    end

    class InvoiceReference < Model
      def code = self["code"]
      def id = self["id"]
      def issue_date = self["issue_date"]
    end

    class InvoiceSeries < Model
      def account = self["account"]
      def created_at = self["created_at"]
      def default_for = self["default_for"]
      def id = self["id"]
      def live = self["live"]
      def object = self["object"]
      def prefix = self["prefix"]
    end

    class InvoiceSeriesCreate < Model
      def default_for = self["default_for"]
      def prefix = self["prefix"]
    end

    class InvoiceSeriesList < Page
      def data = self["data"]
      def has_more = self["has_more"]
      def object = self["object"]
    end

    class InvoiceSeriesUpdate < Model
      def default_for = self["default_for"]
      def prefix = self["prefix"]
    end

    class InvoiceSupplyPeriod < Model
      def end_date = self["end_date"]
      def start_date = self["start_date"]
    end

    class InvoiceSupplyPeriodCreate < Model
      def end_date = self["end_date"]
      def start_date = self["start_date"]
    end

    class InvoiceTax < Model
      def description = self["description"]
      def effect = self["effect"]
      def rate = self["rate"]
      def rule = self["rule"]
      def tax = self["tax"]
      def taxable_base = self["taxable_base"]
      def treatment = self["treatment"]
    end

    class InvoiceTaxTotal < Model
      def amount = self["amount"]
      def description = self["description"]
      def effect = self["effect"]
      def rate = self["rate"]
      def rule = self["rule"]
      def tax = self["tax"]
      def taxable_base = self["taxable_base"]
      def treatment = self["treatment"]
    end

    class InvoiceTotals < Model
      def payable = self["payable"]
      def subtotal = self["subtotal"]
      def tax = self["tax"]
      def total_with_tax = self["total_with_tax"]
      def withheld_tax = self["withheld_tax"]
    end

    class PaymentInstruction < Model
      def account = self["account"]
      def bank_transfer = self["bank_transfer"]
      def created_at = self["created_at"]
      def id = self["id"]
      def label = self["label"]
      def live = self["live"]
      def object = self["object"]
      def type = self["type"]
      def updated_at = self["updated_at"]
    end

    class PaymentInstructionBankTransfer < Model
      def beneficiary = self["beneficiary"]
      def bic = self["bic"]
      def iban = self["iban"]
    end

    class PaymentInstructionBankTransferInput < Model
      def beneficiary = self["beneficiary"]
      def bic = self["bic"]
      def iban = self["iban"]
    end

    class PaymentInstructionBankTransferUpdate < Model
      def beneficiary = self["beneficiary"]
      def bic = self["bic"]
      def iban = self["iban"]
    end

    class PaymentInstructionCreate < Model
      def bank_transfer = self["bank_transfer"]
      def label = self["label"]
      def type = self["type"]
    end

    class PaymentInstructionList < Page
      def data = self["data"]
      def has_more = self["has_more"]
      def object = self["object"]
    end

    class PaymentInstructionUpdate < Model
      def bank_transfer = self["bank_transfer"]
      def label = self["label"]
    end

    class PdfRenderInProgressError < Model
      def code = self["code"]
      def message = self["message"]
    end

    class PdfRenderInProgressErrorResponse < Model
      def error = self["error"]
    end

    class PdfRenderingUnavailableError < Model
      def code = self["code"]
      def message = self["message"]
    end

    class PdfRenderingUnavailableErrorResponse < Model
      def error = self["error"]
    end

    class RelatedObject < Model
      def id = self["id"]
      def object = self["object"]
    end

    class ResourceNotFoundError < Model
      def code = self["code"]
      def message = self["message"]
    end

    class ResourceNotFoundErrorResponse < Model
      def error = self["error"]
    end

    class SpanishAccountRepresentation < Model
      def kind = self["kind"]
      def last_checked_at = self["last_checked_at"]
      def power_code = self["power_code"]
      def status = self["status"]
      def verified_at = self["verified_at"]
    end

    class SpanishAccountTaxRegime < Model
      def account = self["account"]
      def es = self["es"]
      def key = self["key"]
      def object = self["object"]
    end

    class SpanishAccountTaxRegimeDetails < Model
      def representation = self["representation"]
    end

    class SpanishInvoiceQr < Model
      def content = self["content"]
      def image_url = self["image_url"]
    end

    class SpanishInvoiceTaxRegime < Model
      def es = self["es"]
      def key = self["key"]
    end

    class SpanishInvoiceTaxRegimeDetails < Model
      def qr = self["qr"]
      def verifactu = self["verifactu"]
    end

    class TaxId < Model
      def country = self["country"]
      def id = self["id"]
      def live = self["live"]
      def object = self["object"]
      def owner = self["owner"]
      def type = self["type"]
      def value = self["value"]
      def verification = self["verification"]
    end

    class TaxIdInput < Model
      def country = self["country"]
      def type = self["type"]
      def value = self["value"]
    end

    class TaxIdOwner < Model
      def id = self["id"]
      def type = self["type"]
    end

    class TaxIdSnapshot < Model
      def country = self["country"]
      def type = self["type"]
      def value = self["value"]
    end

    class TaxIdVerification < Model
      def completed_at = self["completed_at"]
      def status = self["status"]
      def valid = self["valid"]
    end

    class TaxReference < Model
      def description = self["description"]
      def effect = self["effect"]
      def rate = self["rate"]
      def rule = self["rule"]
      def tax = self["tax"]
      def taxable_base = self["taxable_base"]
      def treatment = self["treatment"]
    end

    class TaxRegime < Model
      def id = self["id"]
      def object = self["object"]
      def taxes = self["taxes"]
    end

    class TaxRegimeList < Page
      def data = self["data"]
      def has_more = self["has_more"]
      def object = self["object"]
    end

    class TaxRegimeTax < Model
      def effect = self["effect"]
      def name = self["name"]
      def rules = self["rules"]
      def tax = self["tax"]
    end

    class TaxRegimeTaxRule < Model
      def authority_code = self["authority_code"]
      def description = self["description"]
      def effective_from = self["effective_from"]
      def effective_until = self["effective_until"]
      def legal_reference = self["legal_reference"]
      def rate = self["rate"]
      def rule = self["rule"]
      def treatment = self["treatment"]
    end

    class ValidationDetail < Model
      def code = self["code"]
      def field = self["field"]
      def message = self["message"]
      def metadata = self["metadata"]
    end

    class Verifactu < Model
      def registrations = self["registrations"]
    end

    class VerifactuRegistration < Model
      def csv = self["csv"]
      def error = self["error"]
      def id = self["id"]
      def invoice = self["invoice"]
      def kind = self["kind"]
      def live = self["live"]
      def object = self["object"]
      def status = self["status"]
      def submitted_at = self["submitted_at"]
    end

    class VerifactuRegistrationError < Model
      def code = self["code"]
      def message = self["message"]
      def raw = self["raw"]
    end

    class VerifactuRegistrationRawError < Model
      def code = self["code"]
      def message = self["message"]
    end

  end
end
