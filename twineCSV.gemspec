# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twineCSV/version'

Gem::Specification.new do |spec|
  spec.name = "twineCSV"
  spec.version = TwineCSV::VERSION
  spec.authors = ["Stefan Neidig"]
  spec.email = ["s.neidig@appcom-interactive.de"]

  spec.summary = %q{twineCSV converts your twine localisation file to CSV and vice versa.}
  spec.description = %q{With twineCSV you can convert your localisation files to csv, so that others can edit them via Excel. After exporting it back to csv you can convert it to the twine format again.}
  spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency('commander')

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
