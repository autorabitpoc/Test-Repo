@isTest
public class SGR_GPA_Helper_Test {
    public static testMethod void sgrProducerAssociationForOpportunity() {
        Test.StartTest();
        Map<Id, RecordType> rtMap = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND (Name = 'Group Account' OR Name = 'Producer Account' OR Name = 'Producer House')]);
        RecordType groupAccountRecordType;
        RecordType producerAccountRecordType;
        RecordType producerHouseRecordType;
        for (RecordType rt : rtMap.values()) {
            if (rt.Name == 'Group Account'){
                groupAccountRecordType = rt;
            }
            else if (rt.Name == 'Producer Account')
            {
                producerAccountRecordType = rt;
            }
            else if (rt.Name == 'Producer House')
            {
                producerHouseRecordType=rt;
            }
        }
        List<Account> newAccountstoinsert = new List<Account>();
        Account newGroupAccount = new Account(Name = 'TestGroupAccount', RecordTypeId = groupAccountRecordType.Id, 
                                              HCSC_Division__C = 'IL', Status__c = 'Active',Forecast_Segment__c='Small Group',
                                              External_ID__c='TX1234');
        Account newProducerAccount = new Account(Name = 'TestProducerAccount', RecordTypeId = producerAccountRecordType.Id, Status__c = 'Active');
        Account newProducerAccount1 = new Account(Name = 'TestProducerAccount1', RecordTypeId = producerAccountRecordType.Id, Status__c = 'Active');
        Account newProducerHouseAccount1 = new Account(Name = 'TestProducerHouseAccount1', RecordTypeId = producerHouseRecordType.Id, Status__c = 'Active');
        insert newGroupAccount;
        insert newProducerAccount;
        insert newProducerAccount1;
        insert newProducerHouseAccount1;
        newAccountstoinsert.add(newGroupAccount);
        newAccountstoinsert.add(newProducerAccount);
        newAccountstoinsert.add(newProducerAccount1);
        newAccountstoinsert.add(newProducerHouseAccount1);
        //insert newAccountstoinsert;      
        
        
        List<Producer_Group_Association__c> sgrpgalist = new List<Producer_Group_Association__c>();
        Producer_Group_Association__c sgrpga1 = new Producer_Group_Association__c(Group_Account__c = newGroupAccount.Id, Producer_Account__c = newProducerAccount.Id, External_ID__c = 'ThisIDIsUnique');
        Producer_Group_Association__c sgrpga2 = new Producer_Group_Association__c(Group_Account__c = newGroupAccount.Id, Producer_Account__c = newProducerAccount1.Id, External_ID__c = 'ThisIDIsUnique1');
        sgrpgalist.add(sgrpga1);
        sgrpgalist.add(sgrpga2);
        insert sgrpgalist;  
        
      
        Id opptyRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Analytical_Opportunity').getRecordTypeId();
        //01/23/2019 - Deployment Fix to add Assigned_UW__c START
        Opportunity newOpp = new Opportunity(Name = 'TestOpportunity', AccountId = newGroupAccount.Id, RFI_RFP_Received_Date__c = System.today(), 
                                             StageName = 'RFI Received',Probability = 10, CloseDate = System.today() + 5, 
                                             Requested_Effective_Date__c = Date.newInstance(Date.today().year(), 01, 01),
                                             RecordtypeId = opptyRecTypeId, Assigned_UW__c = userInfo.getUserId());
		//01/23/2019 - Deployment Fix to add Assigned_UW__c END
		system.assertEquals(newOpp.name,'TestOpportunity');
        insert newOpp;     

        // System.assert([SELECT Opportunity__c FROM Producer_Association_For_Opportunity__c WHERE Opportunity__c = : newOpp.Id].size() == 2);
        
        //GrpAndProdAssociationTriggerHandler.accountContactRelUpdateForProducerAssociation(pgalist);
        SGR_GPA_Helper.updateGPAOnOpportunity(sgrpgalist);
        List<Producer_Association_For_Opportunity__c> pafolist = new  List<Producer_Association_For_Opportunity__c>();
        
        pafolist = [SELECT Opportunity__c FROM Producer_Association_For_Opportunity__c WHERE Opportunity__c = : newOpp.Id];
        
        Test.StopTest();
    }
    
}