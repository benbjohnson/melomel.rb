When /^I set the "([^"]*)" (slider) to "([^"]*)"$/ do |name, type, value|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes(type)
    slider = Melomel::Cucumber.find_labeled!(classes, name)
    slider.setFocus()
    value = value.index('.') ? value.to_f : value.to_i
    slider.value = value
  end
end

Then /^I should see the "([^"]*)" (slider) set to "([^"]*)"$/ do |name, type, value|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes(type)
    slider = Melomel::Cucumber.find_labeled!(classes, name)
    slider.setFocus()
    value = value.index('.') ? value.to_f : value.to_i
    slider.value.should == value
  end
end

