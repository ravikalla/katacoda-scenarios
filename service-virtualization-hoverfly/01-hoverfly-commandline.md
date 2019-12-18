# Use Hoverfly from command line

For your convenience, this scenario has been created with a base project using the Java programming language and the Apache Maven build tool.

**1. Install**

Download Hoverfly installation file
<br/>
``wget https://github.com/SpectoLabs/hoverfly/releases/download/v1.1.3/hoverfly_bundle_linux_amd64.zip``{{execute}}
<br/><br/>
Unzip the installation file
<br/>
``unzip hoverfly_bundle_linux_amd64.zip``{{execute}}

**2. Start**

Hoverfly comes with a command line tool called hoverctl
<br/>
``./hoverctl start``{{execute}}

**3. Capture**
Capture an HTTP request and response
<br/>
``./hoverctl mode capture``{{execute}}
<br/><br/>
Capture response from Time webservice -
<br/>
``curl --proxy http://localhost:8500 http://time.jsontest.com``{{execute}}
<br/><br/>
Capture response from another webservice -
<br/>
``curl --proxy http://localhost:8500 http://jsonplaceholder.typicode.com/todos/1``{{execute}}
<br/><br/>
Admin screen URL - https://[[HOST_SUBDOMAIN]]-8888-[[KATACODA_HOST]].environments.katacoda.com/

**4. Export**

Export simulation to a JSON file
<br/>
``hoverctl export simulation.json``{{execute}}

**5. Simulate**
Set Hoverfly to simulate mode -
<br/>
``./hoverctl mode simulate``{{execute}}
<br/><br/>
Make the same request again to see the same data as before -
<br/>
``curl --proxy http://localhost:8500 http://time.jsontest.com``{{execute}}
<br/>
``curl --proxy http://localhost:8500 http://jsonplaceholder.typicode.com/todos/1``{{execute}}
