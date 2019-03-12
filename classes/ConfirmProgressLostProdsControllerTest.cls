/**************************************************************************************
  Apex Class Name     : ConfirmProgressLostProdsControllerTest
  Version             : 1.0
  Function            : This is a test class for the ConfirmProgressOnLostProductsController class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             5/23/2016
*************************************************************************************/

@isTest(SeeAllData=false)
private class ConfirmProgressLostProdsControllerTest {

    @isTest static void expectedMemberFieldTest() {

        Account testAccount = new Account();
        testAccount.Id = fflib_IDGenerator.generate( Account.SObjectType );

        Opportunity opp = new Opportunity(AccountId = testAccount.Id, HCSC_Division__c = 'IL', Name='oppName 2',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Id = fflib_IDGenerator.generate( Opportunity.SObjectType ); 
        opp.Requested_Effective_Date__c = System.Today() + 1; 

        list<Product2> products = TestClassUtiltity.createProducts();
        products[0].Id = fflib_IDGenerator.generate( Product2.SObjectType ); 
        products[1].Non_Medical_Compensation__c = True;
        products[1].Id = fflib_IDGenerator.generate( Product2.SObjectType ); 

        List<String> oppProdLostList = new List<String>();
        List<String> oppProdSelectedList = new List<String>();

        list<Opportunity_Product__c> oppProductsNew = new List<Opportunity_Product__c>();
        
        list<Opportunity_Product__c> oppProductsLostNew = new List<Opportunity_Product__c>();

        list<Opportunity_Product__c> oppProducts = TestClassUtiltity.createOppProducts(opp.Id,products[0].Id);
        oppProducts[0].Status__c = 'Won';
        oppProducts[0].Projected_Members__c = 100;
        oppProducts[0].Projected_Contracts__c = 100;
        oppProducts[0].Category__c = 'Medical';
        oppProducts[0].Id = fflib_IDGenerator.generate( Opportunity_Product__c.SObjectType ); 
        oppProdSelectedList.add(oppProducts[0].Id);
        oppProductsNew.add(oppProducts[0]);

        list<Opportunity_Product__c> oppProducts2 = TestClassUtiltity.createOppProducts(opp.Id,products[1].Id);
        oppProducts2[0].Status__c = 'Lost';
        oppProducts2[0].Category__c = 'Dental';
        oppProducts2[0].Id = fflib_IDGenerator.generate( Opportunity_Product__c.SObjectType ); 
        oppProdLostList.add(oppProducts2[0].Id);
        oppProductsLostNew.add(oppProducts2[0]);

        list<Opportunity_Product__c> oppProducts3 = TestClassUtiltity.createOppProducts(opp.Id,products[0].Id);
        oppProducts3[0].Status__c = 'Won';
        oppProducts3[0].Category__c = 'Dental';
        oppProducts3[0].Projected_Members__c = 100;
        oppProducts3[0].Projected_Contracts__c = 100;
        oppProducts3[0].Id = fflib_IDGenerator.generate( Opportunity_Product__c.SObjectType ); 
        oppProdSelectedList.add(oppProducts3[0].Id);
        oppProductsNew.add(oppProducts3[0]);

        PageReference pageRef = new PageReference('/apex/ConfirmProgressOnLostProducts');
        pageRef.getParameters().put('oid', opp.Id);
        pageRef.getParameters().put('ids', oppProducts2[0].Id);
        pageRef.getParameters().put('pids',oppProducts[0].Id + '-' + oppProducts3[0].Id);
        Test.setCurrentPage(pageRef); 

        fflib_ApexMocks oppMocks = new fflib_ApexMocks();

        OpportunityDAO.IOpportunityDAO opportunityInstance;
        opportunityInstance = new MockDAOs.OpportunityDAOMock(oppMocks);

        oppMocks.startStubbing();
        oppMocks.when(opportunityInstance.getOpportunityById(opp.Id))
                    .thenReturn(opp);
        oppMocks.stopStubbing();

        fflib_ApexMocks oppProductsMocks = new fflib_ApexMocks(); 

        OpportunityProductDAO.IOpportunityProductDAO opportunityProductInstance;
        opportunityProductInstance = new MockDAOs.OpportunityProductDAOMock(oppProductsMocks);  

        oppProductsMocks.startStubbing();
        oppProductsMocks.when(opportunityProductInstance.getLostProducts(oppProdLostList))
                    .thenReturn(oppProductsLostNew);
        oppProductsMocks.stopStubbing(); 

        oppProductsMocks.startStubbing();
        oppProductsMocks.when(opportunityProductInstance.getSelectedProducts(oppProdSelectedList))
                    .thenReturn(oppProductsNew);
        oppProductsMocks.stopStubbing();
        
        Test.startTest();

        ConfirmProgressOnLostProductsController confirmController = new ConfirmProgressOnLostProductsController(opportunityInstance, opportunityProductInstance);

        confirmController.opportunityDAOInstance = opportunityInstance;
        confirmController.opportunityProductDAOInstance = opportunityProductInstance;

        confirmController.getFields();
        confirmController.save();
        confirmController.cancel();

        System.assertEquals(100, confirmController.opportunityObj.Expected_Health_Members__c);
        System.assertEquals(100, confirmController.opportunityObj.Expected_Health_Contracts__c);
        System.assertEquals(100, confirmController.opportunityObj.Expected_Dental_Members__c);
        System.assertEquals(100, confirmController.opportunityObj.Expected_Dental_Contracts__c);

        System.assertEquals(1, confirmController.opProducts.size());

        Test.stopTest();
    }

    @isTest static void notNullExpectedFieldsTest() {
    
        Account testAccount = new Account();
        testAccount.Id = fflib_IDGenerator.generate( Account.SObjectType );
        
        Opportunity opp = new Opportunity(AccountId = testAccount.Id, HCSC_Division__c = 'IL', Name='oppName 2',StageName = 'Expected In', CloseDate = System.Today().addYears(2), Expected_RFP_Release_Date__c = System.Today().addYears(1), Expected_Decision_Date__c = System.Today().addYears(1), RFI_RFP_Received_Date__c = System.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Label.ProductTypeN).getRecordTypeId();
        opp.Requested_Effective_Date__c = System.Today() + 1;   
        opp.Id = fflib_IDGenerator.generate( Opportunity.SObjectType ); 
        opp.Expected_Health_Members__c = 50; 
        opp.Expected_Health_Contracts__c = 50; 
        opp.Expected_Dental_Members__c = 50; 
        opp.Expected_Dental_Contracts__c = 50;      

        list<Product2> products = TestClassUtiltity.createProducts();
        products[0].Id = fflib_IDGenerator.generate( Product2.SObjectType ); 
        products[1].Non_Medical_Compensation__c = True;
        products[1].Id = fflib_IDGenerator.generate( Product2.SObjectType ); 
        
        List<String> oppProdLostList = new List<String>();
        List<String> oppProdSelectedList = new List<String>();

        list<Opportunity_Product__c> oppProductsNew = new List<Opportunity_Product__c>();
        
        list<Opportunity_Product__c> oppProductsLostNew = new List<Opportunity_Product__c>();

        list<Opportunity_Product__c> oppProducts = TestClassUtiltity.createOppProducts(opp.Id,products[0].Id);
        oppProducts[0].Status__c = 'Won';
        oppProducts[0].Projected_Members__c = 100;
        oppProducts[0].Projected_Contracts__c = 100;
        oppProducts[0].Category__c = 'Medical';
        oppProducts[0].Id = fflib_IDGenerator.generate( Opportunity_Product__c.SObjectType ); 
        oppProdSelectedList.add(oppProducts[0].Id);
        oppProductsNew.add(oppProducts[0]);

        list<Opportunity_Product__c> oppProducts2 = TestClassUtiltity.createOppProducts(opp.Id,products[1].Id);
        oppProducts2[0].Status__c = 'Lost';
        oppProducts2[0].Category__c = 'Dental';
        oppProducts2[0].Id = fflib_IDGenerator.generate( Opportunity_Product__c.SObjectType ); 
        oppProdLostList.add(oppProducts2[0].Id);
        oppProductsLostNew.add(oppProducts2[0]);

        PageReference pageRef = new PageReference('/apex/ConfirmProgressOnLostProducts');
        pageRef.getParameters().put('oid', opp.Id);
        pageRef.getParameters().put('ids', oppProducts2[0].Id);
        pageRef.getParameters().put('pids', oppProducts[0].Id);
        Test.setCurrentPage(pageRef);

        fflib_ApexMocks oppMocks = new fflib_ApexMocks();

        OpportunityDAO.IOpportunityDAO opportunityInstance;
        opportunityInstance = new MockDAOs.OpportunityDAOMock(oppMocks);

        oppMocks.startStubbing();
        oppMocks.when(opportunityInstance.getOpportunityById(opp.Id))
                    .thenReturn(opp);
        oppMocks.stopStubbing();

        fflib_ApexMocks oppProductsMocks = new fflib_ApexMocks(); 

        OpportunityProductDAO.IOpportunityProductDAO opportunityProductInstance;
        opportunityProductInstance = new MockDAOs.OpportunityProductDAOMock(oppProductsMocks);  

        oppProductsMocks.startStubbing();
        oppProductsMocks.when(opportunityProductInstance.getLostProducts(oppProdLostList))
                    .thenReturn(oppProductsLostNew);
        oppProductsMocks.stopStubbing(); 

        oppProductsMocks.startStubbing();
        oppProductsMocks.when(opportunityProductInstance.getSelectedProducts(oppProdSelectedList))
                    .thenReturn(oppProductsNew);
        oppProductsMocks.stopStubbing();
        
        Test.startTest();

        ConfirmProgressOnLostProductsController confirmController = new ConfirmProgressOnLostProductsController(opportunityInstance, opportunityProductInstance);

        confirmController.opportunityDAOInstance = opportunityInstance;
        confirmController.opportunityProductDAOInstance = opportunityProductInstance;

        confirmController.save();

        System.assertEquals(50, confirmController.opportunityObj.Expected_Health_Members__c);
        System.assertEquals(50, confirmController.opportunityObj.Expected_Health_Contracts__c);
        System.assertEquals(50, confirmController.opportunityObj.Expected_Dental_Members__c);
        System.assertEquals(50, confirmController.opportunityObj.Expected_Dental_Contracts__c);

        Test.stopTest();
    }
}