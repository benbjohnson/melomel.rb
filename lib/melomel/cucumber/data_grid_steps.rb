When /^I select "([^"]*)" on the "([^"]*)" data grid$/ do |value, name|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes('data grid')
    grid = Melomel::Cucumber.find_labeled!(classes, name)
    grid.setFocus()

    # Retrieve data and take off header row
    data = Melomel::Cucumber.get_grid_data(grid)[1..-1]
  
    # Loop data and check for matches
    index = nil
    data.each_index do |i|
      row = data[i]
      row.each do |cell|
        if cell.strip == value
          index = i
          break
        end
      end
    
      break unless index.nil?
    end
  
    # If we couldn't find a matching cell then throw an error
    raise "Cannot find '#{value}' on data grid" if index.nil?
  
    grid.selectedIndex = index
  end
end


Then /^I should see "([^"]*)" selected on the "([^"]*)" data grid$/ do |value, name|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes('data grid')
    grid = Melomel::Cucumber.find_labeled!(classes, name)
    grid.setFocus()

    # Retrieve data and take off header row
    data = Melomel::Cucumber.get_grid_data(grid)[1..-1]
  
    # Loop data and check for matches
    index = nil
    data.each_index do |i|
      row = data[i]
      row.each do |cell|
        if cell.strip == value
          index = i
          break
        end
      end
    
      break unless index.nil?
    end
  
    grid.selectedIndex.should == index
  end
end

Then /^I should see the following data in the "([^"]*)" data grid:$/ do |name, table|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes('data grid')
    grid = Melomel::Cucumber.find_labeled!(classes, name)
    grid.setFocus()

    data = Melomel::Cucumber.get_striped_grid_data(grid)
  
    table.diff!(data)
  end
end


Then /^I should see no data in the "([^"]*)" data grid$/ do |name|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes('data grid')
    grid = Melomel::Cucumber.find_labeled!(classes, name)
    grid.setFocus()

    # Retrieve data and take off header row
    data = Melomel::Cucumber.get_grid_data(grid)[1..-1]
    
    data.size.should == 0 
  end
end
