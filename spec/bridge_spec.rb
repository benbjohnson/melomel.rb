require 'spec_helper'

describe "Bridge" do
  before do
    @bridge = Melomel::Bridge.new('localhost', 10101)
  end
  
  def connect
    # Mock server
    @server = mock(Socket)
    TCPServer.stub!(:open).and_return(@server)
    
    # Mock regular socket
    @socket = mock(Socket)
    @socket.should_receive(:gets).and_return("<connect/>\x00")
    @server.should_receive(:accept).and_return(@socket)
    
    # Attempt connection
    @bridge.connect()
  end
  
  it "should send messages over a socket connection" do
    connect()
    @socket.should_receive(:puts).with("<message/>\x00")
    @bridge.send('<message/>')
  end

  it "should receive messages from a socket connection" do
    connect()
    @socket.should_receive(:gets).and_return("<message/>\x00")
    @bridge.receive().should == '<message/>'
  end

  it "should send a policy file and connect" do
    policy = '<?xml version="1.0"?><!DOCTYPE cross-domain-policy SYSTEM "http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd"><cross-domain-policy><allow-access-from domain="localhost" to-ports="10101"/></cross-domain-policy>';
    
    # Mock server
    server = mock(Socket)
    TCPServer.should_receive(:open).and_return(server)
    
    # Mock policy file
    socket = mock(Socket)
    socket.should_receive(:gets).and_return("<policy-file-request/>\x00")
    socket.should_receive(:send).with(policy)
    socket.should_receive(:flush)
    socket.should_receive(:close)
    server.should_receive(:accept).and_return(socket)
    
    # Mock regular socket
    socket = mock(Socket)
    socket.should_receive(:gets).and_return("<connect/>\x00")
    server.should_receive(:accept).and_return(socket)
    
    # Attempt connection
    @bridge.connect()
  end
end

describe "Bridge Message Parsing" do
  before do
    @bridge = Melomel::Bridge.new('localhost', 10101)
  end
  
  it "should parse a null" do
    message = '<return dataType="null"/>'
    @bridge.parse_message_value(Nokogiri::XML(message).root).should be_nil
  end

  it "should parse an integer" do
    message = '<return value="12" dataType="int"/>'
    @bridge.parse_message_value(Nokogiri::XML(message).root).should == 12
  end

  it "should parse a float" do
    message = '<return value="100.12" dataType="float"/>'
    @bridge.parse_message_value(Nokogiri::XML(message).root).should == 100.12
  end

  it "should parse a boolean true" do
    message = '<return value="true" dataType="boolean"/>'
    @bridge.parse_message_value(Nokogiri::XML(message).root).should == true
  end

  it "should parse a boolean false" do
    message = '<return value="false" dataType="boolean"/>'
    @bridge.parse_message_value(Nokogiri::XML(message).root).should == false
  end

  it "should parse a string" do
    message = '<return value="foo" dataType="string"/>'
    @bridge.parse_message_value(Nokogiri::XML(message).root).should == 'foo'
  end

  it "should parse an object proxy" do
    message = '<return value="123" dataType="object"/>'
    proxy = @bridge.parse_message_value(Nokogiri::XML(message).root)
    proxy.class.should == Melomel::ObjectProxy
    proxy.proxy_id.should == 123
    proxy.bridge.should == @bridge
  end

  it "should throw an error when parsing an unknown type" do
    message = '<return value="foo" dataType="unknown_type"/>'
    lambda {@bridge.parse_message_value(Nokogiri::XML(message).root)}.should raise_error(Melomel::UnrecognizedTypeError)
  end
end

describe "Bridge Message Formatting" do
  before do
    @bridge = Melomel::Bridge.new('localhost', 10101)
  end
  
  it "should format nil" do
    xml = Nokogiri::XML('<root/>').root
    @bridge.format_message_value(xml, nil)
    xml.to_s.should == '<root dataType="null"/>'
  end
  
  it "should format an integer" do
    xml = Nokogiri::XML('<root/>').root
    @bridge.format_message_value(xml, 12)
    xml.to_s.should == '<root value="12" dataType="int"/>'
  end
  
  it "should format a float" do
    xml = Nokogiri::XML('<root/>').root
    @bridge.format_message_value(xml, 100.12)
    xml.to_s.should == '<root value="100.12" dataType="float"/>'
  end

  it "should format a boolean true" do
    xml = Nokogiri::XML('<root/>').root
    @bridge.format_message_value(xml, true)
    xml.to_s.should == '<root value="true" dataType="boolean"/>'
  end

  it "should format a boolean false" do
    xml = Nokogiri::XML('<root/>').root
    @bridge.format_message_value(xml, false)
    xml.to_s.should == '<root value="false" dataType="boolean"/>'
  end

  it "should format a string" do
    xml = Nokogiri::XML('<root/>').root
    @bridge.format_message_value(xml, 'foo')
    xml.to_s.should == '<root value="foo" dataType="string"/>'
  end

  it "should format an object" do
    proxy = Melomel::ObjectProxy.new(@bridge, 123)
    xml = Nokogiri::XML('<root/>').root
    @bridge.format_message_value(xml, proxy)
    xml.to_s.should == '<root value="123" dataType="object"/>'
  end
end

describe "Bridge Actions" do
  before do
    @bridge = Melomel::Bridge.new('localhost', 10101)
  end
  
  it "should execute a 'get' command" do
    @bridge.should_receive(:send).with('<get object="123" property="foo"/>')
    @bridge.should_receive(:receive).and_return('<return value="bar" dataType="string"/>')
    @bridge.get_property(123, 'foo').should == 'bar'
  end
  
  it "should execute a 'set' command" do
    @bridge.should_receive(:send).with("<set object=\"123\" property=\"foo\">\n<arg value=\"bar\" dataType=\"string\"/>\n</set>")
    @bridge.should_receive(:receive).and_return('<return value="bar" dataType="string"/>')
    @bridge.set_property(123, 'foo', 'bar').should == 'bar'
  end
  
  it "should execute an 'invoke' command" do
    @bridge.should_receive(:send).with("<invoke object=\"123\" method=\"foo\">\n<args>\n<arg value=\"John\" dataType=\"string\"/>\n<arg value=\"12\" dataType=\"int\"/>\n</args>\n</invoke>")
    @bridge.should_receive(:receive).and_return('<return value="John is 12" dataType="string"/>')
    @bridge.invoke_method(123, 'foo', 'John', 12).should == 'John is 12'
  end
  
  it "should execute a 'create' command" do
    @bridge.should_receive(:send).with("<create class=\"flash.geom.Point\"/>")
    @bridge.should_receive(:receive).and_return('<return value="123" dataType="object"/>')
    @bridge.create_object('flash.geom.Point').proxy_id.should == 123
  end
  
  it "should execute a 'get-class' command" do
    @bridge.should_receive(:send).with("<get-class name=\"flash.geom.Point\"/>")
    @bridge.should_receive(:receive).and_return('<return value="123" dataType="object"/>')
    @bridge.get_class('flash.geom.Point').proxy_id.should == 123
  end
end