# frozen_string_literal: true

require "rake/testtask"

Rake::TestTask.new(:test) do |task|
  task.libs << "lib" << "test"
  task.pattern = "test/**/*_test.rb"
end

desc "Regenerate the contract (SCHEMA accepts a file or HTTPS URL)"
task :generate do
  args = [RbConfig.ruby, "scripts/generate_contract.rb"]
  args += ["--schema", ENV.fetch("SCHEMA")] if ENV["SCHEMA"]
  sh(*args)
end

desc "Check generated contract against the current schema"
task :check_generated do
  args = [RbConfig.ruby, "scripts/generate_contract.rb", "--check"]
  args += ["--schema", ENV.fetch("SCHEMA")] if ENV["SCHEMA"]
  sh(*args)
end

desc "Build the gem"
task :build do
  sh "gem", "build", "fiscalrail.gemspec", "--strict"
end

task default: :test
