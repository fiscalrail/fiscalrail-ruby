# frozen_string_literal: true

module FiscalRail
  class Error < StandardError; end
  class WebhookSignatureError < Error; end

  class APIConnectionError < Error
    attr_reader :idempotency_key

    def initialize(message, idempotency_key: nil)
      @idempotency_key = idempotency_key
      super(message)
    end
  end

  class APITimeoutError < APIConnectionError; end

  class ResponseParseError < Error
    attr_reader :model, :field, :request_id, :idempotency_key

    def initialize(message, model:, field:, request_id: nil, idempotency_key: nil)
      @model, @field, @request_id, @idempotency_key = model, field, request_id, idempotency_key
      super("Could not parse FiscalRail #{model} response at #{field}: #{message}")
    end
  end

  class APIError < Error
    attr_reader :code, :status_code, :request_id, :details, :idempotency_key, :body

    def initialize(message, code:, status_code:, request_id:, details: [], idempotency_key: nil, body: nil)
      @code, @status_code, @request_id = code, status_code, request_id
      @details, @idempotency_key, @body = details, idempotency_key, body
      super(request_id ? "#{message} (request_id: #{request_id})" : message)
    end
  end

  class AuthenticationError < APIError; end
  class InvalidRequestError < APIError; end
  class ResourceNotFoundError < APIError; end
  class InvalidCustomerError < APIError; end
  class CustomerNotFoundError < APIError; end
  class InvalidInvoiceError < APIError; end
  class InvalidInvoiceSeriesError < APIError; end
  class InvalidPaymentInstructionError < APIError; end
  class InvalidInvoiceAmendmentError < APIError; end
  class AccountNotConfiguredError < APIError; end
  class BalanceExhaustedError < APIError; end
  class IdempotencyConflictError < APIError; end
  class PdfRenderInProgressError < APIError; end
  class PdfRenderingUnavailableError < APIError; end

  module Errors
    CLASSES = {
      "authentication_required" => AuthenticationError,
      "invalid_request" => InvalidRequestError,
      "invalid_idempotency_key" => InvalidRequestError,
      "resource_not_found" => ResourceNotFoundError,
      "invalid_customer" => InvalidCustomerError,
      "customer_not_found" => CustomerNotFoundError,
      "invalid_invoice" => InvalidInvoiceError,
      "invalid_invoice_series" => InvalidInvoiceSeriesError,
      "invalid_payment_instruction" => InvalidPaymentInstructionError,
      "invalid_invoice_amendment" => InvalidInvoiceAmendmentError,
      "account_not_configured" => AccountNotConfiguredError,
      "balance_exhausted" => BalanceExhaustedError,
      "idempotency_key_in_use" => IdempotencyConflictError,
      "idempotency_key_mismatch" => IdempotencyConflictError,
      "pdf_render_in_progress" => PdfRenderInProgressError,
      "pdf_rendering_unavailable" => PdfRenderingUnavailableError
    }.freeze

    def self.from_response(status:, headers:, body:, idempotency_key: nil)
      payload = JSON.parse(body)
      build(status, headers, payload, idempotency_key)
    rescue JSON::ParserError
      build(status, headers, body, idempotency_key)
    end

    def self.build(status, headers, payload, idempotency_key)
      error = payload.is_a?(Hash) && payload["error"].is_a?(Hash) ? payload["error"] : {}
      code = error["code"] || "http_#{status}"
      details = Array(error["details"]).select { |detail| detail.is_a?(Hash) }
      CLASSES.fetch(code, APIError).new(
        error["message"] || "FiscalRail returned HTTP #{status}",
        code: code, status_code: status, request_id: headers["request-id"],
        details: details, idempotency_key: idempotency_key, body: payload
      )
    end
  end
end
