When /^I click the "([^"]*)" (button|check box|radio button)$/ do |name, type|
  classes = Melomel::Flex.get_component_classes(type)
  button = Melomel::Cucumber.find_by_label!(classes, name)
  Melomel.click(button)
end

Then /^I should see the "([^"]*)" (button|check box|radio button) (not )?selected$/ do |name, type, neg|
  classes = Melomel::Flex.get_component_classes(type)
  button = Melomel::Cucumber.find_by_label!(classes, name)
  button.selected.should == neg.nil?
end
