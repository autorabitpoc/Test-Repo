/**************************************************************************************
  Apex Class Name     : ProfileDAOTest
  Version             : 1.0
  Function            : This is a test class for CaseDAO.
  Modification Log    :
* Developer                 Date
* ----------------------------------------------------------------------------                 
* Ralph Tariga              6/21/2016
*************************************************************************************/
@isTest (seealldata = false)
public class CaseDAOTest {
    @isTest static void getRequestTypeParentCaseTest(){
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

        Case case1 = [SELECT Provider_Groups__c, Request_Types__c, Standard_Medical_Access_Criteria__c FROM Case LIMIT 1];
        CaseDAO.ICaseDAO caseDAOInstance = new CaseDAO();
        Case case2 = caseDAOInstance.getRequestTypeParentCase(case1.Id);
        System.assert(case1 != null);
        System.assert(case2 != null);
        System.assertEquals(case1.Provider_Groups__c, case2.Provider_Groups__c);
        System.assertEquals(case1.Request_Types__c, case2.Request_Types__c);
        System.assertEquals(case1.Standard_Medical_Access_Criteria__c, case2.Standard_Medical_Access_Criteria__c); 
    }

    @isTest static void getPGCasesAndLineItemReviewChildrenTest(){
        Profile p = [SELECT Id FROM Profile LIMIT 1];
        User userObj = new User(Alias = 'test', Email = 'uniqueUsername@testemail.com', EmailEncodingKey = 'UTF-8', LastName = 'Last Name', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'uniqueUsername@testemail.com');
        insert userObj;

        Account acctObj = new Account();
        acctObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Group_Account).getRecordTypeId();
        acctObj.Name = 'Test CaseDAO Account';
        acctObj.HCSC_Division__c = 'IL';
        insert acctObj;

        List<Case> newCases = new List<Case>();
        for(Integer i=0; i<10; i++) {
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
            newCase.Group_Number_s__c='12343445st';
            newCases.add(newCase);
        }
        insert newCases;

        List<Case> caseList1 = [SELECT Status, (SELECT Disposition_Status__c, Disposition_Date_Time__c, RecordTypeId FROM Line_Item_Reviews__r) FROM Case];
        CaseDAO.ICaseDAO caseDAOInstance = new CaseDAO();
        Set<Id> caseIds = new Set<Id>();
        for(Case curCase : caseList1) {
            caseIds.add(curCase.Id);
        }
        List<Case> caseList2 = caseDAOInstance.getPGCasesAndLineItemReviewChildren(caseIds);
        System.assert(caseList1 != null);
        System.assert(caseList2 != null);
        Boolean result = false;
        for(Case curCase : caseList2) {
            result = caseIds.contains(curCase.Id);
            System.assertEquals(true, result);
        } 
    }

    @isTest static void updatePGCasesStatusesTest(){
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
        newCase.Group_Number_s__c='12r344test';
        insert newCase;

        newCase.Status = 'In Progress';
        CaseDAO.ICaseDAO caseDAOInstance = new CaseDAO();
        List<Case> caseList = new List<Case>();
        caseList.add(newCase);
        caseDAOInstance.updatePGCasesStatuses(caseList);
        Case updatedCase = [SELECT Status FROM Case WHERE Id = :newCase.Id];
        System.assert(updatedCase != null);
        System.assertEquals(updatedCase.Status, 'In Progress'); 
    }   

    @isTest
    static void caseDAOComplexityScoreTest() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(Alias = 'standt1', Email = 'john.testing@testorg.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'John', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'john.testing@testorg.com', isActive = TRUE);
        insert testUser;

        Id groupAccRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId();
        Id performanceGuaranteeRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get( Label.Performance_Guarantee ).getRecordTypeId(); 
        Id gemsAccountStructRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get( Label.GEMS_Account_Structure ).getRecordTypeId();
        Id gemsAccountSubmissionRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get( Label.GEMS_Account_Submission ).getRecordTypeId();
        CaseDAO.ICaseDAO caseDAOInstance = new CaseDAO();

        Account testAcnt = TestClassUtiltity.createAccountWithRecType('TestAccount', groupAccRecId);
        Map<Id, Account> accountMap = new Map<Id, Account>();
        accountMap.put(testAcnt.id, testAcnt);

        Case testCase = new Case(accountId = testAcnt.id, Underwriter_Lookup__c = testUser.id);
        testCase.Group_Status__c = 'Existing Group - Adding PGs';
        testCase.Status = 'In Progress';
        testCase.Guarantee_Period_Start__c = System.today() + 1;
        testCase.PG_Exhibit_Due_Date__c = System.today() + 5;
        testCase.RecordTypeId = performanceGuaranteeRecordType;
        testCase.Group_Number_s__c='123434test';
        insert testCase;

        List<Case> pGCases = caseDAOInstance.getPGAndGemsCases( accountMap, performanceGuaranteeRecordType, gemsAccountStructRecordType, gemsAccountSubmissionRecordType );
        System.assert(!pGCases.isEmpty());

        Test.stopTest();
    }
        
}