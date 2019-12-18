# Use Hoverfly in Java Spring

For your convenience, this scenario has been created with a base project using the Java programming language and the Apache Maven build tool

**0. Go to root folder**
``cd ..``{{execute}}

**1. Install Support project**

Download support project that has webservices that should be virtualized -
<br/>
``git clone https://github.com/ravikalla/onlineaccount-external-virtualization-site``{{execute}}
<br/>
Build the application -
<br/>
``cd onlineaccount-external-virtualization-site``{{execute}}
<br/><br/>
``mvn clean install``{{execute}}
<br/><br/>
Start the application -
<br/>
``cd target``{{execute}}
<br/><br/>
``java -jar ExternalAudit-0.0.1-SNAPSHOT.jar &``{{execute}}
<br/><br/>
Support project URLs -
 * https://[[HOST_SUBDOMAIN]]-7001-[[KATACODA_HOST]].environments.katacoda.com/datetime
 * https://[[HOST_SUBDOMAIN]]-7001-[[KATACODA_HOST]].environments.katacoda.com/audit/deposit/10000
 * https://[[HOST_SUBDOMAIN]]-7001-[[KATACODA_HOST]].environments.katacoda.com/audit/deposit/1000
 * https://[[HOST_SUBDOMAIN]]-7001-[[KATACODA_HOST]].environments.katacoda.com/audit/withdraw/10000
 * https://[[HOST_SUBDOMAIN]]-7001-[[KATACODA_HOST]].environments.katacoda.com/audit/withdraw/1000

**2. Get Bank Application**

Hoverfly is configured in this Bank Application written in Spring
<br/>
Got to previous folder - ``cd ..``{{execute}}
<br/>
Download Bank Application - ``git clone https://github.com/ravikalla/online-account``{{execute}}
<br/>
Go to application folder - ``cd online-account``{{execute}}

**3. Build Bank Application**

Run tests on the Bank application
<br/>
Got to previous folder - ``mvn clean test``{{execute}}
<br/>
Execute tests
``mvn test``{{execute}}
<br/><br/>
Host reports on server to view -
``cp /root/projects/virtualization-katacoda/online-account/target/extent-report.html /var/www/html/index.html``{{execute}}
<br/>
View test report: https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/
