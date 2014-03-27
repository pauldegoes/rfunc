# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rfunc/version'

Gem::Specification.new do |spec|
  spec.name          = "rfunc"
  spec.version       = RFunc::VERSION
  spec.authors       = ["Paul De Goes"]
  spec.email         = ["pauldegoes@hotmail.com"]
  spec.summary       = %q{This gem provides a more functional collection library to Ruby}
  spec.description   = %q{nada}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "yard"
end
