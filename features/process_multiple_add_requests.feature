Feature: process multiple add-file requests

  As the git_transactor
  I want to process multiple 'add-file' requests
  So that the files are added to the repository

  Scenario: process multiple add-file requests
    Given that the git repository exists
    And   the request queue exists
    And   a source-file directory exists
    And   a source-file named "foo/bar.txt" exists
    And   the file "foo/bar.txt" does not exist in the repository
    And   there is an "add" request for "foo/bar.txt" in the queue
    And   a source-file named "baz/quux.txt" exists
    And   the file "baz/quux.txt" does not exist in the repository
    And   there is an "add" request for "baz/quux.txt" in the queue
    When  I process the queue
    Then  I should see "foo/bar.txt" in the repository
    And   I should see "baz/quux.txt" in the repository
    And   I should see "Updating file foo/bar.txt, Updating file baz/quux.txt" in the commit log
