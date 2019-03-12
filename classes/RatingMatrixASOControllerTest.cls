/**************************************************************************************
  Apex Class Name     : RatingMatrixASOControllerTest
  Version             : 1.0
  Function            : This is a test class for the RatingMatrixASOController class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             6/6/2016
*************************************************************************************/
@isTest(SeeAllData=false)
private class RatingMatrixASOControllerTest { 

	@isTest static void ratingMatrixASOTest(){
		
		Account TestAcnt = new Account();
        TestAcnt.Name = 'Test1';
        insert TestAcnt;

		Opportunity opp = new Opportunity(AccountId = TestAcnt.id, HCSC_Division__c = 'IL', Name='oppName 3',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() - 1;         
        insert opp;

		Secure_Information__c testSecure = new Secure_Information__c(Opportunity_Name__c = opp.Id);
		insert testSecure;

		Rate__c testRate = new Rate__c(Secure_Information__c = testSecure.Id);
		testRate.Id = fflib_IDGenerator.generate( Rate__c.SObjectType );

		List<Rate_Group__c> rateGroupInsert = new List<Rate_Group__c>();

		Rate_Group__c testRateGroup = new Rate_Group__c(Rate__c = testRate.Id);
		testRateGroup.Id = fflib_IDGenerator.generate( Rate_Group__c.SObjectType );

		rateGroupInsert.add(testRateGroup);

		List<Rate_Admin_Charge__c> rateAdminChargeInsert = new List<Rate_Admin_Charge__c>();

		Rate_Admin_Charge__c testRateAdminCharge = new Rate_Admin_Charge__c(Rate__C = testRate.Id);
		testRateAdminCharge.Id = fflib_IDGenerator.generate( Rate_Admin_Charge__c.SObjectType );

		rateAdminChargeInsert.add(testRateAdminCharge);

		PageReference pageRef = new PageReference('/apex/RatingMatrixASO');
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

        fflib_ApexMocks rateGroupMocks = new fflib_ApexMocks(); 

        RateGroupDAO.IRateGroupDAO rateGroupInstance;
        rateGroupInstance = new MockDAOs.RateGroupDAOMock(rateGroupMocks);  

        rateGroupMocks.startStubbing();
        rateGroupMocks.when(rateGroupInstance.insertRateGroup(rateGroupInsert))
                    .thenReturn(rateGroupInsert);
        rateGroupMocks.stopStubbing();

        fflib_ApexMocks rateAdminChargeMocks = new fflib_ApexMocks();

        RateAdminChargeDAO.IRateAdminChargeDAO rateAdminChargeInstance;
        rateAdminChargeInstance = new MockDAOs.RateAdminChargeDAOMock(rateAdminChargeMocks);  

        rateAdminChargeMocks.startStubbing();
        rateAdminChargeMocks.when(rateAdminChargeInstance.insertRateAdminCharge(rateAdminChargeInsert))
                    .thenReturn(rateAdminChargeInsert);
        rateAdminChargeMocks.stopStubbing();

        RateTermDAO.IRateTermDAO rateTermDAOInstance;

		Test.startTest();

		ApexPages.StandardController sc2 = new ApexPages.StandardController(testRate);
		RatingMatrixASOController ratingASOController = new RatingMatrixASOController(sc2, rateInstance, rateGroupInstance, rateAdminChargeInstance, rateTermDAOInstance);

		ratingASOController.rateDAOInstance = rateInstance;
		ratingASOController.rateGroupDAOInstance = rateGroupInstance;
		ratingASOController.rateAdminChargeDAOInstance = rateAdminChargeInstance;
		ratingASOController.rateTermDAOInstance = rateTermDAOInstance;

		ratingASOController.hcscDivision = 'IL';
		ratingASOController.saveRateBackground();
		ratingASOController.saveNewRateRecord();
		ratingASOController.cancel();	

		System.assertEquals(12, ratingASOController.rateGroups.size());		

		System.assertEquals(6, ratingASOController.rateAdminCharges.size());

		Test.stopTest();
	}

	@isTest static void ratingMatrixASOTestDiffState(){
		
		Account TestAcnt = new Account();
        TestAcnt.Id = fflib_IDGenerator.generate( Account.SObjectType );

		Opportunity opp = new Opportunity(AccountId = TestAcnt.id, HCSC_Division__c = 'IL', Name='oppName 3',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() - 1;         
        opp.Id = fflib_IDGenerator.generate( Opportunity.SObjectType );

		Secure_Information__c testSecure = new Secure_Information__c(Opportunity_Name__c = opp.Id);
		testSecure.Id = fflib_IDGenerator.generate( Secure_Information__c.SObjectType ); 

		Rate__c testRate = new Rate__c(Secure_Information__c = testSecure.Id);
		testRate.Id = fflib_IDGenerator.generate( Rate__c.SObjectType );

		List<Rate_Group__c> rateGroupInsert = new List<Rate_Group__c>();

		Rate_Group__c testRateGroup = new Rate_Group__c(Rate__c = testRate.Id);
		testRateGroup.Id = fflib_IDGenerator.generate( Rate_Group__c.SObjectType );

		rateGroupInsert.add(testRateGroup);

		List<Rate_Admin_Charge__c> rateAdminChargeInsert = new List<Rate_Admin_Charge__c>();

		Rate_Admin_Charge__c testRateAdminCharge = new Rate_Admin_Charge__c(Rate__C = testRate.Id);
		testRateAdminCharge.Id = fflib_IDGenerator.generate( Rate_Admin_Charge__c.SObjectType );

		rateAdminChargeInsert.add(testRateAdminCharge);

		PageReference pageRef = new PageReference('/apex/RatingMatrixASO');
		pageRef.getParameters().put('state', 'TX');
		pageRef.getParameters().put('secure', testSecure.Id);
		Test.setCurrentPage(pageRef);

		fflib_ApexMocks rateMocks = new fflib_ApexMocks(); 

        RateDAO.IRateDAO rateInstance;
        rateInstance = new MockDAOs.RateDAOMock(rateMocks);  

        rateMocks.startStubbing();
        rateMocks.when(rateInstance.insertRate(testRate))
                    .thenReturn(testRate);
        rateMocks.stopStubbing();

        fflib_ApexMocks rateGroupMocks = new fflib_ApexMocks(); 

        RateGroupDAO.IRateGroupDAO rateGroupInstance;
        rateGroupInstance = new MockDAOs.RateGroupDAOMock(rateGroupMocks);  

        rateGroupMocks.startStubbing();
        rateGroupMocks.when(rateGroupInstance.insertRateGroup(rateGroupInsert))
                    .thenReturn(rateGroupInsert);
        rateGroupMocks.stopStubbing();

        fflib_ApexMocks rateAdminChargeMocks = new fflib_ApexMocks();

        RateAdminChargeDAO.IRateAdminChargeDAO rateAdminChargeInstance;
        rateAdminChargeInstance = new MockDAOs.RateAdminChargeDAOMock(rateAdminChargeMocks);  

        rateAdminChargeMocks.startStubbing();
        rateAdminChargeMocks.when(rateAdminChargeInstance.insertRateAdminCharge(rateAdminChargeInsert))
                    .thenReturn(rateAdminChargeInsert);
        rateAdminChargeMocks.stopStubbing();

        RateTermDAO.IRateTermDAO rateTermDAOInstance;

		Test.startTest();

		ApexPages.StandardController sc2 = new ApexPages.StandardController(testRate);
		RatingMatrixASOController ratingASOController = new RatingMatrixASOController(sc2, rateInstance, rateGroupInstance, rateAdminChargeInstance, rateTermDAOInstance);

		ratingASOController.rateDAOInstance = rateInstance;
		ratingASOController.rateGroupDAOInstance = rateGroupInstance;
		ratingASOController.rateAdminChargeDAOInstance = rateAdminChargeInstance;
		ratingASOController.rateTermDAOInstance = rateTermDAOInstance;

		ratingASOController.hcscDivision = 'TX';
		ratingASOController.saveRateBackground();
		ratingASOController.saveNewRateRecord();
		ratingASOController.cancel();	

		System.assertEquals(13, ratingASOController.rateGroups.size());		

		System.assertEquals(6, ratingASOController.rateAdminCharges.size());

		Test.stopTest();
	}

	@isTest static void ratingMatrixASOEditTest(){
		
		Account TestAcnt = new Account();
        TestAcnt.Name = 'Test1';
        insert TestAcnt;

		Opportunity opp = new Opportunity(AccountId = TestAcnt.id, HCSC_Division__c = 'IL', Name='oppName 3',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() - 1;         
        insert opp;

		Secure_Information__c testSecure = new Secure_Information__c(Opportunity_Name__c = opp.Id);
		insert testSecure; 

		Rate__c testRate = new Rate__c(Secure_Information__c = testSecure.Id);
		testRate.Id = fflib_IDGenerator.generate( Rate__c.SObjectType );

		List<Rate_Group__c> rateGroupInsert = new List<Rate_Group__c>();

		Rate_Group__c testRateGroup = new Rate_Group__c(Rate__c = testRate.Id);
		testRateGroup.Id = fflib_IDGenerator.generate( Rate_Group__c.SObjectType );

		rateGroupInsert.add(testRateGroup);

		List<Rate_Admin_Charge__c> rateAdminChargeInsert = new List<Rate_Admin_Charge__c>();

		Rate_Admin_Charge__c testRateAdminCharge = new Rate_Admin_Charge__c(Rate__C = testRate.Id);
		testRateAdminCharge.Id = fflib_IDGenerator.generate( Rate_Admin_Charge__c.SObjectType );

		rateAdminChargeInsert.add(testRateAdminCharge);

		PageReference pageRef = new PageReference('/apex/RatingMatrixASO');
		pageRef.getParameters().put('rateId',  testRate.Id);
		Test.setCurrentPage(pageRef);

		fflib_ApexMocks rateMocks = new fflib_ApexMocks(); 

        RateDAO.IRateDAO rateInstance;
        rateInstance = new MockDAOs.RateDAOMock(rateMocks);  

        rateMocks.startStubbing();
        rateMocks.when(rateInstance.grabASORateObj(testRate.Id))
                    .thenReturn(testRate);
        rateMocks.stopStubbing();

        rateMocks.startStubbing();
        rateMocks.when(rateInstance.updateRate(testRate))
                    .thenReturn(testRate);
        rateMocks.stopStubbing();

        fflib_ApexMocks rateGroupMocks = new fflib_ApexMocks(); 

        RateGroupDAO.IRateGroupDAO rateGroupInstance;
        rateGroupInstance = new MockDAOs.RateGroupDAOMock(rateGroupMocks);  

        rateGroupMocks.startStubbing();
        rateGroupMocks.when(rateGroupInstance.grabRateGroups(testRate.Id))
                    .thenReturn(rateGroupInsert);
        rateGroupMocks.stopStubbing();
        
        rateGroupMocks.startStubbing();
        rateGroupMocks.when(rateGroupInstance.upsertRateGroup(rateGroupInsert))
                    .thenReturn(rateGroupInsert);
        rateGroupMocks.stopStubbing();

        fflib_ApexMocks rateAdminChargeMocks = new fflib_ApexMocks();

        RateAdminChargeDAO.IRateAdminChargeDAO rateAdminChargeInstance;
        rateAdminChargeInstance = new MockDAOs.RateAdminChargeDAOMock(rateAdminChargeMocks);  

        rateAdminChargeMocks.startStubbing();
        rateAdminChargeMocks.when(rateAdminChargeInstance.grabRateAdminCharges(testRate.Id))
                    .thenReturn(rateAdminChargeInsert);
        rateAdminChargeMocks.stopStubbing();

        rateAdminChargeMocks.startStubbing();
        rateAdminChargeMocks.when(rateAdminChargeInstance.upsertRateAdminCharge(rateAdminChargeInsert))
                    .thenReturn(rateAdminChargeInsert);
        rateAdminChargeMocks.stopStubbing();

        RateTermDAO.IRateTermDAO rateTermDAOInstance;

		Test.startTest();

		ApexPages.StandardController sc2 = new ApexPages.StandardController(testRate);
		RatingMatrixASOController ratingASOController = new RatingMatrixASOController(sc2, rateInstance, rateGroupInstance, rateAdminChargeInstance, rateTermDAOInstance);

		ratingASOController.rateDAOInstance = rateInstance;
		ratingASOController.rateGroupDAOInstance = rateGroupInstance;
		ratingASOController.rateAdminChargeDAOInstance = rateAdminChargeInstance;
		ratingASOController.rateTermDAOInstance = rateTermDAOInstance;

		ratingASOController.hcscDivision = 'TX';		
		ratingASOController.saveRateBackground();	
		ratingASOController.hcscDivision = 'MT';	
		ratingASOController.saveNewRateRecord();
		ratingASOController.cancel();
		
		System.assertEquals('MT', ratingASOController.hcscDivision);		

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

		PageReference pageRef = new PageReference('/apex/RatingMatrixASO');
		pageRef.getParameters().put('state', 'IL');
		pageRef.getParameters().put('secure', '');
		Test.setCurrentPage(pageRef);

		fflib_ApexMocks rateMocks = new fflib_ApexMocks(); 

        RateDAO.IRateDAO rateInstance;
        rateInstance = new MockDAOs.RateDAOMock(rateMocks);  

        fflib_ApexMocks rateGroupMocks = new fflib_ApexMocks(); 

        RateGroupDAO.IRateGroupDAO rateGroupInstance;
        rateGroupInstance = new MockDAOs.RateGroupDAOMock(rateGroupMocks);  

        fflib_ApexMocks rateAdminChargeMocks = new fflib_ApexMocks();

        RateAdminChargeDAO.IRateAdminChargeDAO rateAdminChargeInstance;
        rateAdminChargeInstance = new MockDAOs.RateAdminChargeDAOMock(rateAdminChargeMocks); 

        RateTermDAO.IRateTermDAO rateTermDAOInstance;

        Test.startTest(); 

		ApexPages.StandardController sc2 = new ApexPages.StandardController(testRate);
		RatingMatrixASOController ratingASOController = new RatingMatrixASOController(sc2, rateInstance, rateGroupInstance, rateAdminChargeInstance, rateTermDAOInstance);

		ratingASOController.rateDAOInstance = rateInstance;
		ratingASOController.rateGroupDAOInstance = rateGroupInstance;
		ratingASOController.rateAdminChargeDAOInstance = rateAdminChargeInstance;
		ratingASOController.rateTermDAOInstance = rateTermDAOInstance;

		ratingASOController.hcscDivision = 'OK';
		ratingASOController.saveRateBackground();

		}catch(Exception ex){

			System.assertEquals('System.NullPointerException: Attempt to de-reference a null object', ex.getMessage());
		}

		Test.stopTest();
	}

}