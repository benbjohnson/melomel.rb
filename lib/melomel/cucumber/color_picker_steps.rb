When /^I set the "([^"]*)" color picker to "#([0-9A-Fa-f]{6})"$/ do |name, color|
  classes = Melomel::Flex.get_component_classes('color picker')
  picker = Melomel::Cucumber.find_labeled!(classes, name)
  picker.selectedColor = color.hex
end

Then /^I should see the "([^"]*)" color picker set to "#([0-9A-Fa-f]{6})"$/ do |name, color|
  classes = Melomel::Flex.get_component_classes('color picker')
  picker = Melomel::Cucumber.find_labeled!(classes, name)
  sprintf('%06X', picker.selectedColor).should == color
end

