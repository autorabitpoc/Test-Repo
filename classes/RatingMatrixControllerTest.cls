/**************************************************************************************
  Apex Class Name     : RatingMatrixControllerTest
  Version             : 1.0
  Function            : This is a test class for the RatingMatrixController class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             6/1/2016
*************************************************************************************/
@isTest(SeeAllData=false)
private class RatingMatrixControllerTest { 

	@isTest static void ratingMatrixTest(){
		
		Account TestAcnt = new Account();
        TestAcnt.Id = fflib_IDGenerator.generate( Account.SObjectType );

		Opportunity opp = new Opportunity(AccountId = TestAcnt.id, HCSC_Division__c = 'IL', Name='oppName 3',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() - 1;         
        opp.Id = fflib_IDGenerator.generate( Opportunity.SObjectType );

		List<Product2> product = TestClassUtiltity.createProducts();
        product[0].Id = fflib_IDGenerator.generate( Product2.SObjectType ); 
        product[1].Id = fflib_IDGenerator.generate( Product2.SObjectType ); 
            
        List<Opportunity_Product__c> opptyProd = TestClassUtiltity.createOppProducts(opp.id,product[0].Id);
        opptyProd[0].Status__c = 'In Progress';
        opptyProd[0].Product_Type__c = 'New Sale';
        opptyProd[0].Id = fflib_IDGenerator.generate( Opportunity_Product__c.SObjectType ); 

		Secure_Information__c testSecure = new Secure_Information__c(Opportunity_Name__c = opp.Id);
		testSecure.Id = fflib_IDGenerator.generate( Secure_Information__c.SObjectType ); 

		Rate__c testRate = new Rate__c(Secure_Information__c = testSecure.Id);
		testRate.Id = fflib_IDGenerator.generate( Rate__c.SObjectType );

		List<Rate_Product__c> rateProdsInsert = new List<Rate_Product__c>();

		Rate_Product__c rateProd = new Rate_Product__c(Rate__c = testRate.Id);
		rateProd.Id = fflib_IDGenerator.generate( Rate_Product__c.SObjectType );

		rateProdsInsert.add(rateProd);

		PageReference pageRef = new PageReference('/apex/RatingMatrix');
		pageRef.getParameters().put('oid',  opp.Id);
		pageRef.getParameters().put('state', 'IL');
		pageRef.getParameters().put('secure', testSecure.Id);
		Test.setCurrentPage(pageRef);

		fflib_ApexMocks oppProductsMocks = new fflib_ApexMocks(); 

        OpportunityProductDAO.IOpportunityProductDAO opportunityProductInstance;
        opportunityProductInstance = new MockDAOs.OpportunityProductDAOMock(oppProductsMocks);  

        oppProductsMocks.startStubbing();
        oppProductsMocks.when(opportunityProductInstance.getRatingProducts(opp.Id))
                    .thenReturn(opptyProd);
        oppProductsMocks.stopStubbing();

       	fflib_ApexMocks rateMocks = new fflib_ApexMocks(); 

        RateDAO.IRateDAO rateInstance;
        rateInstance = new MockDAOs.RateDAOMock(rateMocks);  

        rateMocks.startStubbing();
        rateMocks.when(rateInstance.insertRate(testRate))
                    .thenReturn(testRate);
        rateMocks.stopStubbing();

        fflib_ApexMocks rateProductMocks = new fflib_ApexMocks(); 

        RateProductDAO.IRateProductDAO rateProductInstance;
        rateProductInstance = new MockDAOs.RateProductDAOMock(rateProductMocks);

        rateProductMocks.startStubbing();
        rateProductMocks.when(rateProductInstance.insertRateProducts(rateProdsInsert))
                    .thenReturn(rateProdsInsert);
        rateProductMocks.stopStubbing();   

		Test.startTest();

		ApexPages.StandardController sc2 = new ApexPages.StandardController(testRate);
		RatingMatrixController ratingController = new RatingMatrixController(sc2, opportunityProductInstance, rateInstance, rateProductInstance);

		ratingController.opportunityProductDAOInstance = opportunityProductInstance;
		ratingController.rateDAOInstance = rateInstance;
		ratingController.rateProductDAOInstance = rateProductInstance;

		System.assertEquals(1, ratingController.opportunityProds.size());

		ratingController.numberOfYears = 'One Year';
		ratingController.hcscDivision = 'IL';
		ratingController.otherRate = 'test';
		ratingController.rateStructure = 'Employee Only';
		ratingController.saveRateBackground();
		ratingController.saveNewRateRecord();
		ratingController.cancel();

		System.assertEquals(1, ratingController.rateProds.size());

		Test.stopTest();
	}

	@isTest static void ratingMatrixEditTest(){
		
		Account TestAcnt = new Account();
        TestAcnt.Id = fflib_IDGenerator.generate( Account.SObjectType );

		Opportunity opp = new Opportunity(AccountId = TestAcnt.id, HCSC_Division__c = 'IL', Name='oppName 3',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() - 1;         
        opp.Id = fflib_IDGenerator.generate( Opportunity.SObjectType );

		List<Product2> product = TestClassUtiltity.createProducts();
        product[0].Id = fflib_IDGenerator.generate( Product2.SObjectType ); 
        product[1].Id = fflib_IDGenerator.generate( Product2.SObjectType ); 
            
        List<Opportunity_Product__c> opptyProd = TestClassUtiltity.createOppProducts(opp.id,product[0].Id);
        opptyProd[0].Status__c = 'In Progress';
        opptyProd[0].Product_Type__c = 'New Sale';
        opptyProd[0].Id = fflib_IDGenerator.generate( Opportunity_Product__c.SObjectType ); 

		Secure_Information__c testSecure = new Secure_Information__c(Opportunity_Name__c = opp.Id);
		testSecure.Id = fflib_IDGenerator.generate( Secure_Information__c.SObjectType ); 

		Rate__c testRate = new Rate__c(Secure_Information__c = testSecure.Id);
		testRate.Id = fflib_IDGenerator.generate( Rate__c.SObjectType );

		List<Rate_Product__c> rateProdsInsert = new List<Rate_Product__c>();

		Rate_Product__c rateProd = new Rate_Product__c(Rate__c = testRate.Id);
		rateProd.Id = fflib_IDGenerator.generate( Rate_Product__c.SObjectType );

		rateProdsInsert.add(rateProd);

		PageReference pageRef = new PageReference('/apex/RatingMatrix');
		pageRef.getParameters().put('rateId',  testRate.Id);
		Test.setCurrentPage(pageRef);

		fflib_ApexMocks oppProductsMocks = new fflib_ApexMocks(); 

        OpportunityProductDAO.IOpportunityProductDAO opportunityProductInstance;
        opportunityProductInstance = new MockDAOs.OpportunityProductDAOMock(oppProductsMocks);

		fflib_ApexMocks rateMocks = new fflib_ApexMocks(); 

        RateDAO.IRateDAO rateInstance;
        rateInstance = new MockDAOs.RateDAOMock(rateMocks);  

        rateMocks.startStubbing();
        rateMocks.when(rateInstance.grabRateObj(testRate.Id))
                    .thenReturn(testRate);
        rateMocks.stopStubbing();

        rateMocks.startStubbing();
        rateMocks.when(rateInstance.updateRate(testRate))
                    .thenReturn(testRate);
        rateMocks.stopStubbing();

        fflib_ApexMocks rateProductMocks = new fflib_ApexMocks(); 

        RateProductDAO.IRateProductDAO rateProductInstance;
        rateProductInstance = new MockDAOs.RateProductDAOMock(rateProductMocks);  

        rateProductMocks.startStubbing();
        rateProductMocks.when(rateProductInstance.grabRateProducts(testRate.Id))
                    .thenReturn(rateProdsInsert);
        rateProductMocks.stopStubbing();

        rateProductMocks.startStubbing();
        rateProductMocks.when(rateProductInstance.updateRateProducts(rateProdsInsert))
                    .thenReturn(rateProdsInsert);
        rateProductMocks.stopStubbing();

		Test.startTest();

		ApexPages.StandardController sc2 = new ApexPages.StandardController(testRate);
		RatingMatrixController ratingController = new RatingMatrixController(sc2, opportunityProductInstance, rateInstance, rateProductInstance);

		ratingController.opportunityProductDAOInstance = opportunityProductInstance;
		ratingController.rateDAOInstance = rateInstance;
		ratingController.rateProductDAOInstance = rateProductInstance;

		System.assertEquals(1, ratingController.rateProds.size());

		ratingController.numberOfYears = 'One Year';
		ratingController.hcscDivision = 'IL';
		ratingController.otherRate = 'test';
		ratingController.rateStructure = 'Employee Only';
		ratingController.saveRateBackground();
		ratingController.otherRate = 'New Test';
		ratingController.saveNewRateRecord();
		ratingController.cancel();

		System.assertEquals('New Test', ratingController.otherRate);

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

		PageReference pageRef = new PageReference('/apex/RatingMatrix');
		pageRef.getParameters().put('state', 'IL');
		pageRef.getParameters().put('secure', '');
		Test.setCurrentPage(pageRef);

		fflib_ApexMocks oppProductsMocks = new fflib_ApexMocks(); 

        OpportunityProductDAO.IOpportunityProductDAO opportunityProductInstance;
        opportunityProductInstance = new MockDAOs.OpportunityProductDAOMock(oppProductsMocks);

		fflib_ApexMocks rateMocks = new fflib_ApexMocks(); 

        RateDAO.IRateDAO rateInstance;
        rateInstance = new MockDAOs.RateDAOMock(rateMocks);  

        fflib_ApexMocks rateProductMocks = new fflib_ApexMocks(); 

        RateProductDAO.IRateProductDAO rateProductInstance;
        rateProductInstance = new MockDAOs.RateProductDAOMock(rateProductMocks);  

        Test.startTest(); 

		ApexPages.StandardController sc2 = new ApexPages.StandardController(testRate);
		RatingMatrixController ratingController = new RatingMatrixController(sc2, opportunityProductInstance, rateInstance, rateProductInstance);

		ratingController.opportunityProductDAOInstance = opportunityProductInstance;
		ratingController.rateDAOInstance = rateInstance;
		ratingController.rateProductDAOInstance = rateProductInstance;

		ratingController.saveRateBackground();

		}catch(Exception ex){

			System.assertEquals('System.NullPointerException: Attempt to de-reference a null object', ex.getMessage());
		}

		Test.stopTest();
	}

}