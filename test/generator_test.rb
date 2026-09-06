# frozen_string_literal: true

require_relative "test_helper"
require_relative "../scripts/generate_contract"

class GeneratorTest < SDKTest
  def document
    {
      "info" => { "version" => "1" },
      "paths" => {
        "/examples/{id}" => {
          "parameters" => [{ "name" => "id", "in" => "path", "required" => true }],
          "get" => { "operationId" => "retrieveExample", "responses" => { "200" => { "content" => { "application/json" => { "schema" => { "$ref" => "#/components/schemas/Example" } } } } } }
        }
      },
      "components" => { "schemas" => {
        "Money" => { "type" => "string" },
        "Example" => { "type" => "object", "required" => ["id"], "properties" => {
          "id" => { "type" => "string" }, "amount" => { "$ref" => "#/components/schemas/Money" }
        } }
      } }
    }
  end

  def test_deterministic_generation_and_real_ruby_syntax
    first = ContractGenerator.new(document).generate
    assert_equal first, ContractGenerator.new(document).generate
    first.each_value { |source| assert RubyVM::InstructionSequence.compile(source) }
    assert_includes first["contract.rb"], '"format": "decimal"'
    assert_includes first["models.rb"], "class Example < Model"
  end

  def test_rejects_duplicate_ids_remote_refs_and_unsupported_constructs
    duplicate = document
    duplicate["paths"]["/another"] = duplicate["paths"]["/examples/{id}"]
    assert_raises(RuntimeError) { ContractGenerator.new(duplicate).generate }
    remote = document
    remote["components"]["schemas"]["Example"] = { "$ref" => "https://example.com/schema" }
    assert_raises(RuntimeError) { ContractGenerator.new(remote).generate }
    unsupported = document
    unsupported["components"]["schemas"]["Example"]["if"] = {}
    assert_raises(RuntimeError) { ContractGenerator.new(unsupported).generate }
    assert_raises(RuntimeError) { ContractGenerator.read("http://example.com/schema") }
  end

  def test_allof_keeps_base_fields_and_derived_types
    schema = document
    schema["components"]["schemas"]["Extended"] = { "allOf" => [
      { "$ref" => "#/components/schemas/Example" },
      { "type" => "object", "required" => ["name"], "properties" => { "name" => { "type" => "string" } } }
    ] }
    result = ContractGenerator.new(schema).generate
    extended = result["models.rb"].split("class Extended < Model").last
    assert_includes extended, 'def id = self["id"]'
    assert_includes extended, 'def name = self["name"]'
  end
end
