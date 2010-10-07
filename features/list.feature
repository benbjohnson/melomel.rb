Feature: List-Based Controls
  ##############################################################################
  # Lists
  ##############################################################################

  Scenario: Halo List
    When I select "foo" on the "#haloList" list
    Then I should see "foo" selected on the "#haloList" list

  Scenario: Spark List
    When I select "foo" on the "#sparkList" list
    Then I should see "foo" selected on the "#sparkList" list


  ##############################################################################
  # Combo boxes
  ##############################################################################

  Scenario: Halo Combo Box
    When I select "foo" on the "#haloComboBox" combo box
    Then I should see "foo" selected on the "#haloComboBox" combo box

  Scenario: Spark Combo Box
    When I select "foo" on the "#sparkComboBox" combo box
    Then I should see "foo" selected on the "#sparkComboBox" combo box

