/***********************
Name : Roopa Pothuluri
Date : 1/12/2019
Description : Test class for SGR_CloneOppty
************************/

@isTest
public class SGR_CloneOppty_Test {
    public static testmethod void clontest() {

        List<Account> accs = new List<Account>();
        accs.add(new Account(Name = 'TestAcc1', External_Id__c = 'A1234', Market_Segment__c = 'SG', hold_end_date__c = Date.today() - 1, SGR_Hold_Reason__c = '1st Year Renewal'));
        accs.add(new Account(Name = 'TestAcc2', External_Id__c = 'A5678', Market_Segment__c = 'SG', hold_end_date__c = Date.today() - 1, SGR_Hold_Reason__c = '1st Year Renewal'));
        insert accs;

        Id prodRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Production_Opportunity').getRecordTypeId();
        Id analyRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Analytical_Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity(AccountId = accs.get(0).Id, Name = 'Oppty1', RecordTypeId = prodRecId, StageName = 'Triggered', CloseDate = System.today().addYears(2), Renewal_Date__c = System.Today().addMonths(3), Rating_Status__c = 'Rated', Subscribers_Count__c = 4, Health_Count__c = 44, Dental_Count__c = 55);
        Opportunity opp1 = new Opportunity(AccountId = accs.get(0).Id, Name = 'Oppty1', RecordTypeId = prodRecId, StageName = 'Triggered', CloseDate = System.today().addYears(2), Renewal_Date__c = System.Today().addMonths(3), Rating_Status__c = 'Sold', Subscribers_Count__c = 4, Health_Count__c = 44, Dental_Count__c = 55);
        insert opp1;
        Opportunity opp2 = new Opportunity(AccountId = accs.get(0).Id, Name = 'Oppty1', RecordTypeId = prodRecId, StageName = 'Triggered', CloseDate = System.today().addYears(2), Renewal_Date__c = System.Today().addMonths(3), Rating_Status__c = 'Closed', Subscribers_Count__c = 4, Health_Count__c = 44, Dental_Count__c = 55);
        insert opp2;
        Opportunity opp3 = new Opportunity(AccountId = accs.get(0).Id, Name = 'Oppty1', RecordTypeId = prodRecId, StageName = 'Triggered', CloseDate = System.today().addYears(2), Renewal_Date__c = System.Today().addMonths(3), Rating_Status__c = 'Finalized', Subscribers_Count__c = 4, Health_Count__c = 44, Dental_Count__c = 55);
        insert opp3;
        Map<id, id> newRecID = new Map<id, id>();
        map<string, string> replaceValues = new map<string, string>();
        insert opp;
        Test.starttest();
        Sgr_CloneOppty.OppNew(opp.Id);
        Sgr_CloneOppty.createChildRecord(opp, newRecID, 'sobjectRelName', replaceValues);
        Sgr_CloneOppty.OppNew(opp1.Id);
        Sgr_CloneOppty.createChildRecord(opp1, newRecID, 'sobjectRelName', replaceValues);
        Sgr_CloneOppty.OppNew(opp2.Id);
        Sgr_CloneOppty.createChildRecord(opp2, newRecID, 'sobjectRelName', replaceValues);
        Sgr_CloneOppty.OppNew(opp3.Id);
        Sgr_CloneOppty.createChildRecord(opp3, newRecID, 'sobjectRelName', replaceValues);
        Test.stoptest();
    }
}