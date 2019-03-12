@isTest(seeAllData=false)
private class TestProductTracking {
    
    @isTest static void TestInsertProductTracking(){
        
        Account theAccount = new Account();
        theAccount.Name = 'My Test Account';
        theAccount.Fax = '1234567';
        theAccount.Effective_Date__c = system.today().addyears(2);
        theAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        insert theAccount;
        
        Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
        
        Account theWinner = new Account();
        theWinner.Name = 'My Competitor Account';
        theWinner.Fax = '7654321';
        theWinner.Effective_Date__c = system.today().addyears(2);
        theWinner.Type = 'Competitor Account';
        theWinner.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        insert theWinner;        
        
        Contact theContact = new Contact();
        theContact.FirstName = 'John';
        theContact.LastName = 'Doe';
        theContact.Account__c = theAccount.Id;        
        insert theContact;
        
        AccountContactRole theACR = new AccountContactRole();
        theACR.AccountId = theAccount.Id;
        theACR.ContactId = theContact.Id;
        theACR.IsPrimary = true;
        theACR.Role = 'Producer';
        insert theACR;
        
        Id OppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        Opportunity theOpportunity = new Opportunity();
        theOpportunity.AccountId = theAccount.Id;
        theOpportunity.Name = 'oppName 1';
        theOpportunity.StageName = 'RFI Received';
        theOpportunity.CloseDate = system.Today().addYears(2);
        theOpportunity.Expected_Decision_Date__c = system.Today().addYears(1);
        theOpportunity.RFI_RFP_Received_Date__c = system.Today().addYears(1);        
        insert theOpportunity;
        
        Id ProductrecTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC BlueStar Product').getRecordTypeId();
        Product2 theProduct = new Product2();
        theProduct.Name = 'RX';
        theProduct.IsActive = true;
        theProduct.Product_Category__c = 'Pharmacy';
        theProduct.Family = 'Ancillary and other';
        theProduct.RecordTypeId = ProductrecTypeId;
        theProduct.Product_Type__c = 'Non-Medical';
        theProduct.Simplified_Product__c = 'RX';
        insert theProduct;      
        
        Opportunity_Product__c aOpportunityProduct = new Opportunity_Product__c();
        aOpportunityProduct.Opportunity_Name__c = theOpportunity.Id;
        aOpportunityProduct.Product__c = theProduct.Id;
        aOpportunityProduct.Status__c = 'Lost';
        aOpportunityProduct.Incumbent__c = testCompetitorAccount.Id;
        aOpportunityProduct.Account__c = theWinner.Id;
        insert aOpportunityProduct;
        
        Product_Tracking__c theProductTracking = new Product_Tracking__c();
        theProductTracking.Opportunity_Product__c = aOpportunityProduct.Id; 
        theProductTracking.Consultant__c = null; /*setting null to test that its populated by Trigger */
               
        test.startTest();
        
        insert theProductTracking;        
        Product_Tracking__c afterTriggerProductTracking = [SELECT Id, Consultant__c
                                                           FROM Product_Tracking__c 
                                                           WHERE Id = :theProductTracking.Id];
        system.assertEquals(afterTriggerProductTracking.Consultant__c,theContact.Id);                
        
        theProductTracking.PBMCarrier__c = theWinner.Id;                      
        update theProductTracking;        
        Opportunity_Product__c afterTriggerOpportunityProduct = [SELECT Id, Account__c
                                                                 FROM Opportunity_Product__c
                                                                 WHERE Id = :aOpportunityProduct.Id];        
        system.assertEquals(afterTriggerOpportunityProduct.Account__c, theProductTracking.PBMCarrier__c); 
        
        test.stopTest();
        
        
    }
    
    
}