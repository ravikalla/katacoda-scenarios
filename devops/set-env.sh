#!/bin/bash
cd /root/projects/
git clone https://github.com/ravikalla/online-account.git
cd /root/projects/online-account/

sudo apt update
sudo apt --yes --force-yes install nginx

clear scr
#~/.launch.sh
