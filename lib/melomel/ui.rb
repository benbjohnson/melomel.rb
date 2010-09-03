# This class provides ease of use utility methods for finding display objects
# and interacting with them.
module Melomel
  class << self
    # Finds all display objects matching a class and hash of properties.
    def find_all(class_name, root={}, properties={})
      Melomel.bridge.find_all(class_name, root, properties)
    end

    # Finds a display object by class and properties.
    def find(class_name, root={}, properties={})
      Melomel.bridge.find(class_name, root, properties)
    end


    # Imitates a click on a component
    def click(component, properties={})
      Melomel.bridge.click(component, properties)
    end

    # Imitates a double click on a component
    def double_click(component, properties={})
      Melomel.bridge.double_click(component, properties)
    end


    # Imitates a key down on a component
    def key_down(component, char, properties={})
      Melomel.bridge.key_down(component, char, properties)
    end

    # Imitates a key up on a component
    def key_up(component, char, properties={})
      Melomel.bridge.key_up(component, char, properties)
    end

    # Imitates a key press on a component
    def key_press(component, char, properties={})
      Melomel.bridge.key_press(component, char, properties)
    end
  end
end