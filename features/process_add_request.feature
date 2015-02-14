Feature: process add-file-request

  As the git_transactor
  I want to process an 'add-file' request
  So that the file is added to the repository

  Scenario: add-file request
    Given that the git repository exists
    And   the request queue exists
    And   a source-file directory exists
    And   a source-file named "apple/peaches.txt" exists
    And   the file "apple/peaches.txt" does not exist in the repository
    And   there is an "add" request for "apple/peaches.txt" in the queue
    When  I process the queue
    Then  I should see "apple/peaches.txt" in the repository
    And   I should see "Updating file apple/peaches.txt" in the commit log
