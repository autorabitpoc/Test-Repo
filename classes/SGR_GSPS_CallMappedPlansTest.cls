@isTest
public class SGR_GSPS_CallMappedPlansTest {
    
    static testmethod  void testmethod1()
    {
        String divisions1 = 'IL';
        String   marketSegment1 ='SG';
        String  fundingType1 ='PREM';
        String bid='jq123';
        Date renewEffDate1 =date.today();
        String renType1='Analytical'; 
        
        Account newAccount1 = new Account(Name = 'Test Account',county_code__c='1234', external_ID__c ='AC12345', HCSC_Division__c = 'IL', 
                                          Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',
                                          Funding_Type__c='PREM',Product_Type__c='H',hold_end_date__c=Date.today()-1,
                                          SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        insert accList;
        
        List<opportunity> oplist = new List<opportunity>();
        opportunity opp = new opportunity();
        opp.Accountid = newAccount1.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Product_Type__c='H';
        opp.Account_Market_Segment__c='SG';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.recordTypeId=SGR_AccountRenewalBatch_test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        //01/23/2019 - Deployment Fix START
        opp.Assigned_UW__c = userInfo.getUserId();
        //01/23/2019 - Deployment Fix END
        oplist.add(opp);
        insert oplist;
        Set<id> ide = new Set<id>();
        ide.add(newAccount1.id);
        SGR_Opportunity_Plan_Rate__c opplanrate = new SGR_Opportunity_Plan_Rate__c(); 
        list<SGR_Opportunity_Plan_Rate__c> opplanlist = new list<SGR_Opportunity_Plan_Rate__c>();
        opplanrate.Name = oplist[0].id;
        opplanrate.Account__c = newAccount1.id;
        
        opplanlist.add(opplanrate);
        Insert opplanlist;
        SGR_Opportunity_Plan_Rate__c pr= new SGR_Opportunity_Plan_Rate__c();
        pr.Plan_Name__c='PR-00000001';
        pr.Plan_Status__c='Mapped';
        pr.Opportunity__c=opp.Id;
        pr.Benefit_Agreement_Effective_Date__c=date.today();
        
        insert pr;
        
        Test.startTest();
        SGR_AccountRenewalBatch sbr= new SGR_AccountRenewalBatch(divisions1,marketSegment1,fundingType1,renewEffDate1,renType1);
        ID batchId1 = Database.executeBatch(sbr,50);
        
        SGR_GSPS_CallMappedPlans svcp = new SGR_GSPS_CallMappedPlans(batchId1);
        Database.executeBatch(svcp,50);
        
        List<Opportunity> accLists = [select id,Renewal_Date__c,HCSC_Division__c,Funding_Type__c,Account_Market_Segment__c from Opportunity];
        svcp.execute(null, accLIsts);
        Test.stopTest();
    }
}