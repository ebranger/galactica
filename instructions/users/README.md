# The Galactica cluster
These are instructions for users of the galactica computer cluster.

## Introduction

The Linux cluster Galactica consists of one home node that contains, among other things, the users home directories as well as a number of compute nodes.

You can log in to the home node at `galactica.physcis.uu.se` for light work such as file handling and editing and some matlab. However, it is important that you do not run massively parallel calculations on the home node as that will slow down the entire cluster. Should you do this (by mistake of course) your calculations may be terminated without prior notification. If in doubt, ask first.

For computationally heavy work, please use one of the compute nodes. You can log in to these from galactica using ssh.

The first time you log in, run the command `passwordless`. After you have done this run the program `loadavg` to see which nodes that are currently available and their present workload.

To log in to one of the compute nodes, you may use a shortcut command named the same as the node, e.g. use `adama` to log in to the adama node.

## Priorities

If you are running large jobs in parallel you might want to occupy a whole compute node. However, doing so for an extended time could be problematic as it prevents others from running shorter calculations efficiently. If you have long running calculations (i.e., extending beyond hours), please run these in low priority. This is done with the [nice](https://linux.die.net/man/1/nice) command.

To run e.g. serpent with low priority type: `nice -n 20 sss2 -omp 64 ABR`

