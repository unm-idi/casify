# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'casify/version'

Gem::Specification.new do |spec|
  spec.name          = "casify"
  spec.version       = Casify::VERSION
  spec.authors       = ["UNM IDI"]
  spec.email         = ["idi.unm@gmail.com"]

  spec.summary       = %q{Gem Used by UNM IDI in order to provide single sign on authentication and authorization.}
  spec.homepage      = "https://github.com/unm-idi/casify"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  # spec.bindir        = "exe"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "omniauth-cas"
  spec.add_development_dependency "httparty"
  spec.add_development_dependency "activesupport"
end
