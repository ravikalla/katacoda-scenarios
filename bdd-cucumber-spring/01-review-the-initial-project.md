# Review the base structure of the application

For your convenience, this scenario has been created with a base project using the Java programming language and the Apache Maven build tool.

As you review the content, you will notice that there are a lot of **TODO** comments. **Do not remove them!** These comments are used as markers for later exercises in this scenario. 

**1. Add BDD Dependencies**

To add Spring JMS to our project all we have to do is to add the following line in ``pom.xml``{{open}}
<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- TODO: Katacoda : Add cucumber dependency here -->">
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

**1.1. BDD Runner Class**

``src/test/java/in/ravikalla/onlineacc/BDDTest.java``{{open}}

<pre class="file" data-filename="src/test/java/in/ravikalla/onlineacc/BDDTest.java" data-target="replace">
package in.ravikalla.onlineacc;

import static org.mockito.Matchers.startsWith;

import java.io.File;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import static io.specto.hoverfly.junit.core.SimulationSource.dsl;
import static io.specto.hoverfly.junit.dsl.HoverflyDsl.service;
import static io.specto.hoverfly.junit.dsl.ResponseCreators.success;

import io.specto.hoverfly.junit.core.HoverflyConfig;
import io.specto.hoverfly.junit.rule.HoverflyRule;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.ClassRule;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.ClassRule;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;

import com.cucumber.listener.Reporter;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import in.ravikalla.onlineacc.service.UserServiceImpl.AccountServiceImpl;
import in.ravikalla.onlineacc.util.AppConstants;
import io.specto.hoverfly.junit.rule.HoverflyRule;

import static in.ravikalla.onlineacc.util.AppConstants.*;

@ActiveProfiles("test")
@RunWith(Cucumber.class)
@CucumberOptions(features = "classpath:features"
        , tags = {"@Regression"}
        , glue={"in.ravikalla.onlineacc.stepdef"}
		, plugin = { "pretty", "html:target/cucumber/cucumber-html-report", "json:target/cucumber/cucumber.json",
				"junit:target/cucumber/cucumber.xml",
				"com.cucumber.listener.ExtentCucumberFormatter:target/extent-report.html" })
public class BDDTest {
	private static final Logger L = LogManager.getLogger(BDDTest.class);

	@ClassRule
	public static HoverflyRule hoverflyRule = HoverflyRule.inCaptureOrSimulationMode("account.json",HoverflyConfig.configs().proxyLocalHost(true));
	//public static HoverflyRule hoverflyRule = HoverflyRule.inSimulationMode(HoverflyConfig.configs().proxyLocalHost(true));
	//public static HoverflyRule hoverflyRule = HoverflyRule.inCaptureOrSimulationMode("account.json", HoverflyConfig.configs().proxyLocalHost(true));

	@BeforeClass
	public static void setUp() throws Exception {
		L.info("49 : Start : BDDTest.setUp()");
		BDDTest.hoverflyRule.inSimulationMode(dsl(
				service(EXTERNAL_BANK_URL)
				.get(startsWith(EXTERNAL_BANK_URL_DEPOSIT))
					.willReturn(
						success("deposit success", "text/plain"))
				.get(startsWith(EXTERNAL_BANK_URL_WITHDRAW))
					.willReturn(
						success("withdraw success", "text/plain"))), HoverflyConfig.configs().proxyLocalHost(true));
	}

	@AfterClass
    public static void teardown() {
        Reporter.loadXMLConfig(new File("src/test/resources/extent-config.xml"));
        Reporter.setSystemInfo("user", System.getProperty("user.name"));
        Reporter.setSystemInfo("os", "Mac OSX");
        Reporter.setTestRunnerOutput("Sample test runner output message");
    }
}
</pre>

**1.2. Add Checkings Account Feature File**

``src/test/resources/features/CheckingsAccountActivities1.feature``{{open}}

<pre class="file" data-filename="src/test/resources/features/CheckingsAccountActivities1.feature" data-target="replace">
Feature: Check money deposited can be withdrawn from Checkings account in all possible cases

@Regression
Scenario Outline: Check if the money deposited can be withdrawn from CheckingsAccount in all positive scenarios
	Given Common user logged in
	And Initial balance in Checkings account is &lt;InitialBalance&gt;
	When Deposit money of &lt;DepositAmount&gt; dollars in CheckingsAccount
	And Withdraw money of &lt;WithdrawAmount&gt; dollars from CheckingsAccount
	Then Check remaining amount &lt;RemainingAmount&gt; dollars in CheckingsAccount

	Examples:
		|InitialBalance|DepositAmount|WithdrawAmount|RemainingAmount|
		|1700.00       |1000         |500           |2200.00        |
		|2200.00       |1000000      |0             |1002200.00     |
		|1002200.00    |1000         |5000          |998200.00      |
		|998200.00     |0            |998200.00     |0.00           |

@Regression
Scenario Outline: Check if overdraft is possible in CheckingsAccount
	Given Common user logged in
	And Initial balance in Checkings account is &lt;InitialBalance&gt;
	And Withdraw money of &lt;WithdrawAmount&gt; dollars from CheckingsAccount
	Then Check remaining amount &lt;RemainingAmount&gt; dollars in CheckingsAccount

	Examples:
		|InitialBalance|WithdrawAmount|RemainingAmount|
		|0.00          |500           |-500.00        |

@Regression
Scenario Outline: Check if huge amounts of money can be deposited and withdrawn in CheckingsAccount
	Given Common user logged in
	And Initial balance in Checkings account is &lt;InitialBalance&gt;
	When Deposit money of &lt;DepositAmount&gt; dollars in CheckingsAccount
	Then Check remaining amount &lt;RemainingAmount&gt; dollars in CheckingsAccount
	And Withdraw money of &lt;WithdrawAmount&gt; dollars from CheckingsAccount

	Examples:
		|InitialBalance|DepositAmount   |RemainingAmount    |WithdrawAmount     |
		|-500.00       |1000            |500.00             |0.00               |
		|500.00        |1000000000000000|1000000000000500.00|1000000000000500.00|

</pre>

**2. Test**

Execute tests
``mvn test``{{execute}}
<br/><br/>
Host reports on server to view
``cp /root/projects/bdd-cucumber-spring-katacoda/target/extent-report.html /var/www/html/index.html``{{execute}}
<br/>
View test report: https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/

**3. Build**

``mvn clean install``{{execute}}

**4. Start**
 Navigate to the executable folder
``cd target``{{execute}}

 Start the application
``java -jar bdd-cucumber-spring-0.0.1-SNAPSHOT.jar``{{execute}}

Open the application: https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/

* Login with the default credentials "Admin/password"





To add Spring JMS to our project all we have to do is to add the following line in ``pom.xml``{{open}}

Along with the JMS dependencies this starter also brings in the ActiveMQ Broker. The Broker manages connections to the Queue and acts as the mediator between the application and ActiveMQ. The `jackson-databind` dependency is for marshalling and unmarshalling the messages we will send. We will cover this later.

Right now the application will not compile because we are missing our Message object in the provided code. In our next step we'll fill in those required classes and we will be able to test it locally.

## Congratulations

You have now successfully executed the first step in this scenario. In the next step we will setup the code necessary todo BDD testing.
