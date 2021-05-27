#!/bin/bash

# $1 : Directory where the compressed Serpent2 distribution files are located.
# $2 : Directory where Serpent2 will be installed.

# $1 is expected to contain the following files:
# sha256sum.txt
# Serpent2.tar.gz
# sssup2.1.32.tar.gz
# photon_data.zip
# xsdata/endfb68.zip
# xsdata/endfb7.zip
# xsdata/jef22.zip
# xsdata/jeff31.zip
# xsdata/jeff311.zip


# Check checksums to ensure file intergrity.
cd $1
sha256sum --quiet -c sha256sum.txt

mkdir -p $2
cd $2

# Extract and build latest update.
tar -xzf $1/Serpent2.tar.gz
tar -xzf --overwrite $1/sssup2.1.32.tar.gz
make clean
make
rm -f *.c *.h *.o versions.txt Makefile

# Install nuclear data.
mkdir -p xsdata
cd xsdata
XSCON=xsdirconvert.pl
curl -LsS http://montecarlo.vtt.fi/download/$XSCON -o $XSCON
chmod a+x $XSCON
mkdir -p photon_data
cd photon_data
unzip -qq $1/photon_data.zip
cd ..
for f in endfb68.zip endfb7.zip jef22.zip jeff31.zip jeff311.zip; do
   D=$(basename $f .zip)
   mkdir -p $D
   cd $D
   unzip -qq $1/xsdata/$f
   for f in *.xsdir; do
      sed -i -e "s+datapath=/xs/acedata+datapath=$2/xsdata/$D/acedata+g" $f
      ../$XSCON $f > ../$(basename $f .xsdir).xsdata
   done
   cd ..
done

# Setup PATH's et.c.
S=serpent-2.1.32.sh
( cat << __EOF__
export PATH=\$PATH:$2
export SERPENT_DATA=$2/xsdata
export SERPENT_ACELIB=sss_endfb7u.xsdata
__EOF__
) > $S
chmod a+x $S
