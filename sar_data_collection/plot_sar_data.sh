#!/bin/bash
#
# Script to collect and plot SAR data.
#
# Author: Peter Jansson
#
#
# DIR specifies where this script is located.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
# Setup database
DB=tmp_sar_data.db
rm -f $DB
sqlite3 $DB < sar_db_setup.sql
# Collect data (that was gathered via Cron) from the compute nodes.
DD=~/sar_data
/opt/c3-5/cexec rsync -a ~/sar_data/ galactica:$DD/
# Populate database with data
./sar_load_all_data_into_db.sh $DB $DD
# Plot data
python plot_sar_data.py $DB
# Move plots to a user-readable directory.
mkdir -p -m a+r /usage
mv -f *.svg /usage
# Cleanup
rm -f $DB
