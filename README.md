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
in development


## Execution Overview

When the script executes, it checks for "queue entry files" in the
`work/queue/` directory.

If the `work/queue/` directory is empty the script simply terminates with
an exit status of `0`.

If the `work/queue/` directory is not empty, the script processes each
queue entry file in the order of the queue entry filenames from lowest
to highest, committing each change to the local repository.

If a commit is successful, the queue entry file is moved to the
`work/passed/` subdirectory.

If a commit fails, the queue entry file is moved to the `work/failed`
subdirectory.

After all commits have been made to the local repository, the updated
local repository is pushed to the remote repository.

Upon a successful push to the remote repository, the script terminates
with an exit status of `0`.

If any error occurred during processing queue entries, or on the push
to the remote repo, the script terminates with an exit status of `1`.


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
