When /^I click the "([^"]*)" button on the alert$/ do |label|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes('alert')
    alert = Melomel.find!(classes)
    button = Melomel::Cucumber.find_by_label!('mx.controls.Button', label, alert)
    button.setFocus()
    Melomel.click(button)
  end
end

Then /^I should see an alert$/ do
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes('alert')
    Melomel.find!(classes)
  end
end

Then /^I should see an alert with the title: "([^"]*)"$/ do |title|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes('alert')
    alert = Melomel.find!(classes)
    alert.title.should == title
  end
end

Then /^I should see an alert with the message: "([^"]*)"$/ do |message|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes('alert')
    alert = Melomel.find!(classes)
    alert.text.should == message
  end
end

Then /^I should see an alert with the following message:$/ do |message|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes('alert')
    alert = Melomel.find!(classes)
    alert.text.should == message
  end
end
