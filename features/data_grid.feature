Feature: Data Grid
  Scenario: Halo Data Grid
    When I select "John Smith" on the "#haloDataGrid" data grid
    Then I should see "123 Fake St" selected on the "#haloDataGrid" data grid
    And I should see the following data in the "#haloDataGrid" data grid:
      | Name       | Address          | City   | State |
      | Susy Que   | 1000 Broadway St | Denver | CO    |
      | John Smith | 123 Fake St      | Denver | CO    |

  Scenario: Empty Halo Data Grid
    Then I should see no data in the "#emptyHaloDataGrid" data grid

  Scenario: Halo Advanced Data Grid
    When I select "John Smith" on the "#haloAdvancedDataGrid" data grid
    Then I should see "123 Fake St" selected on the "#haloAdvancedDataGrid" data grid
    And I should see the following data in the "#haloAdvancedDataGrid" data grid:
      | Name       | Address          | City   | State |
      | Susy Que   | 1000 Broadway St | Denver | CO    |
      | John Smith | 123 Fake St      | Denver | CO    |
