@isTest
public class SGR_PGA_Opportunity_Test {
	static testMethod void CreateTwoProducerAssociationForOpportunity() {
        Test.StartTest();
        Map<Id, RecordType> rtMap = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND (Name = 'Group Account' OR Name = 'Producer Account')]);
        RecordType groupAccountRecordType;
        RecordType producerAccountRecordType;
        for (RecordType rt : rtMap.values()) {
            if (rt.Name == 'Group Account')
                groupAccountRecordType = rt;
            else if (rt.Name == 'Producer Account')
                producerAccountRecordType = rt;
        }

        List<Account> newAccounts = new List<Account>();
        Account newGroupAccount = new Account(Name = 'TestGroupAccount', RecordTypeId = groupAccountRecordType.Id, HCSC_Division__C = 'IL');
        Account newProducerAccount1 = new Account(Name = 'TestProspectAccount1', RecordTypeId = producerAccountRecordType.Id, Status__c = 'Active');
        Account newProducerAccount2 = new Account(Name = 'TestProspectAccount2', RecordTypeId = producerAccountRecordType.Id, Status__c = 'Inactive');
        newAccounts.add(newGroupAccount);
        newAccounts.add(newProducerAccount1);
        newAccounts.add(newProducerAccount2);
        insert newAccounts;

        List<Producer_Group_Association__c> newPGAs = new List<Producer_Group_Association__c>();
        Producer_Group_Association__c pga1 = new Producer_Group_Association__c(Group_Account__c = newGroupAccount.Id, Producer_Account__c = newProducerAccount1.Id, External_ID__c = 'ThisIDIsUnique',Primary__c = true);
        Producer_Group_Association__c pga2 = new Producer_Group_Association__c(Group_Account__c = newGroupAccount.Id, Producer_Account__c = newProducerAccount2.Id, External_ID__c = 'ThisIDIsUniqueAlso',Primary__c = true);
        newPGAs.add(pga1);
        newPGAs.add(pga2);
        insert newPGAs;
		List<Opportunity> oppList = new List<Opportunity>();
        Opportunity newOpp = new Opportunity(Name = 'TestOpportunity', AccountId = newGroupAccount.Id, RFI_RFP_Received_Date__c = System.today(), StageName = 'RFI Received',Probability = 10, CloseDate = System.today() + 5);
        oppList.add(newOpp);
        insert oppList;
        SGR_PGA_Opportunity.sgrCreateProducerAssociationForOpportunity(oppList);
        //System.assert([SELECT Opportunity__c FROM Producer_Association_For_Opportunity__c WHERE Opportunity__c = : newOpp.Id].size() == 1);
        Test.StopTest();
    }
}