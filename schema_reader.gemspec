# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'schema_reader/version'

Gem::Specification.new do |spec|
  spec.name          = "schema_reader"
  spec.version       = SchemaReader::VERSION
  spec.authors       = ["Dustin Zeisler"]
  spec.email         = ["dustin@zive.me"]
  spec.description   = %q{Reads Rails Database schema and creates a class from selected table with getters and setters.}
  spec.summary       = %q{This was created for unit testing Rails ActiveRecord.
                        Instead of creating a mock that can become out of date with real objects schema reader creates mocks form the true definition.}
  spec.homepage      = "https://github.com/zeisler/schema_reader"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~>10.1"
  spec.add_development_dependency "rspec", "~>2.14"
  spec.add_development_dependency 'active_hash', '1.2.3'

  if RUBY_ENGINE == "rubinius"
    spec.add_development_dependency 'rubysl'
    spec.add_development_dependency "rubysl-singleton", "~> 2.0"
    spec.add_development_dependency "rubysl-optparse", "~> 2.0"
    spec.add_development_dependency "rubysl-ostruct", "~> 2.0"
  end

  #spec.add_development_dependency "debase", "~>0.0"
  #spec.add_development_dependency "ruby-debug-ide", "~>0.4"

end
