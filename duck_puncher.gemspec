# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'duck_puncher/version'

Gem::Specification.new do |spec|
  spec.name          = "duck_puncher"
  spec.version       = DuckPuncher::VERSION
  spec.authors       = ["Ryan Buckley"]
  spec.email         = ["arebuckley@gmail.com"]
  spec.description   = %q{Duck punches Ruby with some of my favorite class extensions}
  spec.summary       = %q{Duck punches Ruby}
  spec.homepage      = "https://github.com/ridiculous/duck_puncher"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "usable", "~> 1", "< 2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", '~> 10.1'
  spec.add_development_dependency "minitest", '~> 5.0'
  spec.add_development_dependency "minitest-reporters", '~> 1.1'
end
