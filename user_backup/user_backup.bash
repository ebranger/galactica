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
                  -printf "%T@ %p\n" | sort -n \
                  | cut -f2 -d' ' | head -n1 ) 
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
#   $3 interval between backups in mins 
#   $4 retention period in mins 
#   $5 source directory
#
function updateBackupChain {
  local backupRootDir="$1"
  local chain="$2"
  getNewestDirInChain $backupRootDir "$chain"    
  local lastBackupDir="$ret"
  local interval="$3"
  local retentionDuration="$4"
  local sourceDir="$5"

  if [[ -z $chain ]]; then
    echo "Name of chain must be specified!"
    exit 1
  fi

  local backupCreationTime="$(date -d "$(stat -c %y "$lastBackupDir")" +"%Y-%m-%d %H:%M:%S")"
  debugPrint "`date +\"%Y-%m-%d %H:%M:%S\"`"
  debugPrint "Starting backup routine..."
  debugPrint "# --- info ---" 
  debugPrint "# backup root directory: $backupRootDir"
  debugPrint "# current chain: $chain"
  debugPrint "# last backup in chain: $lastBackupDir" 
  debugPrint "# created on: $backupCreationTime"
  debugPrint "# backup interval: $interval min"
  debugPrint "# backup retention: $retentionDuration min"
  debugPrint "# --- actions ---"

  if test "`find $lastBackupDir -maxdepth 0 -mmin +$interval`" -o \
          -z "$lastBackupDir"; then
    debugPrint "# it's time, creating a new backup..."
    addBackupToChain $backupRootDir $chain $sourceDir   
    debugPrint "# created the backup dir $ret"
    getExpiredDirInChain $backupRootDir $chain $retentionDuration
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


# main routine
# purpose
#   perform an action according to arguments passed
#   and show a help screen if arguments are invalid
# arguments
#   depending on the subroutine
#   if invalid arguments are passed
#   a help screen with the correct syntax
#   will be printed
#   
function main { 
  if [ "$1" = "backup" ]; then
    local backupDir="$2"
    local chain="$3"
    local interval_day="$4"
    local retention_day="$5"
    local sourceDir="$6"

    # sanity checks
    numRex='^[0-9]+([.][0-9]+)?$'
    chainRex='^[0-9a-zA-Z]+$'
    if [ ! -d "$backupDir" ]; then
      echo "specified backup directory '$backupDir' does not exist!"
      exit 1
    elif [ ! -d "$sourceDir" ]; then
      echo "specified source directory '$sourceDir' does not exist!"
      exit 1
    elif ! [[ $chain =~ $chainRex ]]; then
      echo "specified chain name is invalid, only letters and digits are allowed!"
      exit 1
    elif ! [[ $interval_day =~ $numRex ]]; then
      echo "specified interval is not a valid number!"
      exit 1
    elif ! [[ $retention_day =~ $numRex ]]; then
      echo "specified retention duration is not a valid number!"
      exit 1 
    fi

    # internally work with minutes instead of days
    local interval_min=`awk -v x="$interval_day" 'BEGIN {printf "%.0f", (x * 24*60)}'`
    local retention_min=`awk -v x="$retention_day" 'BEGIN {printf "%.0f", (x * 24*60)}'`

    echo "interval in days: $interval_day"
    echo "interval in min: $interval_min"
    echo "backupdir: $backupDir"
    echo "chain: $chain"
    echo "retention: $retention_min"
    echo "sourcedir: $sourceDir"

    updateBackupChain "$backupDir" "$chain" "$interval_min" "$retention_min" "$sourceDir" 

  else
    echo
    echo "user_backup.bash backup {backupdir} {chain} {interval} {retention} {sourcedir}"
    echo 
    echo "{backupdir}      the directory to store the backups"
    echo "{chain}          the name of the chain to update"
    echo "{interval}       interval between consecutive backups in days"
    echo "{retention}      retention time of backups in days"
    echo "{sourcedir}      the directory that should be backed up"
  fi
}

# call the main function
main "$@"

