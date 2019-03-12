@isTest
private class ProspectingAppNewProdGrpAssocCtrlTest {
    @testSetup
    static void setupData() {
        Account testProducerAccount = new Account();
        testProducerAccount.Name = 'Test Producer Account';
        testProducerAccount.RecordTypeId = [Select Id, SobjectType, DeveloperName From RecordType WHERE DeveloperName ='Producer_Account' and SobjectType ='Account'  limit 1].Id;
        
        Account testGroupAccount = new Account();
        testGroupAccount.Name = 'Test Group Account';
        testGroupAccount.RecordTypeId = [Select Id, SobjectType, DeveloperName From RecordType WHERE DeveloperName ='Group_Account' and SobjectType ='Account'  limit 1].Id;
        
        List<Account> testAccounts = new List<account>();
        testAccounts.add(testProducerAccount);
        testAccounts.add(testGroupAccount);
        
        insert testAccounts;
        
        Producer_Group_Association__c testPGA = new Producer_Group_Association__c();
        testPGA.Group_Account__c = testGroupAccount.Id;
        testPGA.Producer_Account__c = testProducerAccount.Id;
        testPGA.Primary__c = true;
        insert testPGA;
    }
    
    static testMethod void testSaveProdGroupAssoc() {
        Account testGroupAccount = [SELECT Id FROM Account WHERE Name='Test Group Account'];
        
        Producer_Group_Association__c testPGA = [SELECT Id, Producer_Account__r.Name, Producer_Type__c, Primary__c 
                                                 FROM Producer_Group_Association__c WHERE Group_Account__c=:testGroupAccount.Id];
        testPGA.Primary__c = false;
        ProspectingAppNewProdGrpAssocController.saveProdGroupAssoc(testPGA);
        
        testPGA = [SELECT Id, Producer_Account__r.Name, Producer_Type__c, Primary__c 
                   FROM Producer_Group_Association__c WHERE Group_Account__c=:testGroupAccount.Id];
        
        System.assertEquals(false, testPGA.Primary__c);
    }
}