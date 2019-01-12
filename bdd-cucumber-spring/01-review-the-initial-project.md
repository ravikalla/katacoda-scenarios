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

``src/test/resources/features/CheckingsAccountActivities.feature``{{open}}

<pre class="file" data-filename="src/test/resources/features/CheckingsAccountActivities.feature" data-target="replace">
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

**1.3. Add Checkings Account StepDefinition File**

``src/test/java/in/ravikalla/onlineacc/stepdef/DepositCheckCheckAccStep.java``{{open}}

<pre class="file" data-filename="src/test/java/in/ravikalla/onlineacc/stepdef/DepositCheckCheckAccStep.java" data-target="replace">
package in.ravikalla.onlineacc.stepdef;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import java.io.IOException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.Assert;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.IntegrationTest;
import org.springframework.boot.test.SpringApplicationContextLoader;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.jayway.restassured.RestAssured;

import cucumber.api.java.Before;
import cucumber.api.java8.En;
import in.ravikalla.onlineacc.StartApplication;
import in.ravikalla.onlineacc.domain.PrimaryAccount;
import in.ravikalla.onlineacc.utils.UserType;

import static in.ravikalla.onlineacc.util.AppConstants.*;

@SuppressWarnings("deprecation")
@ContextConfiguration(classes = { StartApplication.class }, loader = SpringApplicationContextLoader.class)
@WebAppConfiguration
@IntegrationTest("server.port:0")
@TestPropertySource("/application.yml")
public class DepositCheckCheckAccStep implements En {

	@Autowired
	WebApplicationContext context;

	MockMvc mockMvc;

	private static final Logger L = LogManager.getLogger(DepositCheckCheckAccStep.class);

	@Value("${local.server.port}")
	private int port;

	// Start : Global variables used while testing
	private UserType enumUserType = null;
	// End : Global variables used while testing

	@Before
	public void setup() throws IOException {
		L.debug("Start : DepositCheckCheckAccStep.setUp()");

		MockitoAnnotations.initMocks(this);
		RestAssured.port = port;

		enumUserType = UserType.COMMON;

		mockMvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
		L.debug("End : DepositCheckCheckAccStep.setUp()");
	}

	public DepositCheckCheckAccStep() {

		Given("^Common user logged in$", () -&gt; {
			L.debug("Start : User logged in");

			enumUserType = UserType.COMMON;

			L.debug("End : User logged in");
		});
		And("^Initial balance in Checkings account is ([^\"]*)$", (String strInitialBalance) -&gt; {
			L.debug("Start : Intial balance match");
			try {
				PrimaryAccount objPrimaryAccount = getPrimaryAccountDetails();
				Assert.assertEquals("Account Balance should match", strInitialBalance, objPrimaryAccount.getAccountBalance().toPlainString());
			} catch (Exception e) {
				Assert.fail("132 : Couldnt check the initial balance : " + e);
			}
			L.debug("End : Intial balance match");
		});
		When("^Deposit money of ([^\"]*) dollars in CheckingsAccount$", (String strDepositMoney) -&gt; {
			L.debug("Start : Deposit money");
			try {
				mockMvc.perform(post(URI_ACC + URI_DEPOSIT).param("amount", strDepositMoney).param("accountType", "Primary")
						.with(user(enumUserType.getUserName()).password(enumUserType.getPWD())))
					.andExpect(status().is3xxRedirection());
			} catch (Exception e) {
				Assert.fail("143 : Deposit Money : " + e);
			}
			L.debug("End : Deposit money");
		});
		And("^Withdraw money of ([^\"]*) dollars from CheckingsAccount$", (String strWithdrawMoney) -&gt; {
			L.debug("Start : Withdraw money");
			try {
				mockMvc.perform(post(URI_ACC + URI_WITHDRAW).param("amount", strWithdrawMoney).param("accountType", "Primary")
						.with(user(enumUserType.getUserName()).password(enumUserType.getPWD()))).andExpect(status().is3xxRedirection());
			} catch (Exception e) {
				Assert.fail("153 : Withdraw Money : " + e);
			}
			L.debug("End : Withdraw money");
		});
		And("^Check remaining amount ([^\"]*) dollars in CheckingsAccount$", (String strRemainingAmount) -&gt; {
			L.debug("Start : Remaining balance match");
			try {
				PrimaryAccount objPrimaryAccount = getPrimaryAccountDetails();
				Assert.assertEquals("Account Balance should match", strRemainingAmount, objPrimaryAccount.getAccountBalance().toPlainString());
			} catch (Exception e) {
				Assert.fail("132 : Couldnt check the initial balance : " + e);
			}
			L.debug("End : Remaining balance match");
		});
	}

	private PrimaryAccount getPrimaryAccountDetails() throws Exception {
		MvcResult objMvcResult = mockMvc
				.perform(get(URI_ACC + URI_ACC_PRIMARY).with(user(enumUserType.getUserName()).password(enumUserType.getPWD()))
//								.contentType(MediaType.APPLICATION_JSON)
						)
				.andExpect(model().attributeExists("primaryAccount"))
				.andExpect(view().name("primaryAccount"))
				.andReturn();
		PrimaryAccount primaryAccount = (PrimaryAccount) objMvcResult.getModelAndView().getModel().get("primaryAccount");
		return primaryAccount;
	}
}
</pre>

**1.4. Add Savings Account Feature File**

``src/test/resources/features/SavingsAccountActivities.feature``{{open}}

<pre class="file" data-filename="src/test/resources/features/SavingsAccountActivities.feature" data-target="replace">
Feature: Check of money deposited can be withdrawn from Savings account in all possible cases

@Regression
Scenario Outline: Check if the money that is deposited money can be withdrawn from SavingsAccount in general cases
	Given Common user logged in for Savings Account
	And Initial balance in Savings account is &lt;InitialBalance&gt;
	When Deposit money of &lt;DepositAmount&gt; dollars in SavingsAccount
	And Withdraw money of &lt;WithdrawAmount&gt; dollars from SavingsAccount
	Then Check remaining amount &lt;RemainingAmount&gt; dollars in SavingsAccount

	Examples:
		|InitialBalance|DepositAmount|WithdrawAmount|RemainingAmount|
		|4250.00       |1000         |500           |4750.00        |
		|4750.00       |1000000      |0             |1004750.00     |
		|1004750.00    |1000         |5000          |1000750.00     |
		|1000750.00    |0            |1000750.00    |0.00           |

@Regression
Scenario Outline: Check if overdraft is possible in SavingsAccount
	Given Common user logged in for Savings Account
	And Initial balance in Savings account is &lt;InitialBalance&gt;
	And Withdraw money of &lt;WithdrawAmount&gt; dollars from SavingsAccount
	Then Check remaining amount &lt;RemainingAmount&gt; dollars in SavingsAccount

	Examples:
		|InitialBalance|WithdrawAmount|RemainingAmount|
		|0.00          |500           |-500.00        |

@Regression
Scenario Outline: Check if large amounts of money can be deposited in SavingsAccount
	Given Common user logged in for Savings Account
	And Initial balance in Savings account is &lt;InitialBalance&gt;
	When Deposit money of &lt;DepositAmount&gt; dollars in SavingsAccount
	Then Check remaining amount &lt;RemainingAmount&gt; dollars in SavingsAccount
	And Check if transaction count of SavingsAccount is greater than 0
	And Withdraw money of &lt;WithdrawAmount&gt; dollars from SavingsAccount

	Examples:
		|InitialBalance|DepositAmount   |RemainingAmount    |WithdrawAmount     |
		|-500.00       |1000            |500.00             |0.00               |
		|500.00        |1000000000000000|1000000000000500.00|1000000000000500.00|
</pre>

**1.5. Add Savings Account StepDefinition File**

``src/test/java/in/ravikalla/onlineacc/stepdef/DepositCheckSavAccStep.java``{{open}}

<pre class="file" data-filename="src/test/java/in/ravikalla/onlineacc/stepdef/DepositCheckSavAccStep.java" data-target="replace">
package in.ravikalla.onlineacc.stepdef;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import java.io.IOException;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.Assert;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.IntegrationTest;
import org.springframework.boot.test.SpringApplicationContextLoader;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.jayway.restassured.RestAssured;

import cucumber.api.java.Before;
import cucumber.api.java8.En;
import in.ravikalla.onlineacc.StartApplication;
import in.ravikalla.onlineacc.domain.SavingsAccount;
import in.ravikalla.onlineacc.domain.SavingsTransaction;
import in.ravikalla.onlineacc.utils.UserType;

import static in.ravikalla.onlineacc.util.AppConstants.*;

@SuppressWarnings("deprecation")
@ContextConfiguration(classes = { StartApplication.class }, loader = SpringApplicationContextLoader.class)
@WebAppConfiguration
@IntegrationTest("server.port:0")
@TestPropertySource("/application.yml")
public class DepositCheckSavAccStep implements En {

	@Autowired
	WebApplicationContext context;

	MockMvc mockMvc;

	private static final Logger L = LogManager.getLogger(DepositCheckSavAccStep.class);

	@Value("${local.server.port}")
	private int port;

	// Start : Global variables used while testing
	private UserType enumUserType = null;
	// End : Global variables used while testing

	@Before
	public void setup() throws IOException {
		L.debug("Start : DepositCheckSavAccStep.setUp()");

		MockitoAnnotations.initMocks(this);
		RestAssured.port = port;

		enumUserType = UserType.COMMON;

		mockMvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
		L.debug("End : DepositCheckSavAccStep.setUp()");
	}

	public DepositCheckSavAccStep() {
		Given("^Common user logged in for Savings Account$", () -&gt; {
			L.debug("Start : User logged in");

			enumUserType = UserType.COMMON;

			L.debug("End : User logged in");
		});

		And("^Initial balance in Savings account is ([^\"]*)$", (String strInitialBalance) -&gt; {
			L.debug("Start : Intial balance match");

			try {
				SavingsAccount objSavingsAccount = getSavingsAccountDetails();

				L.debug("90 : Actual AccountBalance = {}, Expected = {}", objSavingsAccount.getAccountBalance().toPlainString(), strInitialBalance);
				Assert.assertEquals("Account Balance should match", strInitialBalance, objSavingsAccount.getAccountBalance().toPlainString());
			} catch (Exception e) {
				Assert.fail("132 : Couldnt check the initial balance : " + e);
			}

			L.debug("End : Intial balance match");
		});
		When("^Deposit money of ([^\"]*) dollars in SavingsAccount$", (String strDepositMoney) -&gt; {
			L.debug("Start : Deposit money");
			try {
				mockMvc.perform(post(URI_ACC + URI_DEPOSIT).param("amount", strDepositMoney).param("accountType", "Savings")
						.with(user(enumUserType.getUserName()).password(enumUserType.getPWD())))
					.andExpect(status().is3xxRedirection());
			} catch (Exception e) {
				Assert.fail("143 : Deposit Money : " + e);
			}
			L.debug("End : Deposit money");
		});
		And("^Withdraw money of ([^\"]*) dollars from SavingsAccount$", (String strWithdrawMoney) -&gt; {
			L.debug("Start : Withdraw money");
			try {
				mockMvc.perform(post(URI_ACC + URI_WITHDRAW).param("amount", strWithdrawMoney).param("accountType", "Savings")
						.with(user(enumUserType.getUserName()).password(enumUserType.getPWD()))).andExpect(status().is3xxRedirection());
			} catch (Exception e) {
				Assert.fail("153 : Withdraw Money : " + e);
			}
			L.debug("End : Withdraw money");
		});
		And("^Check remaining amount ([^\"]*) dollars in SavingsAccount$", (String strRemainingAmount) -&gt; {
			L.debug("Start : Remaining balance match");
			try {
				SavingsAccount objSavingsAccount = getSavingsAccountDetails();
				Assert.assertEquals("Account Balance should match", strRemainingAmount, objSavingsAccount.getAccountBalance().toPlainString());
			} catch (Exception e) {
				Assert.fail("132 : Couldnt check the initial balance : " + e);
			}
			L.debug("End : Remaining balance match");
		});
		And("^Check if transaction count of SavingsAccount is greater than 0$", () -&gt; {
			L.debug("Start : Remaining balance match");
			try {
				List&lt;SavingsTransaction&gt; savingsTransactionList = getSavingsTransactionsDetails();

				Assert.assertNotNull("Transactions cant be null", savingsTransactionList);
				Assert.assertNotNull("Transactions size should be greated than 0", savingsTransactionList.size() &gt; 0);
				L.debug("Savings Transations size = " + savingsTransactionList.size());
//				Assert.assertEquals("Account Balance should match", strRemainingAmount, objSavingsAccount.getAccountBalance().toPlainString());
			} catch (Exception e) {
				Assert.fail("132 : Couldnt check the initial balance : " + e);
			}
			L.debug("End : Remaining balance match");
		});
	}

	private SavingsAccount getSavingsAccountDetails() throws Exception {
		MvcResult objMvcResult = mockMvc
				.perform(get(URI_ACC + URI_ACC_SAVINGS).with(user(enumUserType.getUserName()).password(enumUserType.getPWD()))
//								.contentType(MediaType.APPLICATION_JSON)
						)
				.andExpect(model().attributeExists("savingsAccount"))
				.andExpect(view().name("savingsAccount"))
				.andReturn();
		SavingsAccount objSavingsAccount = (SavingsAccount) objMvcResult.getModelAndView().getModel().get("savingsAccount");
		return objSavingsAccount;
	}
	private List&lt;SavingsTransaction&gt; getSavingsTransactionsDetails() throws Exception {
		MvcResult objMvcResult = mockMvc
				.perform(get(URI_ACC + URI_ACC_SAVINGS).with(user(enumUserType.getUserName()).password(enumUserType.getPWD()))
//								.contentType(MediaType.APPLICATION_JSON)
						)
				.andExpect(model().attributeExists("savingsTransactionList"))
				.andExpect(view().name("savingsAccount"))
				.andReturn();
		List&lt;SavingsTransaction&gt; savingsTransactionList = (List&lt;SavingsTransaction&gt;) objMvcResult.getModelAndView().getModel().get("savingsTransactionList");
		return savingsTransactionList;
	}
}
</pre>

**1.6. Add Transfer Actifities Feature File**

``src/test/resources/features/TransferActivities.feature``{{open}}

<pre class="file" data-filename="src/test/resources/features/TransferActivities.feature" data-target="replace">
Feature: Check account transfer activities between own accounts

@Regression
Scenario Outline: Check if the money can be transferred from Checkings account to Savings account
	Given Common user logged in for account transfer
	And Initial balance in Savings account is &lt;InitialSavingsBalance&gt;
	And Initial balance in Checkings account is &lt;InitialCheckingsBalance&gt;
	When Deposit money of &lt;SavingsDeposit&gt; dollars in SavingsAccount
	And Transfer money of &lt;TransferAmount&gt; from Savings to Checkings account
	Then Check remaining amount &lt;RemainingSavingsBalance&gt; dollars in SavingsAccount
	And Check remaining amount &lt;RemainingCheckingsBalance&gt; dollars in CheckingsAccount

	Examples:
		|InitialSavingsBalance|InitialCheckingsBalance|SavingsDeposit|TransferAmount|RemainingSavingsBalance|RemainingCheckingsBalance|
		|0.00                 |0.00                   |1000           |500          |500.00                 |500.00                     |
</pre>

**1.7. Add Transfer Activities StepDefinition File**

``src/test/java/in/ravikalla/onlineacc/stepdef/TransferActivitiesStep.java``{{open}}

<pre class="file" data-filename="src/test/java/in/ravikalla/onlineacc/stepdef/TransferActivitiesStep.java" data-target="replace">
package in.ravikalla.onlineacc.stepdef;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import java.io.IOException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.Assert;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.IntegrationTest;
import org.springframework.boot.test.SpringApplicationContextLoader;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.jayway.restassured.RestAssured;

import cucumber.api.java.Before;
import cucumber.api.java8.En;
import in.ravikalla.onlineacc.StartApplication;
import in.ravikalla.onlineacc.domain.PrimaryAccount;
import in.ravikalla.onlineacc.utils.UserType;

import static in.ravikalla.onlineacc.util.AppConstants.*;

@SuppressWarnings("deprecation")
@ContextConfiguration(classes = { StartApplication.class }, loader = SpringApplicationContextLoader.class)
@WebAppConfiguration
@IntegrationTest("server.port:0")
@TestPropertySource("/application.yml")
public class TransferActivitiesStep implements En {

	@Autowired
	WebApplicationContext context;

	MockMvc mockMvc;

	private static final Logger L = LogManager.getLogger(TransferActivitiesStep.class);

	@Value("${local.server.port}")
	private int port;

	// Start : Global variables used while testing
	private UserType enumUserType = null;
	// End : Global variables used while testing

	@Before
	public void setup() throws IOException {
		L.debug("Start : TransferActivitiesStep.setUp()");

		MockitoAnnotations.initMocks(this);
		RestAssured.port = port;

		mockMvc = MockMvcBuilders.webAppContextSetup(context).apply(springSecurity()).build();
		L.debug("End : TransferActivitiesStep.setUp()");
	}

	public TransferActivitiesStep() {

		Given("^Common user logged in for account transfer$", () -&gt; {
			L.debug("Start : User logged in");

			enumUserType = UserType.COMMON;

			L.debug("End : User logged in");
		});
		When("^Transfer money of ([^\"]*) from Savings to Checkings account$", (String strTransferAmount) -&gt; {
			L.debug("Start : Amount transfer from Savings to Checkings");
			try {
				mockMvc
						.perform(post(URI_TRANSFER + URI_TRANSFER_BETWEEN_ACCOUNTS)
								.with(user(enumUserType.getUserName()).password(enumUserType.getPWD()))
								.param("transferFrom", "Savings")
								.param("transferTo", "Primary")
								.param("amount", strTransferAmount)
								)
						.andExpect(status().is3xxRedirection());
			} catch (Exception e) {
				Assert.fail("132 : Couldnt transfer money from Savings to Checkings account : " + e);
			}
			L.debug("End : Amount transfer from Savings to Checkings");
		});
	}
}
</pre>

**2. Test**

Execute tests
``mvn test``{{execute}}
<br/><br/>
Host reports on server to view
``cp /root/projects/bdd-cucumber-spring-katacoda/target/extent-report.html /var/www/html/index.html``{{execute}}
<br/>
View test report: https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/

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
