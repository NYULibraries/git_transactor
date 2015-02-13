Feature: process rm-file-request

  As the git_transactor
  I want to process an 'rm-file' request
  So that the file is removed from the repository

  Scenario: rm-file request
    Given that the git repository exists
    And   a source-file directory exists
    And   the source-file to be removed exists in the git repository
    And   there is an rm-request for the file
    When  I process the queue
    Then  I should not see the file in the repository
    And   I should see "Deleting file" in the commit log
