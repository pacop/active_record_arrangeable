# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record_arrangeable/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_record_arrangeable'
  spec.version       = ActiveRecord::Arrangeable::VERSION
  spec.authors       = ['Francisco Padillo']
  spec.email         = ['pacopa.93@gmail.com']
  spec.summary       = 'Friendly and easy sort'
  spec.description   = 'Friendly and easy sort'
  spec.homepage      = ''
  spec.license       = 'MIT'
  spec.metadata      = {'source_code_uri' => 'https://github.com/pacop/active_record_arrangeable'}

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'sqlite3'
  spec.add_dependency 'activerecord', '>= 3.0'
end
