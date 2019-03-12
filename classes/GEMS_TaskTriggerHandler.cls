/********************************************************************************

 *
 * Copyright (C) 2016
 * Health Care Service Corporation (HCSC)
 * All Rights Reserved
 * 
 * File: GEMS_TaskTriggerHandler.apxt

*********************************************************************************
 *  Ver     Date(MM/DD/YYYY)  Name              Description
 *  ---     ----------------  ---------------   ----------------------
 * Ranjit Gandhi               10/20/2017            SFDC-6890 GEMS - Underwriting case - Update Task Owner if Case Owner is Changed  
 *  1.1     08/31/2016        Jalaj            Trigger Handler for Trigger on Task object:-
 
                                                Whenever a task is updated or inserted with a Record Type that contains 'GEMS':
                                                - Controls Pharmacy Coding Workflow
                                                - Determines relation between Account Specialist's Task & Pharmacy Coder's Task
            10/08/2017        Luke Chen         SFDC-6659 Pharmacy Scope Code Task: Update BlueSTAR & AS400 - is not opening 
            10/26/2017        Rajeesha          SFDC-6886 GEMS - Underwriting case - Email Notifications upon Return of Task
            10/26/2017        Rajeesha          SFDC-6889 GEMS - Underwriting case - Email Notifications upon Re-Review of Task
            11/08/2017        Malathi           SFDC-6892 GEMS - Underwriting case - Update case status respectively.     
            04/14/2018		  Luke Chen			SFDC-7896 GEMS: UW Tasks need to be reassigned when in "Return" Status                              
*********************************************************************************/

public class GEMS_TaskTriggerHandler {
    
    /* SFDC-6659, new method for SFDC-6659
     * This method is to start the update bluestar task when 
     * 1. scope status is either 'No Scope Code Changes' or 'Scope Change Only - NoBETSub'
     * 2. peer review is completed
     * 3. 'BlueSTAR Update Request' is completed
     */

    public static void startBluestar(List<Task> gemsTaskList){
        Set<Id> parentIdSet = new Set<Id>();
        Set<String> scopeStatus = new Set<String>{GEMS_Constants.RxScopeNoBETSub,GEMS_Constants.RxScopeNoChanges};
        for(Task newTask : gemsTaskList) parentIdSet.add(newTask.whatid);
        system.debug('>>> startBluestar() input scope code ID'); system.debug(parentIdSet);
        Map<Id,GEMS_Pharmacy_Scope_Code__c>  ScopeCodeMap = new Map<Id,GEMS_Pharmacy_Scope_Code__c>([SELECT Id, STatus__c, Case__c, Name, Scope_Status__c FROM GEMS_Pharmacy_Scope_Code__c WHERE Id in :parentIdSet and Scope_Status__c in :scopeStatus]);
        if(ScopeCodeMap.isEmpty()) return; // do nothing if not 'No Scope Code Changes' or 'Scope Change Only - NoBETSub' scope code
        
        // all potential update bluestar tasks
        List<Task> tmpBSTasks = [Select id, status, subject,GEMS_Start_Date__c,GEMS_End_Date__c,WhatId,ownerId from task where whatid in :ScopeCodeMap.keySet() and subject = :GEMS_Constants.RxTaskSubjUpdtBSAS400 and status = :GEMS_Constants.StatusNotStarted ];
        // all BlueSTAR Update Request tasks and scope code task with In Progress status
        List<Task> taskASList = [Select id, status, subject, WhatId, GEMS_Type__C from task where whatid in :ScopeCodeMap.keySet() AND ((GEMS_Type__C = 'Pharmacy Scope Code Account Specialist') OR (subject = :GEMS_Constants.RxTaskSubjPharmaScopeCode and status = :GEMS_Constants.StatusInProgress)) ];
        
        // final list to update bluestar tasks
        List<Task> blueStarTasks = new List<Task>();
        for(Task bsT : tmpBSTasks){
            boolean isToAdd = true;
            for(Task t : taskASList){
                if(t.whatid == bsT.whatid){
                    // scope code is reopen and in progress, skip this bluestar task
                    if(t.subject == GEMS_Constants.RxTaskSubjPharmaScopeCode && t.status == GEMS_Constants.StatusInProgress) isToAdd = false;
                    // bluestar request is not completed yet, skip this one
                    else if(t.GEMS_Type__C == 'Pharmacy Scope Code Account Specialist' && t.status != GEMS_Constants.StatusCompleted) isToAdd = false;
                }
                if( ! isToAdd) break;
            }
            if(isToAdd) blueStarTasks.add(bsT);
        }
        if(blueStarTasks.isEmpty()) return; // bluestar tasks are either In progress or Completed, do nothing
        // update the bluestar tasks, 
        system.debug('>>> startBluestar() blueStarTasks to update'); system.debug(blueStarTasks);
        for (Task CodertaskNew : blueStarTasks){
            CodertaskNew.status = GEMS_Constants.StatusInProgress;
            CodertaskNew.Gems_Start_Date__c = System.Now();
            /*
            GEMS_Pharmacy_Scope_Code__c rxCode = ScopeCodeMap.get(CodertaskNew.whatid);
            rxCode.Status__c = GEMS_Constants.BSAS400Started;
            scopeCodeToUpdate.add(rxCode);
            Case baCase = caseMap.get(CodertaskNew.whatid);
            baCase.Status = rxCode.Status__c;
            caseToUpdate.add(baCase); */
        }
        update blueStarTasks;
        // update (new List<GEMS_Pharmacy_Scope_Code__c>(scopeCodeToUpdate));
        // update (new List<Case>(caseToUpdate));
    }
    

    public static void StartScopeCodeTask(List<Task> Tasks){   
        Boolean isCodeTaskUpdated = false;
        Boolean isScopeCodeUpdated = false;
        Boolean isRelatedBAsUpdated = false;
        List<Task> tasksUpdateList = new List<Task>();
        for (Task taskNew : Tasks){
              GEMS_Pharmacy_Scope_Code__c  ScopeCode = [SELECT Id, STatus__c, Case__c, Name FROM GEMS_Pharmacy_Scope_Code__c WHERE Id =: taskNew.WhatId];
              List<Case> RelatedBACases = [SELECT Id, Status, GEMS_Pharmacy_Scope_Code__c FROM Case WHERE Parent.Id =: ScopeCode.Case__c AND GEMS_Scope_Code_ID__c =: ScopeCOde.Id];
              List<Task> taskList = new List<Task>();
              taskList = [Select id, status, subject,GEMS_Start_Date__c,GEMS_End_Date__c,WhatId,ownerId from task where whatid =: taskNew.WhatId AND GEMS_Type__C = 'Pharmacy Scope Code Owner' order by ID ASC ];
              for (Task CodertaskNew : taskList){
                if(CodertaskNew.subject != GEMS_Constants.RxTaskSubjUpdtBSAS400 && CodertaskNew.status != GEMS_Constants.StatusCompleted){
                    break;
                } else if(CodertaskNew.subject == GEMS_Constants.RxTaskSubjUpdtBSAS400 && CodertaskNew.status == GEMS_Constants.StatusNotStarted){
                    CodertaskNew.status = GEMS_Constants.StatusInProgress;
                    CodertaskNew.Gems_Start_Date__c = System.Now();
                    System.debug('Status = '+CodertaskNew.status);
                    System.debug('Start Date = '+CodertaskNew.Gems_Start_Date__c );
                    ScopeCode.Status__c = GEMS_Constants.BSAS400Started;
                    tasksUpdateList.add(CodertaskNew);
                    isCodeTaskUpdated = true;
                    isScopeCodeUpdated = true;
                }
            }
            if(isCodeTaskUpdated && isScopeCodeUpdated) {
                update ScopeCode;
            }
            if(isScopeCodeUpdated) {
                for (Case BACase:RelatedBACases){
                    BACase.Status = ScopeCode.Status__c;
                    isRelatedBAsUpdated = true;
                }
            }
            if(isRelatedBAsUpdated) {
                update RelatedBACases;
            }
            if(isCodeTaskUpdated && !tasksUpdateList.isEmpty()) {
                update tasksUpdateList;    
            }
        }    
    }
    
//SFDC-6892 - Update Case status to Return when any one of the UW tasks is returned.
/******************************************************************** 
*    Method Name : updateCaseStatus
Action
*   @description :   This Class is to update Case status to Return when the task is returned
*   @parameters  :   List<Task> newTasks, Map<id,Task> oldTasks
*   @return type :   void
***************************************************************/
  public static void updateCaseStatus(List<Task> newTasks, Map<id,Task> oldTasks){     
        Id medicalUWRecordTypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
        Id dentalUWRecordTypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
        Id additionalUWRecordTypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();
        
        
        Set<String> UWtaskCase = new Set<String>();
        
        for(Task UWupdateTask : newTasks){            
            if(UWupdateTask.status != oldTasks.get(UWupdateTask.Id).status && (UWupdateTask.subject == 'Approve ASO Billing' || UWupdateTask.subject == 'Approve Account Paperwork' || UWupdateTask.subject == 'Approve Setup in BlueSTAR') && (UWupdateTask.Status=='Return')) {                                                
                UWtaskCase.add(UWupdateTask.Whatid);                                                 
             }
            }
          if(UWtaskCase.size()>0){           
            List<Case> StatusCase = [Select id, Status from Case where id in: UWtaskCase and (RecordTypeId =: medicalUWRecordTypeid OR RecordTypeId =: dentalUWRecordTypeid OR RecordTypeId =:additionalUWRecordTypeid)];
            for(Case parentCase1 : StatusCase ){
                parentCase1.Status = 'Return';                                    
            }
            update StatusCase;
 }  
 } 
 
 //SFDC-6892 - End changes        
    /******************************************************************** 
    *    Method Name : updateTaskEmail
    Action
    *   @description :   This Class is to update email field on task Object with the Case Owner email
    *   @parameters  :   List<Task> newTasks, Map<id,Task> oldTasks
    *   @return type :   void
    ***************************************************************/
    
    public static void updateTaskEmail(List<Task> newTasks, Map<id,Task> oldTasks){
    Id medicalUWRecordTypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
    Id dentalUWRecordTypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
    Id additionalUWRecordTypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();
      
    
        Map<id,String> taskCase = new Map<id,String>();
        for(Task updateTask : newTasks){
            //* Ranjit Gandhi     SFDC-6890 GEMS - Underwriting case - For underwriting returned tasks
            if((updateTask.subject == 'Approve ASO Billing' || updateTask.subject == 'Approve Account Paperwork' || updateTask.subject == 'Approve Setup in BlueSTAR') && updateTask.Status=='Return')
            updateTask.Last_Assigned_Owner__c = updateTask.OwnerId;
            
             //*     Harsha SFDC-4889 GEMS Start */
            if(updateTask.subject == 'Approve Account Paperwork' && updatetask.Status=='Return' && (oldTasks.get(updateTask.Id).status != 'Return' || updateTask.OwnerId == null)) // SFDC-7896
                updateTask.OwnerId=[select ownerid from case where id=: updateTask.GEMS_Account_Submission_Info__c].ownerId;
            else if((updateTask.subject == 'Approve ASO Billing' || updateTask.subject == 'Approve Setup in BlueSTAR') && updatetask.Status=='Return' && (oldTasks.get(updateTask.Id).status != 'Return' || updateTask.OwnerId == null)) // SFDC-7896
                updateTask.OwnerId=[SELECT MemberId FROM CaseTeamMember WHERE TeamRole.name ='Account Specialist' and ParentId = : updateTask.GEMS_Account_Submission_Info__c].MemberId;
            //*     Harsha SFDC-4889 GEMS END*/
            
            if(updateTask.status != oldTasks.get(updateTask.Id).status && (updateTask.status == 'Re-Review' || updateTask.status == 'Return') && (updateTask.subject == 'Approve ASO Billing' || updateTask.subject == 'Approve Setup in BlueSTAR' || updateTask.subject == 'Approve Account Paperwork')){
            taskCase.put(updateTask.Whatid,updateTask.GEMS_Account_Submission_Owner_Email__c);     
        }
        }
        if(taskCase.size()>0){
        Map<id,String> parentCase = new Map<id,String>();
        List<Case> ownerCase = [Select id, Case_Owner__c, GEMS_Account_Submission_Info__c,GEMS_Owner_Email__c,GEMS_Account_Submission_Info__r.GEMS_Owner_Email__c, GEMS_Account_Submission_Info__r.Case_Owner__c from Case where id in: taskCase.keySet() and (RecordTypeId =: medicalUWRecordTypeid OR RecordTypeId =: dentalUWRecordTypeid OR RecordTypeId =:additionalUWRecordTypeid)];
        for(Case parentCase1 : ownerCase){
            parentCase.put(parentCase1.GEMS_Account_Submission_Info__c, parentCase1.GEMS_Owner_Email__c);     
        }
        List<User> accSpecialist = [Select id, Name, email from User where id in (Select MemberId from CaseTeamMember where TeamRole.Name = 'Account Specialist' and parentId in: parentCase.keySet())];
        for(Task updateEmail : newTasks){
            for(Case newCase : ownerCase){
            if((updateEmail.subject == 'Approve ASO Billing' || updateEmail.subject == 'Approve Account Paperwork' || updateEmail.subject == 'Approve Setup in BlueSTAR') && updateEmail.status == 'Re-Review'){
                if(newCase.GEMS_Owner_Email__c != Null){
                updateEmail.GEMS_Account_Submission_Owner_Email__c = newCase.GEMS_Owner_Email__c;  
                }
                else{
                 updateEmail.GEMS_Account_Submission_Owner_Email__c = system.label.GEMS_Noreply;
                }      
            }
            else if(updateEmail.subject == 'Approve Account Paperwork' && updateEmail.status == 'Return'){
                   if(newCase.GEMS_Account_Submission_Info__r.GEMS_Owner_Email__c != Null){
                   updateEmail.GEMS_Account_Submission_Owner_Email__c = newCase.GEMS_Account_Submission_Info__r.GEMS_Owner_Email__c;
                   }
                   else{
                   updateEmail.GEMS_Account_Submission_Owner_Email__c = system.label.GEMS_Noreply;
                   }      
                }
                
        
        }  
     }
        for(Task updateEmail1 : newTasks){
            for(User u : accSpecialist){
                if((updateEmail1.subject == 'Approve ASO Billing' || updateEmail1.subject == 'Approve Setup in BlueSTAR') && updateEmail1.status == 'Return'){
                    if(u.email != Null){
                    updateEmail1.GEMS_Account_Submission_Owner_Email__c = u.email;      
                    }
                    else{
                    updateEmail1.GEMS_Account_Submission_Owner_Email__c = system.label.GEMS_Noreply;    
                    }
                }
            }
        }
    }

    } 
}