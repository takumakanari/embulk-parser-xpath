# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "embulk-parser-xpath"
  spec.version       = "0.0.1"
  spec.authors       = ["Tatsunori Matoba"]
  spec.email         = ["matobat@gmail.com"]
  spec.summary       = %q{Embulk parser plugin for XML with XPath support}
  spec.description   = %q{XPath parser plugin is Embulk plugin to fetch entries in xml format use XPath.}
  spec.homepage      = "https://github.com/matobat/embulk-parser-xpath"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1.6"
  spec.add_development_dependency "bundler", "~> 1.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
