When /^I select "([^"]*)" on the "([^"]*)" data grid$/ do |value, name|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes('data grid')
    grid = Melomel::Cucumber.find_labeled!(classes, name)
    grid.setFocus()
    
    index = Melomel::Cucumber.find_grid_index_by_label(grid, value)

    grid.selectedIndex = index
  end
end


Then /^I should see "([^"]*)" selected on the "([^"]*)" data grid$/ do |value, name|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes('data grid')
    grid = Melomel::Cucumber.find_labeled!(classes, name)
    grid.setFocus()

    index = Melomel::Cucumber.find_grid_index_by_label(grid, value)

    grid.selectedIndex.should == index
  end
end

Then /^I should see the following data in the "([^"]*)" data grid:$/ do |name, table|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes('data grid')
    grid = Melomel::Cucumber.find_labeled!(classes, name)
    grid.setFocus()

    data = Melomel::Cucumber.get_grid_data(grid)

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


When /^I (open|close) "([^"]*)" on the "([^"]*)" data grid$/ do |action, value, name|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes('data grid')
    grid = Melomel::Cucumber.find_labeled!(classes, name)
    grid.setFocus()

    element = Melomel::Cucumber.find_grid_element_by_label(grid, value)

    grid.expandItem(element,action == "open")
  end
end
