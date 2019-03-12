@isTest
global class TaskCreationInvocableMethodTest {
    
    /* method to test that the Account Executive is listed on the Account is used for Task */
    private static TestMethod void AccountExecutiveOnAccount(){

        /* create Users */
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        Id ProfileId = p.Id;
        User TestUser1 = new User(Alias = 'test1',Email='standarduser1@testorg.com',EmailEncodingKey = 'UTF-8',FirstName='Standard',LastName='User1',LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId=ProfileId,TimeZoneSidKey='America/Los_Angeles',UserName='Test1234standarduser1@testorg.com');
        insert TestUser1;
        system.debug('TestUser1: ' + TestUser1);
        User TestUser2 = new User(Alias = 'test2',Email='standarduser2@testorg.com',EmailEncodingKey = 'UTF-8',FirstName='Standard',LastName='User2',LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId=ProfileId,TimeZoneSidKey='America/Los_Angeles',UserName='Test1234standarduser2@testorg.com');
        insert TestUser2;
        User TestUser3 = new User(Alias = 'test3',Email='standarduser3@testorg.com',EmailEncodingKey = 'UTF-8',FirstName='Standard',LastName='User3',LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId=ProfileId,TimeZoneSidKey='America/Los_Angeles',UserName='Test1234standarduser3@testorg.com');
        insert TestUser3;  
        
        User AfterInsertUser1 = [SELECT Id, Name FROM User WHERE Id = :TestUser1.Id LIMIT 1];
        
        /* create Account */
        Account TestAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');
        TestAcnt.Account_Cluster_Name__c = AfterInsertUser1.Name;
        system.debug('TestAcnt.Account_Cluster_Name__c: ' + TestAcnt.Account_Cluster_Name__c );
        TestAcnt.OwnerId = TestUser2.Id;        
        update TestAcnt;
        
        /* create Opportunity */
        Opportunity TestOpp = TestClassUtiltity.newOpportunity(TestAcnt.Id,'Test Opportunity'); 
        TestOpp.Expected_RFP_Release_Date__c = Date.today();
        insert TestOpp;
        
        /* create Opportunity Team Member */
        List<OpportunityTeamMember> TestOppTeam = TestClassUtiltity.createOppTeamMember(String.valueOf(TestOpp.Id),String.valueOf(TestUser3.Id));
        TestOppTeam[0].TeamMemberRole = 'Account Executive';
        Insert TestOppTeam;
        
        Test.startTest();
        
        List<TaskCreationInvocableMethod.TaskCreationRequestWrapper> requests = new List<TaskCreationInvocableMethod.TaskCreationRequestWrapper>();

        TaskCreationInvocableMethod.TaskCreationRequestWrapper request = new TaskCreationInvocableMethod.TaskCreationRequestWrapper();

        request.TaskCreationProcess = 'OpportunityWonCreateATaskForAccountExecutive';
        request.TaskRecordTypeName = 'Account Setup Maintenance Task';
        request.OpportunityID = TestOpp.Id;
        request.TaskPriority = 'High';
        request.TaskStatus = 'New';
        request.TaskSubject = 'Other';
        Date TwoDaysFromNow = Date.today();
        request.TaskFollowUpDate = TwoDaysFromNow.addDays(2);
        request.TaskType = 'Create a Contract Admin Case';

        requests.add(request);
        
        TaskCreationInvocableMethod.CreateATask(requests);
        
        Test.stopTest();
        
        List<Task> NewTask = [SELECT Id, OwnerId 
                             FROM Task
                             WHERE
                             Subject = 'Other' AND
                             Priority = 'High' AND
                             Type = 'Create a Contract Admin Case' AND
                             WhatId = :TestOpp.Id AND
                             OwnerId = :TestUser1.Id];
        
        System.assertEquals(1, NewTask.size());
        
    }

    /* method to test that the Account Executive is listed on the Opportunity Team is used for Task */
    private static TestMethod void AccountExecutiveOnOpportunityTeam(){

        /* create Users */
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        Id ProfileId = p.Id;
        User TestUser1 = new User(Alias = 'test1',Email='standarduser1@testorg.com',EmailEncodingKey = 'UTF-8',FirstName='Standard',LastName='User1',LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId=ProfileId,TimeZoneSidKey='America/Los_Angeles',UserName='Test1234standarduser1@testorg.com');
        insert TestUser1;        
        User TestUser2 = new User(Alias = 'test2',Email='standarduser2@testorg.com',EmailEncodingKey = 'UTF-8',FirstName='Standard',LastName='User2',LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId=ProfileId,TimeZoneSidKey='America/Los_Angeles',UserName='Test1234standarduser2@testorg.com');
        insert TestUser2;
        User TestUser3 = new User(Alias = 'test3',Email='standarduser3@testorg.com',EmailEncodingKey = 'UTF-8',FirstName='Standard',LastName='User3',LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId=ProfileId,TimeZoneSidKey='America/Los_Angeles',UserName='Test1234standarduser3@testorg.com');
        insert TestUser3;        
                
        /* create Account */
        Account TestAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');
        TestAcnt.Account_Cluster_Name__c = '';
        system.debug('TestAcnt.Account_Cluster_Name__c: ' + TestAcnt.Account_Cluster_Name__c );
        TestAcnt.OwnerId = TestUser3.Id;        
        update TestAcnt;
        
        /* create Opportunity */
        Opportunity TestOpp = TestClassUtiltity.newOpportunity(TestAcnt.Id,'Test Opportunity'); 
        TestOpp.Expected_RFP_Release_Date__c = Date.today();
        insert TestOpp;
        
        /* create Opportunity Team Member */
        List<OpportunityTeamMember> TestOppTeam = TestClassUtiltity.createOppTeamMember(String.valueOf(TestOpp.Id),String.valueOf(TestUser2.Id));
        TestOppTeam[0].TeamMemberRole = 'Account Executive';
        Insert TestOppTeam;
        
        Test.startTest();
        
        List<TaskCreationInvocableMethod.TaskCreationRequestWrapper> requests = new List<TaskCreationInvocableMethod.TaskCreationRequestWrapper>();

        TaskCreationInvocableMethod.TaskCreationRequestWrapper request = new TaskCreationInvocableMethod.TaskCreationRequestWrapper();

        request.TaskCreationProcess = 'OpportunityWonCreateATaskForAccountExecutive';
        request.TaskRecordTypeName = 'Account Setup Maintenance Task';
        request.OpportunityID = TestOpp.Id;
        request.TaskPriority = 'High';
        request.TaskStatus = 'New';
        request.TaskSubject = 'Other';
        Date TwoDaysFromNow = Date.today();
        request.TaskFollowUpDate = TwoDaysFromNow.addDays(2);
        request.TaskType = 'Create a Contract Admin Case';

        requests.add(request);
        
        TaskCreationInvocableMethod.CreateATask(requests);
        
        Test.stopTest();
        
        List<Task> NewTask = [SELECT Id, OwnerId 
                             FROM Task
                             WHERE
                             Subject = 'Other' AND
                             Priority = 'High' AND
                             Type = 'Create a Contract Admin Case' AND
                             WhatId = :TestOpp.Id AND
                             OwnerId = :TestUser2.Id];
        
        System.assertEquals(1, NewTask.size());
        
    }

    /* method to test that the Account Executive is listed on the Account as Owner is used for Task */
    private static TestMethod void AccountExecutiveOnAccountAsOwner(){

        /* create Users */
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        Id ProfileId = p.Id;
        User TestUser1 = new User(Alias = 'test1',Email='standarduser1@testorg.com',EmailEncodingKey = 'UTF-8',FirstName='Standard',LastName='User1',LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId=ProfileId,TimeZoneSidKey='America/Los_Angeles',UserName='Test1234standarduser1@testorg.com');
        insert TestUser1;        
        User TestUser2 = new User(Alias = 'test2',Email='standarduser2@testorg.com',EmailEncodingKey = 'UTF-8',FirstName='Standard',LastName='User2',LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId=ProfileId,TimeZoneSidKey='America/Los_Angeles',UserName='Test1234standarduser2@testorg.com');
        insert TestUser2;
        User TestUser3 = new User(Alias = 'test3',Email='standarduser3@testorg.com',EmailEncodingKey = 'UTF-8',FirstName='Standard',LastName='User3',LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId=ProfileId,TimeZoneSidKey='America/Los_Angeles',UserName='Test1234standarduser3@testorg.com');
        insert TestUser3;        
                
        /* create Account */
        Account TestAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');
        TestAcnt.Account_Cluster_Name__c = '';
        system.debug('TestAcnt.Account_Cluster_Name__c: ' + TestAcnt.Account_Cluster_Name__c );
        TestAcnt.OwnerId = TestUser3.Id;        
        update TestAcnt;
        
        /* create Opportunity */
        Opportunity TestOpp = TestClassUtiltity.newOpportunity(TestAcnt.Id,'Test Opportunity'); 
        TestOpp.Expected_RFP_Release_Date__c = Date.today();
        insert TestOpp;       
        
        Test.startTest();
        
        List<TaskCreationInvocableMethod.TaskCreationRequestWrapper> requests = new List<TaskCreationInvocableMethod.TaskCreationRequestWrapper>();

        TaskCreationInvocableMethod.TaskCreationRequestWrapper request = new TaskCreationInvocableMethod.TaskCreationRequestWrapper();

        request.TaskCreationProcess = 'OpportunityWonCreateATaskForAccountExecutive';
        request.TaskRecordTypeName = 'Account Setup Maintenance Task';
        request.OpportunityID = TestOpp.Id;
        request.TaskPriority = 'High';
        request.TaskStatus = 'New';
        request.TaskSubject = 'Other';
        Date TwoDaysFromNow = Date.today();
        request.TaskFollowUpDate = TwoDaysFromNow.addDays(2);
        request.TaskType = 'Create a Contract Admin Case';

        requests.add(request);
        
        TaskCreationInvocableMethod.CreateATask(requests);
        
        Test.stopTest();
        
        List<Task> NewTask = [SELECT Id, OwnerId 
                             FROM Task
                             WHERE
                             Subject = 'Other' AND
                             Priority = 'High' AND
                             Type = 'Create a Contract Admin Case' AND
                             WhatId = :TestOpp.Id AND
                             OwnerId = :TestUser3.Id];
        
        System.assertEquals(1, NewTask.size());
        
    }
    

}