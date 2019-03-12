/**************************************************************************************
  Apex Class Name     : RateProductDAOTest
  Version             : 1.0
  Function            : This is a test class for the RateProductDAO class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             6/3/2016
*************************************************************************************/

@isTest(SeeAllData=false)
private class RateProductDAOTest { 

	@isTest
	static void rateDAOTest(){

		RateProductDAO.IRateProductDAO rateProductDAOInstance = new RateProductDAO();

		Account testAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');

		Opportunity opp = new Opportunity(AccountId = testAcnt.Id, HCSC_Division__c = 'IL', Name='oppName 2',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() + 1;    
        insert opp;

		Secure_Information__c testSecure = new Secure_Information__c(Opportunity_Name__c = opp.Id);
		insert testSecure;

		Rate__c testRate = new Rate__c(Secure_Information__c = testSecure.Id);
		insert testRate;

		List<Rate_Product__c> rateProductsToInsert = new List<Rate_Product__c>();

		Rate_Product__c rateProdObj = new Rate_Product__c(Rate__c = testRate.Id, Name = 'PPO');
		rateProductsToInsert.add(rateProdObj);

		rateProductDAOInstance.insertRateProducts(rateProductsToInsert);
		rateProductDAOInstance.grabRateProducts(testRate.Id);
		rateProductDAOInstance.updateRateProducts(rateProductsToInsert);

		List<Rate_Product__c> rateProducts = [SELECT Id FROM Rate_Product__c];

		System.assertEquals(1, rateProducts.size());
	}
}