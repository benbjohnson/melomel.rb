When /^I set the "([^"]*)" (date chooser|date field) to "(\d{1,2}\/\d{1,2}\/\d{4})"$/ do |name, type, date_string|
  classes = Melomel::Flex.get_component_classes(type)
  component = Melomel::Cucumber.find_labeled!(classes, name)
  component.selectedDate = Melomel::Date.parse(date_string)
end

Then /^I should see the "([^"]*)" (date chooser|date field) set to "(\d{1,2}\/\d{1,2}\/\d{4})"$/ do |name, type, date_string|
  classes = Melomel::Flex.get_component_classes(type)
  component = Melomel::Cucumber.find_labeled!(classes, name)
  date = Melomel::Date.parse(date_string)

  component.selectedDate.should_not be_nil
  date.should_not be_nil
  component.selectedDate.toLocaleDateString().should == date.toLocaleDateString()
end

