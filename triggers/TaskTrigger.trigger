/*
 * 08/18/2017   Zachary Campbell SFDC-4552 added methods insertCaseCSSFields, updateCaseCSSFields, and PopulateCaseCSSFields
 * 10/8/2017    Luke Chen        SFDC-6659 Pharmacy Scope Code Task: Update BlueSTAR & AS400 - is not opening
    10/26/2017   Rajeesha         SFDC-6886 GEMS - Underwriting case - Email Notifications upon Return of Task
   10/26/2017   Rajeesha         SFDC-6889 GEMS - Underwriting case - Email Notifications upon Re-Review of Task
   10/31/2017   Malathi          SFDC-6892 GEMS - Do not allow deletion of GEMS UW task except for Sys. Admin. 
   12/01/2017   Luke Chen        SFDC-7704 GEMS - Production Bug - APEX Time Out
*/
trigger TaskTrigger on Task (after insert, after update, before insert, before update, after delete, before delete) {
    Map<ID,Schema.RecordTypeInfo> recordType_Map = Task.sObjectType.getDescribe().getRecordTypeInfosById();
    Id taskUW= Schema.SObjectType.task.getRecordTypeInfosByName().get('GEMS UW Task Record Type').getRecordTypeId();
    Id SGRTR =Schema.SObjectType.task.getRecordTypeInfosByName().get('SGR_Task').getRecordTypeId();
    task t= new task();
     if(trigger.new !=NULL){
           t = trigger.new[0];
       }
    List<Task> GEMSTaskList = new List<Task>();
    List<Task> GEMSPeerReivewList = new List<Task>();
    Boolean GEMSFlag = False;
    Integer TotalNumberOfTasks = 0;
    Integer NumberOfGEMSTasks = 0;
    Integer NumberOfMaintenanceTask = 0;
    
    
    if( trigger.isAfter && trigger.isUpdate )
    { 
        Map<ID,Schema.RecordTypeInfo> record_Map = Task.sObjectType.getDescribe().getRecordTypeInfosById();
       
        for(Task t1 : trigger.new){
            if(record_Map.get(t1.recordTypeID) != null && record_Map.get(t1.recordTypeID).getName().containsIgnoreCase('SGR')){          
                set<id> recid = trigger.newMap.keySet();
                List<task> rectypid = new List<task>();
              
                rectypid = trigger.new;
                Sgr_TaskHelper.rerunValidation(rectypid);
                Sgr_TaskHelper.updateOppty(rectypid);
                
            }
        }
    }
   
    if(trigger.isAfter && trigger.isDelete){
        TaskTriggerHandler.insertCaseCSSFields(trigger.old);
    }
    
    // SFDC-6892 Begin change
     if(trigger.isBefore && trigger.isDelete){
            String ProfileId = UserInfo.getProfileId();
            List<Profile> profiles=[select id from Profile where name='System Administrator' ];  
            if (ProfileId != profiles[0].id) {
       for (Task a : Trigger.old)      
          {            
             if ( a.recordtypeid == taskUW) 
            {
             a.addError('You cannot delete this record');
            }
                  
          }
       }
    }
    
    if(Trigger.isAfter && Trigger.isUpdate && t.RecordTypeId!=SGRTR){
        
        GEMS_TaskTriggerHandler.updateCaseStatus(Trigger.new, Trigger.oldMap); 
        
   }
      // SFDC-6892 - End change
      
    if (Trigger.isInsert || Trigger.isUpdate){ 
      //SFDC-6886 & SFDC-6889
        if(Trigger.isBefore && Trigger.isUpdate && t.RecordTypeId!=SGRTR){
        GEMS_TaskTriggerHandler.updateTaskEmail(Trigger.new, Trigger.oldMap);
          
        }
        // End of SFDC-6886 & SFDC-6889
       
        for (Task taskNew : Trigger.New){
            TotalNumberOfTasks = TotalNumberOfTasks + 1;
            if (taskNew.recordTypeID != null){        
                 String TaskName = recordType_Map.get(taskNew.recordTypeID).getName();
                // #Luke SFDC-4719 Account setup maintenance workflow
                if(TaskName == 'Account Setup Maintenance Task'){
                     NumberOfMaintenanceTask = NumberOfMaintenanceTask + 1;
                }
            }                  
            if(recordType_Map.get(taskNew.recordTypeID) != null && recordType_Map.get(taskNew.recordTypeID).getName().containsIgnoreCase('GEMS'))
            {
                Task oldTask = (trigger.oldMap != null ? (Task) trigger.oldMap.get(taskNew.id) : null);             
                NumberOfGEMSTasks = NumberOfGEMSTasks + 1;
                
               if(taskNew.GEMS_Type__c == 'Pharmacy Scope Code Account Specialist' && tasknew.Status == 'Completed' && (oldTask == null || oldTask.status != 'Completed'))
                {
                    GEMSTaskList.add(TaskNew);
                }
                // SFDC-7704 
                // SFDC-6659, fix for the peer review complete not starting update bluestar task
                else if(taskNew.Subject == 'Peer Review' && taskNew.Status == 'Completed' && oldTask != null && oldTask.Status != 'Completed')
                { 
                    GEMSPeerReivewList.add(TaskNew);
                }     
                   
            
        }
            
    
        if (NumberOfGEMSTasks == TotalNumberOfTasks){
            GEMSFlag = True;
        }else if(NumberOfMaintenanceTask == TotalNumberOfTasks) {return; }// #Luke SFDC-4719 Account setup maintenance workflow
        
        else if (GEMSFlag == False){
            if(Test.isRunningTest() || (!Test.isRunningTest() && ConstantsController.CheckTriggerExecution(userinfo.getProfileId(), ConstantsController.TaskTriggerField))){
           
                if(trigger.isAfter && t.RecordTypeId!=SGRTR){
                    if(trigger.isInsert){
                        TaskTriggerHandler.insertCaseCSSFields(trigger.new);
                    }
                    if(trigger.isUpdate){
                        TaskTriggerHandler.updateCaseCSSFields(trigger.new,trigger.oldMap);
                    }

                    if(trigger.isInsert || trigger.isUpdate){
                        TaskTriggerHandler.updateCaseStatus(trigger.new,trigger.newMap);
                        TaskTriggerHandler.sendEmailAlertToTaskOwner(trigger.new,trigger.oldMap);
                    }
                }   
            }
        }
    }
    }
}