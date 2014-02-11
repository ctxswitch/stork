# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'midwife/version'

Gem::Specification.new do |spec|
  spec.name          = "midwife"
  spec.version       = Midwife::VERSION
  spec.authors       = ["Rob Lyon"]
  spec.email         = ["nosignsoflifehere@gmail.com"]
  spec.description   = %q{ Midwife is a kickstart generator and PXE management tool.  
                           Gets things going enough for a configuration management 
                           tool to take over.}
  spec.summary       = %q{Kickstart generator and PXE manager}
  spec.homepage      = "https://github.com/rlyon/midwife"
  spec.license       = "Apache2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sinatra"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 4.7.3"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "simplecov"
end
