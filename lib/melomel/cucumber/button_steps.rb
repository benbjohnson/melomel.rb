When /^I click the "([^"]*)" (button|check box|image|radio button|tab)$/ do |name, type|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes(type)
    button = Melomel::Cucumber.find_by_label!(classes, name)
    button.setFocus()
    Melomel.click(button)
  end
end

Then /^I should see the "([^"]*)" (button|check box|radio button) (not )?selected$/ do |name, type, neg|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes(type)
    button = Melomel::Cucumber.find_by_label!(classes, name)
    button.setFocus()
    button.selected.should == neg.nil?
  end
end
