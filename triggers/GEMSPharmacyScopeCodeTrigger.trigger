/********************************************************************************
 * Copyright (C) 2016
 * Health Care Service Corporation (HCSC)
 * All Rights Reserved
 * File: GEMSPharmacyScopeCodeTrigger.apxt
*********************************************************************************
 *  Ver     Date(MM/DD/YYYY)  Name              Description
 *  ---     ----------------  ---------------   ----------------------
 *  1.1     08/31/2016        Jalaj            Trigger for GEMS_Pharmacy_Scope_Code__c Object:-
 
                                                Whenever user updates or inserts a scope code record:
                                                - Creates appropriate tasks based on Scope Status 
                                                - Manipulates list of tasks when Scope Status is updated
                                                - Determines workflow for Pharmacy Coding
                                                - USed to keep sync. of Scope Code status & related Case Status
                                                
 *  1.2     11/22/2016       Praveen            Added logic to move the Pharmacy Scope Code BA Level Case Status to "Completed" once "Peer Review" task is completed for assigned Scope Code record of status "No Scope Code Changes".
 *  1.3     12/01/2016       Praveen            Added logic not to move the Pharmacy Scope Code BA Level Case Status to "Completed" once "Peer Review" task is completed for assigned Scope Code record of non "No Scope Code Changes"status .
 *  1.4     05/05/2017       Malathi.K          SFDC-3015 - Made changes to only have Pharmacy Scope Code and Peer Review tasks created when "Scope Change only - NoBETSub' is selected.
 *  1.5     7/21/2017        Luke Chen          SFDC-5061 GEMS - Pharmacy Scope Code - missing task
*********************************************************************************/
trigger GEMSPharmacyScopeCodeTrigger on GEMS_Pharmacy_Scope_Code__c (before update, after insert, after update) {
    
   public String GEMSTaskRecordType {
        get {
            Map<String, Schema.RecordTypeInfo> TaskRecordTypeInfo = Task.sObjectType.getDescribe().getRecordTypeInfosByName();
            String TaskRecordTypeId = TaskRecordTypeInfo.get(GEMS_Constants.CaseRecdType_PharmacyCode).getRecordTypeId();
            return TaskRecordTypeId;
        }
        set;
        
    }
    
    /*
    if( trigger.isBefore && trigger.isUpdate) {
        for (GEMS_Pharmacy_Scope_Code__c ScopeCode : Trigger.new) {  
            if(ScopeCode.Status__c == 'Peer Review Approved' && ScopeCode.Scope_Status__c == GEMS_Constants.RxScopeBETReq){
                Task taskk = [Select id, status, subject,GEMS_start_date__c,GEMS_End_Date__c,WhatId,ownerId from task where whatid =: ScopeCode.Id AND subject = 'BET Creation'];
                if (taskk != Null){
                    if (taskk.Status != GEMS_Constants.StatusInProgress){
                        taskk.Status = GEMS_Constants.StatusInProgress;
                        taskk.GEMS_start_date__c = System.now();
                        update taskk;
                    }
                }
            }
        }
    }

    
    if (trigger.isAfter && trigger.isUpdate){
        
        for (GEMS_Pharmacy_Scope_Code__c ScopeCode : Trigger.new) {  
            
            Case ParentCase = [SELECT id, GEMS_Account_Submission_Info__c FROM Case where id =: ScopeCode.Case__c];
            CaseTeamRole role = [SELECT Id FROM CaseTeamRole WHERE Name = 'Account Specialist' limit 1];
            CaseTeamMember AccountSpecialist = [SELECT MemberId FROM CaseTeamMember WHERE TeamRoleId =: role.Id AND ParentID =: ParentCase.GEMS_Account_Submission_Info__c];
            
            if(AccountSpecialist != Null && (ScopeCode.Status__c == 'Prime Build Completed' || ScopeCode.Status__c == 'AS400 & BlueStar Update Started')){
                Task taskk = [SELECT id, status, GEMS_start_date__c, GEMS_End_Date__c FROM Task where whatid =: ScopeCode.Id AND ownerId =: AccountSpecialist.memberId AND Subject = 'Account Specialist BlueStar Update' order by ID ASC ];
                if (taskk != Null){
                    taskk.status = GEMS_Constants.StatusInProgress;
                    taskk.GEMS_start_date__c = System.now();
                    update taskk;
                }
            }
        }
        
    }

    */
    
     if (trigger.isBefore && trigger.isUpdate){
         for (GEMS_Pharmacy_Scope_Code__c ScopeCode : Trigger.new) {
             for (GEMS_Pharmacy_Scope_Code__c OldScopeCode : Trigger.old){
                 if (OldScopeCode.id != ScopeCode.id) continue; // not the same scope code record, skip
                 // Review reject; close the current Review task and go back to the previous task (by creating new tasks)
                 if (ScopeCode.Status__c == 'Peer Review Rejected' && OldScopeCode.Status__c != 'Peer Review Rejected'){
                     List<Case> ListOfBACases =  [SELECT Id, CaseNumber, Status, GEMS_Pharmacy_Scope_Code__c, GEMS_Temp_Scope_Code__c, GEMS_Benefit_Agreement__r.Name, 
                        GEMS_Benefit_Agreement__r.Product_Type__c, GEMS_Benefit_Agreement__r.Product_Name__c, 
                            GEMS_Benefit_Agreement__r.BA_Description__c, GEMS_Benefit_Agreement__r.BA_Fund_Type__c
                                FROM Case WHERE Parent.Id =: ScopeCode.Case__c AND GEMS_Scope_Code_ID__c =: ScopeCode.Id];
                    List<Task> tasklist = new List<Task>();
                    List<Task> tasksToBeDeleted = new List<Task>();
                    integer i = 0;
                    taskList = [Select id, status, subject,GEMS_start_date__c,GEMS_End_Date__c,WhatId,ownerId from task where whatid =: ScopeCode.Id AND ownerId =: ScopeCode.OwnerId AND GEMS_Type__C = 'Pharmacy Scope Code Owner' order by ID ASC ];                           
                    integer sizeOfTaskList = tasklist.size();
                    if(ScopeCode.Scope_Status__c == GEMS_Constants.RxScopeBETReq){    
                        while(i < sizeOfTaskList ){
                             if (tasklist[i].Subject == 'Peer Review' && tasklist[i].Status == GEMS_Constants.StatusInProgress){
                                 tasklist[i].status = GEMS_Constants.StatusCompleted;
                                 tasklist[i].GEMS_End_Date__c = System.now();
                                 i++;
                             }
                             else if (tasklist[i].Subject == 'Prime Build' && tasklist[i].Status == GEMS_Constants.StatusNotStarted){
                                 tasksToBeDeleted.add(tasklist[i]);
                                 taskList.remove(i);
                                 sizeOfTaskList = sizeOfTaskList - 1;
                             }
                             else if (tasklist[i].Subject == 'Update BlueSTAR & AS400' && tasklist[i].Status == GEMS_Constants.StatusNotStarted){
                                 tasksToBeDeleted.add(tasklist[i]);
                                 taskList.remove(i);
                                 sizeOfTaskList = sizeOfTaskList - 1;
                             }
                             else i++;
                        }
                        taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusInProgress, ScopeCode.id, ScopeCode.OwnerId, 'BET Creation', 'Normal', System.Now(), GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
                        taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusNotStarted, ScopeCode.id, ScopeCode.OwnerId, 'Peer Review', 'Normal', null, GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
                        taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusNotStarted, ScopeCode.id, ScopeCode.OwnerId, 'Prime Build', 'Normal', null, GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
                        taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusNotStarted, ScopeCode.id, ScopeCode.OwnerId, 'Update BlueSTAR & AS400', 'Normal', null, GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
                        
                        for (Case C : ListOfBACases){
                            C.Status = 'BET Creation Started';
                        }
                        ScopeCode.status__c = 'BET Creation Started';
                    }
                    
                    else if (ScopeCode.Scope_Status__c == GEMS_Constants.RxScopeNoChanges || ScopeCode.Scope_Status__c == GEMS_Constants.RxScopeNoBETSub){
                         while(i < sizeOfTaskList ){
                             if (tasklist[i].Subject == 'Peer Review' && tasklist[i].Status == GEMS_Constants.StatusInProgress){
                                 tasklist[i].status = GEMS_Constants.StatusCompleted;
                                 tasklist[i].GEMS_End_Date__c = System.now();
                                 i++;
                             }
                             else if (tasklist[i].Subject == 'Update BlueSTAR & AS400' && tasklist[i].Status == GEMS_Constants.StatusNotStarted){
                                 tasksToBeDeleted.add(tasklist[i]);
                                 taskList.remove(i);
                                 sizeOfTaskList = sizeOfTaskList - 1;
                             }
                             else i++;                           
                        }                                        
                        taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusInProgress, ScopeCode.id, ScopeCode.OwnerId, 'Pharmacy Scope Code', 'Normal', System.Now(), GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
                        taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusNotStarted, ScopeCode.id, ScopeCode.OwnerId, 'Peer Review', 'Normal', null, GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
                        taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusNotStarted, ScopeCode.id, ScopeCode.OwnerId, 'Update BlueSTAR & AS400', 'Normal', null, GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
                        for (Case C : ListOfBACases){
                            C.Status = GEMS_Constants.StatusInProgress;
                        }
                        ScopeCode.status__c = GEMS_Constants.StatusInProgress;
                        
                    }
                    /* merge to above else if block
                    else if (ScopeCode.Scope_Status__c == GEMS_Constants.RxScopeNoBETSub){
                        
                         while(i < sizeOfTaskList ){
                             if (tasklist[i].Subject == 'Peer Review' && tasklist[i].Status == GEMS_Constants.StatusInProgress){
                                 tasklist[i].status = GEMS_Constants.StatusCompleted;
                                 tasklist[i].GEMS_End_Date__c = System.now();
                             }
                             else if (tasklist[i].Subject == 'Update BlueSTAR & AS400' && tasklist[i].Status == GEMS_Constants.StatusNotStarted){
                                 tasksToBeDeleted.add(tasklist[i]);
                                 // taskList.remove(i);
                                 sizeOfTaskList = sizeOfTaskList - 1;
                             }
                             i = i +1;
                        }                                          
                        taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusInProgress, ScopeCode.id, ScopeCode.OwnerId, 'Pharmacy Scope Code', 'Normal', System.Now(), GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
                        taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusNotStarted, ScopeCode.id, ScopeCode.OwnerId, 'Peer Review', 'Normal', null, GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
                                         
                        for (Case C : ListOfBACases){                      
                            C.Status = GEMS_Constants.StatusInProgress;
                        }
                                            
                         ScopeCode.status__c = GEMS_Constants.StatusInProgress;                   
                    }
                    */
                    delete tasksToBeDeleted;
                    upsert taskList;
                    //update ScopeCode;
                    update ListOfBACases;
               
                 } // end of if (ScopeCode.Status__c == 'Peer Review Rejected' && OldScopeCode.Status__c != 'Peer Review Rejected')
             } // end for
         }  // end for
     } // end if (trigger.isBefore && trigger.isUpdate)
    
     if (trigger.isAfter && trigger.isUpdate){
        List<GEMS_Pharmacy_Scope_Code__c> ownerChangedPharmacyScopeCodeList = new List<GEMS_Pharmacy_Scope_Code__c>();
        List<GEMS_Pharmacy_Scope_Code__c> otherChangesPharmacyScopeCodeList = new List<GEMS_Pharmacy_Scope_Code__c>();
        
        for(GEMS_Pharmacy_Scope_Code__c pharmacyScopeRecord: trigger.new)
        {
            if(pharmacyScopeRecord.OwnerId != trigger.oldmap.get(pharmacyScopeRecord.id).OwnerId)
            {
                ownerChangedPharmacyScopeCodeList.add(pharmacyScopeRecord);
            }
            else if (pharmacyScopeRecord!=null)
            {
                otherChangesPharmacyScopeCodeList.add(pharmacyScopeRecord);
            }
        }
        System.debug('ownerChangedPharmacyScopeCodeList=======================>'+ownerChangedPharmacyScopeCodeList);
        
        if(ownerChangedPharmacyScopeCodeList !=null && !ownerChangedPharmacyScopeCodeList.isEmpty())
        {
            Set<Id> pharmacyScopeRecordIdsSet = new Set<Id>();
            Map<Id, GEMS_Pharmacy_Scope_Code__c> pharmScopeIdRecordMap = new Map<Id, GEMS_Pharmacy_Scope_Code__c>();
            for(GEMS_Pharmacy_Scope_Code__c pharmacyScopeRecord: ownerChangedPharmacyScopeCodeList)
            {
                pharmacyScopeRecordIdsSet.add(pharmacyScopeRecord.Id);
                pharmScopeIdRecordMap.put(pharmacyScopeRecord.Id, pharmacyScopeRecord);
            }
            
            List<Task> pharmacyScopeUpdatedTasksList = new List<Task>();
            List<Task> pharmacyScopeTasks = new List<Task>();
            pharmacyScopeTasks = [Select id, status, subject,GEMS_Start_Date__c,GEMS_Type__C,GEMS_End_Date__c,WhatId,ownerId,owner.name from task where whatid IN: pharmacyScopeRecordIdsSet AND status != :GEMS_Constants.StatusCompleted AND GEMS_Type__C = 'Pharmacy Scope Code Owner'];
            System.debug('pharmacyScopeTasks=========>'+pharmacyScopeTasks);
            if(!pharmacyScopeTasks.isEmpty())
            {
                for(Task taskRecord: pharmacyScopeTasks)
                {
                    taskRecord.ownerId = pharmScopeIdRecordMap.get(taskRecord.whatId).ownerId;
                    pharmacyScopeUpdatedTasksList.add(taskRecord);
                }
                if(!pharmacyScopeUpdatedTasksList.isEmpty())
                {
                    update pharmacyScopeUpdatedTasksList;
                }
            }
        }
        
        if(!otherChangesPharmacyScopeCodeList.isEmpty())
        {
            for (GEMS_Pharmacy_Scope_Code__c ScopeCode : otherChangesPharmacyScopeCodeList) {
                for (GEMS_Pharmacy_Scope_Code__c OldScopeCode : Trigger.old){
                    if (OldScopeCode.id != ScopeCode.id) continue; // not the same scope code record, skipv
                    if (ScopeCode.Status__c == 'Peer Review Approved' && OldScopeCode.Status__c != 'Peer Review Approved'){
                        List<Case> ListOfBACases =  [SELECT Id, CaseNumber, Status, GEMS_Pharmacy_Scope_Code__c, GEMS_Temp_Scope_Code__c, GEMS_Benefit_Agreement__r.Name, 
                                GEMS_Benefit_Agreement__r.Product_Type__c, GEMS_Benefit_Agreement__r.Product_Name__c, 
                                    GEMS_Benefit_Agreement__r.BA_Description__c, GEMS_Benefit_Agreement__r.BA_Fund_Type__c, GEMS_Pharmacy_Is_Complete__c
                                        FROM Case WHERE Parent.Id =: ScopeCode.Case__c AND GEMS_Scope_Code_ID__c =: ScopeCode.Id];
                        for (Case C : ListOfBACases){
                            C.Status = 'Peer Review Approved';
                            /*
                            if(ScopeCode.Scope_Status__c==GEMS_Constants.RxScopeNoChanges)
                            {
                                C.Status = GEMS_Constants.StatusCompleted;
                            }
                            */
                            /* SFDC 5061 - remove below block because case is not completed yet due to addtional B* task
                            // Malathi.K Included criteria for Scope Change Only.
                            if((ScopeCode.Scope_Status__c==GEMS_Constants.RxScopeNoChanges  || ScopeCode.Scope_Status__c==GEMS_Constants.RxScopeNoBETSub) && ScopeCode.Is_BlueSTAR_Update_Request_Task_Cmpltd__c)
                            {
                                C.Status = GEMS_Constants.StatusCompleted;
                            }
                            //Added New line for Operational Reports - set is complete flag as true on Scope Code BA level Case
                            C.GEMS_Pharmacy_Is_Complete__c = ScopeCode.Is_Complete__c;
                            */
                        }
                        List<Task> tasklist = new List<Task>();
                        taskList = [Select id, status, subject,GEMS_start_date__c,GEMS_End_Date__c,WhatId,ownerId from task where whatid =: ScopeCode.Id AND ownerId =: ScopeCode.OwnerId AND GEMS_Type__C = 'Pharmacy Scope Code Owner' order by ID ASC ];                           
                        for (Task taskk : tasklist){
                            if(taskk.Subject == 'Peer Review'){
                                taskk.Status = GEMS_Constants.StatusCompleted;
                                taskk.GEMS_End_Date__c = System.now();
                            }
                        }
                        update tasklist;
                        update ListOfBACases;
                    }
                    /* SFDC 5061 - case is not completed yet after review due to additional bluestar task
                     // Malathi.K Included criteria for Scope Change Only.
                    else if( (ScopeCode.Scope_Status__c==GEMS_Constants.RxScopeNoChanges || ScopeCode.Scope_Status__c==GEMS_Constants.RxScopeNoBETSub) && ScopeCode.Status__c == 'Peer Review Approved' && ScopeCode.Is_BlueSTAR_Update_Request_Task_Cmpltd__c && ScopeCode.Is_BlueSTAR_Update_Request_Task_Cmpltd__c!= OldScopeCode.Is_BlueSTAR_Update_Request_Task_Cmpltd__c)
                    {
                        List<Case> ListOfBACases =  [SELECT Id, CaseNumber, Status, GEMS_Pharmacy_Scope_Code__c, GEMS_Temp_Scope_Code__c, GEMS_Benefit_Agreement__r.Name, 
                                                        GEMS_Benefit_Agreement__r.Product_Type__c, GEMS_Benefit_Agreement__r.Product_Name__c, 
                                                        GEMS_Benefit_Agreement__r.BA_Description__c, GEMS_Benefit_Agreement__r.BA_Fund_Type__c, GEMS_Pharmacy_Is_Complete__c
                                                        FROM Case WHERE Parent.Id =: ScopeCode.Case__c AND GEMS_Scope_Code_ID__c =: ScopeCode.Id];
                        for (Case C : ListOfBACases)
                        {
                            c.Status = GEMS_Constants.StatusCompleted;
                        }
                        update ListOfBACases;
                    } 
                    */
                    else if (ScopeCode.Status__c == GEMS_Constants.StatusInProgress && OldScopeCode.Status__c != GEMS_Constants.StatusInProgress ){
                        List<Case> ListOfBACases =  [SELECT Id, CaseNumber, Status, GEMS_Pharmacy_Scope_Code__c, GEMS_Temp_Scope_Code__c, GEMS_Benefit_Agreement__r.Name, 
                                GEMS_Benefit_Agreement__r.Product_Type__c, GEMS_Benefit_Agreement__r.Product_Name__c, 
                                    GEMS_Benefit_Agreement__r.BA_Description__c, GEMS_Benefit_Agreement__r.BA_Fund_Type__c
                                        FROM Case WHERE Parent.Id =: ScopeCode.Case__c AND GEMS_Scope_Code_ID__c =: ScopeCode.Id];
                        for (Case C : ListOfBACases){
                            C.Status = GEMS_Constants.StatusInProgress;
                        }
                        update ListOfBACases;
                    }
                    
                    else if (ScopeCode.Status__c == 'Update BlueSTAR & AS400 Completed' && OldScopeCode.Status__c != 'Update BlueSTAR & AS400 Completed'){
                        List<Case> ListOfBACases =  [SELECT Id, CaseNumber, Status, GEMS_Pharmacy_Scope_Code__c, GEMS_Temp_Scope_Code__c, GEMS_Benefit_Agreement__r.Name, 
                                GEMS_Benefit_Agreement__r.Product_Type__c, GEMS_Benefit_Agreement__r.Product_Name__c, 
                                    GEMS_Benefit_Agreement__r.BA_Description__c, GEMS_Benefit_Agreement__r.BA_Fund_Type__c, GEMS_Pharmacy_Is_Complete__c
                                        FROM Case WHERE Parent.Id =: ScopeCode.Case__c AND GEMS_Scope_Code_ID__c =: ScopeCode.Id];
                        for (Case C : ListOfBACases){
                            //C.Status = GEMS_Constants.StatusInProgress;
                            C.Status = 'Update BlueSTAR & AS400 Completed';
                            //Added New line for Operational Reports - set is complete flag as true on Scope Code BA level Case
                            C.GEMS_Pharmacy_Is_Complete__c = ScopeCode.Is_Complete__c;
                        }
                        update ListOfBACases;
                    }
                    
                    // #Luke already checked if same record (id) in the beginning, remove the "OldScopeCode.id == ScopeCode.id"
                    // if (OldScopeCode.id == ScopeCode.id && OldScopeCode.Scope_Status__c != ScopeCode.Scope_Status__c){
                    if (OldScopeCode.Scope_Status__c != ScopeCode.Scope_Status__c){ 
                        List<Task> taskList= new List<Task>();
                        List<Task> tasksToBeDeleted = new List<Task>();
                        Integer i = 0;
                        Integer sizeOfTaskList;
                        taskList = [Select id, status, subject,GEMS_start_date__c,GEMS_End_Date__c,WhatId,ownerId from task where whatid =: ScopeCode.Id AND ownerId =: ScopeCode.OwnerId AND GEMS_Type__C = 'Pharmacy Scope Code Owner' order by ID ASC ];                           
                        if (taskList != Null){
                           sizeOfTaskList = taskList.size(); 
                        }                        
                        if (OldScopeCode.Scope_Status__c == GEMS_Constants.RxScopeBETReq) {
                            if ((ScopeCode.Scope_Status__c == GEMS_Constants.RxScopeNoChanges) || (ScopeCode.Scope_Status__c == GEMS_Constants.RxScopeNoBETSub)) {
                                while (i < sizeOfTaskList){
                                    if ((taskList[i].subject == 'BET Creation' && tasklist[i].status != GEMS_Constants.StatusCompleted) || (taskList[i].subject == 'Prime Build' && tasklist[i].status != GEMS_Constants.StatusCompleted)) {
                                        tasksToBeDeleted.add(taskList[i]);
                                        tasklist.remove(i);
                                        sizeOfTaskList = sizeOfTaskList - 1;
                                    }else i++;        
                                } 
                            }
                        }
                       
                        if(ScopeCode.Scope_Status__c == GEMS_Constants.RxScopeBETReq){                         
                            if ((OldScopeCode.Scope_Status__c == GEMS_Constants.RxScopeNoChanges) || (OldScopeCode.Scope_Status__c == GEMS_Constants.RxScopeNoBETSub)) {
                                String RXCodeTaskStatus = GEMS_Constants.StatusCompleted;
                                while (i < sizeOfTaskList){
                                    if ((taskList[i].subject == 'Peer Review' && tasklist[i].status != GEMS_Constants.StatusCompleted) || (taskList[i].subject == 'Update BlueSTAR & AS400' && tasklist[i].status != GEMS_Constants.StatusCompleted)) {
                                        tasksToBeDeleted.add(taskList[i]);
                                        tasklist.remove(i);
                                        sizeOfTaskList = sizeOfTaskList - 1;
                                    }else if(taskList[i].subject == 'Pharmacy Scope Code') {
                                        RXCodeTaskStatus = tasklist[i].status;
                                        i++;
                                    }else i++;       
                                } 
                                Task taskk3 = GEMS_Utility.createTask(GEMS_Constants.StatusNotStarted, ScopeCode.id, ScopeCode.OwnerId, 'BET Creation', 'Normal', null, GEMSTaskRecordType, 'Pharmacy Scope Code Owner');
                                if (RXCodeTaskStatus == GEMS_Constants.StatusCompleted) {
                                    taskk3.status = GEMS_Constants.StatusInProgress;
                                    taskk3.GEMS_Start_Date__c = System.Now();
                                }   
                                taskList.add(taskk3);
                                taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusNotStarted, ScopeCode.id, ScopeCode.OwnerId, 'Peer Review', 'Normal', null, GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
                                taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusNotStarted, ScopeCode.id, ScopeCode.OwnerId, 'Prime Build', 'Normal', null, GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
                                taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusNotStarted, ScopeCode.id, ScopeCode.OwnerId, 'Update BlueSTAR & AS400', 'Normal', null, GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
                            }
                            /* #SFDC-5061 redundant else-if block because already included in if-block
                            else if (OldScopeCode.Scope_Status__c == GEMS_Constants.RxScopeNoBETSub){
                                while (i < sizeOfTaskList){
                                    if ((taskList[i].subject == 'Peer Review' && tasklist[i].status == GEMS_Constants.StatusNotStarted) || (taskList[i].subject == 'Prime Build' && tasklist[i].status == GEMS_Constants.StatusNotStarted) || (taskList[i].subject == 'Update BlueSTAR & AS400' && tasklist[i].status == GEMS_Constants.StatusNotStarted)) {
                                        tasksToBeDeleted.add(taskList[i]);
                                        //tasklist.remove(i);
                                        //sizeOfTaskList = sizeOfTaskList - 1;
                                    }
                                    i = i + 1;        
                                } 
                                Task taskk3 = new Task();
                                if (ScopeCode.Status__c != 'Peer Review Approved') {
                                    taskk3.status = GEMS_Constants.StatusNotStarted;   
                                }
                                else {
                                    taskk3.status = GEMS_Constants.StatusInProgress;
                                }   
                                taskk3.WhatId = ScopeCode.id;
                                taskk3.OwnerId = ScopeCode.OwnerId;
                                taskk3.Subject = 'BET Creation';
                                taskk3.priority = 'Normal';
                                taskk3.recordTypeId = GEMSTaskRecordType;
                                taskk3.GEMS_Type__C = 'Pharmacy Scope Code Owner';
                                taskList.add(taskk3);
               
                                Task taskk4 = new Task();
                                taskk4.status = GEMS_Constants.StatusNotStarted;
                                taskk4.WhatId = ScopeCode.id;
                                taskk4.OwnerId = ScopeCode.OwnerId;
                                taskk4.Subject = 'Peer Review';
                                taskk4.priority = 'Normal';
                                taskk4.recordTypeId = GEMSTaskRecordType;
                                taskk4.GEMS_Type__C = 'Pharmacy Scope Code Owner';
                                taskList.add(taskk4);
                      
                                Task taskk5 = new Task();
                                taskk5.status = GEMS_Constants.StatusNotStarted;
                                taskk5.WhatId = ScopeCode.id;
                                taskk5.OwnerId = ScopeCode.OwnerId;
                                taskk5.Subject = 'Prime Build';
                                taskk5.priority = 'Normal';
                                taskk5.recordTypeId = GEMSTaskRecordType;
                                taskk5.GEMS_Type__C = 'Pharmacy Scope Code Owner';
                                taskList.add(taskk5);
                                
                                Task taskk6 = new Task();
                                taskk6.status = GEMS_Constants.StatusNotStarted;
                                taskk6.WhatId = ScopeCode.id;
                                taskk6.OwnerId = ScopeCode.OwnerId;
                                taskk6.Subject = 'Update BlueSTAR & AS400';
                                taskk6.priority = 'Normal';
                                taskk6.recordTypeId = GEMSTaskRecordType;
                                taskk6.GEMS_Type__C = 'Pharmacy Scope Code Owner';
                                taskList.add(taskk6);       
                            }
                            */
                        }
                        upsert taskList;
                        Delete tasksToBeDeleted;
                    }            
                }
            //GEMS_ViewScopeCodeDetailController.firstRun = True;
            //GEMS_ViewScopeCodeDetailController.refreshAfterTrigger();
            }
        }
        
     }
     
     if (trigger.isAfter && trigger.isInsert){
        
        List<Task> taskList = new List<Task>();
        for (GEMS_Pharmacy_Scope_Code__c ScopeCode : Trigger.new) {  
            
            Case ParentCase = [SELECT id, GEMS_Account_Submission_Info__c FROM Case where id =: ScopeCode.Case__c];
            CaseTeamRole role = [SELECT Id FROM CaseTeamRole WHERE Name = 'Account Specialist' limit 1];
            CaseTeamMember AccountSpecialist = [SELECT MemberId FROM CaseTeamMember WHERE TeamRoleId =: role.Id AND ParentID =: ParentCase.GEMS_Account_Submission_Info__c ORDER By MemberId ASC limit 1];
            taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusInProgress, ScopeCode.id, ScopeCode.OwnerId, 'Pharmacy Scope Code', 'Normal', System.Now(), GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
            if(AccountSpecialist != Null)
                taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusNotStarted, ScopeCode.id, AccountSpecialist.MemberId, 'BlueSTAR Update Request', 'Normal', System.Now(), GEMSTaskRecordType, 'Pharmacy Scope Code Account Specialist'));
            if (ScopeCode.Scope_Status__c == GEMS_Constants.RxScopeBETReq)
                taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusNotStarted, ScopeCode.id, ScopeCode.OwnerId, 'BET Creation', 'Normal', null, GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
            taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusNotStarted, ScopeCode.id, ScopeCode.OwnerId, 'Peer Review', 'Normal', null, GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
            if (ScopeCode.Scope_Status__c == GEMS_Constants.RxScopeBETReq)                   
                taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusNotStarted, ScopeCode.id, ScopeCode.OwnerId, 'Prime Build', 'Normal', null, GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
            // #SFDC-5061 All will have 'Update BlueSTAR & AS400' task at the end
            taskList.add(GEMS_Utility.createTask(GEMS_Constants.StatusNotStarted, ScopeCode.id, ScopeCode.OwnerId, 'Update BlueSTAR & AS400', 'Normal', null, GEMSTaskRecordType, 'Pharmacy Scope Code Owner'));
        }
        if(taskList.size() > 0) insert taskList;
    }
}