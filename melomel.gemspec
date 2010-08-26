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

  s.add_bundler_dependencies

  s.test_files   = Dir.glob("test/**/*")
  s.files        = Dir.glob("lib/**/*") + %w(LICENSE README CHANGELOG)
  s.require_path = 'lib'
end
