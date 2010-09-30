require 'rubygems'
require 'rake'
require 'minitest/autorun'
require 'rake/testtask'
require 'rake/rdoctask'

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

Rake::RDocTask.new do |rd|
  rd.main = 'README.md'
  rd.rdoc_files.include('README.md', 'lib/**/*.rb')
  rd.rdoc_dir = 'doc'
  rd.title = 'Melomel.rb Documentation'
end
