# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fini/version'

Gem::Specification.new do |gem|
    gem.name          = "fini"
    gem.version       = Fini::VERSION
    gem.authors       = ["Mikael Arvola"]
    gem.email         = ["mikael@arvola.com"]
    gem.description   = %q{Fini is an ini-parser optimized for performance.}
    gem.summary       = %q{Fast ini parser}
    gem.homepage      = ""

    gem.files         = `git ls-files`.split($/)
    gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
    gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
    gem.require_paths = ["lib"]
    gem.has_rdoc      = 'yard'

    gem.add_development_dependency "rspec"
    gem.add_development_dependency "simplecov"
end
