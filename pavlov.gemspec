# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pavlov/version'

Gem::Specification.new do |gem|
  gem.name          = 'pavlov'
  gem.version       = Pavlov::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.authors       = ['Marten Veldthuis','Mark IJbema', 'Tom de Vries', 'Jan Paul Posma', 'Remon Oldenbeuving', 'Jan Deelstra']
  gem.email         = ['jan+pavlov@deelstra.org']
  gem.summary       = %q{Infrastructure for defining your Ruby architecture.}
  gem.description   = %q{Pavlov is a opinionated toolbox to help you architect your Ruby project.}
  gem.license       = 'MIT'
  gem.homepage      = 'https://github.com/Factlink/pavlov/'
  gem.files         = `git ls-files lib`.split($/)
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.require_paths = ['lib']

  rails_version = '>= 3.2.7'
  gem.add_dependency 'virtus', '= 0.5.5'
  gem.add_dependency 'backports', '~> 3.3'
  gem.add_dependency 'activemodel', rails_version

  gem.add_development_dependency 'rspec', "~> 2.14.0"
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-bundler'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rubocop', '~> 0.20.0'
  gem.add_development_dependency 'guard-rubocop'
  gem.add_development_dependency 'terminal-notifier-guard'
  gem.add_development_dependency 'rb-fsevent'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'benchmark-ips'
  gem.add_development_dependency 'coveralls'
end
