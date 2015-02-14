Feature: process multiple add-file requests

  As the git_transactor
  I want to process multiple 'add-file' requests
  So that the files are added to the repository

  Scenario: process multiple add-file requests
    Given that the git repository exists
    And   a source-file directory exists
    And   there is a request queue
    And   the file "foo/bar.txt" exists in the repo
    And   the file "baz/quux.txt" exists in the repo
    And   there is an "rm" request for "foo/bar.txt" in the queue
    And   there is an "rm" request for "baz/quux.txt" in the queue
    When  I process the queue
    Then  the file "foo/bar.txt" does not exist in the repo
    And   the file "baz/quux.txt" does not exist in the repo
    And   I should see "Deleting file foo/bar.txt, Deleting file baz/quux.txt" in the commit log
