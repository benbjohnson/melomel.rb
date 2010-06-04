require 'socket'
require 'nokogiri'

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

    # Retrieves a property of an object in the Flash virtual machine
    def get_property(proxy_id, property)
      send("<get object=\"#{proxy_id}\" property=\"#{property}\"/>")
      parse_message_value(Nokogiri::XML(receive()).root)
    end

    # Formats a 
    def parse_message_value(message)
      xml = Nokogiri::XML(message)
      value = xml.root['value']
      data_type = xml.root['dataType']
      
      if data_type == 'int'
        return value.to_i
      elsif data_type == 'float'
        return value.to_f
      elsif data_type == 'boolean'
        return value == 'true'
      elsif data_type == 'object'
        return Melomel::ObjectProxy.new(self, value.to_i)
      elsif data_type == 'string' || data_type.nil?
        return value
      else
        raise UnrecognizedTypeError, "Unknown type: #{data_type}"
      end
    end

    # Parses a return message and converts it into an appropriate type
    def parse_message_value(xml)
      value = xml['value']
      data_type = xml['dataType']
      
      if data_type == 'int'
        return value.to_i
      elsif data_type == 'float'
        return value.to_f
      elsif data_type == 'boolean'
        return value == 'true'
      elsif data_type == 'object'
        return Melomel::ObjectProxy.new(self, value.to_i)
      elsif data_type == 'string' || data_type.nil?
        return value
      else
        raise UnrecognizedTypeError, "Unknown type: #{data_type}"
      end
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