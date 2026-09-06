# frozen_string_literal: true

require "openssl"
require "json"
require_relative "errors"

module FiscalRail
  module Webhooks
    DEFAULT_TOLERANCE = 300
    module_function

    def verify_signature(payload, signature, secret, tolerance: DEFAULT_TOLERANCE, now: Time.now)
      raise ArgumentError, "tolerance must be nonnegative or nil" unless tolerance.nil? || (tolerance.is_a?(Numeric) && tolerance.finite? && tolerance >= 0)
      raise WebhookSignatureError, "Missing signing secret" unless secret.is_a?(String) && !secret.empty?
      raise WebhookSignatureError, "Payload must be a raw string" unless payload.is_a?(String)
      raise WebhookSignatureError, "Missing FiscalRail-Signature header" unless signature.is_a?(String)

      fields = signature.split(",").map { |item| item.strip.split("=", 2) }
      timestamps = fields.select { |key, _| key == "t" }.map(&:last)
      signatures = fields.select { |key, _| key == "v1" }.map(&:last)
      unless timestamps.length == 1 && timestamps.first&.match?(/\A\d+\z/) && !signatures.empty?
        raise WebhookSignatureError, "Malformed FiscalRail-Signature header"
      end
      timestamp = Integer(timestamps.first, 10)
      expected = OpenSSL::HMAC.hexdigest("SHA256", secret, "#{timestamp}.".b + payload.b)
      valid = signatures.any? do |candidate|
        candidate && candidate.bytesize == expected.bytesize && OpenSSL.fixed_length_secure_compare(expected, candidate)
      end
      raise WebhookSignatureError, "No matching FiscalRail webhook signature" unless valid
      raise WebhookSignatureError, "FiscalRail webhook timestamp is outside the allowed tolerance" if tolerance && (now.to_f - timestamp).abs > tolerance

      timestamp
    end

    def construct_event(payload, signature, secret, **options)
      verify_signature(payload, signature, secret, **options)
      event = JSON.parse(payload)
      raise WebhookSignatureError, "FiscalRail webhook payload must be a JSON object" unless event.is_a?(Hash)

      event
    rescue JSON::ParserError
      raise WebhookSignatureError, "FiscalRail webhook payload is not valid JSON"
    end
  end
end
