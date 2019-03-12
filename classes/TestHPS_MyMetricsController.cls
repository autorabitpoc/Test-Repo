@isTest
private class TestHPS_MyMetricsController {

    static testMethod void myUnitTest() {
        try{
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
            system.runAs(testUser){
                Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                testAccount.status__c = 'Active';
                testAccount.Fax = '1234567';
                testAccount.Active_Health_Members__c = 10;
                testAccount.Active_Dental_Members__c = 10;
                testAccount.X1_31_Account_Status__c = 'Active';
                testAccount.X1_31_Membership__c = 10;
                update testAccount;
                
                //create Opportunity records
                list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
                
                opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                opportunities[1].StageName = 'RFI Received';
                 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                opportunities[0].StageName = 'RFI Received';
                 opportunities[2].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                opportunities[2].StageName = 'RFI Received';
                 opportunities[3].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                opportunities[3].StageName = 'RFI Received';
                 opportunities[4].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                opportunities[4].StageName = 'RFI Received';
                 opportunities[5].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                opportunities[5].StageName = 'RFI Received';
                opportunities[0].Probability = 10;
                opportunities[1].Probability = 10;
                opportunities[2].Probability = 10;
                opportunities[3].Probability = 10;
                opportunities[4].Probability = 10;
                opportunities[5].Probability = 10;
                
                insert opportunities;
                
                
                //Initializing the Constructor
                HPS_MyMetricsController tempController = new HPS_MyMetricsController();
                //assert the size of the Task list
                System.assertEquals(tempController.medicalRecordsCount,10);
            }
        }catch(Exception e){
            throw e;
        }
    }
    static testMethod void myUnitTest1() {
        try{
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
            system.runAs(testUser){
                Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                testAccount.status__c = 'Sold';
                testAccount.Fax = '1234567';
                testAccount.Active_Health_Members__c = 10;
                testAccount.Active_Dental_Members__c = 10;
                testAccount.X1_31_Account_Status__c = 'Sold';
                testAccount.X1_31_Membership__c = 10;
                update testAccount;
                
                //create Opportunity records
                list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
                opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                opportunities[0].StageName = 'Prospective';
                
                opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                opportunities[1].StageName = 'Prospective';
                
                insert opportunities;
                
                //Initializing the Constructor
                HPS_MyMetricsController tempController = new HPS_MyMetricsController();
                //assert the size of the Task list
                System.assertEquals(tempController.medicalRecordsCount,0);
            }
        }catch(Exception e){
            
        }
    }
}