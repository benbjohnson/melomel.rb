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


  it "should send messages over a socket connection" do
    connect()
    @socket.should_receive(:send).with("<message/>\x00")
    @bridge.send('<message/>')
  end

  it "should receive messages from a socket connection" do
    connect()
    @socket.should_receive(:gets).and_return("<message/>\x00")
    @bridge.receive().should == '<message/>'
  end

  it "should parse a returned integer" do
    message = '<return value="12" dataType="int"/>'
    @bridge.parse_message_value(Nokogiri::XML(message).root).should == 12
  end

  it "should parse a returned float" do
    message = '<return value="100.12" dataType="float"/>'
    @bridge.parse_message_value(Nokogiri::XML(message).root).should == 100.12
  end

  it "should parse a returned boolean true" do
    message = '<return value="true" dataType="boolean"/>'
    @bridge.parse_message_value(Nokogiri::XML(message).root).should == true
  end

  it "should parse a returned boolean false" do
    message = '<return value="false" dataType="boolean"/>'
    @bridge.parse_message_value(Nokogiri::XML(message).root).should == false
  end

  it "should parse a returned string" do
    message = '<return value="foo" dataType="string"/>'
    @bridge.parse_message_value(Nokogiri::XML(message).root).should == 'foo'
  end

  it "should parse a returned object proxy" do
    message = '<return value="123" dataType="object"/>'
    proxy = @bridge.parse_message_value(Nokogiri::XML(message).root)
    proxy.class.should == Melomel::ObjectProxy
    proxy.proxy_id.should == 123
    proxy.bridge.should == @bridge
  end

  it "should execute a get command" do
    connect()
    @bridge.should_receive(:send).with('<get object="123" property="foo"/>')
    @bridge.should_receive(:receive).and_return('<return value="bar" dataType="string"/>')
    @bridge.get_property(123, 'foo').should == 'bar'
  end
end