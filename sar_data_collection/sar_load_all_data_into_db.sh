#!/bin/bash

# Script to search for compressed SAR data files produced by the script
# 'collect_sar_data.sh', and import them into a SQLite database using the
# script 'sar_load_data_into_db.sh'.

# Author: Peter Jansson
# Date: 2019-07-24

# $1: The SQLite database file.
# $2: The directory containing SAR data to import to the database.

PATH=$PATH:./

find "$2" -type f -name '*-cpu.csv.bz2' \
    -exec sar_load_data_into_db.sh "$1" {} cpu_info \;
find "$2" -type f -name '*-mem.csv.bz2' \
    -exec sar_load_data_into_db.sh "$1" {} mem_info \;
