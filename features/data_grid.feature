Feature: Data Grid
  Scenario: Halo Data Grid
    When I select "John Smith" on the "#haloDataGrid" data grid
    Then I should see "123 Fake St" selected on the "#haloDataGrid" data grid
    And I should see an alert with the message: "ListEvent dispatched with rowIndex 1"
    And I click the "OK" button
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

  Scenario: Halo Advanced Data Grid with GroupingCollection
    When I select "CO" on the "#haloGroupingCollectionDataGrid" data grid
    Then I should see "CO" selected on the "#haloGroupingCollectionDataGrid" data grid
    And I should see the following data in the "#haloGroupingCollectionDataGrid" data grid:
      | State | Name | Age | Max Age |
      | CO    |      |     | 43      |
    When I open "CO" on the "#haloGroupingCollectionDataGrid" data grid
    Then I should see the following data in the "#haloGroupingCollectionDataGrid" data grid:
      | State | Name       | Age | Max Age |
      | CO    |            |     | 43      |
      |       | Susy Que   | 43  |         |
      |       | John Smith | 27  |         |
    When I select "Susy Que" on the "#haloGroupingCollectionDataGrid" data grid
    Then I should see "Susy Que" selected on the "#haloGroupingCollectionDataGrid" data grid

  Scenario: Halo Advanced Data Grid with HierarchicalData
    When I select "CO" on the "#haloHierarchicalDataDataGrid" data grid
    Then I should see "CO" selected on the "#haloHierarchicalDataDataGrid" data grid
    And I should see the following data in the "#haloHierarchicalDataDataGrid" data grid:
      | State | Name |
      | CO    |      |
    When I open "CO" on the "#haloHierarchicalDataDataGrid" data grid
    Then I should see the following data in the "#haloHierarchicalDataDataGrid" data grid:
      | State | Name       |
      | CO    |            |
      |       | Susy Que   |
      |       | John Smith |
    When I close "CO" on the "#haloHierarchicalDataDataGrid" data grid
    Then I should see the following data in the "#haloHierarchicalDataDataGrid" data grid:
      | State | Name       |
      | CO    |            |

  Scenario: Halo Advanced Data Grid with GroupingCollection and TreeColumn is not the first column
    When I select "CO" on the "#haloTreeColumnDataGrid" data grid
    Then I should see "CO" selected on the "#haloTreeColumnDataGrid" data grid
    And I should see the following data in the "#haloTreeColumnDataGrid" data grid:
      | Name | State |
      |      | CO    |
    When I open "CO" on the "#haloTreeColumnDataGrid" data grid
    Then I should see the following data in the "#haloTreeColumnDataGrid" data grid:
      | Name       | State |
      |            | CO    |
      | Susy Que   |       |
      | John Smith |       |
    When I close "CO" on the "#haloTreeColumnDataGrid" data grid
    Then I should see the following data in the "#haloTreeColumnDataGrid" data grid:
      | Name | State |
      |      | CO    |
