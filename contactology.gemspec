# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'contactology/version'

Gem::Specification.new do |s|
  s.name        = 'contactology'
  s.version     = Contactology::VERSION
  s.authors     = ['Nathaniel Bibler']
  s.email       = ['git@nathanielbibler.com']
  s.homepage    = 'https://github.com/nbibler/contactology'
  s.summary     = %q{A Ruby interface to the Contactology email marketing API}
  s.description = %q{This library provides Ruby calls to interact with the Contactology email marketing API}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'hashie', '~> 1.1'
  s.add_dependency 'httparty', '~> 0.7.8'
  s.add_dependency 'multi_json', '~> 1.0'

  s.add_development_dependency 'vcr', '~> 1.5'
  s.add_development_dependency 'rspec', '~> 2.0'
  s.add_development_dependency 'infinity_test'
  s.add_development_dependency 'factory_girl', '~> 2.0'
  s.add_development_dependency 'rack', '~> 1.2'
  s.add_development_dependency 'watchr'
end
