require File.join(File.dirname(File.expand_path(__FILE__)), *%w[helper])

class SandboxTestCase < RunnerTestCase
  def setup
    start_runner
    Melomel.connect()
  end

  def teardown
    stop_runner
  end

  # Add tests here.
end
