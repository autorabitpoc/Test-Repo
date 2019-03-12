@isTest(SeeAllData=false)
private class ItemsSharePointDAOTest {
	@testSetup static void setupTestData(){
		Account a = new Account(Name='Test', External_Id__c='AC102981');
		insert a;
		Opportunity o = new Opportunity(Name='Test', RFI_RFP_Received_Date__c=System.Today());
		o.StageName='RFI Received';
		o.Probability = 10;
		o.CloseDate=System.Today();
		insert o;
		Case c = new Case(Subject='Test');
		c.Opportunity_Name__c = o.Id;
		c.AccountId = a.Id;
		insert c;
	}

	@isTest static void daoTest(){
		Account a = [SELECT Id FROM Account LIMIT 1];
		Opportunity o = [SELECT Id FROM Opportunity LIMIT 1];
		Case c = [SELECT Id FROM Case LIMIT 1];

		ItemsSharePointDAO itemsSharepointDaoInstance = new ItemsSharePointDAO();

		Integer aCount = itemsSharepointDaoInstance.getAccountsCountById(a.Id);
		System.assertEquals(0, aCount);
		Integer oCount = itemsSharepointDaoInstance.getOpportunitiesCountById(o.Id);
		System.assertEquals(0, oCount);
		Integer cCount = itemsSharepointDaoInstance.getCasesCountById(c.Id);
		System.assertEquals(0, cCount);
		List<items_Sharepoint__x> listResults = itemsSharepointDaoInstance.getItemizedSharePointRecordsDynamically('select id from items_Sharepoint__x');
		System.assertEquals(0, listResults.size());
	}
}