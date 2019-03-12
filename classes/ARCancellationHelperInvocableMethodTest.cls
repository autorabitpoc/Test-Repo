@isTest
public class ARCancellationHelperInvocableMethodTest {
    
    public static testmethod void Test0001(){
        
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
        
        /* create Case */
        Case CaseObj = new Case();
        CaseObj.Subject = 'Test';
        CaseObj.Status = 'New';
        CaseObj.AccountId = TestAcnt.Id;
        CaseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Cancellation').getRecordTypeId();
        insert CaseObj;
 
        List<Case> TheTestCases = [SELECT Id, AccountId FROM Case];
        
        Test.startTest();
        
        ARCancellationHelperInvocableMethod.LGNAAfterApprovalAccountStructureCancellation(TheTestCases);
        
        
        Test.stopTest();
        
        
    }
    
}