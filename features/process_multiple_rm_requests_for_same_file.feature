Feature: process multiple rm-file requests

  As the git_transactor
  I want to process multiple 'rm-file' requests
  So that the files are removed from the repository

  Scenario: process multiple rm-file requests
    Given that the git repository exists
    And   a source-file directory exists
    And   the request queue exists
    And   the file "foo/bar.txt" exists in the repository
    And   the file "baz/quux.txt" exists in the repository
    And   there is an "rm" request for "foo/bar.txt" in the queue
    And   there is an "rm" request for "baz/quux.txt" in the queue
    And   there is an "rm" request for "foo/bar.txt" in the queue
    When  I process the queue
    Then  the file "foo/bar.txt" does not exist in the repository
    And   the file "baz/quux.txt" does not exist in the repository
    And   I should see "Deleting file foo/bar.txt EADID='bar', Deleting file baz/quux.txt EADID='quux'" in the commit log
