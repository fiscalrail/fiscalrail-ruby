# frozen_string_literal: true

require_relative "lib/fiscalrail/version"

Gem::Specification.new do |spec|
  spec.name = "fiscalrail"
  spec.version = FiscalRail::VERSION
  spec.authors = ["FiscalRail"]
  spec.email = ["hello@fiscalrail.com"]
  spec.summary = "Official Ruby SDK for the FiscalRail API"
  spec.description = "Issue immutable invoices with a small, idiomatic Ruby client."
  spec.homepage = "https://github.com/fiscalrail/fiscalrail-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3"
  spec.files = Dir["lib/**/*.rb", "README.md", "LICENSE", "CHANGELOG.md"]
  spec.require_paths = ["lib"]
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.add_dependency "bigdecimal", ">= 3.1", "< 5"
  spec.add_dependency "net-http", ">= 0.4", "< 1"
end
