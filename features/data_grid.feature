Feature: Data Grid
  Scenario: Halo Data Grid
    When I select "John Smith" on the "#haloDataGrid" data grid
    Then I should see "123 Fake St" selected on the "#haloDataGrid" data grid
    And I should see the following data in the "#haloDataGrid" data grid:
      | Name       | Address          | City   | State |
      | Susy Que   | 1000 Broadway St | Denver | CO    |
      | John Smith | 123 Fake St      | Denver | CO    |
