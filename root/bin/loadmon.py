#!/usr/bin/python 
import os
import sys
from numpy import *
import time

outfile = '/root/loadmon.dat'
nodes = ['galactica', 'apollo', 'starbuck', 'adama', 'roslin', 'caprica', "gaius", "boomer"]

CPU = []

if '--stat' in sys.argv:
    f = open(outfile, 'r')  

    lines = f.readlines()
    N = len(lines)

    i = 0
    
    days   = []
    months = []
    date   = []
    hour   = []
    min    = []
    sec    = []
    year   = []


    
    apollo   = []
    starbuck = []
    adama    = []
    roslin   = []
    caprica  = []
    
    while i < N:
        line = lines[i]
        
        if 'NEW ENTRY' in line:
            
            if i>0:
                CPU.append(cpu)

            cpu = zeros(len(nodes), 'd')

            i = i+1
            date.append(float(lines[i]))

        else:
            line = line.split()

            if line[0] in nodes:
                cpu[nodes.index(line[0])] = float(line[5])

            
        i = i+1

    CPU.append(cpu)
    CPU = array(CPU)

    if "--print" in sys.argv:
        
        
        n = CPU.shape[0]
        m = CPU.shape[1]

        max_len = 10

        for node in nodes:
            if len(node) > max_len:
                max_len = len(node)
        
        line =  "\t"

        for node in nodes:
            line += "\t" + node

        print line

        for i in range(n):
            
            t = time.gmtime(date[i])
            
            line =  time.strftime('%Y-%m-%d', t)
            line += "\t" + time.strftime('%H:%M:%S', t)

            for j in range(m):
                line += "\t%i" %(CPU[i,j])
                
            print line
                
else:
    
    t0 = time.time()

    file = open(outfile, 'a')
    file.write('NEW ENTRY\n')
    file.write('%.10f\n' %(t0))
    file.close()

    os.system('/usr/local/bin/loadavg >> ' + outfile)

