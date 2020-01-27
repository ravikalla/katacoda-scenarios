ssh root@host01 "mkdir /root/projects"
ssh root@host01 "chmod 777 /root/projects"
ssh root@host01 "cd /root/projects"

ssh root@host01 "yum install tree -y"

ssh root@host01 "mkdir -p /root/projects/temp1"
ssh root@host01 "chcon -R -t svirt_sandbox_file_t /root/projects/temp1"
ssh root@host01 "restorecon -R /root/projects/temp1"
ssh root@host01 "chmod 777 /root/projects/temp1"

ssh root@host01 "touch /etc/rhsm/ca/redhat-uep.pem"

# Jenkins Build
ssh root@host01 "cd /root/projects"
ssh root@host01 sudo chmod 777 /var/run/docker.sock && \
ssh root@host01 mkdir -p /jenkins_bkp/jenkins_home && \
ssh root@host01 chmod -R 777 /jenkins_bkp && \
ssh root@host01 git clone https://github.com/ravikalla/online-account.git && \
ssh root@host01 cd online-account && \
ssh root@host01 git checkout master && \
ssh root@host01 cp Dockerfile-Jenkins-Maven ../Dockerfile && \
ssh root@host01 cd .. && \
ssh root@host01 docker build -t ravikalla/jenkins-maven-docker:v0.1 .

# Jenkins Run
docker run --detach -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):$(which docker) -p 9080:8080 -p 50000:50000 -v /jenkins_bkp/jenkins_home:/var/jenkins_home --name jenkinsfordevops ravikalla/jenkins-maven-docker:v0.1