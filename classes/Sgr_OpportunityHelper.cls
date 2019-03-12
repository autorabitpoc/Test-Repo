public class Sgr_OpportunityHelper{
    public static boolean rerun = false;
    public static void updatestatus(list<Opportunity> opptyList, map<Id,Opportunity> oldmap){
    
        set<Id> oppHistorySet = new set<Id>();
        list<Opportunity> updateOpptyList=new list<Opportunity>();
        set<Id> accountIdSet = new set<Id>();
        set<Id> oppsIdSet=new set<Id>();
        list<Task> taskList = new list<Task>();
        Id sGRTR =Schema.SObjectType.task.getRecordTypeInfosByName().get('SGR_Task').getRecordTypeId();
        
        list<Task> inserttaskList = new list<Task>();
        for(OpportunityFieldHistory oph : [SELECT Id,opportunityId,oldvalue, NewValue from OpportunityFieldHistory where 
                                           opportunityId IN : opptyList AND Field = 'Rating_Status__c']){
             if(oph.oldvalue == 'Actuarial-Released'){
                 oppHistorySet.add(oph.opportunityId);
             }                            
                                      
        }
        List<Opportunity> opps =[SELECT Id,Assigned_UW__c, Account.renewal_duration_is_infinite__c,Account.Hold_End_Date__c from Opportunity where Id IN : opptyList];
        for(Opportunity op : opps){
           
           DateTime dT = date.today();
           Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            if(op.Account.renewal_duration_is_infinite__c || op.Account.Hold_End_Date__c > myDate){
                accountIdSet.add(op.AccountId);
            }
        }
       
        for(Opportunity op : opptyList){
            if(((op.Assigned_UW__c!=null)  && ((op.Rating_Status__c == 'Actuarial-Released' && oldmap.get(op.Id).Rating_Status__c != 'Actuarial-Released' && 
               oppHistorySet.contains(op.Id) && !accountIdSet.contains(op.AccountId)) && (op.SGR_Workflow_Activity__c!='Underwriting Hold')))){
                op.SGR_Workflow_Activity__c = 'UW Review';
                op.Workflow_System_Status__c='Awaiting Review Task Completion';//#SFDC-16646 global workflow
                updateOpptyList.add(op);
                Task newTask = new task();
                newTask.Subject = 'Underwriter Review Complete';
                newTask.OwnerId = op.Assigned_UW__c;
                newTask.Status = 'Not started';
                newtask.Priority = 'Normal';
                newtask.RecordTypeId =sGRTR;
                newTask.WhatId = op.Id; 
                   
                taskList.add(newTask);
            }
            
        }
        if(taskList.size()>0){
            insert taskList;
        }
          
    }
    
    public static void creatingChildtask(list<Opportunity> opptyList, map<Id,Opportunity> oldmap){
       set<Id> oppHistorySet = new set<Id>();
        list<task> oppSet= new list<task>();
      if(opptyList!=null && opptyList.size()>0){
        oppSet = [select whatid,status from task where status!='Completed' and subject='Edit Complete' and whatid= :opptyList[0].id];
        }
        set<Id> accountIdSet = new set<Id>();
        list<Task> taskList = new list<Task>();
        Id sGRTR =Schema.SObjectType.task.getRecordTypeInfosByName().get('SGR_Task').getRecordTypeId();
             
       
       for(Opportunity op : opptyList){
            if(op.Assigned_UW__c!=null && (op.Rating_Status__c == 'Pended'&& oldmap.get(op.Id).Rating_Status__c != 'Pended') && oppSet.size()==0 && rerun== false){
                op.SGR_Workflow_Activity__c = 'Pend in Progress';
                Task newTask = new task();
                newTask.Subject = 'Edit Complete';
                newTask.OwnerId = op.Assigned_UW__c;
                newTask.Status = 'Not started';
                newtask.Priority = 'Normal';
                newtask.RecordTypeId =sGRTR;
                newTask.WhatId = op.Id; 
                taskList.add(newTask);
            }
            
        }
        if(taskList.size()>0){
            insert taskList;
        }
        rerun=true; 
    }
    
    //Story: SFDC-17474
    //Author: Landry Harris
    public static void updateOpportunityEffectiveDate(List<Opportunity> newOpps, Map<Id,Opportunity> oldmap) {
        for (Opportunity o: newOpps) {
            if (o.Renewal_Date__c != null && (o.Renewal_Date__c != oldmap.get(o.Id).Renewal_Date__c)) {
                o.Requested_Effective_Date__c = o.Renewal_Date__c;
            }
        }
    }
   
}