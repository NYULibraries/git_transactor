git_transactor
==============

## Overview

This code performs a series of `git add` and `git rm` transactions on
a local repository, and then pushes the updates to a remote
repository.


## Preconditions

* A git client is installed on the system.
* The user running the script has write privileges
  on both the local and remote repositories.
* The user running the script has read privileges on files being added
  to the local repository.


## Status
in production


## Available Functionality

`rake` is used to execute `git_transactor` tasks.
```
rake git_transactor:process_and_push   # Process entries in queue and push to remote
rake git_transactor:pull               # Pull from remote repository to local repository
rake git_transactor:pull_process_push  # Pull from remote repository, process queue, and push back to remote repository
rake git_transactor:push               # Push from local repository to remote repository
rake git_transactor:setup:queue        # Initialize queue structure in QUEUE_ROOT directory
```

The following environment variables must be set when running a `git_transactor`
`rake` task:

```
GT_LOCAL_REPO       # the path to the local EAD repository
GT_SOURCE_PATH      # the path to the directory from which to copy EAD files
GT_QUEUE_ROOT       # the path to the Git Transactor queue directory structure created via
                    #   rake git_transactor:setup_queue task
GT_REMOTE_REPO_URL  # the remote repository URL

e.g.,
rake git_transactor:pull_process_push LOCAL_REPO='./super_duper_files' \
  SOURCE_PATH='/path/to/source/files' QUEUE_ROOT='/path/to/queue/root' \
  REMOTE_REPO_URL='git@github.com:example/super_duper_files.git'
```


## `pull_process_push` execution overview

1. as the name implies, the task first executes a `pull` to synchronize the local repo with the remote repository
2. then, a `process_queue` operation is executed. `process_queue` operation does the following:
  * checks for "queue entry files" in `QUEUE_ROOT/queue` directory
  * if the `QUEUE_ROOT/queue` directory is empty the script simply terminates with an exit status of `0`
  * if the `QUEUE_ROOT/queue` directory is not empty, the script processes each queue entry file in the order of the queue entry filenames, from lowest to highest.
  * if a request is processed successfully, the queue entry file is moved to the `QUEUE_ROOT/passed/` subdirectory
  * if a request is processed unsuccessfully, the queue entry file is moved to the `QUEUE_ROOT/failed/` subdirectory.
  * after all queue entry files, the changes are committed to the local repository
3. the task next executes a `push` operation to synchronize the remote repository with the local repository


## Queue Entry Files

Each queue entry file is named per the following template:
```
<YYYYMMDDTHHMMSSNNNNNNNNN.csv>, where:
  * YYYY = current year
  * MM   = current month,  zero-padded, range: 01-12
  * DD   = current day,    zero-padded  range: 01-31
  * T    = literal character T used as date/time delimiter
  * HH   = current hour,   zero-padded  range: 00-23 (note 24-hour format)
  * MM   = current minute, zero-padded, range: 00-59
  * SS   = current second, zero-padded, range: 00-59
  * NNNNNNNNN = current nanosecond, zero-padded, range: 000000000-999999999
  e.g., 20150227T113018273091611.csv
```
A queue-entry file contains a single line of comma-separated values
that conform to the following template:

`<command>,<absolute path to file being managed>`  
`<command>` must be either `add` or `rm`
