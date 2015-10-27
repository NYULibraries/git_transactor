Feature: pull from remote repo, process queue, and push using a Rake task

  As a User
  I want to use a Rake task to
    update the local repository using a pull operation then
    process the queue and
    push any changes back to the remote repository
  So that all additions and deletions are
    applied to a current version of the repository
    and are reflected in the remote repository

  Scenario: process queue and push using Rake task
    Given that the remote repository exists
    And   that the local repository exists and was cloned from the remote repository
    And   the remote repository has changes that the local repository does not
    And   that a queue parent directory exists
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
    When  I execute the pull, process, and push Rake task
    Then  I should see "foo/bar.txt" in the repository
    And   I should see "baz/quux.txt" in the repository
    And   I should see "Updating file foo/bar.txt, Deleting file circle/square.txt EADID='square', Updating file baz/quux.txt, Deleting file triangle/rhombus.txt EADID='rhombus'" in the commit log
    And   the local repository and the remote repository should be in the same state
