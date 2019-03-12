@istest
public class SGR_FutureTriggerClass_Test{
    
    public static testmethod void testopty(){
        Id sgrGroupAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<String> divisions;
        String marketSegment;
        String fundingType;
        String renewEffDate;
        String renType;
        String division;
        String accNum; 
        String acctNo;
        String bid;
        String renewEffDateStr;
        
        divisions=new List<String>{'IL'};
            marketSegment='SG';
        fundingType='PREM';
        renewEffDateStr ='2018-10-21';
        renewEffDate ='2018-11-28';
        renType='Analytical';
        division= 'IL';
        bid='567';
        accNum='AC12345';
        acctNo='AC12345';
        String returnMsg;
        
        Account newAccount1 = new Account(Name = 'Test Record',recordTypeId=sgrGroupAccount,Product_Type__c='H', external_ID__c ='AC12345', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        insert accList;
        
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        List<opportunity> oplist = new List<opportunity>();
        opportunity opps = new opportunity();
        opps.Accountid = accList[0].id;
        opps.Name = 'Sample';
        opps.StageName = 'lost';
        opps.Product_Type__c='H';
        opps.Batch_Id__c='567';
        opps.Primary_Closed_Reason__c ='Political';
        opps.Closed_Comments__c = 'XYZ';
        opps.Date_Closed__c = date.today().adddays(-1);
        opps.CloseDate = date.today().adddays(2);
        opps.RecordTypeId = sgrProdOpp;
        opps.HCSC_Division__c ='IL';
        opps.Renewal_Date__c =date.valueOf(renewEffDate);
        opps.Batch_Type__c='Batch';
        opps.Assigned_UW__c = Userinfo.getUserId();
        opps.recordTypeId=SGR_AccountRenewalBatch_test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        oplist.add(opps);
        
        
        insert oplist;
        
        List<SGRRenewalBatch__c> renewList = new List<SGRRenewalBatch__c>();
        SGRRenewalBatch__c renew = Sgr_TestDataUtility.createRenewalBatch();
        renewList.add(renew);
        list<SGRRenewalBatch__c > new1 = new list<SGRRenewalBatch__c >();
        new1.add(renew);
        Test.startTest();
        
        SGR_FutureTriggerClass.captureFuture(new1);
        Test.stopTest();
        
    }
    
    public static testmethod void testopty2(){
        Id sgrGroupAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<String> divisions;
        String marketSegment;
        String fundingType;
        String renewEffDate;
        String renType;
        String division;
        String accNum; 
        String acctNo;
        String bid;
        String renewEffDateStr;
        
        
        divisions=new List<String>{'IL'};
            marketSegment='SG';
        fundingType='PREM';
        renewEffDateStr ='2018-10-21';
        renewEffDate ='2018-11-28';
        renType='Analytical';
        division= 'IL';
        bid='567';
        accNum='AC12345';
        acctNo='AC12345';
        String returnMsg;
        
        //Nidhi: replaced accountnumber with external_ID__c
        Account newAccount1 = new Account(Name = 'Test Record',recordTypeId=sgrGroupAccount,Product_Type__c='H', external_ID__c ='AC12345', HCSC_Division__c = 'IL', Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',Funding_Type__c='PREM',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        List<Account> accList = new List<Account>();
        accList.add(newAccount1);
        insert accList;
        
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        List<opportunity> oplist = new List<opportunity>();
        opportunity opps = new opportunity();
        opps.Accountid = accList[0].id;
        opps.Name = 'Sample';
        opps.StageName = 'lost';
        opps.Product_Type__c='H';
        opps.Batch_Id__c='567';
        opps.Primary_Closed_Reason__c ='Political';
        opps.Closed_Comments__c = 'XYZ';
        opps.Date_Closed__c = date.today().adddays(-1);
        opps.CloseDate = date.today().adddays(2);
        opps.RecordTypeId = sgrProdOpp;
        opps.HCSC_Division__c ='IL';
        opps.Renewal_Date__c =date.valueOf(renewEffDate);
        opps.Assigned_UW__c = Userinfo.getUserId();
        opps.recordTypeId=SGR_AccountRenewalBatch_test.getOpptyRecordTypeIds('Opportunity','SGR Analytical Opportunity');
        oplist.add(opps);
        
        insert oplist;
        
        Case renBatch= new Case(Status = 'Closed12', Reason='BlueSTAR Eligibility Fallout');
        insert renBatch;
        List<Id> new1 = new List<Id>();
        new1.add(renBatch.Id);
        
        Test.startTest();
        SGR_FutureTriggerClass.opptyUpdate(new1);
        Test.stopTest();
        
    }
    
     public Static String getOpptyRecordTypeIds(String ObjectName,String recTypeName){
         Map<String, Schema.SObjectType> mapSchemaobject = Schema.getGlobalDescribe() ;
        Schema.SObjectType SchemaObject = mapSchemaobject.get(ObjectName) ;
        Schema.DescribeSObjectResult getDescribeSchema = SchemaObject.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = getDescribeSchema.getRecordTypeInfosByName();
        String recordTypeId = RecordTypeInfo.get(recTypeName).getRecordTypeId();
        System.debug(':::RECTYPE:::'+recordTypeId);
        return recordTypeId;
       
    }
    
}