#!/bin/bash

O=octave-5.2.0

wget https://ftp.acc.umu.se/mirror/gnu.org/gnu/octave/$O.tar.gz
tar xzf $O.tar.gz
cd $O
./configure --prefix=/usr/local/$O --disable-readline
make CFLAGS=-O CXXFLAGS=-O LDFLAGS=
make install
