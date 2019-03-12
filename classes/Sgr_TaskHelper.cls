global  class Sgr_TaskHelper{
    
    public static boolean firsttime = false;
    public static boolean Rerun = false;
    
    public static void updateOppty(list<Task> taskList){
        
        list<Opportunity> opptyList = new list<Opportunity>();
        set<Id> oppIdSet = new set<Id>();
        map<Id,Opportunity> opptyMap = new map<Id,Opportunity>();
        list<Opportunity> OppMarketRelease = new List<Opportunity>();
        
        for(Task taskObj : taskList){           
            if(taskObj.WhatId.getSObjectType().getDescribe().getName()== 'Opportunity' && taskObj.subject == 'Underwriter Review Complete' 
               && taskObj.status == 'Completed'){
                   oppIdSet.add(taskObj.WhatId);            
               }
            else if(taskObj.WhatId.getSObjectType().getDescribe().getName()== 'Opportunity' && taskObj.subject == 'Underwriter Hold Complete' 
               && taskObj.status == 'Completed'){
                   oppIdSet.add(taskObj.WhatId);            
               }
        }
        system.debug('oppIdSet'+oppIdSet);
        if(oppIdSet.size()>0){
            for(Opportunity op : [SELECT Id,Rating_Status__c,SGR_Workflow_Activity__c,Workflow_System_Status__c,RecordTypeid FROM Opportunity where ID IN :oppIdSet]){
                op.Rating_Status__c = 'Underwriting-Released';
                op.SGR_Workflow_Activity__c = '';
               op.Workflow_System_Status__c='Ready to Send to B-Engaged';

                opptyList.add(op);
                //14320 - Collect the list of production opportunities in a clone list when they are marked as underwriting released. 
                //These production oppportunities will be updated as marketing release once the rating status is updated as underwriting released in the system.                 
                Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId();
                if(sgrProdOpp == op.RecordTypeId){
                    Opportunity op1 = new Opportunity();
                	op1 = op;
                	op1.Rating_Status__c = 'Marketing Release';
                	OppMarketRelease.add(op1);                                  
                }
            }
        }
        system.debug('optylist task size'+opptyList);
        if(opptyList.size()>0){
            Database.update(opptyList,false);
        }
        //14320 - Update the Production Opportunities which are updated with Rating Status as Underwriting Released to Marketing Release once the Underwriting Released is writtent to the system.        
        if(OppMarketRelease.size()>0){
            Database.update(OppMarketRelease,false);
            SGR_BengOppFinal OppFinal = new SGR_BengOppFinal(OppMarketRelease);
            if(!test.isRunningTest()){
               ID jobId = System.enqueueJob(OppFinal);
            }            
        }        
    }
    
    public static void RerunValidation(list<Task> TasklistOpp){
        Task TasknewRerun;
        list<Opportunity> Opp= new list<Opportunity>();
        if(TasklistOpp.size()>0 && TasklistOpp!=null){
            TasknewRerun=TasklistOpp[0];
        }
        
        if(TasknewRerun !=null){ 
            system.debug('rerun :: '+Rerun);
            system.debug('TasknewRerun :: '+TasknewRerun);
            if(TasknewRerun.Status == 'Completed' && TasknewRerun.Subject == 'Edit Complete' && Rerun == false){
                
                Opp=[select id,RecordTypeId,AccountId,County_Code__c,Batch_Id__c,Zip_Code__c, Funding_Type__c, Renewal_Date__c, Product_Type__c, 
                     HCSC_Division__c, Account.ShippingState__c,Rating_Status__c,SGR_Workflow_Activity__c,Assigned_UW__c from Opportunity where Id=:TasknewRerun.whatId];
                
                list<Business_Rule_Validation_Log__c> BRV =[select id from Business_Rule_Validation_Log__c where  OpportunityId__c=:TasknewRerun.whatId];
                if(BRV.size()>0 && BRV!=null) {
                    delete BRV;
                }
                SGR_validationHelper Validation = new SGR_validationHelper(Opp,Opp[0].Batch_Id__c);
                
            }
        }
        
        Rerun = true;
    }
    
    public static void RerunValidation_Data(list<Task> TasklistOpp){
        Task TasknewRerun;
        list<Opportunity> Opp= new list<Opportunity>();
        if(TasklistOpp.size()>0 && TasklistOpp!=null){
            TasknewRerun=TasklistOpp[0];
        }
        if(TasknewRerun !=null){ 
            if(TasknewRerun.Status == 'Completed' && TasknewRerun.Subject == 'Data Review Complete' && firsttime == false){
                
               // system.debug('hello1234');
                Opp=[select id,RecordTypeId,AccountId,County_Code__c,Batch_Id__c,Zip_Code__c, Funding_Type__c, Renewal_Date__c, Product_Type__c, 
                     HCSC_Division__c, Account.ShippingState__c,Rating_Status__c,SGR_Workflow_Activity__c,Assigned_UW__c from Opportunity where Id=:TasknewRerun.whatId];
                
               // list<Business_Rule_Validation_Log__c> BRV =[select id from Business_Rule_Validation_Log__c where  OpportunityId__c=:TasknewRerun.whatId];
                //if(BRV.size()>0 && BRV!=null) {
               //     delete BRV;
              //  }
                SGR_validationHelper Validation = new SGR_validationHelper(Opp,Opp[0].Batch_Id__c);
                
            }
        }
        firsttime=true;
    }  
    
}