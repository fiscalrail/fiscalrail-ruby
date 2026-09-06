# frozen_string_literal: true

require "yaml"
require "json"
require "net/http"
require "optparse"
require "fileutils"

# This is a contract-to-Ruby emitter, not a general-purpose OpenAPI generator.
# Validation constraints stay on the server; decoding retains structural types.
class ContractGenerator
  DEFAULT_SCHEMA = "https://docs.fiscalrail.com/openapi.yml"
  ROOT = File.expand_path("..", __dir__)
  METHODS = %w[get post put patch delete].freeze
  KEYS = %w[$ref type format const properties required items oneOf anyOf allOf additionalProperties discriminator].freeze

  def initialize(document)
    @document = document
    @schemas = document.fetch("components").fetch("schemas").dup
    @models = {}
  end

  def generate
    schemas = @schemas.keys.sort.to_h { |name| [name, normalize(@schemas.fetch(name), name)] }
    operations = {}
    @document.fetch("paths").each do |path, item|
      METHODS.each do |method|
        next unless (operation = item[method])

        id = operation.fetch("operationId")
        raise "Duplicate operationId: #{id}" if operations.key?(id)

        responses = operation.fetch("responses").select { |status, _| status.to_s.match?(/\A2\d\d\z/) }
        operations[id] = {
          "method" => method.upcase, "path" => path,
          "parameters" => (item.fetch("parameters", []) + operation.fetch("parameters", [])).map { |p| resolve(p).slice("name", "in", "required") },
          "responses" => responses.to_h do |status, response|
            content = resolve(response).fetch("content", {})
            [status.to_s, content["application/json"] ? normalize(content["application/json"].fetch("schema")) : nil]
          end
        }
      end
    end

    header = "# frozen_string_literal: true\n# Generated from FiscalRail's OpenAPI contract. Do not edit by hand.\n\n"
    contract = { "version" => @document.fetch("info").fetch("version"), "schemas" => schemas, "operations" => operations.sort.to_h }
    # JSON versions differ in how they pretty-print empty collections.
    json = JSON.pretty_generate(contract).gsub(/\[\n\s*\]/, "[]").gsub(/\{\n\s*\}/, "{}")
    contract_rb = header + "require \"json\"\n\nmodule FiscalRail\n  module Generated\n    CONTRACT = JSON.parse(<<~'JSON')\n#{json}\nJSON\n    Model.deep_freeze(CONTRACT)\n    SCHEMAS = CONTRACT.fetch(\"schemas\")\n    OPERATIONS = CONTRACT.fetch(\"operations\")\n  end\nend\n"
    models_rb = header + "module FiscalRail\n  module Models\n"
    @models.sort.each do |name, fields|
      base = fields.include?("has_more") && fields.include?("data") ? "Page" : "Model"
      models_rb << "    class #{name} < #{base}\n"
      fields.sort.each do |field|
        raise "Unsupported Ruby field: #{field}" unless field.match?(/\A[a-z_][a-z_0-9]*\z/)

        models_rb << "      def #{field} = self[#{field.inspect}]\n"
      end
      models_rb << "    end\n\n"
    end
    models_rb << "  end\nend\n"
    { "contract.rb" => contract_rb, "models.rb" => models_rb }
  end

  def resolve(schema)
    return schema unless schema.key?("$ref")

    ref = schema.fetch("$ref")
    raise "Only local references are supported: #{ref}" unless ref.start_with?("#/")

    value = ref.delete_prefix("#/").split("/").reduce(@document) { |node, key| node.fetch(key.gsub("~1", "/").gsub("~0", "~")) }
    resolve(value).merge(schema.reject { |key, _| key == "$ref" })
  end

  def normalize(schema, name = nil)
    return schema if schema == true || schema == false

    unsupported = schema.keys & %w[not if then else patternProperties prefixItems unevaluatedProperties]
    raise "Unsupported schema construct: #{unsupported.join(', ')}" unless unsupported.empty?

    if schema.key?("allOf")
      parts = schema.fetch("allOf").map { |part| resolve(part) }
      raise "Only object allOf is supported" unless parts.all? { |part| part["type"] == "object" }

      schema = schema.reject { |key, _| key == "allOf" }.merge(
        "type" => "object",
        "properties" => parts.reduce({}) { |props, part| props.merge(part.fetch("properties", {})) },
        "required" => parts.flat_map { |part| part.fetch("required", []) }.uniq
      )
    end
    if schema["$ref"]
      ref = schema.fetch("$ref")
      raise "Only component schema references are supported: #{ref}" unless ref.start_with?("#/components/schemas/")
      @schemas.fetch(ref.split("/").last)
    end
    result = schema.slice(*KEYS)
    if schema["properties"]
      model_name = name || schema["title"]
      if model_name
        raise "Unsupported Ruby model name: #{model_name}" unless model_name.match?(/\A[A-Z][a-zA-Z0-9]*\z/)
        fields = schema.fetch("properties").keys.sort
        raise "Conflicting model: #{model_name}" if @models.key?(model_name) && @models[model_name] != fields

        @models[model_name] = fields
        result["model"] = model_name
      end
      result["properties"] = schema.fetch("properties").sort.to_h { |key, value| [key, normalize(value)] }
    end
    %w[oneOf anyOf].each { |key| result[key] = schema[key].map { |part| normalize(part) } if schema[key] }
    result["items"] = normalize(schema["items"]) if schema["items"]
    result["additionalProperties"] = normalize(schema["additionalProperties"]) if schema["additionalProperties"].is_a?(Hash)
    result["format"] = "decimal" if %w[Money Decimal].include?(name)
    result.sort.to_h
  end

  def self.read(source)
    if source.match?(/\Ahttps?:/)
      uri = URI(source)
      raise "Remote schemas must use HTTPS" unless uri.is_a?(URI::HTTPS)

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 10, read_timeout: 30) { |http| http.get(uri.request_uri) }
      raise "Schema download returned HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      response.body
    else
      File.read(source)
    end
  end
end

if $PROGRAM_NAME == __FILE__
  options = { schema: ContractGenerator::DEFAULT_SCHEMA, check: false }
  OptionParser.new do |parser|
    parser.banner = "Usage: ruby scripts/generate_contract.rb [--schema FILE_OR_HTTPS_URL] [--check]"
    parser.on("--schema SOURCE") { |source| options[:schema] = source }
    parser.on("--check") { options[:check] = true }
  end.parse!
  document = YAML.safe_load(ContractGenerator.read(options[:schema]))
  generated = ContractGenerator.new(document).generate
  destination = File.join(ContractGenerator::ROOT, "lib/fiscalrail/generated")
  if options[:check]
    stale = generated.keys.reject { |name| File.file?(File.join(destination, name)) && File.binread(File.join(destination, name)) == generated[name] }
    abort "Generated contract is stale: #{stale.join(', ')}" unless stale.empty?
    puts "Generated contract is current."
  else
    FileUtils.mkdir_p(destination)
    generated.each { |name, content| File.write(File.join(destination, name), content) }
    puts "Generated #{generated.size} files from #{options[:schema]}."
  end
end
