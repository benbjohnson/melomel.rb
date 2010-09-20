require 'nokogiri'

# These add-on methods enable the message encoding and decoding.
module Melomel
  class Bridge
    # Creates an object in the Flash virtual machine and returns the reference
    # to it.
    def create_object(class_name)
      send("<create class=\"#{class_name}\"/>")
      parse_message_value(Nokogiri::XML(receive()).root)
    end

    # Retrieves a reference to a class in the Flash virtual machine.
    def get_class(class_name)
      send("<get-class name=\"#{class_name}\"/>")
      parse_message_value(Nokogiri::XML(receive()).root)
    end

    # Retrieves a property of an object in the Flash virtual machine
    def get_property(proxy_id, property)
      send("<get object=\"#{proxy_id}\" property=\"#{property}\"/>")
      parse_message_value(Nokogiri::XML(receive()).root)
    end

    # Sets a property on an object in the Flash virtual machine
    def set_property(proxy_id, property, value)
      # Create message and format value to set
      xml = Nokogiri::XML("<set object=\"#{proxy_id}\" property=\"#{property}\"><arg/></set>")
      format_message_value(xml.at_xpath('/set/arg'), value)
      
      # Send & Receive
      send(xml.root.to_xml(:indent => 0))
      parse_message_value(Nokogiri::XML(receive()).root)
    end

    # Invokes a method on an object in the Flash virtual machine
    def invoke_method(proxy_id, method_name, *args)
      xml = Nokogiri::XML("<invoke object=\"#{proxy_id}\" method=\"#{method_name}\"><args/></invoke>")
      
      # Loop over and add arguments to call
      args_node = xml.at_xpath('invoke/args')
      args.each do |arg|
        arg_node = Nokogiri::XML::Node.new('arg', xml)
        format_message_value(arg_node, arg)
        args_node.add_child(arg_node)
      end
      
      # Send and receive
      send(xml.root.to_xml(:indent => 0))
      parse_message_value(Nokogiri::XML(receive()).root)
    end
    
    # Invokes a package level function in the Flash virtual machine
    def invoke_function(function, *args)
       xml = Nokogiri::XML("<invoke-function name=\"#{function}\"><args/></invoke>")

        # Loop over and add arguments to call
        args_node = xml.at_xpath('invoke-function/args')
        args.each do |arg|
          arg_node = Nokogiri::XML::Node.new('arg', xml)
          format_message_value(arg_node, arg)
          args_node.add_child(arg_node)
        end

        # Send and receive
        send(xml.root.to_xml(:indent => 0))
        parse_message_value(Nokogiri::XML(receive()).root)
    end

    # Creates an object proxy from a hash
    def create_hash(hash)
      proxy = create_object('Object')
      hash.each_pair do |k,v|
        v = create_hash(v) if !v.nil? && v.is_a?(Hash)
        proxy.set_property(k, v)
      end
      return proxy
    end

    # Formats a Ruby value into an XML message
    def format_message_value(xml, value)
      # Automatically convert simple hashes to objects
      if(!value.nil? && value.is_a?(Hash))
        value = create_hash(value)
      end
      
      if value.nil?
        xml['dataType'] = 'null'
      elsif value.class == Fixnum || value.class == Bignum
        xml['value'] = value.to_s
        xml['dataType'] = 'int'
      elsif value.class == Float
        xml['value'] = value.to_s
        xml['dataType'] = 'float'
      elsif value == true || value == false
        xml['value'] = value.to_s
        xml['dataType'] = 'boolean'
      elsif value.class == Melomel::ObjectProxy
        xml['value'] = value.proxy_id.to_s
        xml['dataType'] = 'object'
      elsif value.class == String
        xml['value'] = value
        xml['dataType'] = 'string'
      end
    end

    # Parses a return message and converts it into an appropriate type
    def parse_message_value(xml)
      value = xml['value']
      data_type = xml['dataType']
      
      if data_type == 'null'
        return nil
      elsif data_type == 'int'
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
  end
end