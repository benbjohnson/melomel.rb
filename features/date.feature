Feature: Date-Based Controls
  Scenario: Halo Date Chooser
    When I set the "#haloDateChooser" date chooser to "01/01/2010"
    Then I should see the "#haloDateChooser" date chooser set to "01/01/2010"

  Scenario: Halo Date Field
    When I set the "#haloDateField" date field to "01/01/1980"
    Then I should see the "#haloDateField" date field set to "01/01/1980"
