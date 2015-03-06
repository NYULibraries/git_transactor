Feature: set up queue structure using a Rake task

  As a User
  I want to setup the queue directory using a Rake task
  So that I can run the git_transactor

  Scenario: setup the queue
    Given that a queue parent directory exists
    When  I setup the queue
    Then  I should be able to use the queue
