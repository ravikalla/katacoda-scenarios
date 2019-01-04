ssh root@host01 "git clone https://github.com/ravikalla/bdd-cucumber-spring-katacoda.git"
ssh root@host01 "yum install tree -y"
ssh root@host01 "mkdir /root/projects/temp"
ssh root@host01 "chmod 777 /root/projects/temp"

ssh root@host01 "mkdir -p /root/projects/temp1"
ssh root@host01 "chcon -R -t svirt_sandbox_file_t /root/projects/temp1"
ssh root@host01 "restorecon -R /root/projects/temp1"
ssh root@host01 "chmod 777 /root/projects/temp1"

ssh root@host01 "touch /etc/rhsm/ca/redhat-uep.pem"
