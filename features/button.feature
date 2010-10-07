Feature: Button-Based Controls
  ##############################################################################
  # Regular Buttons
  ##############################################################################

  Scenario: Halo Button Click
    When I click the "Halo" button
    Then I should see the "#haloButton" button not selected
    And the status should be "Halo Button Clicked"

  Scenario: Spark Button Click
    When I click the "Spark" button
    Then the status should be "Spark Button Clicked"

  Scenario: Halo Toggle Button Selected
    When I click the "Halo Toggle" button
    Then I should see the "Halo Toggle" button selected

  Scenario: Spark Toggle Button Selected
    When I click the "Spark Toggle" button
    Then I should see the "Spark Toggle" button selected


  ##############################################################################
  # Check boxes
  ##############################################################################

  Scenario: Halo Check Box Click
    When I click the "Halo CB" check box
    Then I should see the "Halo CB" check box selected

  Scenario: Spark Check Box Click
    When I click the "Spark CB" check box
    Then I should see the "Spark CB" check box selected


  ##############################################################################
  # Radio button
  ##############################################################################

  Scenario: Halo Radio Button Click
    When I click the "Halo RB" radio button
    Then I should see the "Halo RB" radio button selected

  Scenario: Spark Radio Button Click
    When I click the "Spark RB" radio button
    Then I should see the "Spark RB" radio button selected

