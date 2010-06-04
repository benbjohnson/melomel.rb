require 'socket'
require 'melomel/bridge/messaging'
    
# The bridge manages the connection to the Flash virtual machine. All messages
# sent to the virtual machine are passed through this object.
module Melomel
  class Bridge
    attr_accessor :host, :port
    
    def initialize(host='localhost', port=10101)
      self.host = host
      self.port = port
    end
    
    # Opens a socket connection to listen for incoming bridge connections. This
    # method automatically handles requests for the policy file.
    def connect()
      disconnect()
      
      # Listen for connections
      @server = TCPServer.open(host, port)
      
      # Retrieve socket and check for initial handshake
      while(@socket.nil?) do
        socket = @server.accept()
        data = socket.gets("\x00").chomp("\x00")
        
        # Send policy file if requested.
        if(data == '<policy-file-request/>')
          send_policy_file(socket)
        # Otherwise open connection and continue
        elsif(data == '<connect/>')
          @socket = socket
        end
      end
    end

    # Closes any open connection to a Flash virtual machine.
    def disconnect()
      begin
        @socket.close()
      rescue
      end

      @socket = nil
    end

    # Sends a message over to the Flash bridge.
    def send(message)
      @socket.send("#{message}\x00")
    end

    # Receives a message from the Flash bridge. This is a blocking call.
    def receive()
      @socket.gets("\x00").chomp("\x00")
    end


    private
    def send_policy_file(socket)
      policy = ''
      policy << '<?xml version="1.0"?>'
      policy << '<!DOCTYPE cross-domain-policy SYSTEM "http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd">'
      policy << '<cross-domain-policy>'
      policy << "<allow-access-from domain=\"#{host}\" to-ports=\"#{port}\"/>"
      policy << '</cross-domain-policy>'
      socket.send(policy)
      socket.flush()
      socket.close()
    end
  end
end