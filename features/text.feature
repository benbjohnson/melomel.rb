Feature: Text-Based Controls
  ##############################################################################
  # Labels
  ##############################################################################

  Scenario: Halo Label
    Then I should see "John Smith" in the "Halo Name" label

  Scenario: Spark Label
    Then I should see "Susy Que" in the "Spark Name" label


  ##############################################################################
  # Text Fields
  ##############################################################################

  Scenario: Halo Text Field
    When I type "John Smith" in the "#haloTextInput" text field
    Then I should see "John Smith" in the "#haloTextInput" text field

  Scenario: Spark Label
    When I type "John Smith" in the "#sparkTextInput" text field
    Then I should see "John Smith" in the "#sparkTextInput" text field


  ##############################################################################
  # Text Fields
  ##############################################################################

  Scenario: Halo Text Area
    When I type "John Smith" in the "#haloTextArea" text area
    Then I should see "John Smith" in the "#haloTextArea" text area

  Scenario: Spark Label
    When I type "John Smith" in the "#sparkTextArea" text area
    Then I should see "John Smith" in the "#sparkTextArea" text area
