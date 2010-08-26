require File.join(File.dirname(File.expand_path(__FILE__)), *%w[helper])

class BridgeTestCase < MiniTest::Unit::TestCase
  def setup
    @bridge = Melomel::Bridge.new('localhost', 10101)
  end

  def connect
    # Mock server
    @server = mock('server')
    TCPServer.stubs(:open).returns(@server)
    TCPServer.any_instance.stubs(:close)
    
    # Mock sockets
    @socket = mock('socket')
    @socket.expects(:gets).returns("<connect/>\x00")
    @server.expects(:accept).returns(@socket)
    @server.expects(:close)
    
    # Attempt connection
    @bridge.connect()
  end

  def test_should_send_messages_over_socket_connection
    connect()
    @socket.expects(:puts).with("<message/>\x00")
    @bridge.send('<message/>')
  end

  def test_should_receive_messages_from_socket_connection
    connect()
    @socket.expects(:gets).returns("<message/>\x00")
    assert_equal '<message/>', @bridge.receive()
  end

  def test_should_send_policy_file_and_connect
    policy = '<?xml version="1.0"?><!DOCTYPE cross-domain-policy SYSTEM "http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd"><cross-domain-policy><allow-access-from domain="localhost" to-ports="10101"/></cross-domain-policy>';
    
    # Mock server
    server = mock('server')
    server.expects(:close)
    TCPServer.expects(:open).returns(server)
    
    # Mock policy file
    policy_socket = mock('policy_socket')
    policy_socket.expects(:gets).returns("<policy-file-request/>\x00")
    policy_socket.expects(:send).with(policy)
    policy_socket.expects(:flush)
    policy_socket.expects(:close)
    
    # Mock regular socket
    socket = mock('socket')
    socket.expects(:gets).returns("<connect/>\x00")

    # Server should return policy socket first and then regular socket
    server.stubs(:accept).returns(policy_socket, socket, nil)
    
    # Attempt connection
    @bridge.connect()
  end
end
