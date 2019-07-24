#!/usr/bin/python 
import os
import sys
import socket

# Parse arguments
# -----------------

if '-y' in sys.argv:
    yes = True
else:
    yes = False

if '--erase' in sys.argv:
    erase = True
else:
    erase = False

if '--remote' in sys.argv:
    remote_IP = sys.argv[sys.argv.index("--remote") + 1]
else:
    remote_IP = "192.168.1.100"

if '--silent' in sys.argv:
    silent = True
else:
    silent = False


# Setup
# ------

host = socket.gethostname()


# Read installed packages
# -------------------------
if not silent:
    print 'ssh %s yum info > _yum_remote' %(remote_IP)

os.system('ssh %s yum info > _yum_remote' %(remote_IP))
os.system('yum info > _yum_local')

remote_file = open('_yum_remote')
local_file = open('_yum_local')

remote = remote_file.readlines()
local = local_file.readlines()

remote_file.close()
local_file.close()

os.system('rm _yum_remote')
os.system('rm _yum_local')

remote_installed = []
remote_repos = []

local_installed = []
local_repos = []
local_available = []

i = 0

while i<len(remote):
    l = remote[i].split()

    if len(l) > 0:
       
        if l[0] == 'Name':
            name = l[2]

            while l[0] != 'Repo':
                i = i + 1
                l = remote[i]
                l = l.split()

            if l[2] == 'installed': 
                remote_installed.append(name)
           
    i = i+1

i = 0 

while i<len(local):
    l = local[i].split()

    if len(l) > 0:
       
        if l[0] == 'Name':
            name = l[2]

            local_available.append(name)

            while l[0] != 'Repo':
                i = i + 1
                l = local[i]
                l = l.split()

            if l[2] == 'installed': 
                local_installed.append(name)
            
    i = i+1

# Install packages
# -----------------

if yes:
    command = 'yum -y -C install '
else:
    command = 'yum -C install'

n_install = 0

for package in remote_installed:
    if (not ( package in local_installed)) and (package in local_available):
        command = command + ' ' +  package
        n_install = n_install+1

if n_install > 0:
    os.system(command)
elif not silent:
    print 'nothing to be installed on ' + host


# Remove packages
# ----------------

if erase:

    n_erase = 0
    
    if yes:
        command = 'yum -y erase '
    else:
        command = 'yum erase'

    for package in local_installed:
        if not ( package in remote_installed):
            command = command + ' ' +  package
            n_erase = n_erase + 1
            
    if n_erase > 0:
        os.system(command)
    elif not silent:
        print 'nothing to be erased on ' + host
