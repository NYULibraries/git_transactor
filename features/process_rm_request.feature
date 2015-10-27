Feature: process rm-file-request

  As the git_transactor
  I want to process an 'rm-file' request
  So that the file is removed from the repository

  Scenario: rm-file request
    Given that the git repository exists
    And   a source-file directory exists
    And   the request queue exists
    And   the file "pumpkin/pie.txt" exists in the repository
    And   there is an "rm" request for "pumpkin/pie.txt" in the queue
    When  I process the queue
    Then  the file "pumpkin/pie.txt" does not exist in the repository
    And   I should see "Deleting file pumpkin/pie.txt EADID='pie'" in the commit log
