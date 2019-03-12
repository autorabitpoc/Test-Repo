@isTest(SeeAllData=false)
public class Sgr_TaskHelper_Test{
    
    public static testmethod void updateStatusTest(){
        
        
        Account newAccount1 = new Account(Name='TarunFinalTest',external_ID__c ='1992', HCSC_Division__c = 'IL', 
                                          Renewal_Date__c = date.today(),status__c = 'Active', Market_Segment__c='SG',
                                          Funding_Type__c='PREM',Product_Type__c='H',hold_end_date__c=Date.today()-1,SGR_Hold_Reason__c='1st Year Renewal');
        
        insert newAccount1;
        Id SGRTR =Schema.SObjectType.task.getRecordTypeInfosByName().get('SGR_Task').getRecordTypeId();
        Id taskUW= Schema.SObjectType.task.getRecordTypeInfosByName().get('GEMS UW Task Record Type').getRecordTypeId();
        
        opportunity opp = new opportunity();
        opp.Accountid = newAccount1.id;
        opp.Name = 'Sample';
        opp.StageName = 'lost';
        opp.Product_Type__c='H';
        opp.Primary_Closed_Reason__c ='Political';
        opp.Closed_Comments__c = 'XYZ';
        opp.Date_Closed__c = date.today().adddays(-1);
        opp.CloseDate = date.today().adddays(2);
        opp.Assigned_UW__c = UserInfo.getuserid();
        opp.recordTypeId=Sgr_TaskHelper_Test.getOpptyRecordTypeIds('Opportunity','SGR Production Opportunity');
        opp.Rating_Status__c = 'Actuarial-Released';
        insert opp;
        
        Test.starttest();
        
        list<Task> TasklistOpp=new list<Task>(); 
        
        //delete t;
        Task t1 = new Task();
        t1.Subject = 'Underwriter Review Complete';
        t1.status = 'Completed';
        t1.Whatid = opp.Id;
        t1.RecordTypeId=SGRTR;
        t1.WhatId=opp.ID;
        insert t1;
        TasklistOpp.add(t1);
        Task t2 = new Task();
        t2.status = 'Completed';
        t2.Whatid = opp.Id;
        t2.subject='Edit Complete';	
        t2.ActivityDate=system.today();
        t2.RecordTypeId=SGRTR;
        insert t2;
        Sgr_TaskHelper.rerun = false;
        update t2;
        TasklistOpp.add(t2);
        //delete t1;
        
        Task t3 = new Task();
        t3.status = 'Completed';
        t3.Whatid = opp.Id;
        t3.subject='Data Review Complete';	
        t3.ActivityDate=system.today();
        t3.RecordTypeId=SGRTR;
        insert t3;
        Sgr_TaskHelper.firsttime = false;
        update t3;
        TasklistOpp.add(t3);
        boolean firsttime = false;
        
        Task t4 = new Task();
        t4.Subject = 'Underwriter Hold Complete';
        t4.status = 'Completed';
        t4.Whatid = opp.Id;
        t4.RecordTypeId=taskUW;
        t4.WhatId=opp.ID;
        insert t4;	
        update t4;
        delete t4;
        
        Sgr_TaskHelper.RerunValidation(TasklistOpp);
        Sgr_TaskHelper.RerunValidation_Data(TasklistOpp);
        Sgr_TaskHelper.updateOppty(TasklistOpp);
        Test.stoptest();
        
        
        
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