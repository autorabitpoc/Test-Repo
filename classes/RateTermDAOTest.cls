/**************************************************************************************
  Apex Class Name     : RateTermDAOTest
  Version             : 1.0
  Function            : This is a test class for the RateTermDAO class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             8/31/2016
*************************************************************************************/

@isTest(SeeAllData=false)
private class RateTermDAOTest { 

	@isTest
	static void rateTermDAOTest(){

		RateTermDAO.IRateTermDAO rateTermDAOInstance = new RateTermDAO();

		Account testAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');

		Opportunity opp = new Opportunity(AccountId = testAcnt.Id, HCSC_Division__c = 'IL', Name='oppName 2',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() + 1;    
        insert opp;

		Secure_Information__c testSecure = new Secure_Information__c(Opportunity_Name__c = opp.Id);
		insert testSecure;

		Rate__c testRate = new Rate__c(Secure_Information__c = testSecure.Id);
		insert testRate;

		List<Rate_Term__c> rateTerms = new List<Rate_Term__c>();
		Rate_Term__c rateTermObj = new Rate_Term__c();
		rateTermObj.Rate__c = testRate.Id;
		rateTermObj.Name = 'Other';
		rateTerms.add(rateTermObj);

		rateTermDAOInstance.insertRateTerm(rateTerms);
		rateTermDAOInstance.grabRateTerms(testRate.Id);

		rateTerms[0].Group_1_Amount__c = 2;
		rateTermDAOInstance.upsertRateTerm(rateTerms);

		List<Rate_Term__c> rateTerm = [SELECT Id, Group_1_Amount__c FROM Rate_Term__c];

		System.assertEquals(1, rateTerm.size());
		System.assertEquals(2, rateTerm[0].Group_1_Amount__c);

	}
}