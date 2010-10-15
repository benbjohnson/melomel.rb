When /^I type "([^"]*)" in the "([^"]*)" (text field|text area)$/ do |text, name, type|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes(type)
    component = Melomel::Cucumber.find_labeled!(classes, name)
    component.text = text
  end
end

Then /^I should see "([^"]*)" in the "([^"]*)" (text field|text area|label)$/ do |text, name, type|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes(type)
    component = Melomel::Cucumber.find_labeled!(classes, name)
    component.text.should == text
  end
end
