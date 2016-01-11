# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'platform/skvs/version'

Gem::Specification.new do |spec|
  spec.name          = "platform-skvs"
  spec.version       = SKVS::VERSION
  spec.authors       = ["Christoph Olszowka"]
  spec.email         = ["christoph at olszowka de"]

  spec.summary = spec.description = %q{A simple ruby client for Experimental Platform's SKVS service}
  spec.homepage      = "https://github.com/experimental-platform/platform-skvs-ruby"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.license       = "MIT"

  spec.add_runtime_dependency "http", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov"
end
