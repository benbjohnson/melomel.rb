Then /^the status should be "([^"]*)"$/ do |status|
  Melomel::Cucumber.run! do
    Melomel.get_class('CucumberRunner').status.should == status
  end
end
