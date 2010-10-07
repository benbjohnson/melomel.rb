# This class as a proxy to an object in the Flash virtual machine. Invoking
# methods, accessing properties or changing properties on this object will
# result in a command being sent to Flash to change or access the state of the
# object within the virtual machine. The Ruby object proxy holds no state.
#
# The object proxy works exactly as if the Flash object was a local Ruby object.
# To do this, the following aliases are made:
# * Method calls with method names ending in "=" are aliased to #set_property
# * Method calls without arguments are aliased to #get_property.
# * Method calls with arguments are aliased to #invoke_method
module Melomel
  class ObjectProxy
    attr_reader :bridge, :proxy_id
    
    def initialize(bridge, proxy_id)
      @bridge   = bridge
      @proxy_id = proxy_id
    end
    
    # Retrieves the value of a property for the proxied object.
    def get_property(name)
      @bridge.get_property(@proxy_id, name)
    end
    
    def get_property!(name)
      @bridge.get_property!(@proxy_id, name)
    end
    
    # Sets the value of a property for the proxied object.
    def set_property(name, value)
      @bridge.set_property(@proxy_id, name, value)
    end

    # Sets the value of a property for the proxied object.
    def set_property!(name, value)
      @bridge.set_property!(@proxy_id, name, value)
    end
    
    # Invokes a method on the proxied object. Arguments passed into the method
    # are passed through to the invoked method
    def invoke_method(method_name, *args)
      @bridge.invoke_method(@proxy_id, method_name, *args)
    end

    def invoke_method!(method_name, *args)
      @bridge.invoke_method!(@proxy_id, method_name, *args)
    end
    
    alias :invoke :invoke_method
    
    # Proxies all methods to the appropriate Flash objects.
    def method_missing(symbol, *args)
      method_name = symbol.to_s
      last_char = method_name.to_s[-1,1]
      
      # Methods ending in "=" are aliased to set_property
      if last_char == '='
        return set_property(method_name.chop, *args)
      # Methods with arguments are methods
      elsif args.length > 0
        if last_char == '!'
          return invoke_method!(method_name.chop, *args)
        else
          return invoke_method(method_name, *args)
        end
      # Methods with no arguments are aliased to get_property
      else
        if last_char == '!'
          return get_property!(method_name.chop)
        else
          return get_property(method_name)
        end
      end
    end

    # Array accessor.
    def [](index)
      if index.is_a?(Fixnum)
        get_property("[#{index}]")
      else
        get_property(index.to_s)
      end
    end

    # Array mutator.
    def []=(index, value)
      if index.is_a?(Fixnum)
        set_property("[#{index}]", value)
      else
        set_property(index.to_s, value)
      end
    end
  end
end