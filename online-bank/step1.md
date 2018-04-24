## Easy to deploy the application online -
[Docker Playground](https://labs.play-with-docker.com) is a free IaaS(InfrastructureAsAService) platform where you can freely create many virtual machines easily. It is very simple to use as the console can be accessed from the browser. Each virtual machine supports Docker and Git by default.

### Steps to start SQL Server:
* Login to "[Docker Playground](https://labs.play-with-docker.com)" (You have to signup for the first time)
![Docker Playground](https://github.com/ravikalla/images/blob/master/online-bank/1.png)
* Click on "Add New Instance" button to create a new VirtualMachine. You will see a linux console on the right hand side of the window.
![Add new instance button](https://github.com/ravikalla/images/blob/master/online-bank/2.png)
* In the console, you can start the "Online Bank" application by executing below commands
* Start "MySQL" database
`docker run --detach --name=bankmysql --env="MYSQL_ROOT_PASSWORD=root" -p 3306:3306 mysql`{{execute}}
![Start MySQL server](https://github.com/ravikalla/images/blob/master/online-bank/3.png)
