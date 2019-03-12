/**************************************************************************************
  Apex Class Name     : RateHCADAOTest
  Version             : 1.0
  Function            : This is a test class for the RateHCADAO class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             6/20/2016
*************************************************************************************/
@isTest(SeeAllData=false)
private class RateHCADAOTest{
	
	@isTest
	static void RateHCADAOTest() {
		
		RateHCADAO.IRateHCADAO rateHCADAOInstance = new RateHCADAO();

		Account testAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');

		Opportunity opp = new Opportunity(AccountId = testAcnt.Id, HCSC_Division__c = 'IL', Name='oppName 2',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() + 1;    
        insert opp;

		Secure_Information__c testSecure = new Secure_Information__c(Opportunity_Name__c = opp.Id);
		insert testSecure;

		Rate__c testRate = new Rate__c(Secure_Information__c = testSecure.Id);

		List<Rate_HCA__c> rateHCAsToInsert = new List<Rate_HCA__c>();

		Rate_HCA__c rateHCAObj = new Rate_HCA__c(Rate__c = testRate.Id, Name = 'HCA 1');
		rateHCAsToInsert.add(rateHCAObj);

		rateHCADAOInstance.insertRateHCA(rateHCAsToInsert);
		rateHCADAOInstance.grabRateHCAs(testRate.Id);
		rateHCADAOInstance.upsertRateHCA(rateHCAsToInsert);
		

		List<Rate_HCA__c> rateHCAs = [SELECT Id FROM Rate_HCA__c];

		System.assertEquals(1, rateHCAs.size());

	}
}