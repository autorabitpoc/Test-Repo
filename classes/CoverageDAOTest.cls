@isTest(SeeAllData = false)
public class CoverageDAOTest { 

	@isTest
	static void coverageDAOTest() {
		Test.StartTest();
		Id BlueSTARRecType = Schema.SObjectType.Benefit_Agreement__c.getRecordTypeInfosByName().get( ConstantsController.BlueStar ).getRecordTypeId();
		CoverageDAO.ICoverageDAO coverageDAOInstance = new CoverageDAO();
		Set<Id> baIds = new Set<Id>();

		Account testAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');
		Benefit_Agreement__c testBnftAgrmnt = new Benefit_Agreement__c(Group_Account__c = testAcnt.Id, RecordTypeId = BlueSTARRecType, Funding_Type__c = 'PREM', Effective_Date__c = (System.today() - 1), Status__c = 'Active');
		insert testBnftAgrmnt;
		baIds.add(testBnftAgrmnt.id);
		Coverage__c testCoverage = new Coverage__c(Name = 'testCoverage', Benefit_Agreement__c = testBnftAgrmnt.id, Type__c = 'DRUG');
		insert testCoverage;

		List<Coverage__c> coverages = coverageDAOInstance.getCoveragesForBAs(baIds);
		System.assertEquals( coverages.size(), 1);

		Test.StopTest();
	}
}