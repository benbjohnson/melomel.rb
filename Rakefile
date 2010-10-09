lib = File.expand_path('lib', File.dirname(__FILE__))
$:.unshift lib unless $:.include?(lib)

require 'rubygems'
require 'rake'
require 'minitest/autorun'
require 'rake/testtask'
require 'rake/rdoctask'
require 'melomel'

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


#############################################################################
#
# Packaging tasks
#
#############################################################################

task :release do
  puts ""
  print "Are you sure you want to relase Melomel #{Melomel::VERSION}? [y/N] "
  exit unless STDIN.gets.index(/y/i) == 0
  
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  
  # Build gem and upload
  sh "gem build melomel.gemspec"
  sh "gem push melomel-#{Melomel::VERSION}.gem"
  sh "rm melomel-#{Melomel::VERSION}.gem"
  
  # Commit
  sh "git commit --allow-empty -a -m 'v#{Melomel::VERSION}'"
  sh "git tag v#{Melomel::VERSION}"
  sh "git push origin master"
  sh "git push origin v#{Melomel::VERSION}"
end
