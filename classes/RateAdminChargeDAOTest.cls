/**************************************************************************************
  Apex Class Name     : RateAdminChargeDAOTest
  Version             : 1.0
  Function            : This is a test class for the RateAdminChargeDAO class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             6/6/2016
*************************************************************************************/

@isTest(SeeAllData=false)
private class RateAdminChargeDAOTest { 

	@isTest
	static void rateAdminChargeDAOTest(){

		RateAdminChargeDAO.IRateAdminChargeDAO rateAdminChargeDAOInstance = new RateAdminChargeDAO();

		Account testAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');

		Opportunity opp = new Opportunity(AccountId = testAcnt.Id, HCSC_Division__c = 'IL', Name='oppName 2',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() + 1;    
        insert opp;

		Secure_Information__c testSecure = new Secure_Information__c(Opportunity_Name__c = opp.Id);
		insert testSecure;

		Rate__c testRate = new Rate__c(Secure_Information__c = testSecure.Id);
		insert testRate;

		List<Rate_Admin_Charge__c> rateAdminCharges = new List<Rate_Admin_Charge__c>();
		Rate_Admin_Charge__c rateAdminChargeObj = new Rate_Admin_Charge__c();
		rateAdminChargeObj.Rate__c = testRate.Id;
		rateAdminChargeObj.Name = 'Administrative Charge 1';
		rateAdminCharges.add(rateAdminChargeObj);

		rateAdminChargeDAOInstance.insertRateAdminCharge(rateAdminCharges);
		rateAdminChargeDAOInstance.grabRateAdminCharges(testRate.Id);

		rateAdminCharges[0].Other_Frequency__c = 'test';
		rateAdminChargeDAOInstance.upsertRateAdminCharge(rateAdminCharges);

		List<Rate_Admin_Charge__c> rateAdminCharge = [SELECT Id, Other_Frequency__c FROM Rate_Admin_Charge__c];

		System.assertEquals(1, rateAdminCharge.size());
		System.assertEquals('test', rateAdminCharge[0].Other_Frequency__c);

	}
}