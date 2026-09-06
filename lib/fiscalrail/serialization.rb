# frozen_string_literal: true

require "bigdecimal"
require "date"
require "time"

module FiscalRail
  module Serialization
    module_function

    def json_value(value)
      case value
      when BigDecimal
        raise ArgumentError, "Decimal must be finite" unless value.finite?

        value.to_s("F")
      when Time, DateTime then value.iso8601
      when Date then value.iso8601
      when Model then json_value(value.to_h)
      when Hash
        value.each_with_object({}) do |(key, item), result|
          raise ArgumentError, "Duplicate JSON key: #{key}" if result.key?(key.to_s)

          result[key.to_s] = json_value(item)
        end
      when Array then value.map { |item| json_value(item) }
      when Symbol then value.to_s
      when String, Integer, Float, TrueClass, FalseClass, NilClass then value
      else raise ArgumentError, "Cannot serialize #{value.class} to JSON"
      end
    end
  end
end
