# frozen_string_literal: true

module FiscalRail
  class Decoder
    class Mismatch < StandardError
      attr_reader :field

      def initialize(message, field)
        @field = field
        super(message)
      end
    end

    def self.decode(schema, value, metadata: {})
      new.decode(schema, value, "$", metadata)
    rescue Mismatch => error
      name = schema["$ref"]&.split("/")&.last || "API"
      raise ResponseParseError.new(error.message, model: name, field: error.field,
        request_id: metadata[:request_id], idempotency_key: metadata[:idempotency_key])
    end

    def decode(schema, value, path, metadata = {})
      mismatch("value is not allowed", path) if schema == false
      return value if schema == true || schema.empty?
      if schema["$ref"]
        referenced = Generated::SCHEMAS.fetch(schema.fetch("$ref").split("/").last)
        return decode(referenced.merge(schema.reject { |key, _| key == "$ref" }), value, path, metadata)
      end

      if (branches = schema["oneOf"] || schema["anyOf"])
        if (discriminator = schema["discriminator"]) && value.is_a?(Hash)
          ref = discriminator.fetch("mapping", {})[value[discriminator.fetch("propertyName")]]
          return decode({ "$ref" => ref }, value, path, metadata) if ref
        end
        failures = []
        branches.each do |branch|
          begin
            return decode(branch, value, path, metadata)
          rescue Mismatch => error
            failures << error
          end
        end
        raise failures.max_by { |error| error.field.length }
      end

      types = Array(schema["type"])
      return nil if value.nil? && types.include?("null")
      mismatch("expected #{types.join(' or ')}", path) if value.nil? && !types.empty?
      mismatch("expected #{schema['const'].inspect}", path) if schema.key?("const") && value != schema["const"]

      case (types - ["null"]).first
      when "object"
        mismatch("expected an object", path) unless value.is_a?(Hash)
        properties = schema.fetch("properties", {})
        schema.fetch("required", []).each { |key| mismatch("required field is missing", "#{path}.#{key}") unless value.key?(key) }
        attributes, extra = {}, {}
        value.each do |key, item|
          if properties.key?(key)
            attributes[key] = decode(properties[key], item, "#{path}.#{key}")
          else
            additional = schema["additionalProperties"]
            extra[key] = additional.is_a?(Hash) ? decode(additional, item, "#{path}.#{key}") : item
          end
        end
        return attributes.merge(extra) unless schema["model"]

        Models.const_get(schema.fetch("model"), false).new(attributes, extra_fields: extra, metadata: metadata)
      when "array"
        mismatch("expected an array", path) unless value.is_a?(Array)
        value.each_with_index.map { |item, index| decode(schema.fetch("items", {}), item, "#{path}[#{index}]") }
      when "string"
        mismatch("expected a string", path) unless value.is_a?(String)
        case schema["format"]
        when "decimal"
          mismatch("expected a finite decimal string", path) unless value.match?(/\A-?\d+(?:\.\d+)?\z/)
          BigDecimal(value)
        when "date" then Date.iso8601(value)
        when "date-time" then Time.iso8601(value)
        else value
        end
      when "integer"
        mismatch("expected an integer", path) unless value.is_a?(Integer)
        value
      when "number"
        mismatch("expected a number", path) unless value.is_a?(Numeric)
        value
      when "boolean"
        mismatch("expected a boolean", path) unless value == true || value == false
        value
      when "null" then mismatch("expected null", path)
      else value
      end
    rescue ArgumentError => error
      mismatch(error.message, path)
    end

    private

    def mismatch(message, path)
      raise Mismatch.new(message, path)
    end
  end
end
