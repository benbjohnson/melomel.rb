require 'rubygems'
require 'rake'
require 'minitest/autorun'
require 'rake/testtask'

#############################################################################
#
# Standard tasks
#
#############################################################################
  
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
