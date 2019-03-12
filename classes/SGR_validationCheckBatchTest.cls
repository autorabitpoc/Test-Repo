@isTest

public class SGR_validationCheckBatchTest {
     static testmethod  void testmethod1()
    {
        Id analyRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Analytical_Opportunity').getRecordTypeId();
        String indDiv = 'IL';
        String marketSegment ='SG';
        String fundingType ='PREM';
        DATE renewEffDate =date.today();
        String renType='Analytical';
        
        Account newAccount1 = new Account(Name = 'Test Account', external_ID__c ='AC12345', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        
        
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        
       insert accList;
        
         List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.Accountid = newAccount1.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.Workflow_System_Status__c='Ready to Validate';
        opp.CloseDate = date.today().adddays(2);
        opp.Assigned_UW__c = Userinfo.getUserId();
        opp.RecordTypeId=analyRecId;
        oplist.add(opp);
        

        Set<id> ide = new Set<id>();
        ide.add(newAccount1.id);
        
        
        Actuary_Gate__c g= new Actuary_Gate__c();
        g.Division__c='IL';
        g.Market_Segment__c='SG';
        g.Funding_Type__c='PREM';
        g.Effective_Date__c =date.today();
        g.Status__c = 'Down';
        insert g;
         
      
        
        Test.startTest();
       
      SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(indDiv,marketSegment,fundingType,renewEffDate,renType);
           ID batchId = Database.executeBatch(sbr,50);
       
        SGR_validationCheckBatch svc = new SGR_validationCheckBatch(batchId);
        Database.executeBatch(svc,2);
        
        List<Opportunity> accLists = [select id,Renewal_Date__c,HCSC_Division__c,Funding_Type__c,Account_Market_Segment__c,Workflow_System_Status__c from Opportunity];
        svc.execute(null, accLIsts);
        
        	
        
         Test.stopTest();
    }
}