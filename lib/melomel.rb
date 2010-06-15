require 'melomel/bridge'
require 'melomel/object_proxy'
require 'melomel/ui'
require 'melomel/version'

# This class acts as a singleton instance of the bridge. This is typically the
# only class you'll need to use. If multiple instances of the bridge are needed
# (to connect to multiple SWF files), you will need to instantiate and manage
# the bridge objects manually.
module Melomel
  class MelomelError < StandardError; end
  class UnrecognizedTypeError < MelomelError; end

  class << self
    attr_reader :bridge
    
    # Opens a bridge connection to the SWF file. This is a blocking call and
    # will wait until a SWF connects before continuing.
    def connect(host='localhost', port=10101)
      @bridge = Melomel::Bridge.new(host, port)
      @bridge.connect();
    end

    # Retrieves a reference to a class
    def get_class(class_name)
      @bridge.get_class(class_name)
    end

    # Creates an object in the virtual machine.
    def create_object(class_name)
      @bridge.create_object(class_name)
    end
  end
end