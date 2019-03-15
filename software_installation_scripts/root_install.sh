#yum install mesa-libGLU mesa-libGLU-devel

wget https://root.cern.ch/download/root_v6.08.04.source.tar.gz
tar xzf root_v6.08.04.source.tar.gz
mkdir build
cd build
cmake ../root-6.08.04/ -DCMAKE_INSTALL_PREFIX=/usr/local/root_v6.08.04 -DCMAKE_BUILD_TYPE=Release -Droofit=ON
nice make -j 4
make install
echo ". /usr/local/root_v6.08.04/bin/thisroot.sh" >> /etc/profile.d/root.sh
