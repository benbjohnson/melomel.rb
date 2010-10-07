When /^I set the "([^"]*)" (slider) to "([^"]*)"$/ do |name, type, value|
  classes = Melomel::Flex.get_component_classes(type)
  slider = Melomel::Cucumber.find_labeled!(classes, name)
  value = value.index('.') ? value.to_f : value.to_i
  slider.value = value
end

Then /^I should see the "([^"]*)" (slider) set to "([^"]*)"$/ do |name, type, value|
  classes = Melomel::Flex.get_component_classes(type)
  slider = Melomel::Cucumber.find_labeled!(classes, name)
  value = value.index('.') ? value.to_f : value.to_i
  slider.value.should == value
end

