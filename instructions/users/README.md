# The Galactica cluster
These are instructions for users of the galactica computer cluster.

## Introduction

The Linux cluster Galactica consists of one home node that contains, among other things, the users home directories as well as a number of compute nodes.

You can log in to the home node at `galactica.physics.uu.se` for light work such as file handling and editing and some matlab. However, it is important that you do not run massively parallel calculations on the home node as that will slow down the entire cluster. Should you do this (by mistake of course) your calculations may be terminated without prior notification. If in doubt, ask first.

The first time you log in, run the command `passwordless`. After you have done this run the program `loadavg` to see which nodes that are currently available and their present workload.

Use ssh to log in to one of the compute nodes, e.g. `ssh adama`to log in to the adama node. There is also a shortcut command named the same as the node, e.g. use `adama` to to log in to the adama node.

Please log in to the home node (`galactica`) at least once every 180 day in order to prevent your account from being locked. For this login, you need to use ssh (e.g. [`ssh`](https://linux.die.net/man/1/ssh) on Mac and Linux or [`putty`](https://www.putty.org/) on Windows) and not Fast-X.

## Usage

For computationally heavy work, please use one of the compute nodes.

The cluster is sensitive to heavy disc I/O on the /home folder, so please consider rate limiting your reading/writing from/to files at /home. One way to do that is to `cd` into a directory created by [`mktemp -d`](https://linux.die.net/man/1/mktemp), save your output there and copying it to your home folder when your'e done with your job. As a bonus, I/O to/from your job will be faster since the physical disc used for temporary files is mounted on the compute node itself.

To save on the limited disc space, try to not store files at galactica that you don't need for your current application/work/calculation.

Some plots of CPU and RAM usage of the cluster over time is available in the `/usage` directory on the login node.

### Background calculations

There are some options available for executing calculation jobs on one of the nodes while not being logged-in:

* Schedule your calculation script using [cron](https://linux.die.net/man/5/crontab). An introduction to using cron scheduling is [available here](https://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/).
* Start a terminal multiplexer in a terminal and run your program in that session before detaching from it. Later, you can (re-)attach to the same session in the same or any other terminal window on the same node. We have the [tmux](https://linux.die.net/man/1/tmux) and [screen](https://linux.die.net/man/1/screen) terminal multiplexer programs installed. One source of information on how to use tmux is [available here](https://github.com/tmux/tmux/wiki) and for screen, a user manual is [available here](https://www.gnu.org/software/screen/manual/screen.html).
* Run your your script in the background and detached from the terminal, using [nohup](https://linux.die.net/man/1/nohup).

## Priorities

If you are running large jobs in parallel you might want to occupy a whole compute node. However, doing so for an extended time could be problematic as it prevents others from running shorter calculations efficiently. If you have long running calculations (i.e., extending beyond hours), please run these in low priority. This is done with the [nice](https://linux.die.net/man/1/nice) command.

To run e.g. serpent with low priority type: `nice -n 19 sss2 -omp 64 ABR`
