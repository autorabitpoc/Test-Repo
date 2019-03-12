/**************************************************************************************
  Apex Class Name     : OpportunityDAOTest
  Version             : 1.0
  Function            : This is a test class for the OpportunityDAO class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             5/23/2016
*************************************************************************************/

@isTest(SeeAllData=false)
private class OpportunityDAOTest{

    
    static testMethod void opportunityDAOTest(){

        OpportunityDAO.IOpportunityDAO opportunityDAOInstance = new OpportunityDAO();

        Account testAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');

        Opportunity opp = new Opportunity(AccountId = testAcnt.Id, HCSC_Division__c = 'IL', Name='oppName 2',StageName = 'Expected In', CloseDate = system.Today().addYears(2), Expected_RFP_Release_Date__c = system.Today().addYears(1), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() + 1;    
        insert opp;


        Opportunity opportunityObj = opportunityDAOInstance.getOpportunityById(opp.Id);

        opportunityObj.HCSC_Division__c = 'TX';

        opportunityDAOInstance.updateOpportunity(opportunityObj);

        System.assert(opportunityObj != null);
        System.assertEquals('TX', opportunityObj.HCSC_Division__c);
    
    }

    static testMethod void  getOpportunitiesForCustomContractsCurrProdsTest(){
    	Account testAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');
    	
        Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
    	
    	Opportunity opp = new Opportunity(AccountId = testAcnt.Id, HCSC_Division__c = 'IL', Name='oppName 3',StageName = 'Expected In', CloseDate = system.Today().addYears(2), Expected_RFP_Release_Date__c = system.Today().addYears(1), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() - 1; 
        insert opp;
      
        set<id> oppId=new set<id>();
        oppId.add(opp.id);
        
        set<id> actId=new Set<id>();
        actId.add(testAcnt.id);
        
       Id retypeId =Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        
        List<Product2> testProducts = TestClassUtiltity.createProducts();
        testProducts[0].Non_Medical_Compensation__c = True;
        testProducts[0].Family='Network';
        testProducts[0].Product_Type__c='Medical';
		testProducts[0].HCSC_State__c='IL';
        testProducts[0].Product_Category__c='HMO';
        testProducts[0].NotSimple__c=false;
        testProducts[0].RecordtypeId=retypeId;
       // testProducts[0].Incumbent__c = testCompetitorAccount.Id;
        insert testProducts;
         
        List<Opportunity_Product__c> oppProd = TestClassUtiltity.createOppProducts(opp.Id, testProducts[0].Id);
        oppProd[0].Incumbent__c = testCompetitorAccount.Id;
        insert oppProd;
        
     //   opp.StageName='Won';
      //  opp.Date_Closed__c=System.today();
      //  update opp;
        
        OpportunityDAO.IOpportunityDAO oppIns = new OpportunityDAO();
        
        test.startTest();
        oppIns.getOpportunitiesForCustomContractsCurrProds(testAcnt.id, retypeId);
        oppIns.getOpportunitiesForProduct360(oppId);
        oppIns.getOpportunitiesByParentAccount(actId);
        oppIns.getOpportunitiesForCustomContractsActiveProds(testAcnt.id);
        test.stopTest();
    }
}