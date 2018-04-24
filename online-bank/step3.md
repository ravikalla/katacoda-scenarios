## Start the application using its Docker Image from DockerHub -

Run the application on Docker -

`docker run --detach -p 8888:8888 --link bankmysql:localhost -t ravikalla/online-bank:latest`{{execute}}

Open the application: https://[[HOST_SUBDOMAIN]]-8888-[[KATACODA_HOST]].environments.katacoda.com/

![Open the application](https://github.com/ravikalla/images/blob/master/online-bank/8.png)
* Login with the default credentials "Admin/password" in above application screen

* You will log into the application home screen -
![Open the application](https://github.com/ravikalla/images/blob/master/online-bank/9.png)
