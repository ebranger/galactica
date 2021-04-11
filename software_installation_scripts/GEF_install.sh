#!/bin/bash

# Script to install GEF. Based on instructions at
# http://www.khschmidts-nuclear-web.eu/GEF-2020-1-2.html
# Need a FreeBASIC compiler (fbc).

start_dir=$(pwd)

# Download the GEF source code.
wget "http://www.khschmidts-nuclear-web.eu/GEF_code/GEF-2020-V1-2/Standalone/GEF-2020-V1-2-source.zip" -O GEF-2020-V1-2-source.zip

# Decompress.
unzip GEF-2020-V1-2-source.zip

# Build.
cd GEF-2020-V1-2
fbc GEF.bas

# Install.
D=/usr/local/GEF-2020-V1-2
mkdir $D
cp GEF $D/

# Add to users's PATH.
echo "export PATH=\$PATH:$D" >> /etc/profile.d/GEF-2020-V1-2.sh

cd $start_dir
