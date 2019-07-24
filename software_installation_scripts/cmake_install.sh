wget https://github.com/Kitware/CMake/releases/download/v3.15.0/cmake-3.15.0.tar.gz
export P=$(basename cmake-*.tar.gz .tar.gz)
tar xzf $P.tar.gz
cd $P
./configure --prefix=/usr/local/$P
nice make -j 4
make install
echo "export PATH=/usr/local/$P/bin:\$PATH" >> /etc/profile.d/cmake.sh
