## Cluster administration hints

### Reboot
The home drive of users at the compute nodes are [NFS](https://linux.die.net/man/5/nfs) mounted on the login node.
Therefore it is advisable to let the login node boot first and then let the compute nodes follow, in order to have the NFS “master” already online when the compute nodes wants /home to be mounted.

### User management
The bash script `new_galactica_user` can be convenient when creating new users for the cluster.
Remember to run the bash script `galactify` to propagate new users and their login credentials to the compute node, or wait until it has run on its schedule.
