# These add-on methods provide ease of use utility methods.
module Melomel
  class Bridge
    # Finds a list of display objects matching a class and hash of properties.
    def find_all(class_name, root={}, properties={})
      # Merge hashes if no root is specified
      if root.is_a?(Hash)
        properties.merge!(root)
        root = nil
      end
      
      # Retrieve object
      get_class('melomel.core.UI').findAll(class_name, root, properties)
    end

    # Finds a display object by class and properties.
    def find(class_name, root={}, properties={})
      # Merge hashes if no root is specified
      if root.is_a?(Hash)
        properties.merge!(root)
        root = nil
      end
      
      # Retrieve object
      get_class('melomel.core.UI').find(class_name, root, properties)
    end


    # Imitates a click on a component
    def click(component, properties={})
      get_class('melomel.core.UI').click(component, properties)
    end

    # Imitates a double click on a component
    def double_click(component, properties={})
      get_class('melomel.core.UI').doubleClick(component, properties)
    end


    # Imitates a key down on a component
    def key_down(component, char, properties={})
      get_class('melomel.core.UI').keyDown(component, char, properties)
    end

    # Imitates a key up on a component
    def key_up(component, char, properties={})
      get_class('melomel.core.UI').keyUp(component, char, properties)
    end

    # Imitates a key press on a component
    def key_press(component, char, properties={})
      get_class('melomel.core.UI').keyPress(component, char, properties)
    end
  end
end