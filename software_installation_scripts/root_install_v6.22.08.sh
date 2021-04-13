#!/bin/bash

V=6.22.08
PREFIX=/usr/local/root_v${V}
ARCHIVE=root_v${V}.source.tar.gz

wget -q https://root.cern/download/${ARCHIVE}
tar xzf ${ARCHIVE}
mkdir build
cd build
cmake ../root-${V} -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_BUILD_TYPE=Release -Dbuiltin_openssl=ON
make
make install
echo ". ${PREFIX}/bin/thisroot.sh" >> /etc/profile.d/root_v${V}.sh
