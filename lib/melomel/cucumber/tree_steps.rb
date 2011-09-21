When /^I select "([^"]*)" on the "([^"]*)" tree$/ do |value, name|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes('tree')
    tree = Melomel::Cucumber.find_labeled!(classes, name)
    tree.setFocus()
    
    item = Melomel.find_tree_item_by_label!(tree, value)

    # Find parents
    parents = []
    parent = tree.getParentItem(item)
    puts "Parent: #{parent} - #{item}"
    
    # Reverse parents and expand
    parents.reverse.each do |parent|
      tree.validateNow()
      tree.expandItem(parent, true)
    end
    
    tree.selectedItem = item
  end
end


Then /^I should see "([^"]*)" selected on the "([^"]*)" tree$/ do |value, name|
  Melomel::Cucumber.run! do
    classes = Melomel::Flex.get_component_classes('tree')
    tree = Melomel::Cucumber.find_labeled!(classes, name)
    tree.setFocus()

    tree.itemToLabel(tree.selectedItem).should == value
  end
end
