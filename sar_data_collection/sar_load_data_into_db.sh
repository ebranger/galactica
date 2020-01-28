#!/bin/bash

# Script to import one compressed SAR data file produced by the script
# 'collect_sar_data.sh' into a SQLite database.

# Author: Peter Jansson
# Date: 2019-07-24

# $1: The SQLite database file.
# $2: The file with compressed SAR data to import into the database.
# $3: The table name to which the data belong (cpu_info or mem_info).

# Filter out lines beginning with a '#'.
tmp=sar_load_data.tmp
bzcat "$2" | grep -v "^#" > $tmp

{
   echo ".mode csv"
   echo ".sep ;"
   echo ".import '$tmp' $3"
} | sqlite3 $1

rm -f $tmp

