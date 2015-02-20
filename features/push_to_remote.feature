Feature: push local repository to remote repository

  As the git_transactor
  I want to push the local repository to the remote repository
  So that other systems can act on the changes

  Scenario: push the local repository to the remote repository
    Given that the remote repository exists
    And   that the local repository exists and was cloned from the remote repository
    And   the local repository has changes that the remote repository does not
    When  I push the local repository to the remote repository
    Then  the local repository and the remote repository should be in the same state

