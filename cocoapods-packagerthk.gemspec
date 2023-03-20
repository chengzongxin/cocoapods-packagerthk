# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
# require 'cocoapods-packagerthk/gem_version.rb'
require 'cocoapods-packagerthk.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-packagerthk'
  spec.version       = Pod::Packagerthk::VERSION
  spec.authors       = ['Joe.cheng']
  spec.email         = ['joe.cheng@corp.to8to.com']
  spec.description   = %q{A short description of cocoapods-packagerthk.}
  spec.summary       = %q{A longer description of cocoapods-packagerthk.}
  spec.homepage      = 'https://github.com/chengzongxin/cocoapods-packagerthk'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency "cocoapods", '>= 1.7.3', '< 2.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
