Feature: pull from remote repository to local repository

  As the git_transactor
  I want to pull from the remote repository to the local repository
  So that the local repository is up to date before performing any modifications

  Scenario: pull from the remote repository to the local repository
    Given that the remote repository exists
    And   that the local repository exists and was cloned from the remote repository
    And   the remote repository has changes that the local repository does not
    When  I pull the remote repository to the local repository
    Then  the local repository and the remote repository should be in the same state

