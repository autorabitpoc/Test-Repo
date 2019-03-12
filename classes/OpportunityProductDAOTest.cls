/**************************************************************************************
  Apex Class Name     : OpportunityProductDAOTest
  Version             : 1.0
  Function            : This is a test class for the OpportunityProductDAO class
* Developer                        Date
* ----------------------------------------------------------------------------
* Nick Serafin/Slalom             5/23/2016
*************************************************************************************/

@isTest(SeeAllData = false)
private class OpportunityProductDAOTest {

    @isTest
    static void opportunityProductDAOTest() {

        OpportunityProductDAO.IOpportunityProductDAO opportunityProductDAOInstance = new OpportunityProductDAO();

        Account testAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');
        
        Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);

        Opportunity opp = new Opportunity(AccountId = testAcnt.Id, HCSC_Division__c = 'IL', Name = 'oppName 2', StageName = 'Expected In', CloseDate = system.Today().addYears(2), Expected_RFP_Release_Date__c = system.Today().addYears(1), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() + 1;
        insert opp;

        list<Product2> products = TestClassUtiltity.createProducts();
        products[1].Non_Medical_Compensation__c = True;
        insert products;

        list<Opportunity_Product__c> oppProd = TestClassUtiltity.createOppProducts(opp.Id, products[0].Id);
        oppProd[0].Status__c = 'Won';
        oppProd[0].Projected_Members__c = 100;
        oppProd[0].Projected_Contracts__c = 100;
        oppProd[0].Category__c = 'Medical';
        oppProd[0].Product_Type__c = 'New Sale';
        oppProd[0].Incumbent__c = testCompetitorAccount.Id;
        insert oppProd;

        Id vendorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
      	Account testVendorAccount = TestClassUtiltity.createAccountWithRecType('Test Account', vendorAccountRecordTypeId);

        list<Opportunity_Product__c> oppProd2 = TestClassUtiltity.createOppProducts(opp.Id, products[1].Id);
        oppProd2[0].Status__c = 'Lost';
        oppProd2[0].Category__c = 'Dental';
        oppProd2[0].Product_Type__c = 'New Sale';
        oppProd2[0].Projected_Members__c = 100;
        oppProd2[0].Account__c = testVendorAccount.Id;
        oppProd2[0].Incumbent__c = testCompetitorAccount.Id;

        insert oppProd2;

        List<String> oppProdIdList = new List<String>();
        List<String> oppIdList = new List<String>();

        oppProdIdList.add(oppProd[0].Id);
        oppProdIdList.add(oppProd2[0].Id);
        
        oppIdList.add(opp.Id);

        List<Opportunity_Product__c> lostProducts = opportunityProductDAOInstance.getLostProducts(oppProdIdList);
        List<Opportunity_Product__c> selectedProducts = opportunityProductDAOInstance.getSelectedProducts(oppProdIdList);
        List<Opportunity_Product__c> rateProducts = opportunityProductDAOInstance.getRatingProducts(opp.Id);
        List<AggregateResult> aggregateOpportunityProducts = opportunityProductDAOInstance.getAggregateOpportunityProductByIds(oppIdList);
  
        lostProducts[0].Projected_Members__c = 10;

        opportunityProductDAOInstance.updateOpportunityProducts(lostProducts);

        System.assert(lostProducts != null);
        System.assert(selectedProducts != null);
        System.assertEquals(10, lostProducts[0].Projected_Members__c);
        System.assertEquals(2, rateProducts.size());
        System.assert(!aggregateOpportunityProducts.isEmpty());
        System.assertEquals(1, aggregateOpportunityProducts.size());
        System.assertEquals(200.0, aggregateOpportunityProducts[0].get('noOfProjectedMembers'));
        System.assertNotEquals(null, aggregateOpportunityProducts[0].get('opportunityName'));

    }
}