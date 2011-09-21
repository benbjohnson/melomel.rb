Feature: Tree
  Scenario: Halo Tree
    When I select "Baz" on the "#haloTree" tree
    Then I should see "Baz" selected on the "#haloTree" tree
