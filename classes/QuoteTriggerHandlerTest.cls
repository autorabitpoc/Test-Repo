/******************************************************************************************
* Apex Class Name     : QuoteTriggerHandlerTest
* Version             : 1.0
* Function            : This class is serves as Unit Test class for QuoteTriggerHandler.
* Modification Log    :
* Developer             Date		Description
* ----------------------------------------------------------------------------
* Zachary Campbell		2/23/2018	SFDC-7961 - Initial version creation 
******************************************************************************************/
@isTest
public class QuoteTriggerHandlerTest {
    
    public static testMethod void deleteQuoteRequestRecords() {
        
        LGNAFeatureFlags__c AFeatureFlag = new LGNAFeatureFlags__c();
        AFeatureFlag.LGNA_Quote_Request_Deletion__c = true;
        Insert AFeatureFlag;            
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(Alias = 'standt12', Email = 'john.testing@testorg2.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'John', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'john.testing@testorg2.com', isActive = TRUE);
        insert testUser;
        
        Profile uw = [SELECT Id FROM Profile WHERE Name = 'Underwriting'];
        User uwUser = new User(Alias = 'standt12', Email = 'smit.testing@testorg24.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'Smith', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'smith.testing@testorg24.com', isActive = TRUE);
        insert uwUser;            
        
        //Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account123');
        Id groudActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Account groupAccount = TestClassUtiltity.createAccountWithRecType('Test Account234', groudActRecId);
        groupAccount.Underwriter_Name__c='Smith Testing';
        groupAccount.Account_Executive_2__c='Smith Testing';
        groupAccount.Account_Cluster_Name__c='Smith Testing';
        update groupAccount;
        
        list<Competitor_Relationship__c> carriers=TestClassUtiltity.createCarrierHistory(groupAccount.id);
        insert carriers;
        
        List<Opportunity> testOpp = TestClassUtiltity.CreateOpportunities(groupAccount.Id);
        testOpp[0].Requested_Effective_Date__c = System.now().date();//oppName 1
        testOpp[0].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        testOpp[1].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        testOpp[2].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        insert testOpp;
        
        Id PriceBook2Id =TestClassUtiltity.getNonStandardPriceBook('Underwriting Price Book');            
        
        Quote existingQuote = TestClassUtiltity.createQuote(testOpp[0].id);
        existingQuote.pricebook2Id = priceBook2Id;
        insert existingQuote;
        
        Quote_Request_Summary__c testQReq = TestClassUtiltity.createQuoteReq(existingQuote.id, uwUser.id);
        testQReq.Opportunity_Name__c = testOpp[0].name;
        testQReq.Opportunity_Id__c = String.valueOf(testOpp[0].id);
        testQReq.Account_Id__c = String.valueOf(groupAccount.Id);
        insert TestQReq;
        
        List<Quote_Request_Summary__c> qr = [select id from Quote_Request_Summary__c where Quote_Name__c =:existingQuote.Id];
        System.assertEquals(qr.isEmpty(), false);            
        
        System.runAs(testUser) {
            
            test.startTest();
            
            delete existingQuote;
            
            test.stopTest();
            
            qr = [select id from Quote_Request_Summary__c where Quote_Name__c =:existingQuote.Id];
            System.assertEquals(qr.isEmpty(), true);
            
        }
    }
    
}