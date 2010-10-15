Feature: Waiting For Busy Application
  Scenario: Wait Until Cursor is Not Busy
    When I click the "Wait!" button
    Then the status should be "done waiting!"
