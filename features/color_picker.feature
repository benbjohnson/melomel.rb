Feature: Color Picker
  Scenario: Set the color
    When I set the "My Picker" color picker to "#FF0000"
    Then I should see the "#haloColorPicker" color picker set to "#FF0000"
