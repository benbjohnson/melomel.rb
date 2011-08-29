require 'cucumber'
require 'melomel'
Dir.glob(File.dirname(__FILE__) + '/cucumber/*') {|file| require file }

# This class holds utility methods for running Cucumber steps.
module Melomel
  class Cucumber
    # A wrapper for Melomel actions that automatically waits until the Flash
    # virtual machine is not busy before continuing.
    #
    # Returns nothing.
    def self.run!
      Melomel.wait()
      yield
    end

    # Finds a component by id.
    #
    # class_name - The class or classes to match on.
    # id         - The id of the component.
    # root       - The root component to search from. Defaults to the stage.
    # properties - Additional properties to search on.
    #
    # Returns a component matching the id and the additional properties.
    def self.find_by_id!(class_name, id, root={}, properties={})
      properties['id'] = id
      Melomel.find!(class_name, root, properties)
    end

    # Finds a component by label. If the first character is a "#" then the
    # component should be found by id. Otherwise it is found by label.
    #
    # class_name - The class or classes to match on.
    # label      - The label of the component.
    # root       - The root component to search from. Defaults to the stage.
    # properties - Additional properties to search on.
    #
    # Returns a component matching the label and the additional properties.
    def self.find_by_label!(class_name, label, root={}, properties={})
      set_properties_key(properties, 'label', label)
      Melomel.find!(class_name, root, properties)
    end

    # Finds a component that shares the same parent as a given label. If the
    # first character is a "#" then the component should be found by id.
    # Otherwise it is found by label.
    #
    # class_name - The class or classes to match on.
    # label      - The label text.
    # root       - The root component to search from. Defaults to the stage.
    # properties - Additional properties to search on.
    #
    # Returns a component labeled by another component.
    def self.find_labeled!(class_name, label, root={}, properties={})
      if label.index('#') == 0
        find_by_id!(class_name, label[1..-1], root, properties)
      else
        Melomel.find_labeled!(class_name, label, root, properties)
      end
    end

    # Finds a component by title. If the first character is a "#" then the
    # component should be found by id. Otherwise it is found by title.
    #
    # class_name - The class or classes to match on.
    # title      - The title of the component.
    # root       - The root component to search from. Defaults to the stage.
    # properties - Additional properties to search on.
    #
    # Returns a component matching the title and the additional properties.
    def self.find_by_title!(class_name, title, root={}, properties={})
      set_properties_key(properties, 'title', title)
      Melomel.find!(class_name, root, properties)
    end

    # Finds a component by text. If the first character is a "#" then the
    # component should be found by id. Otherwise it is found by text.
    #
    # class_name - The class or classes to match on.
    # text       - The text property of the component.
    # root       - The root component to search from. Defaults to the stage.
    # properties - Additional properties to search on.
    #
    # Returns a component matching the text and the additional properties.
    def self.find_by_text!(class_name, text, root={}, properties={})
      set_properties_key(properties, 'text', text)
      Melomel.find!(class_name, root, properties)
    end

    # Sets the key in the properties hash. If the first character is "#" then
    # the key is "id". Otherwise it is set to the value of "key".
    #
    # properties - The properties hash.
    # key        - The name of the key to set.
    # name       - The name of the component.
    #
    # Returns nothing.
    def self.set_properties_key(properties, key, name)
      if name.index('#') == 0
        properties['id'] = name[1..-1]
      else
        properties[key] = name
      end
    end

    # Retrieves grid data as a 2D array of rows of columns. The first row
    # contains the grid's header.
    #
    # grid - The grid to generate the table from.
    #
    # Returns a 2D array of rows of columns of data.
    def self.get_grid_data(grid)
      data_with_elements = get_grid_data_with_elements(grid)
      
      # Remove data grid elements
      data_with_elements.map{|row| row[1..-1]}
    end
    
    # Retrieves the first element of a grid, which matches the label
    #
    # label - The label that should be found in the grid
    # grid - The grid which will be searched in
    #
    # Returns the matched element
    def self.find_grid_element_by_label(grid, label)
      data_with_elements = get_grid_data_with_elements(grid)
      
      # Remove data grid elements and first row
      data = data_with_elements.map{|row| row[1..-1]}[1..-1]
      
      index = find_index_by_label(data, label)
      
      data_with_elements[index + 1].first
    end
    
    # Retrieves the index of the first element of a grid, which matches the label
    #
    # label - The label that should be found in the grid
    # grid - The grid which will be searched in
    #
    # Returns the matched elements index
    def self.find_grid_index_by_label(grid, label)
      data_with_elements = get_grid_data_with_elements(grid)
      
      # Remove data grid elements and first row
      data = data_with_elements.map{|row| row[1..-1]}[1..-1]
      
      index = find_index_by_label(data, label)
      index
    end
    
    # Retrieves grid data as a 2D array of rows of columns. The first row
    # contains the grid's header. The first column contains the grids elements.
    #
    # grid - The grid to generate the table from.
    #
    # Returns a 2D array of rows of columns of data.
    def self.get_grid_data_with_elements(grid)
      # Retrieve as columns of rows
      data = []
      group_labels = []
      
      # Add the empty cell in the upper left corner
      data << [nil]
      
      # Retrieve data with cursor and group labels
      i = 0
      elements = get_grid_elements(grid)
      elements.each do |element|
        data[0] << element
        if !element.GroupLabel.nil? && element.GroupLabel != ""
          group_labels[i] = element.GroupLabel
        end
        i += 1
      end
      
      grid.columns.length.times do |i|
        column_data = []
        column = grid.columns[i]
        labels = Melomel.items_to_labels!(column, elements)

        # Add column header
        column_data << column.headerText
        
        # Set group labels
        # either in first column or, if treeColumn is set in the corresponding column
        # Comparision between the current column and the treeColumn is still a bit vague,
        # but column == grid.treeColumn is always false, because these are two different objects
        if (grid.treeColumn == nil && i == 0) ||
          (grid.treeColumn != nil && column.headerText == grid.treeColumn.headerText)
          group_labels.length.times do |j|
            if !group_labels[j].nil?
              labels[j] = group_labels[j]
            end
          end
        end
        
        # Add label data
        labels.length.times do |j|
          column_data << labels[j]
        end
        
        # Add column data to data set
        data << column_data
      end
      
      # Transpose data
      data = data.transpose()
      
      # Trim whitespace from each cell
      data.each {|row| row.each {|cell| cell.strip! unless cell.nil? || !cell.is_a?(String)}}
      
      return data
    end
    
    # Searches for a label in 2D grid data
    #
    # label - The label that should be found in the data
    # data - The data which will be searched in
    #
    # Returns an array of all the elements
    def self.find_index_by_label(data, label)
      index = nil
      data.each_index do |i|
        row = data[i]
          row.each do |cell|
            if (cell != nil) && (cell.strip == label)
              index = i
            break
          end
        end
        break unless index.nil?
      end
      raise "Cannot find '#{value}' on data grid" if index.nil?
      index
    end
    
    
    # Retrieves all elements of a grid through a cursor
    #
    # grid - The grid to retrieve the objects from
    #
    # Returns an array of all the elements
    def self.get_grid_elements(grid)
      elements = []
      unless grid.dataProvider.nil?
        cursor = grid.dataProvider.createCursor()
        while !cursor.afterLast do
          elements.push cursor.current
          break if !cursor.moveNext()
        end
      end
      elements
    end
  end
end
