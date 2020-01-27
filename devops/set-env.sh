#!/bin/bash
cd /root/projects/
git clone https://github.com/ravikalla/online-account.git
cd /root/projects/online-account/

# Jenkins Build
cd /root/projects
sudo chmod 777 /var/run/docker.sock
mkdir -p /jenkins_bkp/jenkins_home
chmod -R 777 /jenkins_bkp
git clone https://github.com/ravikalla/online-account.git
cd online-account
git checkout master
cp Dockerfile-Jenkins-Maven ../Dockerfile
cd ..
docker build -t ravikalla/jenkins-maven-docker:v0.1 .

# Jenkins Run
docker run --detach -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):$(which docker) -p 9080:8080 -p 50000:50000 -v /jenkins_bkp/jenkins_home:/var/jenkins_home --name jenkinsfordevops ravikalla/jenkins-maven-docker:v0.1

# Install NGINX
sudo apt update
sudo apt --yes --force-yes install nginx

clear scr
#~/.launch.sh
