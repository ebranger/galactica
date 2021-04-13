#!/bin/bash

#yum install mesa-libGLU mesa-libGLU-devel

V=6.22.08
PREFIX=/usr/local/root_v${V}
ARCHIVE=root_v${V}.source.tar.gz

wget https://root.cern/download/${ARCHIVE}
tar xzf ${ARCHIVE}
mkdir build
cd build
cmake ../root-${V}/ -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_BUILD_TYPE=Release -Droofit=ON
make -j
make install
echo ". ${PREFIX}/bin/thisroot.sh" >> /etc/profile.d/root_v${V}.sh
