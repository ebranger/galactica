if id -nG "$USER" | grep -qw MCNP6.2 ; then
   ##### DISPLAY, for plotting
   export DISPLAY
   DISPLAY=":0.0"

   ##### path for mcnp620
   export PATH
   PATH="/usr/local/mcnp6.2/MCNP_CODE/bin:$PATH"

   ##### path for data   
   export DATAPATH
   DATAPATH="/usr/local/mcnp6.2/MCNP_DATA"

   ##### path for data   
   export ISCDATA
   ISCDATA="/usr/local/mcnp6.2/MCNP_CODE/MCNP620/Utilities/ISC/data"

   ulimit -s unlimited
fi
