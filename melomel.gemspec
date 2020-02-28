# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'melomel/version'

Gem::Specification.new do |s|
  s.name        = "melomel"
  s.version     = Melomel::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ben Johnson"]
  s.email       = ["benbjohnson@yahoo.com"]
  s.homepage    = "http://github.com/benbjohnson/melomel.rb"
  s.summary     = "A Ruby interface to Melomel"

  s.add_dependency('nokogiri', '~> 1.4.3')

  s.add_development_dependency('rake', '~> 13.0.1')
  s.add_development_dependency('minitest', '~> 1.7.0')
  s.add_development_dependency('mocha', '~> 0.9.8')
  s.add_development_dependency('cucumber', '~> 0.10.0')
  s.add_development_dependency('rspec', '~> 2.6.0')

  s.test_files   = Dir.glob("test/**/*")
  s.files        = Dir.glob("lib/**/*") + %w(README.md CHANGELOG)
  s.require_path = 'lib'
end
