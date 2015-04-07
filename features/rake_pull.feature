Feature: pull from the remote repository to the local repository using a Rake task

  As a User
  I want to use a Rake task to pull from the remote repository to the local repository
  So that the local repository is up to date before performing any modifications

  Scenario: pull from the remote repository to the local repository using Rake task
    Given that the remote repository exists
    And   that the local repository exists and was cloned from the remote repository
    And   that a queue parent directory exists
    And   the request queue exists
    And   a source-file directory exists
    And   the remote repository has changes that the local repository does not
    When  I execute the pull Rake task
    Then  the local repository and the remote repository should be in the same state
