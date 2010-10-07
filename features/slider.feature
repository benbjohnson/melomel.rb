Feature: Slider Controls
  Scenario: Halo Horizontal Slider
    When I set the "#haloHSlider" slider to "12"
    Then I should see the "#haloHSlider" slider set to "12"

  Scenario: Halo Vertical Slider
    When I set the "#haloVSlider" slider to "10.2"
    Then I should see the "#haloVSlider" slider set to "10.2"

  Scenario: Spark Horizontal Slider
    When I set the "#sparkHSlider" slider to "12"
    Then I should see the "#sparkHSlider" slider set to "12"

  Scenario: Spark Vertical Slider
    When I set the "#sparkVSlider" slider to "80"
    Then I should see the "#sparkVSlider" slider set to "80"

  Scenario: Set above limit
    When I set the "#haloHSlider" slider to "200"
    Then I should see the "#haloHSlider" slider set to "100"
