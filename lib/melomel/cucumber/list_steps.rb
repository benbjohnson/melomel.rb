When /^I select "([^"]*)" on the "([^"]*)" (combo box|list)$/ do |value, name, type|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes(type)
    list = Melomel::Cucumber.find_labeled!(classes, name)
    labels = Melomel.items_to_labels!(list, list.dataProvider)
  
    # Loop over labels and set the selected index when we find a match
    index = nil
    labels.length.times do |i|
      if labels[i] == value
        index = i
      end
    end
    raise "Cannot find '#{value}' on #{type}" if index.nil?
  
    list.selectedIndex = index
  end
end

Then /^I should see "([^"]*)" selected on the "([^"]*)" (combo box|list)$/ do |value, name, type|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes(type)
    list = Melomel::Cucumber.find_labeled!(classes, name)
    label = list.itemToLabel(list.selectedItem)
    label.should == value
  end
end

