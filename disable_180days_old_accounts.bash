#!/bin/bash

limit_days=180

# Script to disable all user accounts that have not logged in
# in the last $limit_days days.
# Must be run with superuser privileges.
# Users that have a folder in /home AND that have not logged in according to
# both 'lastlog' AND 'last' will be disabled.

# Author: Peter Jansson
# Date: 2019-02-12

# To re-enable a user login, run the following commands:
#  passwd -u LOGIN
#  chage -E -1 LOGIN

# Function to disable a user login specified by $1.
disable() {
  passwd -l $1 \
    | grep -v "passwd: Success" \
    | grep -v "Locking password for user ";
  chage -E 0 $1;
  echo "$1 was disabled due to account inactivity";
}

limit_stamp=$(date -d "now - $limit_days days" +%s)
lastlog_list=$(lastlog -b $limit_days | tail -n +2 | cut -d ' ' -f 1,1)

for user in $(ls /home); do
  for lastlog_user in $lastlog_list; do
    if [[ "$lastlog_user" = "$user" ]]; then
      if [ $(last $user | wc -l) -ge 3 ]; then
        # Have > 0 entries in the 'last' list.
        last_stamp=$(date -d "$(last -FR $user | head -1 |cut -c 23-46)" +%s)
        if [ $limit_stamp -ge $last_stamp ]; then
          disable $user
        fi
      else
        # The 'last' list is empty, assume no recent login.
        disable $user
      fi
    fi
  done
done
