@isTest(SeeAllData=false)
public class CaseAccountCancellationControllerTest{
    @isTest static void getCaseTest(){
        Profile p = [SELECT Id FROM Profile LIMIT 1];
        User userObj = new User(Alias = 'test', Email = 'uniqueUsername@testemail.com', EmailEncodingKey = 'UTF-8', LastName = 'Last Name', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'uniqueUsername@testemail.com');
        insert userObj;
        
        Account acctObj = new Account();
        acctObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Group_Account).getRecordTypeId();
        acctObj.Name = 'Test CaseDAO Account';
        acctObj.HCSC_Division__c = 'IL';
        insert acctObj;
        Case newCase = new Case();
        newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.Performance_Guarantee).getRecordTypeId();       
        newCase.Underwriter_Lookup__c = userObj.Id;     
        newCase.Account = acctObj;
        newCase.Group_Status__c = 'Existing Group - Adding PGs';
        newCase.Status = 'New';
        newCase.Guarantee_Period_Start__c = System.today();
        newCase.PG_Exhibit_Due_Date__c = System.today();
        newCase.Standard_Medical_Access_Criteria__c = 'IL/MT/NM/OK: 2 prov in 8m, 1 hosp in 10m';
        newCase.Request_Types__c = 'Service Area Match';
        newCase.Provider_Groups__c = 'Specialists';
        newCase.Group_Number_s__c='9123434test';
        
        insert newCase;
        Test.startTest();
        CaseAccountCancellationController.CaseAccountCancellationController(newCase.Id);
        Test.stopTest();
        
        
    }
    
}