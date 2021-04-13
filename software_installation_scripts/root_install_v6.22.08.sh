#!/bin/bash

V=6.22.08
PREFIX=/usr/local/root_v${V}
ARCHIVE=root_v${V}.source.tar.gz
F=${PREFIX}/bin/thisroot.sh

wget -q https://root.cern/download/${ARCHIVE}
tar xzf ${ARCHIVE}
mkdir build
cd build
cmake ../root-${V} -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_BUILD_TYPE=Release \
&& make \
&& make install \
&& echo "if [ -f ${F} ]; then . ${F}; fi" > /etc/profile.d/root_v${V}.sh
