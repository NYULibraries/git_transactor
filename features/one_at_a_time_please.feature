Feature: Prevent multiple processes from operating on same data

  As a User
  I want to ensure that only one GitTransactor::Processor is working on a queue at a time
  So that the queue state is not corrupted

  Scenario: Multiple processes try to process and push the same queue structure
    Given that the git repository exists
    And   the request queue exists
    And   a source-file directory exists
    And   the request queue is locked by another process
    When  I try to run rake "git_transactor:process_and_push"
    Then  "GitTransactor::LockError: Queue is already in use." should be output to "stderr"
    And   the exit status should be "1"
