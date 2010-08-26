require File.join(File.dirname(File.expand_path(__FILE__)), *%w[helper])

class IntegrationTestCase < RunnerTestCase
  def setup
    start_runner
    Melomel.connect()
  end

  def teardown
    stop_runner
  end

  def test_should_get_application_name
    app = Melomel.get_class('mx.core.FlexGlobals')
    assert_equal 'Melomel Runner', app.topLevelApplication.name
  end

  def test_should_get_property
    runner = Melomel.get_class('MelomelRunner')
    assert_equal 'bar', runner.foo
  end

  def test_should_set_property
    runner = Melomel.get_class('MelomelRunner')
    runner.name = 'Susy'
    assert_equal 'Susy', runner.name
    runner.name = 'John' # TODO: Do not make other tests dependent on this
  end

  def test_should_invoke_method
    runner = Melomel.get_class('MelomelRunner')
    assert_equal 'Hello, John', runner.hello('John')
  end

  def test_should_create_object
    point = Melomel.create_object('flash.geom.Point')
    point.x = 30
    point.y = 40
    assert_equal 50, point.length
  end
end
