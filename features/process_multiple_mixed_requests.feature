Feature: process multiple add-file and rm-file requests

  As the git_transactor
  I want to process multiple 'add-file' and 'rm-file' requests
  So that the files are added to and removed from the repository

  Scenario: process multiple add-file and rm-file requests
    Given that the git repository exists
    And   the request queue exists
    And   a source-file directory exists
    And   a source-file named "foo/bar.txt" exists
    And   a source-file named "baz/quux.txt" exists
    And   the file "circle/square.txt" exists in the repository
    And   the file "triangle/rhombus.txt" exists in the repository
    And   there is an "add" request for "foo/bar.txt" in the queue
    And   there is an "rm" request for "circle/square.txt" in the queue
    And   there is an "add" request for "baz/quux.txt" in the queue
    And   there is an "rm" request for "triangle/rhombus.txt" in the queue
    When  I process the queue
    Then  I should see "foo/bar.txt" in the repository
    And   the file "circle/square.txt" does not exist in the repository
    And   I should see "baz/quux.txt" in the repository
    And   the file "triangle/rhombus.txt" does not exist in the repository
    And   I should see "Updating file foo/bar.txt, Deleting file circle/square.txt, Updating file baz/quux.txt, Deleting file triangle/rhombus.txt" in the commit log
