if id -nG "$USER" | grep -qw scoobygang ; then
   export PATH=/usr/local/MCNP:$PATH
   export DATAPATH=/usr/local/MCNP/DATA
fi

export PATH=/opt/paraview/bin:$PATH
export LD_LIBRARY_PATH=/opt/paraview/lib:$LD_LIBRARY_PATH

export PATH=/usr/local/openmpi/openmpi-4.0.0/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/openmpi/openmpi-4.0.0/lib:$LD_LIBRARY_PATH

export PYTHONSTARTUP=/usr/local/pythonstartup.py
