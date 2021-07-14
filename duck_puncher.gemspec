# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'duck_puncher/version'

Gem::Specification.new do |spec|
  spec.name          = "duck_puncher"
  spec.version       = DuckPuncher::VERSION
  spec.authors       = ["Ryan Buckley"]
  spec.email         = ["arebuckley@gmail.com"]
  spec.description   = %q{Administer precision punches}
  spec.summary       = %q{Administer precision extensions (a.k.a "punches") to your favorite Ruby classes}
  spec.homepage      = "https://github.com/ridiculous/duck_puncher"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/).keep_if { |f| f =~ /duck_puncher/ and f !~ %r{test/} }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0.0"

  spec.add_runtime_dependency "usable", ">= 3.3"

  spec.add_development_dependency "bundler", ">= 1.3"
  spec.add_development_dependency "rake", '~> 10.1'
  spec.add_development_dependency "minitest", '~> 5.0'
  spec.add_development_dependency "minitest-reporters", '~> 1.1'
end
