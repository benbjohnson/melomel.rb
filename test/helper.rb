require 'rubygems'
require "bundler"
Bundler.setup
require 'minitest/autorun'
require 'mocha'

dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift(File.join(dir, '..', 'lib'))
$LOAD_PATH.unshift(dir)

require 'melomel'

class RunnerTestCase < MiniTest::Unit::TestCase
  def start_runner
    # Make sure FLEX_HOME is defined
    raise 'FLEX_HOME environment variable must be set' if ENV['FLEX_HOME'].nil?

    # Open up the sandbox
    @pid = fork do
      exec("#{ENV['FLEX_HOME']}/bin/adl target/MelomelRunner-app.xml")
    end
    Process.detach(@pid)
  end

  def stop_runner
    Process.kill('KILL', @pid)
  end
end