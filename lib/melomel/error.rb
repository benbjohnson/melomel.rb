# This class is used for all errors returned from the Flash virtual machine.
module Melomel
  class Error < StandardError
    ############################################################################
    #
    # Constructor
    #
    ############################################################################

    def initialize(object, error_id, message, name, stack_trace)
      @object   = object
      @error_id = error_id
      @message  = message
      @name     = name
      @stack_trace = stack_trace
    end
    

    ############################################################################
    #
    # Public Properties
    #
    ############################################################################

    # A proxied reference to the original Flash error object.
    #
    # Returns a Melomel::ObjectProxy.
    attr_reader :object

    # The error identifier of the Flash error.
    attr_reader :error_id

    # The Flash error message.
    attr_reader :message

    # The name of the Flash error.
    attr_reader :name

    # The Flash stack trace. This is only available when using the Flash debug
    # player or the AIR Debug Launcher (ADL).
    attr_reader :stack_trace
  end
end