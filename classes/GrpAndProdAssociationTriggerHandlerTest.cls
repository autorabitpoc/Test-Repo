/***************************************************************************************
  Apex Class Name     : GrpAndProdAssociationTriggerHandler
  Version             : 1.0
  Function            : This is a test class for GrpAndProdAssociationTriggerHandler
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Padma Bedampeta            10/20/2017          Unit Testing for GrpAndProdAssociationTriggerHandler Class
*************************************************************************************/
@isTest
public class GrpAndProdAssociationTriggerHandlerTest {
    public static testMethod void ProducerAssociationForOpportunity() {
       Test.StartTest();
        Map<Id, RecordType> rtMap = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND (Name = 'Group Account' OR Name = 'Producer Account' OR Name = 'Producer House')]);
        RecordType groupAccountRecordType;
        RecordType producerAccountRecordType;
        RecordType producerHouseRecordType;
        for (RecordType rt : rtMap.values()) {
            if (rt.Name == 'Group Account')
                groupAccountRecordType = rt;
            else if (rt.Name == 'Producer Account')
                producerAccountRecordType = rt;
            else if (rt.Name == 'Producer House')
                producerHouseRecordType=rt;
        }
        List<Account> newAccounts = new List<Account>();
        Account newGroupAccount = new Account(Name = 'TestGroupAccount', RecordTypeId = groupAccountRecordType.Id, HCSC_Division__C = 'IL');
        Account newProducerAccount = new Account(Name = 'TestProducerAccount', RecordTypeId = producerAccountRecordType.Id, Status__c = 'Active');
        Account newProducerAccount1 = new Account(Name = 'TestProducerAccount1', RecordTypeId = producerAccountRecordType.Id, Status__c = 'Active');
        Account newProducerHouseAccount1 = new Account(Name = 'TestProducerHouseAccount1', RecordTypeId = producerHouseRecordType.Id, Status__c = 'Active');

        newAccounts.add(newGroupAccount);
        newAccounts.add(newProducerAccount);
        newAccounts.add(newProducerAccount1);
        newAccounts.add(newProducerHouseAccount1);
        insert newAccounts;
        
        newProducerAccount.ParentId = newProducerHouseAccount1.Id;
        newProducerAccount1.ParentId = newProducerHouseAccount1.Id;
        newAccounts.clear();
        newAccounts.add(newProducerAccount);
        newAccounts.add(newProducerAccount1);
        Update newAccounts;
        
        List<Contact> relContacts = new List<Contact>();
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Producer Contact').getRecordTypeId();

 
        Contact relProdCont = new Contact(FirstName='Rel',LastName='Conatct1',RecordTypeId = conRecordTypeId,AccountId=newProducerAccount1.Id,Status__c='Active');
        Contact relProdCont1 = new Contact(FirstName='Related',LastName='Conatct2',RecordTypeId = conRecordTypeId,AccountId=newProducerAccount.Id,Status__c='Active');
        relContacts.add(relProdCont);
        relContacts.add(relProdCont1);
        insert relContacts;
        
        List<AccountContactRelation> accContRelListToUpdate = new List<AccountContactRelation>();
        AccountContactRelation accContrel1 = new  AccountContactRelation(AccountId = newGroupAccount.Id, Contactid = relProdCont.Id, IsActive=True);
        AccountContactRelation accContrel2 = new  AccountContactRelation(AccountId = newGroupAccount.Id, Contactid = relProdCont1.Id, IsActive=True);
        accContRelListToUpdate.add(accContrel1);
         accContRelListToUpdate.add(accContrel2);
        insert accContRelListToUpdate;
        
        Opportunity newOpp = new Opportunity(Name = 'TestOpportunity', AccountId = newGroupAccount.Id, RFI_RFP_Received_Date__c = System.today(), 
                                             StageName = 'RFI Received',Probability = 10, CloseDate = System.today() + 5, 
                                             Requested_Effective_Date__c = Date.newInstance(Date.today().year(), 01, 01));
        insert newOpp;

        List<Producer_Group_Association__c> pgalist = new List<Producer_Group_Association__c>();
       Producer_Group_Association__c pga1 = new Producer_Group_Association__c(Group_Account__c = newGroupAccount.Id, Producer_Account__c = newProducerAccount.Id, External_ID__c = 'ThisIDIsUnique', Primary__c = true);
        Producer_Group_Association__c pga2 = new Producer_Group_Association__c(Group_Account__c = newGroupAccount.Id, Producer_Account__c = newProducerAccount1.Id, External_ID__c = 'ThisIDIsUnique1');
        pgalist.add(pga1);
        pgalist.add(pga2);
        insert pgalist;        
               
        List<Producer_Association_For_Opportunity__c> pafolist = new  List<Producer_Association_For_Opportunity__c>();
        
        pafolist = [SELECT Opportunity__c FROM Producer_Association_For_Opportunity__c WHERE Opportunity__c = : newOpp.Id];
        System.debug('pafolist:::::::::::::::'+pafolist);
       // System.assert([SELECT Opportunity__c FROM Producer_Association_For_Opportunity__c WHERE Opportunity__c = : newOpp.Id].size() == 2);
        pgalist.clear();
        
         pga2.End_Date__c = system.today();
        pgalist.add(pga2);
        Update pgalist;
		GrpAndProdAssociationTriggerHandler.accountContactRelUpdateForProducerAssociation(pgalist);
        
       Test.StopTest();
}
    public static testMethod void ProducerAssociationTermination() {
    }
    
    public static testMethod void populatePrimaryProducerAccount(){
    	//RecordType grpRT=[SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND Name = 'Group Account'];
    	Id grpRT= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
    	Id prodRT= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
    	Id prospRT= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
    	
    	Account newTestAcct=new Account();
    	newTestAcct.name='testAct1';
    	newTestAcct.AccountNumber='IL-55599';
    	newTestAcct.recordTypeId=grpRT;
    	insert newTestAcct;
    	
    	
    	Account newTestProspAcct=new Account();
    	newTestProspAcct.name='testProspAct1';
    	newTestProspAcct.AccountNumber='IL-32509';
    	newTestProspAcct.recordTypeId=prospRT;
    	insert newTestProspAcct;
    	
    	Account newTestProdAcct=new Account();
    	newTestProdAcct.name='testProdAct1';
    	newTestProdAcct.Status__c='Active';
    	newTestProdAcct.recordTypeId=prodRT;
    	insert newTestProdAcct;
    	
    	Account newTestProdAcct2=new Account();
    	newTestProdAcct2.name='testProdAct2';
    	newTestProdAcct2.Status__c='Active';
    	newTestProdAcct2.recordTypeId=prodRT;
    	insert newTestProdAcct2;
    	
    	test.startTest();
    	
    	Producer_Group_Association__c newPag=new Producer_Group_Association__c();
    	newPag.Group_Account__c=newTestAcct.id;
    	newPag.Producer_Account__c=newTestProdAcct.id;
    	newPag.Primary__c=true;
    	newPag.End_Date__c=null;
    	
    	insert newPag;
    	
    	
    	Producer_Group_Association__c newPag3=new Producer_Group_Association__c();
    	newPag3.Group_Account__c=newTestAcct.id;
    	newPag3.Producer_Account__c=newTestProdAcct.id;
    	newPag3.Primary__c=true;
    	newPag3.End_Date__c=null;
    	insert newPag3;
    		
    	Producer_Group_Association__c newPag2=new Producer_Group_Association__c();
    	newPag2.Group_Account__c=newTestProspAcct.id;
    	newPag2.Producer_Account__c=newTestProdAcct.id;
    	newPag2.Primary__c=true;
    	newPag2.End_Date__c=null;
    	insert newPag2;
    	
    	newPag2.Producer_Account__c=newTestProdAcct2.id;
    	update newPag2;
    	
    	test.stopTest();
    	
    }
}