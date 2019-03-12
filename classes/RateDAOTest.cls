/**************************************************************************************
  Apex Class Name     : RateDAOTest
  Version             : 1.0
  Function            : This is a test class for the RateDAO class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             6/03/2016
*************************************************************************************/

@isTest(SeeAllData=false)
private class RateDAOTest { 

	@isTest
	static void rateDAOTest(){

		RateDAO.IRateDAO rateDAOInstance = new RateDAO();

		Account testAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');

		Opportunity opp = new Opportunity(AccountId = testAcnt.Id, HCSC_Division__c = 'IL', Name='oppName 2',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() + 1;    
        insert opp;

		Secure_Information__c testSecure = new Secure_Information__c(Opportunity_Name__c = opp.Id);
		insert testSecure;

		Rate__c testRate = new Rate__c(Secure_Information__c = testSecure.Id);

		rateDAOInstance.insertRate(testRate);
		rateDAOInstance.grabRateObj(testRate.Id);
		rateDAOInstance.grabASORateObj(testRate.Id);
		rateDAOInstance.grabHCARateObj(testRate.Id);

		testRate.Other_Rate__c = 'test';
		rateDAOInstance.updateRate(testRate);

		List<Rate__c> rate = [SELECT Id, Other_Rate__c FROM Rate__c];

		System.assertEquals(1, rate.size());
		System.assertEquals('test', rate[0].Other_Rate__c);


	}
}