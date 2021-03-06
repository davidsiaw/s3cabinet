# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3cabinet/version'

Gem::Specification.new do |spec|
  spec.name          = "s3cabinet"
  spec.version       = S3Cabinet::VERSION
  spec.authors       = ["David Siaw (via Travis CI)"]
  spec.email         = ["david.siaw@mobingi.com"]

  spec.summary       = "S3 as a key value store"
  spec.description   = "Well actually S3 IS a key value store"
  spec.homepage      = "https://github.com/davidsiaw/s3cabinet"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-core"
  spec.add_dependency "json"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "fakes3"
  spec.add_development_dependency 'rspec_junit_formatter', '0.2.2'
end
