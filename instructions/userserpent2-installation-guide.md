## Guide to installation of Serpent 2 on SNIC HPC

1. Find a suitable SFTP client to move Serpent 2 installation files from Galactica `/usr/local/Serpent2` directory to SNIC user directory. On Unix/MacOS, use Cyberduck or the in-built shell. Windows users may use WinSCP, FileZilla, or something similar.
    - The SCP command should look something like: `scp -r user@server1:/path/to/dir user@server2:/path/to/dir`, where `server1`is `galactica.physics.uu.se` and `server2` is `rackham.uppmax.uu.se` if the user is allocated HPCs on Rackham cluster in Uppmax.


2. Verify the SHA256 checksum value after copying files to ensure all files were copied correctly.
3. Once the requisite files have been moved to Uppmax destination directory, begin the installation process according to: [Serpent2 installation](http://serpent.vtt.fi/mediawiki/index.php/Installing_and_running_Serpent). Steps summarized below:
    1. Extract the installation package from tarball `Serpent2.tar.gz` using `tar -xzf <filename>`.
    2. Serpent 2 is written in C and needs to be compiled using `Make` build tool to compile the code and create the required executables and libraries
    Navigate to the desired installation directory for Serpent 2 (which is also where all the extracted files are) and run the `make` command as indicated below:
    `~/installation-dir$ make`.
    3. The make command is fairly verbose and prints the progress on the prompt. It should look like the snippet below (taken from [SerpentWiki](http://serpent.vtt.fi/mediawiki/index.php/Installing_and_running_Serpent)) and code should compile successfully without errors and print `Serpent 2 Compiled OK.`, and return to prompt.
          ```
          ~/installation-dir$ make
          gcc -Wall -ansi -ffast-math -O3 -DOPEN_MP -fopenmp -Wno-unused-but-set-variable -pedantic -c addbranching.c
          gcc -Wall -ansi -ffast-math -O3 -DOPEN_MP -fopenmp -Wno-unused-but-set-variable -pedantic -c addbuf.c
          gcc -Wall -ansi -ffast-math -O3 -DOPEN_MP -fopenmp -Wno-unused-but-set-variable -pedantic -c addbuf1d.c
          ...
          gcc -Wall -ansi -ffast-math -O3 -DOPEN_MP -fopenmp -Wno-unused-but-set-variable -pedantic -c zaitoiso.c
          gcc -Wall -ansi -ffast-math -O3 -DOPEN_MP -fopenmp -Wno-unused-but-set-variable -pedantic -c zdis.c
          gcc -Wall -ansi -ffast-math -O3 -DOPEN_MP -fopenmp -Wno-unused-but-set-variable -pedantic -c zonecount.c
          gcc addbranching.o addbuf.o addbuf1d.o ... zaitoiso.o zdis.o zonecount.o -lm -fopenmp -lgd -o sss2
          Serpent 2 Compiled OK.
          ~/installation-dir$
          ```
          (`...` in the snippets implies truncated verbose output during command execution).
     4. If everything goes as planned, the `~/installation-dir` should now contain an executable called `sss2`. 
        
  Installation of Serpent 2 is now complete.
  
  ## Guide to installation of updates to Serpent 2 on SNIC HPC
  1. SerpentWiki suggests making a backup before proceeding so we'll do exactly that.  
      ```
      ~/installation-dir$ make bk
      ...
      ~/installation-dir$
      ```
  2. Next step is extracting the update files from the tarball `sssup2.1.31.tar.gz`. Here `1.31` in the filename indicates the update version. The updates are cumulative in nature i.e. update `sssup2.1.X+1.tar.gz` contains all the modifications in update `sssup2.1.X.tar.gz` and earlier.
      ```
      ~/installation-dir$ tar -xzvf sssup2.1.31.tar.gz
      ...
      ~/installation-dir$
      ```
  3. Remove executables after update files have been extracted using `make clean` and recreate them by re-using `make`.
      ```
      ~/installation-dir$ make clean
      ...
      ~/installation-dir$ make
      ...
      ~/installation-dir$
      ```
    
   4. At this point, the user may check the version of the Serpent 2 installation as follows:
      ```
      [user@rackham2 ~]$ sss2 -version

        _                   .-=-.           .-=-.          .-==-.       
       { }      __        .' O o '.       .' O o '.       /  -<' )--<   
       { }    .' O'.     / o .-. O \     / o .-. O \     /  .---`       
       { }   / .-. o\   /O  /   \  o\   /O  /   \  o\   /O /            
        \ `-` /   \ O`-'o  /     \  O`-'o  /     \  O`-`o /             
         `-.-`     '.____.'       `._____.'       `.____.'              

      Serpent 2 beta

      A Continuous-energy Monte Carlo Reactor Physics Burnup Calculation Code

       - Version 2.1.31 (May 16, 2019) -- Contact: serpent@vtt.fi

       - Reference: J. Leppanen, et al. "The Serpent Monte Carlo code: Status,
                    development and applications in 2013." Ann. Nucl. Energy,
                    82 (2015) 142-150.

       - Compiled May 29 2020 02:57:30

       - MPI Parallel calculation mode not available

       - OpenMP Parallel calculation mode available

       - Geometry and mesh plotting available

       - Default data path not set
       
       [user@rackham2 ~]$
       ```
       
       Updates to Serpent 2 installation are now complete.

## Guide to setup of data libraries for Serpent 2 on SNIC HPC 
1. The cross-section libraries available in the Galactica `/usr/local/Serpent2/xsdata` directory are: `jeff31.zip`, `jeff311.zip`, `endfb7.zip`, `endfb68.zip` & `jef22.zip`. To begin set-up of data libraries, extract the files using the following command: `unzip filename.zip`. The guide describes the case for `jeff31`.  

2. Once the library is unzipped, it needs to be formatted correctly so Serpent 2 can read it. Serpent 2 uses continuous-energy cross sections from ACE format data libraries. The file residing in the installation directory is in `xsdir` format which needs to be converted to `xsdata` format using a Perl script [`xsdirconvert.pl`](http://montecarlo.vtt.fi/download/xsdirconvert.pl). We assume that all cross-section files are placed in the `xs-data` directory along with the script:
    ```
    ~/installation-dir/xsdata$ xsdirconvert.pl sss_jeff31u.xsdir > sss_jeff31u.xsdata
    ~/installation-dir/xsdata$
    ```
   __OBS!__ The path inside the `sss_jeff31u.xsdir` file must be set correctly to reflect the installation diretory path else this step will fail and execution of the Perl script will print errors to the screen complaining about cross section files not being found. Enter absolute path under the first line inside `sss_jeff31u.xsdir`: `datapath=/xs/acedata`.

3. Once the cross-section files are in the correct format readable by Serpent 2, the user must provide the path to the data libraries. This step will also make `sss2` a system-wide recognizable command in the shell so the user need not be in the installation folder or provide the full path when the code needs to be run. This can be done as follows:
    ```
    SERPENT_DATA="/path/to/xs-data"
    export SERPENT_DATA

    SERPENT_ACELIB="/path/to/sss_jeff31u.xsdata"
    export SERPENT_ACELIB
    ```
    These commands will update the `$PATH` variable in the `~/.bashrc` file. Needless to say, the commands should be followed by `source ~/.bashrc` command to update the changes in the current user session. If not done, the changes will come into effect in the next user login session.
    
This concludes the Serpent 2 installation, installation of updates, and setting up of data libraries on the SNIC clusters. Good luck!
   
