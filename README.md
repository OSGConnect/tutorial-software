[title]: - "Software Access Using HTCondor or the Web"


Overview
--------

This tutorial will illustrate how software can be transferred and accessed in OSG Connect. 
It is a hands-on example of the instructions in our [Transferring Software guide](https://support.opensciencegrid.org/support/solutions/articles/5000634395), which 
uses the same mechanisms described in our [general data transfer guides](https://support.opensciencegrid.org/support/solutions/folders/12000013267).  

When using HTCondor to transfer software keep in mind that the *Executable* specified in the submit file is transferred by default. Then remember that you must have execute permission on the software files, and that the `PATH` (folders where executables can be found) may be set differently on the remote host. 

Different methods to access software without transferring it are described in the [Distributed Environment Modules guide](https://support.opensciencegrid.org/support/solutions/articles/12000048518).

Starting Up
-----------

First login to your osgconnect login node. Then, to create a working directory, you can  run `tutorial software`. 

Look around the tutorial directory. We have our input file `random_words`, which 
contains the text we'd like to analyze. We also have a folder called `stats`, which 
has our analysis program inside: 

	[user@login]$ ls -lh stats
	total 40
	-rwxr-xr-x  1 user  user    19K Mar 25 17:18 distribution

To make it easier to transfer our program, we are going to create a `tar.gz` file out 
of the `stats` directory: 

	[user@login]$ tar -czf distribution.tar.gz stats/

We'll also write a shell script to run inside our job (the job's "executable"). In 
the tutorial directory, this is the `words.sh` script. 
This script does two things: unzip our software `tar.gz` file and then run our 
program on the input file: 

	#!/bin/bash

	tar xzf words.tar.gz
	cat random_words | ./distribution


Transferring Software Via HTCondor File Transfer
--------------------------------------------------------------------

Now we're almost ready to submit a job! First, let's try using HTCondor's 
usual file transfer mechanism. Look at the submit file `htcondor-transfer.submit`

	########################
	# Submit description file for short test program
	# using HTCondor file transfer
	########################

	Universe       = vanilla
	Executable     = words.sh
	transfer_input_files = random_words, distribution.tar.gz

	should_transfer_files = YES
	when_to_transfer_output = ON_EXIT

	Error   = log/words.err.$(Cluster)-$(Process)
	Output  = log/words.out.$(Cluster)-$(Process)
	Log     = log/words.log.$(Cluster)

	Queue 1

Note that the `transfer_input_files` line includes both our input file and software `tar.gz` file. 

Submit the job:

	[user@login]$ condor_submit htcondor-transfer.submit
	Submitting job(s).....
	1 job(s) submitted to cluster 14038.

Transferring Software Via HTTP
-------------------------------

Our software `tar.gz` file is pretty small, but sometimes they can be larger. If 
your software files are more than 100MB (and less than 1GB), you should use the 
HTTP method to transfer your software. This requires two things: 

### Put your software in `/public`

In order to transfer your file via HTTP, it needs to be on a public web location, 
which is provided via your `/public` folder. Copy the software there: 

	[user@login]$ ls -al /public/<username>
	...
	[user@login]$ cp distribution.tar.gz /public/<username>/

### Use a link in the submit file

Take a look at `http-transfer.submit`

	########################
	# Submit description file for short test program
	# using http file transfer
	########################

	Universe       = vanilla
	Executable     = words.sh
	transfer_input_files = random_words, https://stash.osgconnect.net/public/username/distribution.tar.gz

	should_transfer_files = YES
	when_to_transfer_output = ON_EXIT

	Error   = log/words.err.$(Cluster)-$(Process)
	Output  = log/words.out.$(Cluster)-$(Process)
	Log     = log/words.log.$(Cluster)

	Queue 1

Note that it has a link for the `tar.gz` file instead of a path. Change the username 
in the link to your own and then submit the job: 

	[user@login]$ condor_submit http-transfer.submit
	Submitting job(s).....
	1 job(s) submitted to cluster 14039.

Completed Jobs
--------------------------------

Once the jobs are completed, you can look at the output in the logs directory and verify that the job ran correctly:

	[user@login tutorial-software]$ cat log/words.out.14038-2
	Ashkenazim |45 (0.44%) +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	BIOS       |45 (0.44%) +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Anaheim    |44 (0.43%) +++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Aymara     |44 (0.43%) +++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Arthurian  |43 (0.42%) ++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Anaxagoras |43 (0.42%) ++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Bactria    |43 (0.42%) ++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Alexis     |43 (0.42%) ++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Ariel      |43 (0.42%) ++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Aubrey     |42 (0.41%) +++++++++++++++++++++++++++++++++++++++++++++++++++++
	Baryshnikov|42 (0.41%) +++++++++++++++++++++++++++++++++++++++++++++++++++++
	Bahia      |42 (0.41%) +++++++++++++++++++++++++++++++++++++++++++++++++++++
	Angstrom   |42 (0.41%) +++++++++++++++++++++++++++++++++++++++++++++++++++++
	Asoka      |42 (0.41%) +++++++++++++++++++++++++++++++++++++++++++++++++++++
	Alcatraz   |41 (0.40%) ++++++++++++++++++++++++++++++++++++++++++++++++++++

## Getting Help

For assistance or questions, please email the OSG User Support team  at `support@opensciencegrid.org` or visit the [help desk and community forums](http://support.opensciencegrid.org).
