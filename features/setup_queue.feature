Feature: set up queue structure

  As a User
  I want to setup the queue directory
  So that I can run the git_transactor

  Scenario: setup the queue
    Given that a parent directory exists
    And   that directory is writable by the current process
    When  I setup the queue
    Then  I should be able to use the queue
