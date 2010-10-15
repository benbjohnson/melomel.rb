# These add-on methods provide ease of use utility methods.
module Melomel
  class Bridge
    # Blocks until Melomel.busy in the Flash virtual machine is false.
    #
    # Returns nothing.
    def wait()
      loop do 
        break unless busy!
        sleep 0.1
      end
    end
    
    # Checks if the Flash virtual machine is currently busy. See Melomel#busy
    # in the Melomel asdocs for more information.
    #
    # Returns true if the Flash virtual machine is busy. Otherwise returns
    # false.
    def busy!
      get_class!('Melomel').busy!
    end
    
    # Finds a list of display objects matching a class and hash of properties.
    #
    # class_name - The type of objects to search for.
    # root       - The object to start searching from. (Defaults to the stage).
    # properties - A list of properties to match on each object.
    #
    # Example:
    # 
    #   bridge.find_all('mx.controls.Button', :label => 'Click me')
    #   # => [<Melomel::ObjectProxy>, <Melomel::ObjectProxy>]
    #
    # Returns a list of display objects contained by root that match the
    # properties and class specified.
    def find_all(class_name, root={}, properties={})
      # Merge hashes if no root is specified
      if root.is_a?(Hash)
        properties.merge!(root)
        root = nil
      end
      
      # Retrieve object
      get_class('melomel.core.UI').findAll(class_name, root, properties)
    end
    
    def find_all!(class_name, root={}, properties={})
      objects = find_all(class_name, root, properties)
      raise MelomelError.new("No objects found") if objects.empty?
      return objects
    end

    # Finds the first display object matching a class and hash of properties.
    #
    # class_name - The type of object to search for.
    # root       - The object to start searching from. (Defaults to the stage).
    # properties - A list of properties to match on the object.
    #
    # Example:
    # 
    #   bridge.find('mx.controls.Button', :label => 'Click me')
    #   # => <Melomel::ObjectProxy>
    #
    # Returns the first display object contained by root that matches the
    # properties and class specified.
    def find(class_name, root={}, properties={})
      # Merge hashes if no root is specified
      if root.is_a?(Hash)
        properties.merge!(root)
        root = nil
      end
      
      # Retrieve object
      get_class('melomel.core.UI').find(class_name, root, properties)
    end

    def find!(class_name, root={}, properties={})
      object = find(class_name, root, properties)
      raise MelomelError.new("No object found") if object.nil?
      return object
    end

    # Finds a component based on the label of a nearby component. This works
    # by first finding a Halo or Spark label component and then recursively
    # searching the label's parent's children for a component of a given class.
    #
    # class_name - The type of object to search for.
    # label_text - The label text to search for.
    # root       - The object to start searching from. (Defaults to the stage).
    # properties - A list of properties to match on the object.
    #
    # Example:
    # 
    #   bridge.find_labeled('mx.controls.TextInput', 'First Name')
    #   # => <Melomel::ObjectProxy>
    #
    # Returns the first display object which is inside the parent of a given
    # label.
    def find_labeled(class_name, label_text, root={}, properties={})
      # Merge hashes if no root is specified
      if root.is_a?(Hash)
        properties.merge!(root)
        root = nil
      end
      
      # Retrieve object
      get_class('melomel.core.UI').findLabeled(class_name, label_text, root, properties)
    end

    def find_labeled!(class_name, label_text, root={}, properties={})
      object = find_labeled(class_name, label_text, root, properties)
      raise MelomelError.new("No object found") if object.nil?
      return object
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


    # Generates a list of labels created by a data control or column based on a
    # data set.
    #
    # component - The control or column which has an itemToLabel() method.
    # data      - The data set to generate labels from.
    #
    # Returns a Ruby array of labels.
    def items_to_labels!(component, data)
      get_class('melomel.core.UI').itemsToLabels!(component, data)
    end
  end
end