# frozen_string_literal: true

module FiscalRail
  class Model
    attr_reader :extra_fields, :request_id, :idempotent_replayed, :idempotency_key

    def initialize(attributes, extra_fields: {}, metadata: {})
      @attributes = self.class.deep_freeze(attributes)
      @extra_fields = self.class.deep_freeze(extra_fields)
      @request_id = metadata[:request_id]&.dup&.freeze
      @idempotent_replayed = metadata[:idempotent_replayed]&.dup&.freeze
      @idempotency_key = metadata[:idempotency_key]&.dup&.freeze
      freeze
    end

    def [](key)
      key = key.to_s
      @attributes.key?(key) ? @attributes[key] : @extra_fields[key]
    end

    # Unknown fields remain accessible without defining methods on the class.
    def method_missing(name, *args, **kwargs)
      return @extra_fields[name.to_s] if args.empty? && kwargs.empty? && @extra_fields.key?(name.to_s)

      super
    end

    def respond_to_missing?(name, include_private = false)
      @extra_fields.key?(name.to_s) || super
    end

    def to_h
      self.class.unwrap(@extra_fields.merge(@attributes))
    end

    def inspect
      "#<#{self.class.name}#{self['id'] ? " id=#{self['id'].inspect}" : ''}>"
    end

    def self.unwrap(value)
      case value
      when Model then value.to_h
      when Hash then value.transform_values { |item| unwrap(item) }
      when Array then value.map { |item| unwrap(item) }
      else value
      end
    end

    def self.deep_freeze(value)
      case value
      when Hash then value.each { |key, item| deep_freeze(key); deep_freeze(item) }
      when Array then value.each { |item| deep_freeze(item) }
      end
      value.freeze
    end
  end

  class Page < Model
    include Enumerable

    def each(&block)
      return enum_for(:each) unless block

      self["data"].each(&block)
    end
  end
end
