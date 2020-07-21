#!/bin/bash

# Script to be called regularly to produce compressed SAR data.
# Two files are generated in $1; one with CPU usage info and one with memory
# usage info.
# The files will be named with a second-precision time stamp and hostname.

# Author: Peter Jansson
# Date: 2019-07-24

# $1: The directory where files will be saved.

f=$(date -u +%Y%m%dT%H%M%SZ)-$(hostname)
mkdir -p "$1"
sadf -d > "$1/$f-cpu.csv"
sadf -d -- -r > "$1/$f-mem.csv"
bzip2 "$1/$f-cpu.csv" "$1/$f-mem.csv"

