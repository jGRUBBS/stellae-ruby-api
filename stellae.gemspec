# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stellae/version'

Gem::Specification.new do |spec|
  spec.name          = "stellae-ruby-api"
  spec.version       = Stellae::VERSION
  spec.authors       = ["Justin Grubbs"]
  spec.email         = ["justin@sellect.com"]
  spec.description   = %q{Ruby Library for Stellae Fulfillment API}
  spec.summary       = %q{This is a library for interfacing with the Stellae Fulfillment API}
  spec.homepage      = "http://sellect.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "builder"
  spec.add_dependency "xml-simple"
  spec.add_dependency "hashie"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "debugger"
end
