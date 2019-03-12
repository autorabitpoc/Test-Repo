/*
@Description : This is an test class for BatchAccountRenewalNotification
@author      : Deloitte
@date        : 10/29/2015
*/
@isTest
public with sharing class TestBatchAccountRenewalNotification {
    /*
@Description : This is a testMethod for testing the accountRenewalBatch
@author      : Deloitte
@date        : 10/29/2015
*/
    
    static testMethod void testWithAccountRenewalTaskSomeToSelect(){
        
        System.debug('!!BEGIN - testWithAccountRenewalTaskSomeToSelect');
        
        String accountRenewalTaskSubject     = Label.Account_Renewal_Task_Subject;
        String cedeAccountRenewalTaskSubject   = Label.Cede_Account_Renewal_Task_Subject;
        
        /* create a User */
        Profile p = [SELECT Id FROM Profile WHERE Name='LGNA - Sales MSR']; //Padma Update profile from LGNA - Sales to LGNA - Sales MSR Since profile deleted in prod.        
        User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');        
        testUser.IsActive = True;        
        Update testUser;        
        System.debug('testUser: ' + testUser);
        
        system.runAs(testUser){           
            
            /* create an Account */
            Account TestAccount = TestClassUtiltity.CreateAccountRecord('TestAccount');            
            TestAccount.Effective_Date__c = Date.today().addDays(-365);
            TestAccount.Renewal_Notification_in_days__c = 2;
            TestAccount.Renewal_Date__c = date.today().addDays(2);
            TestAccount.Active_Health_Subscribers__c = 151;
            TestAccount.Ceded__c = true;
            TestAccount.Status__c = 'Active'; 
            TestAccount.HCSC_Division__c = 'IL';
            TestAccount.OwnerId = testUser.Id;
            Update TestAccount;     
            System.debug('TestAccount: ' + TestAccount);         
            
            /* create the Custom Setting used by the Query in the Class */
            Custom_Notification_Enabled_Profiles__c TestCustomSetting = new Custom_Notification_Enabled_Profiles__c();            
            TestCustomSetting.Name='LGNA - Sales MSR';//Padma Update profile from LGNA - Sales to LGNA - Sales MSR Since profile deleted in prod.
            TestCustomSetting.Account_Renewal_Tasks__c = true;
            Insert TestCustomSetting;                                                     
            
            test.startTest();
            
            BatchAccountRenewalNotification bt = new BatchAccountRenewalNotification();
            Id batchId=database.executeBatch(bt);
            
            /* successfully scheduled the Batch job verification */
            System.assertNOTEquals(batchId,null);            
            
            test.stopTest();    
            
            /* ensure that the renewal task was created for the Account */
            List<Task> AfterBatchTask = [SELECT Id FROM TASK WHERE 
                                         WhatId = :TestAccount.Id AND
                                         OwnerId = :TestAccount.OwnerId AND
                                         Subject = :cedeAccountRenewalTaskSubject];            
            System.assertEquals(1, AfterBatchTask.size());
            
        }        
        System.debug('!!END - testWithAccountRenewalTaskSomeToSelect');
    }
    
    static testMethod void myUnitTest1() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
        system.runAs(testUser){
            Account TestAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');
            TestAcnt.Renewal_Notification_in_days__c = 2;
            TestAcnt.Renewal_Date__c = date.today().addDays(2);
            TestAcnt.Ceded__c = true;
            TestAcnt.Status__c = 'Active';
            update TestAcnt;
            Custom_Notification_Enabled_Profiles__c ce = new Custom_Notification_Enabled_Profiles__c();            
            ce.Name='Standard User';
            ce.Account_Renewal_Tasks__c = true;
            insert ce;
            test.startTest();
            BatchAccountRenewalNotification bt = new BatchAccountRenewalNotification();
            Id batchId=database.executeBatch(bt);
            System.assertNOTEquals(batchId,null);
            test.stopTest();
        }
    }
}