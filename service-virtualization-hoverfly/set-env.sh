#!/bin/bash
cd /root/projects
git clone https://github.com/ravikalla/virtualization-katacoda.git
cd /root/projects/virtualization-katacoda/

sudo apt update
sudo apt --yes --force-yes install nginx

clear scr
#~/.launch.sh
