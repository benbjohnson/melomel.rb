When /^I click the "([^"]*)" button on the alert$/ do |label|
  classes = Melomel::Flex.get_component_classes('alert')
  alert = Melomel.find!(classes)
  button = Melomel::Cucumber.find_by_label!('mx.controls.Button', label, alert)
  Melomel.click(button)
end

Then /^I should see an alert$/ do
  classes = Melomel::Flex.get_component_classes('alert')
  Melomel.find!(classes)
end

Then /^I should see an alert with the title: "([^"]*)"$/ do |title|
  classes = Melomel::Flex.get_component_classes('alert')
  alert = Melomel.find!(classes)
  alert.title.should == title
end

Then /^I should see an alert with the message: "([^"]*)"$/ do |message|
  classes = Melomel::Flex.get_component_classes('alert')
  alert = Melomel.find!(classes)
  alert.text.should == message
end

Then /^I should see an alert with the following message:$/ do |message|
  classes = Melomel::Flex.get_component_classes('alert')
  alert = Melomel.find!(classes)
  alert.text.should == message
end
