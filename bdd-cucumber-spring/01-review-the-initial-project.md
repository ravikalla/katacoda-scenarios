# Review the base structure of the application

For your convenience, this scenario has been created with a base project using the Java programming language and the Apache Maven build tool.

As you review the content, you will notice that there are a lot of **TODO** comments. **Do not remove them!** These comments are used as markers for later exercises in this scenario. 

**1. Add BDD Dependencies**

To add Spring JMS to our project all we have to do is to add the following line in ``pom.xml``{{open}}
<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- TODO: Add cucumber dependency here -->">
		&lt;dependency&gt;
			&lt;groupId&gt;info.cukes&lt;/groupId&gt;
			&lt;artifactId&gt;cucumber-java&lt;/artifactId&gt;
			&lt;version&gt;${cucumber.spring}&lt;/version&gt;
			&lt;scope&gt;test&lt;/scope&gt;
		&lt;/dependency&gt;
		&lt;dependency&gt;
			&lt;groupId&gt;info.cukes&lt;/groupId&gt;
			&lt;artifactId&gt;cucumber-java8&lt;/artifactId&gt;
			&lt;version&gt;${cucumber.spring}&lt;/version&gt;
			&lt;scope&gt;test&lt;/scope&gt;
		&lt;/dependency&gt;
		&lt;dependency&gt;
			&lt;groupId&gt;info.cukes&lt;/groupId&gt;
			&lt;artifactId&gt;cucumber-spring&lt;/artifactId&gt;
			&lt;version&gt;${cucumber.spring}&lt;/version&gt;
			&lt;scope&gt;test&lt;/scope&gt;
		&lt;/dependency&gt;
		&lt;dependency&gt;
			&lt;groupId&gt;info.cukes&lt;/groupId&gt;
			&lt;artifactId&gt;cucumber-junit&lt;/artifactId&gt;
			&lt;version&gt;${cucumber.spring}&lt;/version&gt;
			&lt;scope&gt;test&lt;/scope&gt;
		&lt;/dependency&gt;
		&lt;dependency&gt;
		    &lt;groupId&gt;com.vimalselvam&lt;/groupId&gt;
		    &lt;artifactId&gt;cucumber-extentsreport&lt;/artifactId&gt;
		    &lt;version&gt;3.0.1&lt;/version&gt;
		&lt;/dependency&gt;
</pre>

**2. Build**

``mvn clean install``{{execute}}

**3. Start**

``cd target``{{execute}}
``java -jar bdd-cucumber-spring-0.0.1-SNAPSHOT.jar``{{execute}}

To add Spring JMS to our project all we have to do is to add the following line in ``pom.xml``{{open}}

Along with the JMS dependencies this starter also brings in the ActiveMQ Broker. The Broker manages connections to the Queue and acts as the mediator between the application and ActiveMQ. The `jackson-databind` dependency is for marshalling and unmarshalling the messages we will send. We will cover this later.

Right now the application will not compile because we are missing our Message object in the provided code. In our next step we'll fill in those required classes and we will be able to test it locally.

## Congratulations

You have now successfully executed the first step in this scenario. In the next step we will setup the code necessary todo BDD testing.
