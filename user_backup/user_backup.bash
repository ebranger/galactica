#!/bin/bash

# function calls pass their result
# into this variable
ret=''

function debugPrint {
  echo debug: $1
}

# getDirsInPeriod
# purpose
#   return the directories in the defined period
#   belonging to a specific chain
# arguments
#   $1  base directory for search
#   $2  chain suffix
#   $3  start date
#   $4  end date 
#
function getDirsInPeriod {
  ret=$(find "$1" -mindepth 1 -maxdepth 1 \
                  -name "*$2" -type d -newermt "$3" \! -newermt "$4") 
}


# getNumberOfDirsInChain
# purpose
#   return the number of directories in 
#   the specified chain
# arguments
#   $1 base directory for search
#   $2 chain suffix
#
function getNumberOfDirsInChain {
  ret=$(find "$1" -mindepth 1 -maxdepth 1 \
                   -name "*$2" -type d -printf . | wc -c)
}


# getNewestDirInChain
# purpose
#   return the newest directory
#   in the specified chain
# arguments
#   $1 base directory for search
#   $2 chain suffix
# 
function getNewestDirInChain {
  ret=$(find "$1" -mindepth 1 -maxdepth 1 \
                  -name "*$2" -type d -printf "%T@ %p\n" \
                  | sort -n | cut -f2 -d' ' | tail -n1 )
}


# getExpiredDirInChain
# purpose
#   return the expired backup dir
#   in the specified chain
# arguments
#   $1 base directory for search
#   $2 chain suffix
#   $3 retention period in min
#
function getExpiredDirInChain {
  ret=$(find "$1" -mindepth 1 -maxdepth 1 \
                  -name "*$2" -type d -mmin "+$3" \
                  | tail -n1 ) 
}


# addBackupToChain
# purpose
#   add a new backup to
#   the specified chain  
# arguments
#   $1 backup directory 
#   $2 chain suffix
#   $3 source directory 
#   
function addBackupToChain {
  ret=''
  getNewestDirInChain "$1" "$2"
  local lastBackupDir="$ret"
  local sourceDir="$3"
  local newBackupDir="$1/$(date +%Y%m%d_%H%M%S)_$2" 
  cp -al "$lastBackupDir" "$newBackupDir"
  rsync -a --delete "$sourceDir/" "$newBackupDir"
  touch "$newBackupDir"
  ret="$newBackupDir"
}


# updateBackupChain
# purpose
#   adds a new backup to the specified chain
#   if sufficient time has passed till last backup
#   and delete expired backup dir 
# arguments
#   $1 backup directory
#   $2 chain suffix
#   $3 source directory
#   $4 interval between backups in mins 
#   $5 retention period in mins 
#
function updateBackupChain {
  local backupRootDir="$1"
  local chain="$2"
  getNewestDirInChain $1 "$chain"    
  local lastBackupDir="$ret"
  local sourceDir="$3"
  local interval="$4"
  local retentionDuration="$5"

  if [[ -z $chain ]]; then
    echo "Name of chain must be specified!"
    exit 1
  fi

  debugPrint "Starting backup routine..."
  debugPrint "# --- info ---" 
  debugPrint "# backup root directory: $backupRootDir"
  debugPrint "# current chain: $chain"
  debugPrint "# last backup in chain: $lastBackupDir" 
  debugPrint "# backup interval: $interval min"
  debugPrint "# backup retention: $retentionDuration min"
  debugPrint "# --- actions ---"

  if test "`find $lastBackupDir -maxdepth 0 -mmin +$interval`" -o \
          -z "$lastBackupDir"; then
    debugPrint "# it's time, creating a new backup..."
    addBackupToChain $1 $2 $3   
    debugPrint "# created the backup dir $ret"
    getExpiredDirInChain $1 $2 $retentionDuration
    local expiredDir="$ret"  
    if [[ ! -z $expiredDir ]]; then
      debugPrint "# deleting expired backup dir $expiredDir"
      if [[ $expiredDir == *$chain ]]; then 
        rm -r "$expiredDir" 
      else
        echo "Something fatal went wrong!"
      fi
    fi
  else
    debugPrint "# last backup is too recent, nothing to do"
  fi
  debugPrint "Returning from backup routine..."
}

