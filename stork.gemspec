# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stork/version'

Gem::Specification.new do |spec|
  spec.name          = "stork"
  spec.version       = Stork::VERSION
  spec.authors       = ["Rob Lyon"]
  spec.email         = ["nosignsoflifehere@gmail.com"]
  spec.summary       = %q{Autoinstallation and PXE management.}
  spec.description   = %q{Autoinstallation and PXE management for Redhat/CentOS based system deployment.}
  spec.homepage      = "https://github.com/rlyon/stork"
  spec.license       = "Apache2"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sinatra"
  spec.add_runtime_dependency "thin"
  spec.add_runtime_dependency "sqlite3"
  spec.add_runtime_dependency "rest-client"
  spec.add_runtime_dependency "highline"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "minitest", "~> 4.7.3"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "minitest-given"
  spec.add_development_dependency "minitest-debugger"
end
