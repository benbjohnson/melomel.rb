$:.unshift(File.join(File.dirname(__FILE__), '../../lib'))
require 'melomel/cucumber'

# Make sure FLEX_HOME is defined
raise 'FLEX_HOME environment variable must be set' if ENV['FLEX_HOME'].nil?

# Open up the sandbox
@pid = fork do
  exec("#{ENV['FLEX_HOME']}/bin/adl target/CucumberRunner-app.xml")
end
Process.detach(@pid)

Melomel.connect()

at_exit do
  Process.kill('KILL', @pid)
end