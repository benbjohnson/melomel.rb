Feature: Alert
  Scenario: Click an alert button
    When I click the "Show Alert" button
    And I click the "OK" button on the alert
    Then the status should be "ok"

  Scenario: See the alert
    When I click the "Show Alert" button
    Then I should see an alert
    And I should see an alert with the title: "My Alert"
    And I should see an alert with the message: "You have been alerted."
    And I should see an alert with the following message:
      """
      You have been alerted.
      """
    And I click the "Cancel" button on the alert
