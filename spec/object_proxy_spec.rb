require 'spec_helper'

describe "Object Proxy" do
  before do
    @bridge = mock()
    @proxy = Melomel::ObjectProxy.new(@bridge, 123)
  end

  it "should delegate to bridge to retrieve property" do
    @bridge.should_receive(:get_property).with(123, 'foo')
    @proxy.get_property('foo')
  end
  
  it "should delegate to bridge to set property" do
    @bridge.should_receive(:set_property).with(123, 'foo', 'bar')
    @proxy.set_property('foo', 'bar')
  end
  
  it "should delegate to bridge to invoke method" do
    @bridge.should_receive(:invoke_method).with(123, 'foo', 'bar', 'baz')
    @proxy.invoke_method('foo', 'bar', 'baz')
  end
  
  it "should alias accessors to get_property()" do
    @proxy.should_receive(:get_property).with('foo')
    @proxy.foo
  end
  
  it "should alias mutators to set_property()" do
    @proxy.should_receive(:set_property).with('foo', 'bar')
    @proxy.foo = 'bar'
  end
  
  it "should alias methods with arguments to invoke_method()" do
    @proxy.should_receive(:invoke_method).with('foo', 'bar', 'baz')
    @proxy.foo('bar', 'baz')
  end
end