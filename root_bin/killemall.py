#!/usr/bin/python
from numpy import *

import os
import sys
import pickle


os.system('top -b -n 1 > out')
Top = open('out')
Top = Top.readlines()
os.system('rm out')

if len(Top) > 0:

    i = 0

    while True:
        top = Top[i].split()

        if len(top) > 0:
            i = i+1
            continue

        else:
            i = i+1
            break


    header = Top[i].split()

    CPU  = []
    USER = []
    NICE = []
    PID  = []
    TIME = []

    i_nice = header.index('NI')
    i_user = header.index('USER')
    i_cpu  = header.index('%CPU')
    i_pid  = header.index('PID')
    i_time = header.index('TIME+')

    for j in range(i+1,len(Top)):

        if len(Top[j]) > 5:
            top = Top[j]
            top = top.replace(',', '.')
            top = top.split()
        else:
            continue

        cpu  = float(top[i_cpu])
        nice = float(top[i_nice])
        pid  = int(top[i_pid])
        user = top[i_user]
        time = top[i_time]

        CPU.append(cpu)
        NICE.append(nice)
        USER.append(user)
        PID.append(pid)
        TIME.append(time)

    CPU = array(CPU)
    NICE = array(NICE)
    USER = array(USER)
    PID  = array(PID)
    #TIME = array(TIME)

    tot_cpu = sum(CPU)
    users = unique(USER)

    home_users = os.listdir('/home')


    if 'killemall.log' in os.listdir('/root/'):
        over_users = pickle.load(open('/root/killemall.log'))
    else:
        over_users = {}

    new_over_users = []

    for user in users:

        if user not in home_users:
            continue

        i = where(USER == user)

        cpu = CPU[i].sum()

        if cpu < 500.0:
            continue

        new_over_users.append(user)

        if user in over_users.keys():
            over_users[user] += 1
        else:
            over_users[user] = 1

    for user in over_users.keys():
        if user not in new_over_users:
            del over_users[user]

    file = open('/root/killemall.log', 'w')
    pickle.dump(over_users, file)
    file.close()
