/**************************************************************************************
  Apex Class Name     : RatingMatrixHCAControllerTest
  Version             : 1.0
  Function            : This is a test class for the RatingMatrixHCAController class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             6/20/2016
*************************************************************************************/
@isTest(SeeAllData=false)
private class RatingMatrixHCAControllerTest {

	@isTest static void ratingMatrixHCATest() {

		Account TestAcnt = new Account();
        TestAcnt.Id = fflib_IDGenerator.generate( Account.SObjectType );

		Opportunity opp = new Opportunity(AccountId = TestAcnt.id, HCSC_Division__c = 'IL', Name='oppName 3',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() - 1;         
        opp.Id = fflib_IDGenerator.generate( Opportunity.SObjectType );

		Secure_Information__c testSecure = new Secure_Information__c(Opportunity_Name__c = opp.Id);
		testSecure.Id = fflib_IDGenerator.generate( Secure_Information__c.SObjectType ); 

		Rate__c testRate = new Rate__c(Secure_Information__c = testSecure.Id);
		testRate.Id = fflib_IDGenerator.generate( Rate__c.SObjectType );

		List<Rate_HCA__c> rateHCAInsert = new List<Rate_HCA__c>();

		Rate_HCA__c rateHCA = new Rate_HCA__c(Rate__c = testRate.Id);
		rateHCA.Id = fflib_IDGenerator.generate( Rate_HCA__c.SObjectType );

		rateHCAInsert.add(rateHCA);

		PageReference pageRef = new PageReference('/apex/RatingMatrixHCA');
		pageRef.getParameters().put('state', 'IL');
		pageRef.getParameters().put('secure', testSecure.Id);
		Test.setCurrentPage(pageRef);

		fflib_ApexMocks rateMocks = new fflib_ApexMocks(); 

        RateDAO.IRateDAO rateInstance;
        rateInstance = new MockDAOs.RateDAOMock(rateMocks);  

        rateMocks.startStubbing();
        rateMocks.when(rateInstance.insertRate(testRate))
                    .thenReturn(testRate);
        rateMocks.stopStubbing();

        fflib_ApexMocks rateHCAMocks = new fflib_ApexMocks(); 

        RateHCADAO.IRateHCADAO rateHCAInstance;
        rateHCAInstance = new MockDAOs.RateHCADAOMock(rateHCAMocks);  

        rateHCAMocks.startStubbing();
        rateHCAMocks.when(rateHCAInstance.insertRateHCA(rateHCAInsert))
                    .thenReturn(rateHCAInsert);
        rateHCAMocks.stopStubbing();

		Test.startTest();

		ApexPages.StandardController sc2 = new ApexPages.StandardController(testRate);
		RatingMatrixHCAController ratingController = new RatingMatrixHCAController(sc2, rateInstance, rateHCAInstance);

		ratingController.rateDAOInstance = rateInstance;
		ratingController.rateHCADAOInstance = rateHCAInstance;
		
		ratingController.accountStructure = 'Employee Only';
		ratingController.hcscDivision = 'IL';
		ratingController.groupNumbers = '123';
		ratingController.healthCareAccount = 'HCA';
		ratingController.saveRateBackground();
		ratingController.saveNewRateRecord();
		ratingController.cancel();

		System.assertEquals(1, ratingController.rateHCAs.size());

		Test.stopTest();
		
	}

	@isTest static void ratingMatrixHCAEditTest(){
		
		Account TestAcnt = new Account();
        TestAcnt.Id = fflib_IDGenerator.generate( Account.SObjectType );

		Opportunity opp = new Opportunity(AccountId = TestAcnt.id, HCSC_Division__c = 'IL', Name='oppName 3',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() - 1;         
        opp.Id = fflib_IDGenerator.generate( Opportunity.SObjectType );

		Secure_Information__c testSecure = new Secure_Information__c(Opportunity_Name__c = opp.Id);
		testSecure.Id = fflib_IDGenerator.generate( Secure_Information__c.SObjectType ); 

		Rate__c testRate = new Rate__c(Secure_Information__c = testSecure.Id);
		testRate.Id = fflib_IDGenerator.generate( Rate__c.SObjectType );

		List<Rate_HCA__c> rateHCAInsert = new List<Rate_HCA__c>();

		Rate_HCA__c rateHCA = new Rate_HCA__c(Rate__c = testRate.Id);
		rateHCA.Id = fflib_IDGenerator.generate( Rate_HCA__c.SObjectType );

		rateHCAInsert.add(rateHCA);

		PageReference pageRef = new PageReference('/apex/RatingMatrixHCA');
		pageRef.getParameters().put('rateId',  testRate.Id);
		Test.setCurrentPage(pageRef);

		fflib_ApexMocks rateMocks = new fflib_ApexMocks(); 

        RateDAO.IRateDAO rateInstance;
        rateInstance = new MockDAOs.RateDAOMock(rateMocks);  

        rateMocks.startStubbing();
        rateMocks.when(rateInstance.grabHCARateObj(testRate.Id))
                    .thenReturn(testRate);
        rateMocks.stopStubbing();

        rateMocks.startStubbing();
        rateMocks.when(rateInstance.updateRate(testRate))
                    .thenReturn(testRate);
        rateMocks.stopStubbing();

        fflib_ApexMocks rateHCAMocks = new fflib_ApexMocks(); 

        RateHCADAO.IRateHCADAO rateHCAInstance;
        rateHCAInstance = new MockDAOs.RateHCADAOMock(rateHCAMocks);  

        rateHCAMocks.startStubbing();
        rateHCAMocks.when(rateHCAInstance.grabRateHCAs(testRate.Id))
                    .thenReturn(rateHCAInsert);
        rateHCAMocks.stopStubbing();

        rateHCAMocks.startStubbing();
        rateHCAMocks.when(rateHCAInstance.upsertRateHCA(rateHCAInsert))
                    .thenReturn(rateHCAInsert);
        rateHCAMocks.stopStubbing();

		Test.startTest();

		ApexPages.StandardController sc2 = new ApexPages.StandardController(testRate);
		RatingMatrixHCAController ratingController = new RatingMatrixHCAController(sc2, rateInstance, rateHCAInstance);

		ratingController.rateDAOInstance = rateInstance;
		ratingController.rateHCADAOInstance = rateHCAInstance;
		
		ratingController.accountStructure = 'Employee Only';
		ratingController.hcscDivision = 'IL';
		ratingController.groupNumbers = '123';
		ratingController.healthCareAccount = 'HCA';
		ratingController.saveRateBackground();
		ratingController.addNewHCA();
		ratingController.saveNewRateRecord();
		ratingController.cancel();

		System.assertEquals(2, ratingController.rateHCAs.size());

		Test.stopTest();
	}

	@isTest static void testException(){
	
	try{	

		Account TestAcnt = new Account();
        TestAcnt.Id = fflib_IDGenerator.generate( Account.SObjectType );

		Opportunity opp = new Opportunity(AccountId = TestAcnt.id, HCSC_Division__c = 'IL', Name='oppName 3',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() - 1;         
        opp.Id = fflib_IDGenerator.generate( Opportunity.SObjectType );

		Secure_Information__c testSecure = new Secure_Information__c(Opportunity_Name__c = opp.Id);
		testSecure.Id = fflib_IDGenerator.generate( Secure_Information__c.SObjectType ); 

		Rate__c testRate = new Rate__c(Secure_Information__c = testSecure.Id);
		testRate.Id = fflib_IDGenerator.generate( Rate__c.SObjectType );

		PageReference pageRef = new PageReference('/apex/RatingMatrixHCA');
		pageRef.getParameters().put('state', 'IL');
		pageRef.getParameters().put('secure', '');
		Test.setCurrentPage(pageRef);

		fflib_ApexMocks rateMocks = new fflib_ApexMocks(); 

        RateDAO.IRateDAO rateInstance;
        rateInstance = new MockDAOs.RateDAOMock(rateMocks);  

        fflib_ApexMocks rateHCAMocks = new fflib_ApexMocks(); 

        RateHCADAO.IRateHCADAO rateHCAInstance;
        rateHCAInstance = new MockDAOs.RateHCADAOMock(rateHCAMocks);  

        Test.startTest(); 

		ApexPages.StandardController sc2 = new ApexPages.StandardController(testRate);
		RatingMatrixHCAController ratingController = new RatingMatrixHCAController(sc2, rateInstance, rateHCAInstance);

		ratingController.rateDAOInstance = rateInstance;
		ratingController.rateHCADAOInstance = rateHCAInstance;

		ratingController.saveRateBackground();

		}catch(Exception ex){

			System.assertEquals('System.NullPointerException: Attempt to de-reference a null object', ex.getMessage());
		}

		Test.stopTest();
	}
}