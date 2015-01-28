Feature: process add-file-request

  As the git_transactor
  I want to process an 'add-file' request
  So that the file is added to the repository

  Scenario: add-file request
    Given that the file does not exist in the repository
    And there is an add-request for the file
    When I process the add-request
    Then I should see the file in the repository
    And I should see "Updating file" in the commit log
