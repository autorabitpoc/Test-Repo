@isTest(SeeAllData = false)
public class ContractAdministrationTriggerHandlerTest { 
	@isTest
	static void calculateContractAdministrationComplexityScoreTest() {
		Test.StartTest();

		Account testAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');
		Contract_Administration__c contractAdmin = new Contract_Administration__c(Account__c = testAcnt.id, Status__c = 'Fully Executed', Complexity__c = 'Medium');
		insert contractAdmin;

		testAcnt = [SELECT ComplexityScoreContractAdministration__c FROM Account WHERE Id = :testAcnt.Id];

		System.assertEquals(testAcnt.ComplexityScoreContractAdministration__c, 5);

		Test.StopTest();
	}
}