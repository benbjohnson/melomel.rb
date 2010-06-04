# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'melomel/version'

Gem::Specification.new do |s|
  s.name        = "melomel"
  s.version     = Melomel::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ben Johnson"]
  s.email       = ["ben@leafedbox.com"]
  s.homepage    = "http://github.com/benbjohnson/melomel"
  s.summary     = "External interface to Flash through Ruby"
  s.description = "The best way to interact with your Flash objects through Ruby."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "melomel"

  s.add_development_dependency "rspec"

  s.files        = Dir.glob("lib/**/*") + %w(LICENSE README CHANGELOG)
  s.require_path = 'lib'
end
