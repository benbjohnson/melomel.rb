require 'nokogiri'

# These add-on methods enable the message encoding and decoding.
module Melomel
  class Bridge
    ###########################################################################
    #
    # Basic Messages
    #
    ###########################################################################

    # Creates an object in the Flash virtual machine and returns the reference
    # to it.
    #
    # class_name - The name of the class to instantiate.
    #
    # Returns an instance of the class if the class is found. Otherwise, nil.
    def create_object(class_name)
      send_create_object(class_name, false)
    end

    # Same as `create_object` except that an error is thrown if the class is
    # not found.
    def create_object!(class_name)
      send_create_object(class_name, true)
    end

    # Retrieves a reference to a class in the Flash virtual machine.
    #
    # class_name - The name of the class to retrieve a reference to.
    #
    # Returns a reference to the class if it exists. Otherwise, nil.
    def get_class(class_name)
      send_get_class(class_name, false)
    end

    # Same as `get_class` except that an error is thrown if the class is not
    # found.
    def get_class!(class_name)
      send_get_class(class_name, true)
    end

    # Retrieves a property of an object in the Flash virtual machine
    #
    # proxy_id - The identifier for the object proxy.
    # property - The name of the property to access.
    # 
    # Returns the value of the property if it exists. Otherwise, nil.
    def get_property(proxy_id, property)
      send_get_property(proxy_id, property, false)
    end

    # Same as `get_property` except that an error is thrown if the property
    # does not exist.
    def get_property!(proxy_id, property)
      send_get_property(proxy_id, property, true)
    end

    # Sets a property on an object in the Flash virtual machine
    #
    # proxy_id - The identifier of the object proxy.
    # property - The name of the property to mutate.
    # value    - The value to set the property to.
    #
    # Returns the value of the property after being set.
    def set_property(proxy_id, property, value)
      send_set_property(proxy_id, property, value, false)
    end

    # Same as `set_property` except that an error is thrown if the property
    # does not exist.
    def set_property!(proxy_id, property, value)
      send_set_property(proxy_id, property, value, true)
    end

    # Invokes a method on an object in the Flash virtual machine
    #
    # proxy_id    - The identifier of the object proxy.
    # method_name - The name of the method to invoke.
    # *args       - List of arguments passed to the method.
    #
    # Returns the value returned from the Flash method.
    def invoke_method(proxy_id, method_name, *args)
      send_invoke_method(proxy_id, method_name, args, false)
    end
    
    # Same as `invoke_method` except that an error is thrown if the method
    # does not exist.
    def invoke_method!(proxy_id, method_name, *args)
      send_invoke_method(proxy_id, method_name, args, true)
    end
    
    # Invokes a package level function in the Flash virtual machine
    # 
    # function_name - The fully qualified name of the function to invoke.
    # *args         - List of arguments passed to the function.
    #
    # Returns the return value of the Flash function.
    def invoke_function(function_name, *args)
      send_invoke_function(function_name, args, false)
    end

    # Same as `invoke_function` except that an error is thrown if the method
    # does not exist.
    def invoke_function!(function_name, *args)
      send_invoke_function(function_name, args, true)
    end


    ###########################################################################
    #
    # Utility Methods
    #
    ###########################################################################

    # Formats a Ruby value into an XML message
    def format_message_value(xml, value)
      # Automatically convert simple objects to proxies.
      value = value.to_object_proxy(self) unless value.nil?
      
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
      name = xml.name()
      
      # If we receive an error back then raise it in the Ruby VM.
      if name == 'error'
        stack_trace_xml = xml.at_xpath('stack-trace')
        object      = Melomel::ObjectProxy.new(self, xml['proxyId'].to_i)
        error_id    = xml['errorId'].to_i
        message     = xml['message']
        name        = xml['name']
        stack_trace = stack_trace_xml ? stack_trace_xml.to_str : nil
        $stderr.puts(stack_trace)
        raise Melomel::Error.new(object, error_id, message, name, stack_trace), message

      # Otherwise we have a return value so we should parse it.
      else
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
    

    ###########################################################################
    #
    # Private Methods
    #
    ###########################################################################

    private
    
    # Creates an object in the Flash virtual machine and returns the reference
    # to it.
    def send_create_object(class_name, throwable=true)
      send("<create class=\"#{class_name}\" throwable=\"#{throwable}\"/>")
      parse_message_value(Nokogiri::XML(receive()).root)
    end

    # Retrieves a reference to a class in the Flash virtual machine.
    def send_get_class(class_name, throwable=true)
      send("<get-class name=\"#{class_name}\" throwable=\"#{throwable}\"/>")
      parse_message_value(Nokogiri::XML(receive()).root)
    end

    # Retrieves a property of an object in the Flash virtual machine
    def send_get_property(proxy_id, property, throwable)
      send("<get object=\"#{proxy_id}\" property=\"#{property}\" throwable=\"#{throwable}\"/>")
      parse_message_value(Nokogiri::XML(receive()).root)
    end

    # Sets a property on an object in the Flash virtual machine
    def send_set_property(proxy_id, property, value, throwable)
      # Create message and format value to set
      xml = Nokogiri::XML("<set object=\"#{proxy_id}\" property=\"#{property}\" throwable=\"#{throwable}\"><arg/></set>")
      format_message_value(xml.at_xpath('/set/arg'), value)
      
      # Send & Receive
      send(xml.root.to_xml(:indent => 0))
      parse_message_value(Nokogiri::XML(receive()).root)
    end

    # Invokes a method on an object in the Flash virtual machine
    def send_invoke_method(proxy_id, method_name, args, throwable)
      xml = Nokogiri::XML("<invoke object=\"#{proxy_id}\" method=\"#{method_name}\" throwable=\"#{throwable}\"><args/></invoke>")
      
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
    def send_invoke_function(function_name, args, throwable)
      xml = Nokogiri::XML("<invoke-function name=\"#{function_name}\" throwable=\"#{throwable}\"><args/></invoke>")

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
  end
end