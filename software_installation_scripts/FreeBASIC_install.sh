#!/bin/bash

# Script to install FreeBASIC.
# Based mostly on instructions in the readme file supplied by FreeBASIC.

start_dir=$(pwd)

# Install system packages needed by FreeBASIC
yum -y install gcc ncurses-devel ncurses-compat-libs libffi-devel \
               mesa-libGL-devel libX11-devel libXext-devel libXrender-devel \
               libXrandr-devel libXpm-devel

# Get FreeBASIC compiled for Linux from links via https://www.freebasic.net/
wget "https://downloads.sourceforge.net/project/fbc/FreeBASIC-1.07.3/Binaries-Linux/FreeBASIC-1.07.3-linux-x86_64.tar.gz?ts=1618118072&r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Ffbc%2Ffiles%2FFreeBASIC-1.07.3%2FBinaries-Linux%2FFreeBASIC-1.07.3-linux-x86_64.tar.gz%2Fdownload" -O FreeBASIC-1.07.3-linux-x86_64.tar.gz

# Install.
tar xzf FreeBASIC-1.07.3-linux-x86_64.tar.gz
cd FreeBASIC-1.07.3-linux-x86_64
D=/usr/local/FreeBASIC-1.07.3
mkdir $D
./install.sh -i $D

# Add to users's PATH et.c.
echo "export PATH=\$PATH:$D/bin" >> /etc/profile.d/FreeBASIC-1.07.3.sh

cd $start_dir
