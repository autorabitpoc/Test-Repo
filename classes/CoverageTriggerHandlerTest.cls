@isTest(SeeAllData = false)
public class CoverageTriggerHandlerTest {

	@isTest
	static void coverageDAOTest() {
		Test.StartTest();
		Id BlueSTARRecType = Schema.SObjectType.Benefit_Agreement__c.getRecordTypeInfosByName().get( ConstantsController.BlueStar ).getRecordTypeId();

		Account testAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');
		Benefit_Agreement__c testBnftAgrmnt = new Benefit_Agreement__c(Group_Account__c = testAcnt.Id, RecordTypeId = BlueSTARRecType, Funding_Type__c = 'PREM', Effective_Date__c = (System.today() - 1), Status__c = 'Active');
		insert testBnftAgrmnt;
		Coverage__c testCoverage = new Coverage__c(Name = 'testCoverage', Benefit_Agreement__c = testBnftAgrmnt.id, Type__c = 'DRUG');
		insert testCoverage;

		testBnftAgrmnt = [SELECT ComplexityScoreCoverage__c FROM Benefit_Agreement__c WHERE Id = :testBnftAgrmnt.Id ];
		System.assertEquals( testBnftAgrmnt.ComplexityScoreCoverage__c, 3);

		Test.StopTest();
	} 
}