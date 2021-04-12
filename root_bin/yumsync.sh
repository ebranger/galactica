#!/bin/bash
ssh -fNM -D 1080 galactica
/root/git_wdir/galactica/root_bin/yumsync.py -y --erase --silent --remote galactica
ssh -q -O exit galactica
