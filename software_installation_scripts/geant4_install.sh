#yum install gcc gcc-c++ gcc-gfortran
#yum install cmake
#yum install libXmu
#yum install libXmu-devel
#yum install mesa-libGLw
#yum install mesa-libGLw-devel

export G=geant4.10.03.p01

export GG=Geant4-10.3.1

wget http://geant4.cern.ch/support/source/$G.tar.gz
tar xzf $G.tar.gz
mkdir build
cd build
cmake \
         -DCMAKE_INSTALL_PREFIX=/usr/local/$G \
         -DGEANT4_BUILD_MULTITHREADED=ON \
         -DGEANT4_INSTALL_DATA=ON \
         -DGEANT4_USE_XM=ON \
         -DGEANT4_USE_OPENGL_X11=ON \
         -DGEANT4_USE_RAYTRACER_X11=ON \
         ../$G
make
make install

echo ". /usr/local/$G/bin/geant4.sh" >> /etc/profile.d/$G.sh
echo ". /usr/local/$G/share/$GG/geant4make/geant4make.sh" >> /etc/profile.d/$G.sh

# Installing Geant4Py
export GEANT4_INSTALL=/usr/local/$G
cd ../environments/g4py/
mkdir build
cd build
cmake ..
make
make install

#echo PYTHONPATH=<g4py>/lib64:<g4py>/lib64/examples:<g4py>/lib64/tests  (zsh, bash)
