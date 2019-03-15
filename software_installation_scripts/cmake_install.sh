export P=cmake-3.7.2
wget https://cmake.org/files/v3.7/$P.tar.gz
tar xzf $P.tar.gz
cd $P
./configure --prefix=/usr/local/$P
nice make -j 4
make install
echo "export PATH=/usr/local/$P/bin:\$PATH" >> /etc/profile.d/cmake.sh
