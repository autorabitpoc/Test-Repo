/**************************************************************************************
  Apex Class Name     : LineItemReviewTriggerHandlerTest
  Version             : 1.0
  Function            : This is a test class for LineItemReviewTriggerHandler.
  Modification Log    :
* Developer                 Date
* ----------------------------------------------------------------------------                 
* Ralph Tariga              6/21/2016
*************************************************************************************/
@isTest (seealldata = false)
public class LineItemReviewTriggerHandlerTest {
    /*  changePGParentCaseStatusIfAllLineItemsHaveDispositionTest
    *   @developer:     Ralph Tariga/Slalom, LLC
    *   @date:          6/21/2016
    *   @description:   Test if PG Case Status changes when Child Line Item Review Items have all been dispositioned
    */
    static testMethod void changePGParentCaseStatusIfAllLineItemsHaveDispositionTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User userObj = new User(Alias = 'test', Email = 'uniqueUsername@testemail.com', EmailEncodingKey = 'UTF-8', LastName = 'Last Name', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'uniqueUsername@testemail.com');
        insert userObj;

        Case newCase = new Case();

        System.runAs(userObj) {
            Account acctObj = new Account();
            acctObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Group_Account).getRecordTypeId();
            acctObj.Name = 'Test CaseDAO Account';
            acctObj.HCSC_Division__c = 'IL';
            insert acctObj;

            newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.Performance_Guarantee).getRecordTypeId();       
            newCase.Underwriter_Lookup__c = userObj.Id;     
            newCase.Account = acctObj;
            newCase.Group_Status__c = 'Existing Group - Adding PGs';
            newCase.Group_Number_s__c = '22';
            newCase.Status = 'Submitted';
            newCase.Guarantee_Period_Start__c = System.today();
            newCase.PG_Exhibit_Due_Date__c = System.today();
            newCase.Standard_Medical_Access_Criteria__c = 'IL/MT/NM/OK: 2 prov in 8m, 1 hosp in 10m';
            newCase.Request_Types__c = 'Service Area Match';
            newCase.Provider_Groups__c = 'Specialists';
            newCase.Financial__c = true;
            insert newCase;
        }       

        Test.StartTest();
            newCase.Ready_for_SME_Review__c = true;
            newCase.SME_Groups__c = 'PG - Dental PG Approvers;PG - Rx - MT;PG - Website Availability Approvers';
            update newCase;

            Case testCase = [SELECT Status, (SELECT Disposition_Status__c, Disposition_Date_Time__c FROM Line_Item_Reviews__r) FROM Case WHERE Id = :newCase.Id];
            List<Line_Item_Review__c> smeLirListToUpdate = new List<Line_Item_Review__c>(); 
            for(Line_Item_Review__c curLir : testCase.Line_Item_Reviews__r) {
                curLir.Disposition_Status__c = 'Accepted';
                smeLirListToUpdate.add(curLir);
            }
            update smeLirListToUpdate;

            testCase = [SELECT Status FROM Case WHERE Id = :newCase.Id];
            System.assertEquals(testCase.Status, 'Reviewed by SMEs');

            newCase.Ready_for_Underwriter__c = true;
            update newCase;

            Id uwLirRecordTypeID = Schema.SObjectType.Line_Item_Review__c.getRecordTypeInfosByName().get('PG UW Line Item Review').getRecordTypeId();
            testCase = [SELECT Status, (SELECT Disposition_Status__c, Disposition_Date_Time__c FROM Line_Item_Reviews__r WHERE RecordTypeId = :uwLirRecordTypeID) FROM Case WHERE Id = :newCase.Id];
            List<Line_Item_Review__c> uwLirListToUpdate = new List<Line_Item_Review__c>(); 
            for(Line_Item_Review__c curLir : testCase.Line_Item_Reviews__r) {
                curLir.Disposition_Status__c = 'Accepted';
                uwLirListToUpdate.add(curLir);
            }
            update uwLirListToUpdate;

            testCase = [SELECT Status FROM Case WHERE Id = :newCase.Id];
            System.assertEquals(testCase.Status, 'Reviewed by UW');
        Test.StopTest(); 
    }

    /*  changePGParentCaseStatusIfAllLineItemsHaveDispositionHelperTest
    *   @developer:     Ralph Tariga/Slalom, LLC
    *   @date:          6/21/2016
    *   @description:   Test if helper method properly checks if Child Line Item Reviews have been dispositioned
    */
    static testMethod void changePGParentCaseStatusIfAllLineItemsHaveDispositionHelperTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User userObj = new User(Alias = 'test', Email = 'uniqueUsername@testemail.com', EmailEncodingKey = 'UTF-8', LastName = 'Last Name', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'uniqueUsername@testemail.com');
        insert userObj;

        Case newCase = new Case();

        System.runAs(userObj) {
            Account acctObj = new Account();
            acctObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Group_Account).getRecordTypeId();
            acctObj.Name = 'Test CaseDAO Account';
            acctObj.HCSC_Division__c = 'IL';
            insert acctObj;

            newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.Performance_Guarantee).getRecordTypeId();       
            newCase.Underwriter_Lookup__c = userObj.Id;     
            newCase.Account = acctObj;
            newCase.Group_Status__c = 'Existing Group - Adding PGs';
            newCase.Group_Number_s__c = '23';
            newCase.Status = 'Submitted';
            newCase.Guarantee_Period_Start__c = System.today();
            newCase.PG_Exhibit_Due_Date__c = System.today();
            newCase.Standard_Medical_Access_Criteria__c = 'IL/MT/NM/OK: 2 prov in 8m, 1 hosp in 10m';
            newCase.Request_Types__c = 'Service Area Match';
            newCase.Provider_Groups__c = 'Specialists';
            newCase.Financial__c = true;
            insert newCase;
        }

        Test.StartTest();
            newCase.Ready_for_SME_Review__c = true;
            newCase.SME_Groups__c = 'PG - Dental PG Approvers;PG - Rx - MT;PG - Website Availability Approvers';
            update newCase;

            List<Case> casesToTest = new List<Case>();
            casesToTest.add(newCase);
            List<Case> casesToUpdate = LineItemReviewTriggerHandler.changePGParentCaseStatusIfAllLineItemsHaveDispositionHelper(casesToTest,  ConstantsController.pgCaseStatusInternalHCSCSMEReview, ConstantsController.pgCaseStatusInternalReviewedbySMEs, Schema.SObjectType.Line_Item_Review__c.getRecordTypeInfosByName().get('PG SME Line Item Review').getRecordTypeId());
            System.assert(casesToUpdate != null);
            System.assertEquals(casesToUpdate.size(), 0);

            Case testCase = [SELECT Status, (SELECT Disposition_Status__c, Disposition_Date_Time__c, RecordTypeId FROM Line_Item_Reviews__r) FROM Case WHERE Id = :newCase.Id];
            List<Line_Item_Review__c> smeLirListToUpdate = new List<Line_Item_Review__c>(); 
            for(Line_Item_Review__c curLir : testCase.Line_Item_Reviews__r) {
                curLir.Disposition_Status__c = 'Accepted';
                smeLirListToUpdate.add(curLir);
            }
            update smeLirListToUpdate;

            casesToTest.clear();
            testCase = [SELECT Status, (SELECT Disposition_Status__c, Disposition_Date_Time__c, RecordTypeId FROM Line_Item_Reviews__r) FROM Case WHERE Id = :newCase.Id];
            casesToTest.add(testCase);
            casesToUpdate.clear();
            casesToUpdate = LineItemReviewTriggerHandler.changePGParentCaseStatusIfAllLineItemsHaveDispositionHelper(casesToTest,  ConstantsController.pgCaseStatusInternalReviewedbySMEs, ConstantsController.pgCaseStatusInternalReviewedbySMEs, Schema.SObjectType.Line_Item_Review__c.getRecordTypeInfosByName().get('PG SME Line Item Review').getRecordTypeId());
            System.assert(casesToUpdate != null);
            System.assertEquals(casesToUpdate.size(), 1);

            newCase.Ready_for_Underwriter__c = true;
            update newCase;

            casesToTest.clear();
            casesToTest.add(newCase);
            casesToUpdate.clear();
            casesToUpdate = LineItemReviewTriggerHandler.changePGParentCaseStatusIfAllLineItemsHaveDispositionHelper(casesToTest,  ConstantsController.pgCaseStatusInternalHCSCUWReview, ConstantsController.pgCaseStatusInternalReviewedbyUW, Schema.SObjectType.Line_Item_Review__c.getRecordTypeInfosByName().get('PG UW Line Item Review').getRecordTypeId());
            System.assert(casesToUpdate != null);
            System.assertEquals(casesToUpdate.size(), 0);

            testCase = [SELECT Status, (SELECT Disposition_Status__c, Disposition_Date_Time__c, RecordTypeId FROM Line_Item_Reviews__r) FROM Case WHERE Id = :newCase.Id];
            List<Line_Item_Review__c> uwLirListToUpdate = new List<Line_Item_Review__c>(); 
            for(Line_Item_Review__c curLir : testCase.Line_Item_Reviews__r) {
                curLir.Disposition_Status__c = 'Accepted';
                uwLirListToUpdate.add(curLir);
            }
            update uwLirListToUpdate;

            casesToTest.clear();
            testCase = [SELECT Status, (SELECT Disposition_Status__c, Disposition_Date_Time__c, RecordTypeId FROM Line_Item_Reviews__r) FROM Case WHERE Id = :newCase.Id];
            casesToTest.add(testCase);
            casesToUpdate.clear();
            casesToUpdate = LineItemReviewTriggerHandler.changePGParentCaseStatusIfAllLineItemsHaveDispositionHelper(casesToTest,  ConstantsController.pgCaseStatusInternalReviewedbyUW, ConstantsController.pgCaseStatusInternalReviewedbyUW, Schema.SObjectType.Line_Item_Review__c.getRecordTypeInfosByName().get('PG UW Line Item Review').getRecordTypeId());
            System.assert(casesToUpdate != null);
            System.assertEquals(casesToUpdate.size(), 1);
        Test.StopTest(); 
    }   
}