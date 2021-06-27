#!/bin/bash

# Script to install GEF. Based on instructions at
# http://www.khschmidts-nuclear-web.eu/
# Need a FreeBASIC compiler (fbc).

start_dir=$(pwd)

V=GEF-2021-V1-1

# Download the GEF source code.
wget "http://www.khschmidts-nuclear-web.eu/GEF_code/${V}/Standalone/${V}-source.zip" -O ${V}-source.zip

# Decompress.
unzip ${V}-source.zip

# Build.
cd ${V}
fbc GEF.bas

# Install.
D=/usr/local/${V}
mkdir $D
cp GEF $D/

# Add to users's PATH.
echo "export PATH=\$PATH:$D" >> /etc/profile.d/${V}.sh

cd $start_dir
