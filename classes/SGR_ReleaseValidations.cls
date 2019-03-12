/**************************************************************************************
Apex Class Name     : SGR_ReleaseValidations  
Version             : 1.0
Function            : This class is used for validating the Updates on the Workflow status.
Modification Log    :
* Developer:  SantoshKumar Nalli                 Date  : 01/10/2018               Description
* ----------------------------------------------------------------------------               
*************************************************************************************/

public class SGR_ReleaseValidations {
   @AuraEnabled
   public static List<String> initiateValidation(List<Opportunity>  opps)
    {
        
       Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId();
       list<Opportunity> oppUpdateList=new List<Opportunity>();
       String msg ='';
       List<String> msgLst = new List<String>();
       set<Id> oppHistorySet = new set<Id>();
       list<Opportunity> oppMarketRelease = new List<Opportunity>();
        
        List<OpportunityFieldHistory> opph=[SELECT Id,opportunityId,oldvalue, NewValue from OpportunityFieldHistory where  opportunityId IN :opps AND Field = 'Rating_Status__c'];
            for (OpportunityFieldHistory op:opph)
            {
                if(op.oldvalue=='Actuarial-Released')
                {
                     oppHistorySet.add(op.opportunityId);
                }
                    
            }
        //Processing List of opportunities to  validate
        list<Task> inserttaskList = new list<Task>();
        for(opportunity temp:opps){
            //Manipulating SGR workflow status based on conditions.
            if(temp.RecordTypeid == sgrProdOpp){ 
            if(temp.Rating_Status__c=='Rated')
             
            {
                temp.Rating_Status__c ='Actuarial-Released';
            }
            if(((temp.Account.renewal_duration_is_infinite__c==true) || (temp.Renewal_Date__c <= temp.Account.hold_end_date__c)) && !oppHistorySet.contains(temp.Id) )//Account.Renewal_Date__c&& temp.Rating_Status__c =='Actuarial-Released')//( temp.Account.Status__c =='Underwriter hold' &&  (temp.Account.Renewal_Date__c <= temp.Account.hold_end_date__c || temp.Account.renewal_duration_is_infinite__c==true ) && temp.Rating_Status__c =='Actuarial-Released')
            {  
                temp.SGR_Workflow_Activity__c='Underwriting Hold';
                temp.Workflow_System_Status__c='Awaiting Hold Task Completion';
                
                if(temp.Assigned_UW__c!=null){
                Task newTask = new task();
                newTask.Subject = 'Underwriter Hold Complete';
                newTask.OwnerId = temp.Assigned_UW__c;
                newTask.Status = 'New';
                newtask.Priority = 'Normal';
                newTask.WhatId = temp.Id; 
                inserttaskList.add(newTask);
            }
            
            }
            
            else if((temp.Renewal_Date__c > temp.Account.hold_end_date__c && temp.Account.renewal_duration_is_infinite__c==false) && !oppHistorySet.contains(temp.Id) )//&& temp.Rating_Status__c =='Actuarial-Released' ( temp.Account.Status__c =='Underwriter hold' &&  (temp.Account.Renewal_Date__c > temp.Account.hold_end_date__c || temp.Account.renewal_duration_is_infinite__c==false ) && temp.Rating_Status__c =='Actuarial-Released')
            {
                temp.SGR_Workflow_Activity__c='';
                temp.Rating_Status__c='Underwriting-Released';
                temp.Workflow_System_Status__c='Ready to Send to B-Engaged';
                //14320 - Collect the list of opportunities in a clone list when they are marked as underwriting released. 
                //These production oppportunities will be updated as marketing release once the rating status is updated as underwriting released in the system. 
                Opportunity temp1 = new Opportunity();
                temp1 = temp;
                temp1.Rating_Status__c = 'Marketing Release';
                oppMarketRelease.add(temp1);
            }
            
        }
            else{
                temp.SGR_Workflow_Activity__c='';
            	temp.Rating_Status__c='Underwriting-Released';
                temp.Workflow_System_Status__c='Ready to Send to B-Engaged';
                }
        oppUpdateList.add(temp);
        }
        
        if(! oppUpdateList.isEmpty() && oppUpdateList.size()>0){
           update oppUpdateList; //updating opportunities
        }
        //14320 - Update the Production Opportunities which are updated with Rating Status as Underwriting Released to Marketing Release once the Underwriting Released is writtent to the system.
        if(! oppMarketRelease.isEmpty() && oppMarketRelease.size()>0){
           update oppMarketRelease;
            SGR_BengoppFinal oppFinal = new SGR_BengoppFinal(oppMarketRelease);
            if(!test.isRunningTest()){
                //Submit B-engage final transmission for opportunities once the opportunities are updated with ratings tatus as marketing release.
               ID jobId = System.enqueueJob(oppFinal);
            }            
        }        
           
        if(inserttaskList.size()>0){
            insert inserttaskList;
        }
                             
           msg = 'Opportunities  Workflow status updated successfully';
           msgLst.add(msg);
           return msgLst;
    }
    
}