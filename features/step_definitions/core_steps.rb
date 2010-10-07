Then /^the status should be "([^"]*)"$/ do |status|
  Melomel.get_class('CucumberRunner').status.should == status
end
