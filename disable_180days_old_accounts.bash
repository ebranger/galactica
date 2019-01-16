#!/bin/bash

# Script to disable all accounts that have not logged in in the last 180 days.
# Must be run with superuser privileges.

# Author: Peter Jansson
# Date: 2019-01-16
#

#echo "Users that have not logged in, in the last 180 days:"
not_loggedin_users=$(lastlog -b 180 | tail -n +2 | cut -d ' ' -f 1,1)
#echo $not_loggedin_users

#echo "Users from the home folder:"
home_users=$(ls /home)
#echo $home_users

#echo -n "For each user from the home folder, check if she/he is in the "
#echo "'180 days' list"

for user in $home_users; do
   for user_check in $not_loggedin_users; do
      if [[ "$user_check" = "$user" ]]; then
#         echo "$user is in the list, account is disabled"
         passwd -l $user
         chage -E 0 $user
      fi
   done
done
