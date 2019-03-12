/**************************************************************************************
  Apex Class Name     : RateGroupDAOTest
  Version             : 1.0
  Function            : This is a test class for the RateGroupDAO class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             6/6/2016
*************************************************************************************/

@isTest(SeeAllData=false)
private class RateGroupDAOTest { 

	@isTest
	static void rateGroupDAOTest(){

		RateGroupDAO.IRateGroupDAO rateGroupDAOInstance = new RateGroupDAO();

		Account testAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');

		Opportunity opp = new Opportunity(AccountId = testAcnt.Id, HCSC_Division__c = 'IL', Name='oppName 2',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() + 1;    
        insert opp;

		Secure_Information__c testSecure = new Secure_Information__c(Opportunity_Name__c = opp.Id);
		insert testSecure;

		Rate__c testRate = new Rate__c(Secure_Information__c = testSecure.Id);
		insert testRate;

		List<Rate_Group__c> rateGroups = new List<Rate_Group__c>();
		Rate_Group__c rateGroupObj = new Rate_Group__c();
		rateGroupObj.Rate__c = testRate.Id;
		rateGroupObj.Name = 'Group 1';
		rateGroups.add(rateGroupObj);

		rateGroupDAOInstance.insertRateGroup(rateGroups);
		rateGroupDAOInstance.grabRateGroups(testRate.Id);

		rateGroups[0].Group_1_Amount__c = 2;
		rateGroupDAOInstance.upsertRateGroup(rateGroups);

		List<Rate_Group__c> rateGroup = [SELECT Id, Group_1_Amount__c FROM Rate_Group__c];

		System.assertEquals(1, rateGroup.size());
		System.assertEquals(2, rateGroup[0].Group_1_Amount__c);

	}
}