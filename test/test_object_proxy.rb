require File.join(File.dirname(File.expand_path(__FILE__)), *%w[helper])

class ObjectProxyTestCase < MiniTest::Unit::TestCase
  def setup
    @bridge = mock()
    @proxy = Melomel::ObjectProxy.new(@bridge, 123)
  end

  def test_should_delegate_to_bridge_to_retrieve_property
    @bridge.expects(:get_property).with(123, 'foo')
    @proxy.get_property('foo')
  end
  
  def test_should_delegate_to_bridge_to_set_property
    @bridge.expects(:set_property).with(123, 'foo', 'bar')
    @proxy.set_property('foo', 'bar')
  end
  
  def test_should_delegate_to_bridge_to_invoke_method
    @bridge.expects(:invoke_method).with(123, 'foo', 'bar', 'baz')
    @proxy.invoke_method('foo', 'bar', 'baz')
  end
  
  def test_should_alias_invoke_to_invoke_method
    @bridge.expects(:invoke_method).with(123, 'foo')
    @proxy.invoke('foo')
  end
  
  def test_should_alias_accessors_to_get_property_method
    @proxy.expects(:get_property).with('foo')
    @proxy.foo
  end
  
  def test_should_alias_mutators_to_set_property_method
    @proxy.expects(:set_property).with('foo', 'bar')
    @proxy.foo = 'bar'
  end
  
  def test_should_alias_methods_with_arguments_to_invoke_method
    @proxy.expects(:invoke_method).with('foo', 'bar', 'baz')
    @proxy.foo('bar', 'baz')
  end
  
  def test_should_alias_methods_ending_in_bang_to_invoke_method
    @proxy.expects(:invoke_method).with('foo')
    @proxy.foo!()
  end
end
