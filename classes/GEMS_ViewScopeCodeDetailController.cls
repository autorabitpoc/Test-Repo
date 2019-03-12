/******************************************************************************************************************************
Class: GEMS_ViewScopeCodeDetailController.cls

Description:
Whenever user clicks on Scope Code on Pharmacy Coding Related List on Pharmacy Coding Case, class is initiated for the following scenarios 
    - Retrieving Scope Code details from the database 
    - Retrieving tasks & status of tasks
    - Sending for Peer Review   
    - Performing Validations 
    - Pharmacy Coding Workflow

  Ver     Date(MM/DD/YYYY)  Name                    Description
  ---     ----------------  ---------------         ----------------------
  1.1     08/31/2016        Jalaj                   Controller for GEMSViewScopeDetail VF Page:
  1.2     09/22/2016        Praveen                 Changes made to update the case status to "AS400 & BlueStar Update Completed" instead "Update BlueSTAR & AS400 Completed"
  1.3     11/04/2016        Praveen                 Added logic to refresh entire page on save of Pharmacy Scope code record for tasks rendering issue.
  1.4     12/04/2016        Praveen                 Added logic to update Is_BlueSTAR_Update_Request_Task_Cmpltd__c boolean when Update BlueStar Update Request task is completed for assigned Pharmacy Scope Code.
  1.5     06/02/2017        Phani Kommareddy        SFDC-3879 Updates on AS should update Pharmacy scode AS tasks uncompleted   
  1.6     07/23/2017        Phani Kommareddy        SFDC-4226 Pharmacy Scope Code - trigger approval workflow off task completion, not button
  1.7     07/25/2017        Shankar                 SFDC-5101 Pharmacy Scope Code - Removed "Verify BlueSTAR" and "Update AS400" checkboxes & validation
  1.8     10/26/2017        Bharath                 SFDC-6384 Include the link to Pharmacy Scope Code in the email notification.
  		   5/13/2018		Luke Chen				SFDC-6944 GEMS: Account Setup - Allow AS to re-assign their task on Scope Code page
**********************************************************************************************************************************/

public without Sharing class GEMS_ViewScopeCodeDetailController {
    
    public Integer selectedVal{get;set;}
    
    public Id CurrentUserId {get;set;}
    public List<GEMS_Pharmacy_Scope_Code__c> AllScopeCodes{set;get;}
    public Task assignedAsTask {get;set;}  // SFDC-6944
    public Boolean allAsTaskComplete {get;set;} // SFDC-6944
    
    public String GEMSTaskRecordType {
        get {            
            Map<String, Schema.RecordTypeInfo> TaskRecordTypeInfo = Task.sObjectType.getDescribe().getRecordTypeInfosByName();
            String TaskRecordTypeId = TaskRecordTypeInfo.get('GEMS Pharmacy Scope Code').getRecordTypeId();
            return TaskRecordTypeId;
        }
        set;
        
    }
    
    Public List<SelectOption> options{
        get {
            options = new List<SelectOption>(); 
            options.add(new SelectOption('Yes','Yes')); 
            options.add(new SelectOption('No','No')); 
            return Options;
        }
        set;
    }
    
    public GEMS_Pharmacy_Scope_Code__c ScopeCodeRecord{get;set;}
    
    public String selectParamVal{get; set;}
    
    
    
    public GEMS_Pharmacy_Scope_Code__c PermScopeCodeRecord {
        get {
            String RecType = ScopeCodeRecord.Type__c;
            if( RecType =='Permanent'){
                return ScopeCodeRecord;
            } else {
                return [SELECT Id, Owner.Id, Name, Case__c, Temp__c, Type__c, Related_Scope_Code__c, Mail__c, Retail__c, Peer_Review_Reject_Counter__c,
                        Group_Pay_Code__c, Copay_Type__c, Rider_Code__c, Scope_Status__c, Status__c, Peer_Reviewer__c, Owner.Name, Related__c,
                        Accums_Integration__c, Formulary_Type__c, Prime_Certify_Date__c, Prime_Plan_ID__c, Report_Format_Code__c, Comments__c,
                        Case__r.CaseNumber, Case__r.HCSC_Division__c, Case__r.GEMS_Case_Effective_Date__c, Case__r.GEMS_Case_Effective_Date_Email__c, Case__r.GEMS_Submission_Type__c,
                        Case__r.GEMS_Submission_Sub_Type__c, Case__r.GEMS_Line_of_Business__c, Case__r.GEMS_Account_Submission_Info__c, 
                        Case__r.Market_Segment__c, Case__r.Status, Case__r.Owner.Name, Case__r.GEMS_Type__c, Case__r.Account.AccountNumber, 
                        Case__r.Account.External_ID__c, Case__r.Account.Name, Verify_BlueSTAR__c, Update_AS400__c,
                        Is_BlueSTAR_Update_Request_Task_Cmpltd__c
                        FROM GEMS_Pharmacy_Scope_Code__c WHERE Id =: ScopeCodeRecord.Related__c];
            }
        }
        set;
    }
    
    public CaseTeamMember AccountSpecialist{
        get{
            CaseTeamRole role = [SELECT Id FROM CaseTeamRole WHERE Name = 'Account Specialist' limit 1];
            return [SELECT MemberId FROM CaseTeamMember WHERE TeamRoleId =: role.Id AND ParentID =: PermScopeCodeRecord.Case__r.GEMS_Account_Submission_Info__c ORDER By LastModifiedDate  DESC limit 1];
        }
        set;
    }
    
    public List<Task> listOfAccountSpecialistTasks{get; set;}
    
    public List<GEMS_Pharmacy_Scope_Code__c> RelatedScopeCodeRecords{
        get{
            return [SELECT Id, Owner.Id, Name, Case__c, Temp__c, Type__c, Related_Scope_Code__c, Mail__c, Retail__c, Peer_Review_Reject_Counter__c,
                    Group_Pay_Code__c, Copay_Type__c, Rider_Code__c, Scope_Status__c, Status__c, Peer_Reviewer__c, Owner.Name, Related__c,
                    Accums_Integration__c, Formulary_Type__c, Prime_Certify_Date__c, Prime_Plan_ID__c, Report_Format_Code__c, Comments__c,
                    Case__r.CaseNumber, Case__r.HCSC_Division__c, Case__r.GEMS_Case_Effective_Date__c, Case__r.GEMS_Case_Effective_Date_Email__c, Case__r.GEMS_Submission_Type__c,
                    Case__r.GEMS_Submission_Sub_Type__c, Case__r.GEMS_Line_of_Business__c, Case__r.GEMS_Account_Submission_Info__c, 
                    Case__r.Market_Segment__c, Case__r.Status, Case__r.Owner.Name, Case__r.GEMS_Type__c, Case__r.Account.AccountNumber, 
                    Case__r.Account.External_ID__c, Case__r.Account.Name, Verify_BlueSTAR__c, Update_AS400__c
                    FROM GEMS_Pharmacy_Scope_Code__c WHERE Related__c =: PermScopeCodeRecord.Id];     
        }
        set;
    }
    
    public List<GEMS_Pharmacy_Scope_Code__c> getAllScopeCodes() {
        List<GEMS_Pharmacy_Scope_Code__c> AllScopeCodes2 = new List<GEMS_Pharmacy_Scope_Code__c>();
        AllScopeCodes2.add(PermScopeCodeRecord);
        if(!RelatedScopeCodeRecords.isEmpty()) {
            AllScopeCodes2.addAll(RelatedScopeCodeRecords);
        }
        return AllScopeCodes2;
    }
    
    
    
    public List<Case> ListOfBACases{
        get{
            return [SELECT Id, CaseNumber, Status, GEMS_Pharmacy_Scope_Code__c, GEMS_Temp_Scope_Code__c, GEMS_Benefit_Agreement__r.Name, 
                    GEMS_Benefit_Agreement__r.Product_Type__c, GEMS_Benefit_Agreement__r.Product_Name__c, 
                    GEMS_Benefit_Agreement__r.BA_Description__c, GEMS_Benefit_Agreement__r.BA_Fund_Type__c
                    FROM Case WHERE Parent.Id =: PermScopeCodeRecord.Case__c AND Status != 'Routed In Error' AND GEMS_Scope_Code_ID__c =: PermScopeCodeRecord.id];
        }
        set;
    }
    
    public List<Task> taskList{get; set;}
    public Integer currentTask{get;set;}
    
    
    public GEMS_ViewScopeCodeDetailController(ApexPages.standardController con) {
        try {
            CurrentUserId = UserInfo.getUserId();
            GEMS_Pharmacy_Scope_Code__c ScopeCodeRec = (GEMS_Pharmacy_Scope_Code__c)con.getRecord();
            ScopeCodeRecord = [SELECT Id, Owner.Id, Name, Case__c, Temp__c, Type__c, Related_Scope_Code__c, Mail__c, Retail__c, Peer_Review_Reject_Counter__c,
                               Group_Pay_Code__c, Copay_Type__c, Rider_Code__c, Scope_Status__c, Status__c, Peer_Reviewer__c, Owner.Name, Related__c,
                               Accums_Integration__c, Formulary_Type__c, Prime_Certify_Date__c, Prime_Plan_ID__c, Report_Format_Code__c, Comments__c,
                               Case__r.CaseNumber, Case__r.HCSC_Division__c, Case__r.GEMS_Case_Effective_Date__c, Case__r.GEMS_Case_Effective_Date_Email__c, Case__r.GEMS_Submission_Type__c,
                               Case__r.GEMS_Submission_Sub_Type__c, Case__r.GEMS_Line_of_Business__c, Case__r.GEMS_Account_Submission_Info__c, 
                               Case__r.Market_Segment__c, Case__r.Status, Case__r.Owner.Name, Case__r.GEMS_Type__c, Case__r.Account.AccountNumber, 
                               Case__r.Account.External_ID__c, Case__r.Account.Name, Verify_BlueSTAR__c, Update_AS400__c                                
                               FROM GEMS_Pharmacy_Scope_Code__c WHERE ID =: ScopeCodeRec.ID];
            
            taskList = [Select id, status, subject,GEMS_Start_Date__c,GEMS_End_Date__c,WhatId,ownerId from task where whatid =: PermScopeCodeRecord.Id AND GEMS_Type__C = 'Pharmacy Scope Code Owner' order by ID ASC ];                           
            listOfAccountSpecialistTasks = [Select id, status, subject,GEMS_Start_Date__c,GEMS_End_Date__c,WhatId,ownerId from task where whatid =: PermScopeCodeRecord.Id AND GEMS_Type__C = 'Pharmacy Scope Code Account Specialist' order by ID ASC ];
            currentTask = 0;
            Integer noOfTasks= taskList.Size();
            AllScopeCodes = getAllScopeCodes();  
            allAsTaskComplete = true;
            if(listOfAccountSpecialistTasks!=null & !listOfAccountSpecialistTasks.isEmpty()) assignedAsTask = listOfAccountSpecialistTasks.get(listOfAccountSpecialistTasks.size() - 1);  // SFDC-6944  
            else assignedAsTask = null; 
            if(assignedAsTask!=null && assignedAsTask.status != 'Completed') allAsTaskComplete = false;
        }
        catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_ViewScopeCodeDetailController(ApexPages.standardController con)','High');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));  
        }  
    }
     
    public pageReference redirectToPerm(){
        if (ScopeCodeRecord.Type__c != 'Permanent'){
            PageReference pageRef = new PageReference('/'+PermScopeCodeRecord.Id);
            return pageRef;
        }
        else {
            return Null;
        }
        
    }
    
    public void UpdateTasks(){
        Boolean autoApprovalCreation = false;
        
        
        //SFDC-4226 Peer Reviewer and Prime Plan ID must be entered before user can complete the Pharmacy Scope Code task 
        Set<String> rxTaskSubjects = new Set<String>{GEMS_Constants.RxTaskSubjPharmaScopeCode,GEMS_Constants.RxTaskSubjBETCreation};
        for(Task Taskk : taskList) {
            if(rxTaskSubjects.contains(Taskk.Subject) && Taskk.Status == GEMS_Constants.StatusInProgress) {
                if(PermScopeCodeRecord.Prime_Plan_ID__c == null || PermScopeCodeRecord.peer_reviewer__c == null)  {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please add a Peer Reviewer AND Prime Plan ID before completing this task. Prime Plan ID: Expecting a minimum of 6 numeric characters'));
                }
                break;
            } 
        }
        if (CurrentUserId != PermScopeCodeRecord.ownerId){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Only the assignee is allowed to complete the tasks');
            ApexPages.addMessage(myMsg);            
        } else if(!ApexPages.hasMessages()){
            try {
                update PermScopeCodeRecord;
                for(Task Taskk : taskList) {
                    if (Taskk.Status == 'In Progress'){
                        if (Taskk.Subject == 'Prime Build' && PermScopeCodeRecord.Status__c == 'Prime Build Started' &&  PermScopeCodeRecord.Prime_Certify_Date__c == Null ) {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please enter Prime Certify Date before marking Prime Build as complete');
                            ApexPages.addMessage(myMsg);
                            break;    
                        }
                        else if (Taskk.Subject == 'Prime Build' && PermScopeCodeRecord.Status__c == 'Prime Build Started' &&  PermScopeCodeRecord.Prime_Plan_ID__c == Null ) {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please enter Prime Plan ID before marking Prime Build as complete');
                            ApexPages.addMessage(myMsg);
                            break;    
                        }
                        else if(Taskk.Subject == 'Update BlueSTAR & AS400' && PermScopeCodeRecord.Status__c == 'Update BlueSTAR & AS400 Started' && listOfAccountSpecialistTasks[NumberOfAccSpecTasks - 1].Status == 'In Progress'){
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please wait for Account Specialist to complete BlueSTAR Update task.');
                            ApexPages.addMessage(myMsg);
                            break; 
                        }
                        
                        else if(selectparamVal != 'Yes' && selectparamVal != 'No' && (taskk.subject =='Prime Build' || taskk.subject =='Update BlueSTAR & AS400') && listOfAccountSpecialistTasks[NumberOfAccSpecTasks - 1].Status != 'In Progress') {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please answer the question BlueStar Update required? as Yes or No');
                            ApexPages.addMessage(myMsg);
                            break;
                        }
                        
                        // 5101 - Removed the validation for Update AS400 and Verify BlueSTAR checkboxes
                        Taskk.status = 'Completed';
                        Taskk.GEMS_End_Date__c = System.now();
                        if (Taskk.Subject == 'Pharmacy Scope Code'){
                            if(PermScopeCodeRecord.Scope_Status__c == 'No Scope Code Changes'  || PermScopeCodeRecord.Scope_Status__c == 'Scope Change Only - NoBETSub') {
                                autoApprovalCreation = true;
                            }
                            PermScopeCodeRecord.Status__c = 'Pharmacy Scope Coding Completed';
                            for (Task AccSpecTask: listOfAccountSpecialistTasks){
                                if(AccSpecTask.status != 'Completed'){
                                  AccSpecTask.GEMS_Start_Date__c = System.now();
                                  AccSpecTask.status = 'In Progress';
                                  sendEmail();
                                }
                            }
                            
                            for (Task taskk2 : taskList){
                                if (Taskk2.Subject == 'BET Creation' && PermScopeCodeRecord.Scope_Status__c == 'BET Submission Required'){
                                    Taskk2.Status = 'In Progress';
                                    Taskk2.GEMS_Start_Date__c = System.now();
                                    PermScopeCodeRecord.Status__c = 'BET Creation Started';
                                }  
                            }
                            break; 
                        } else if (Taskk.Subject == 'BET Creation'){
                            if(PermScopeCodeRecord.Scope_Status__c == 'BET Submission Required') {
                                autoApprovalCreation = true;
                            }
                            PermScopeCodeRecord.Status__c = 'BET Creation Completed';                        
                            break;
                        } else if (Taskk.Subject == 'Peer Review'){
                            CreateAccountSpecialistTask();
                        } else if (Taskk.Subject == 'Prime Build'){
                            Boolean AccSpecFlag = false;
                            CreateAccountSpecialistTask();
                            for (Task AccSpecTask : listOfAccountSpecialistTasks ){
                                if(AccSpecTask.Status != 'Completed'){
                                    PermScopeCodeRecord.Status__c = 'Prime Build Completed';
                                    AccSpecFlag = true;
                                }
                            }
                            if (AccSpecFlag == false){
                                for (Task taskk2 : taskList){
                                    if (Taskk2.Subject == 'Update BlueSTAR & AS400'){
                                        Taskk2.Status = 'In Progress';
                                        Taskk2.GEMS_Start_Date__c = System.now();
                                        PermScopeCodeRecord.Status__c = 'Update BlueSTAR & AS400 Started';
                                    }
                                }
                            }
                            break;                              
                        }
                        
                        else if (Taskk.Subject == 'Update BlueSTAR & AS400'){
                            If(selectParamVal == 'Yes'){
                                Task taskknew = new task();
                                taskknew.status = 'Not Started';
                                taskknew.subject = 'Update BlueSTAR & AS400';
                                taskknew.WhatId = PermScopeCodeRecord.id;
                                taskknew.OwnerId = PermScopeCodeRecord.OwnerId;
                                taskknew.priority = 'Normal';
                                taskknew.recordTypeId = GEMSTaskRecordType;
                                taskknew.GEMS_Type__C = 'Pharmacy Scope Code Owner';
                                taskList.add(taskknew);
                            }
                            else {
                                PermScopeCodeRecord.Status__c = 'AS400 & BlueStar Update Completed';
                            }
                            CreateAccountSpecialistTask();
                            break;  
                        }
                    }
                } 
                update PermScopeCodeRecord;
                List<Case> updateCaseList = new List<Case>();
                for (Case C : ListOfBACases){
                    C.Status = PermScopeCodeRecord.Status__c;
                    updateCaseList.add(c);
                }
                update updateCaseList;
                upsert TaskList;
                update listOfAccountSpecialistTasks;   
                system.debug('5:');
                if(autoApprovalCreation)
                    updateStatus();
            }
            catch(Exception ex) {
                ApexPages.addMessages(ex);              
                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_ViewScopeCodeDetailController(ApexPages.standardController con)','High');
            }
        }
    }
    
    public void UpdateScopeCodeBeforePeerReview(){
        update PermScopeCodeRecord;    
    }
    
    
    
    public pageReference SaveScopeCode(){
        if (CurrentUserId != PermScopeCodeRecord.Ownerid && CurrentUserId != PermScopeCodeRecord.Peer_Reviewer__c){
       // if(false){
            ApexPages.Message myMsg = new ApexPages.message(ApexPages.Severity.ERROR,'Error: Only the Scope Code Owner or the Peer Reviewer is allowed to edit');
            ApexPages.addMessage(myMsg);      
            return null;        
        } else {
            try {   
                update RelatedScopeCodeRecords;
                update AllScopeCodes;
                if (PermScopeCodeRecord.Status__c != 'Peer Review Pending') 
                    update listOfBACases;
            }
            catch(Exception ex) {
                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_ViewScopeCodeDetailController(ApexPages.standardController con)','High');
                ApexPages.addMessages(ex);
                return null;
            }
        }
        if(ApexPages.getMessages().isEmpty())  {
            PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Saved succesfully'));
            return null;
        }
        
        return null;
    }
    
    
    
    public pageReference CancelScopeCode(){
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        return pageRef;
    }
    
    public void approvalProcess(){
        try {
            update PermScopeCodeRecord;
            if (PermScopeCodeRecord.Peer_Reviewer__c == '' || PermScopeCodeRecord.Peer_Reviewer__c == Null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please enter Peer Reviewer');
                ApexPages.addMessage(myMsg);
            }
            else {
                PermScopeCodeRecord.Status__c = 'Peer Review Pending';
                update PermScopeCodeRecord;
            }
        }
        catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_ViewScopeCodeDetailController(ApexPages.standardController con)','High');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); 
        }  
    }
    
    public PageReference updateStatus(){
        if (CurrentUserId != PermScopeCodeRecord.OwnerId){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Only the Scope Code Owner is allowed to Send for Peer Review Approval');
            ApexPages.addMessage(myMsg);
            return null;              
        } else { 
            try {
                List<Case> updateCaseList = new List<Case>();
                PermScopeCodeRecord.Status__c = 'Peer Review Pending';
                for (Task taskk: taskList){
                    if(taskk.subject == 'Peer Review' && taskk.status == 'Not Started'){
                        taskk.status = 'In Progress';
                        taskk.GEMS_Start_Date__c = System.now();
                        update taskk;
                        break;
                    }
                }
                for (Case C : ListOfBACases) {
                    C.Status = PermScopeCodeRecord.Status__c;
                    System.debug('Updating BA Case Status from UpdateStatus'+C.Status);
                    updateCaseList.add(c);
                }
                
                update updateCaseList;
                ListOfBACases = updateCaseList;
                System.debug('===ListOfBACases===='+ListOfBACases);
                update PermScopeCodeRecord;
                PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
                return pageRef;
            }
            catch(Exception ex) {
                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_ViewScopeCodeDetailController(ApexPages.standardController con)','High');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); 
                return null; 
            }  
        }
    }
    
    public PageReference StartPrimeBuild(){
        try{
        for (Task taskk : taskList){
            if(taskk.subject == 'Prime Build'){
                taskk.status = 'In Progress';
                taskk.GEMS_Start_Date__c = System.now();
                PermScopeCodeRecord.Status__c = 'Prime Build Started';
            }
        }
        List<Case> updateCaseList = new List<Case>();
        for (Case C : ListOfBACases){
            C.Status = PermScopeCodeRecord.Status__c;
            updateCaseList.add(c);
        }
        
        update updateCaseList;
        update PermScopeCodeRecord;
        update tasklist;
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        return pageRef;
        }
        catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_ViewScopeCodeDetailController(ApexPages.standardController con)','High');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            return null;
        }  
    }
    
    public void StartAccountSpecialistTasks(){
        
        for (Task taskk : listOfAccountSpecialistTasks){
            if(taskk.subject == 'Account Specialist Review'){
                taskk.Status = 'In Progress';
                taskk.GEMS_Start_Date__c = System.now();
                update taskk;
                break;
            }
        }
        
    }
    
    public void UpdateAccountSpecialistTasks(){
        try {
            integer flag = 0;
            for (Task taskk : listOfAccountSpecialistTasks){
                if(taskk.status == 'In Progress'){
                    taskk.Status = 'Completed';
                    taskk.GEMS_End_Date__c = System.now();
                    if(taskk.Subject == 'BlueSTAR Update Request') {
                        PermScopeCodeRecord.Is_BlueSTAR_Update_Request_Task_Cmpltd__c=true;
                        update PermScopeCodeRecord;
                    }
                    if(taskk.subject == 'Account Specialist BlueStar Update'){
                        flag =1;
                        break;
                    }
                    if (flag == 1){
                        for (Task CoderTaskk:taskList) {
                            if(CoderTaskk.subject != 'Update BlueSTAR & AS400' && CoderTaskk.status != 'Completed'){
                                break;
                            } else if(CoderTaskk.subject == 'Update BlueSTAR & AS400' && CoderTaskk.status == 'Not Started'){
                                CoderTaskk.status = 'In Progress';
                                CoderTaskk.Gems_Start_Date__c = System.Now();
                                PermScopeCodeRecord.Status__c = 'Update BlueSTAR & AS400 Started';
                            }
                        }
                        break;
                    }
                    if (taskk.subject == 'Account Specialist Review'){
                        for (Task taskk2 : listOfAccountSpecialistTasks){
                            if(taskk2.status == 'Not Started'){
                                taskk2.Status = 'In Progress';
                                taskk2.GEMS_Start_Date__c = System.now();
                                flag = 1;
                                break;
                            }
                        }                                             
                    }
                    if (flag == 1)
                        break;
                }
            }
            update listOfAccountSpecialistTasks;
        } catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_ViewScopeCodeDetailController(ApexPages.standardController con)','High');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));  
        }  
    }
	
	// SFDC-6944 reassign the Account Specialist task owner
	public void UpdateAccountSpecialistTaskOwner(){
		Id newASId = assignedAsTask.ownerId;
		List<Task> taskToUpdate = new List<Task>();
		for(Task oneTask : listOfAccountSpecialistTasks){if(oneTask.status != 'Completed'){oneTask.ownerId=newASId; taskToUpdate.add(oneTask);}}
		update taskToUpdate;
	}

    
    public Integer NumberOfAccSpecTasks {
        get {
            return listOfAccountSpecialistTasks.size();
        }
        set;
    }
    
    public void CreateAccountSpecialistTask(){
        try{
        if(selectparamVal != 'Yes' && selectparamVal != 'No') {
        } else if (selectParamVal == 'Yes' && listOfAccountSpecialistTasks[NumberOfAccSpecTasks-1].status != 'In Progress' && AccountSpecialist != Null){
            SendEmail();
            Task taskk2 = new Task();
            taskk2.status = 'In Progress';
            taskk2.GEMS_Start_Date__c = System.now();
            taskk2.WhatId = PermScopeCodeRecord.id;
            if(assignedAsTask==null) taskk2.OwnerId = AccountSpecialist.MemberId; // SFDC-6944
            else taskk2.OwnerId = assignedAsTask.OwnerId;
            taskk2.Subject = 'BlueSTAR Update Request';
            taskk2.priority = 'Normal';
            taskk2.recordTypeId = GEMSTaskRecordType;
            taskk2.GEMS_Type__C = 'Pharmacy Scope Code Account Specialist';
            listOfAccountSpecialistTasks.add(taskk2);
            assignedAsTask = taskk2;
        }
        
        else if (PermScopeCodeRecord.Status__c != 'AS400 & BlueStar Update Completed'){
            SendEmail();
        }
        
        upsert listOfAccountSpecialistTasks;
        }
        catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_ViewScopeCodeDetailController(ApexPages.standardController con)','High');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));  
        }  
    }
    
    public void SendEmail(){
        String EmailBody = '<HTML>';
        try{
        if (PermScopeCodeRecord.Status__c != 'Prime Build Completed' && PermScopeCodeRecord.Status__c != 'Prime Build Started' && PermScopeCodeRecord.Status__c != 'Update BlueSTAR & AS400 Started' && PermScopeCodeRecord.Status__c != 'AS400 & BlueStar Update Completed'){           
            for (GEMS_Pharmacy_Scope_Code__c PermScopeCodeRecord : AllScopeCodes){
                if(PermScopeCodeRecord.Type__c != 'Permanent') {
                    EmailBody = EmailBody + '<br/>'  + 'Temp Scope Code' + '<br/>'  + 'Name: ' + PermScopeCodeRecord.name + '<br/>'  + 'Group Pay Code: ' + PermScopeCodeRecord.Group_Pay_Code__c + '<br/>'  + 'Copay Type: ' + PermScopeCodeRecord.Copay_Type__c + '<br/>'  + 'Formulary Type: ' + PermScopeCodeRecord.Formulary_Type__c + '<br/>'  + 'Accums Integration: ' + PermScopeCodeRecord.Accums_Integration__c + '<br/>' ;
                    //SFDC-6384 - Include link to the pharmacy scope code in the email notification. 
                    EmailBody = EmailBody + 'Scope Code Details: ' + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+PermScopeCodeRecord.ID+'">'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+PermScopeCodeRecord.ID+'</a>' + '<br/>';
                }
            }
            for (GEMS_Pharmacy_Scope_Code__c PermScopeCodeRecord : AllScopeCodes){
                if(PermScopeCodeRecord.Type__c == 'Permanent') {
                    EmailBody = EmailBody + '<br/>' + 'Perm Scope Code' + '<br/>'  + 'Name: ' + PermScopeCodeRecord.name + '<br/>'  + 'Status: ' + PermScopeCodeRecord.Status__c + '<br/>'  + 'Group Pay Code: ' + PermScopeCodeRecord.Group_Pay_Code__c + '<br/>'  + 'Copay Type: ' + PermScopeCodeRecord.Copay_Type__c + '<br/>'  + 'Formulary Type: ' + PermScopeCodeRecord.Formulary_Type__c + '<br/>'  + 'Rider Code: ' + PermScopeCodeRecord.Rider_Code__c + '<br/>'  +'Prime Plan ID: ' + PermScopeCodeRecord.Prime_Plan_ID__c + '<br/>'  + 'Scope Status: ' + PermScopeCodeRecord.Scope_Status__c + '<br/>'  +  'Accums Integration: ' + PermScopeCodeRecord.Accums_Integration__c + '<br/>' ;
                    //SFDC-6384 - Include link to the pharmacy scope code in the email notification. 
                    EmailBody = EmailBody + 'Scope Code Details: ' + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+PermScopeCodeRecord.ID+'">'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+PermScopeCodeRecord.ID+'</a>' + '<br/>';
                }
            }
            
            for (Case C : ListOfBACases){
                EmailBody = EmailBody + '<br/>'  +  'Case# ' + C.CaseNumber + '<br/>'  + 'BA No. ' + C.GEMS_Benefit_Agreement__r.Name + '<br/>'  +  'Product Type: ' + C.GEMS_Benefit_Agreement__r.Product_Type__c + '<br/>'  + 'Product Name: ' + C.GEMS_Benefit_Agreement__r.Product_Name__c + '<br/>'  + 'Desription: ' + C.GEMS_Benefit_Agreement__r.BA_Description__c + '<br/>'  + 'Fund Type: ' + C.GEMS_Benefit_Agreement__r.BA_Fund_Type__c + '<br/>' ;
            }  
            
            EmailBody = EmailBody + '<br/>' + 'Account Number: ' + PermScopeCodeRecord.Case__r.Account.External_ID__c + '<br/>' + 'Case Number: ' + PermScopeCodeRecord.Case__r.CaseNumber;
            //EmailBody = EmailBody + '<br/>' + 'Case Details: ' + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+PermScopeCodeRecord.Case__c+'">'+'Pharmacy Coding Case'+'</a></HTML>' +'<br/>';
            EmailBody = EmailBody + '<br/>' + 'Case Details: ' + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+PermScopeCodeRecord.Case__c+'">'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+PermScopeCodeRecord.Case__c+'</a></HTML>' +'<br/>';
            
        }
        
        else {
            for (GEMS_Pharmacy_Scope_Code__c PermScopeCodeRecord : AllScopeCodes){
                if(PermScopeCodeRecord.Type__c == 'Permanent') {
                    EmailBody = EmailBody + 'Perm Scope Code' + '<br/>'  + 'Name: ' + PermScopeCodeRecord.name + '<br/>'  + 'Status: ' + PermScopeCodeRecord.Status__c + '<br/>'  + 'Group Pay Code: ' + PermScopeCodeRecord.Group_Pay_Code__c + '<br/>'  + 'Copay Type: ' + PermScopeCodeRecord.Copay_Type__c + '<br/>'  + 'Formulary Type: ' + PermScopeCodeRecord.Formulary_Type__c + '<br/>'  + 'Rider Code: ' + PermScopeCodeRecord.Rider_Code__c + '<br/>'  +'Prime Plan ID: ' + PermScopeCodeRecord.Prime_Plan_ID__c + '<br/>'  + 'Scope Status: ' + PermScopeCodeRecord.Scope_Status__c + '<br/>'  +  'Accums Integration: ' + PermScopeCodeRecord.Accums_Integration__c + '<br/>' ;
                    //SFDC-6384 - Include link to the pharmacy scope code in the email notification. 
                    EmailBody = EmailBody + 'Scope Code Details: ' + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+PermScopeCodeRecord.ID+'">'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+PermScopeCodeRecord.ID+'</a>' + '<br/>';
                }
            }
            for (Case C : ListOfBACases){
                EmailBody = EmailBody + '<br/>' +  'Case# ' + C.CaseNumber + '<br/>'  + 'BA No. ' + C.GEMS_Benefit_Agreement__r.Name + '<br/>'  +  'Product Type: ' + C.GEMS_Benefit_Agreement__r.Product_Type__c + '<br/>'  + 'Product Name: ' + C.GEMS_Benefit_Agreement__r.Product_Name__c + '<br/>'  + 'Desription: ' + C.GEMS_Benefit_Agreement__r.BA_Description__c + '<br/>'  + 'Fund Type: ' + C.GEMS_Benefit_Agreement__r.BA_Fund_Type__c + '<br/>';
            }  
            
            EmailBody = EmailBody + '<br/>' + 'Account Number: ' + PermScopeCodeRecord.Case__r.Account.External_ID__c + '<br/>' + 'Case Number: ' + PermScopeCodeRecord.Case__r.CaseNumber; 
            //EmailBody = EmailBody + '<br/>' + 'Case Details: '+'<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+PermScopeCodeRecord.Case__c+'">'+'Pharmacy Coding Case'+'</a></HTML>' +'<br/>';
            EmailBody = EmailBody + '<br/>' + 'Case Details: '+'<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+PermScopeCodeRecord.Case__c+'">'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+PermScopeCodeRecord.Case__c+'</a></HTML>' +'<br/>';
        }
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if (PermScopeCodeRecord.Status__c != 'Prime Build Completed' && PermScopeCodeRecord.Status__c != 'Prime Build Started' && PermScopeCodeRecord.Status__c != 'Update BlueSTAR & AS400 Started' && PermScopeCodeRecord.Status__c != 'AS400 & BlueStar Update Completed'){           
            mail.setSubject('***ACTION NEEDED***'+ PermScopeCodeRecord.Case__r.Account.Name + ' - ' + PermScopeCodeRecord.Case__r.Account.External_ID__c +  
                                ' - ' +  PermScopeCodeRecord.Case__r.GEMS_Case_Effective_Date_Email__c + ' - ' + PermScopeCodeRecord.Case__r.CaseNumber + '- Scope Code Assigned');
        } else {
                mail.setSubject('***ACTION NEEDED***'+ PermScopeCodeRecord.Case__r.Account.Name + ' - ' + PermScopeCodeRecord.Case__r.Account.External_ID__c +  
                                ' - ' +  PermScopeCodeRecord.Case__r.GEMS_Case_Effective_Date_Email__c + ' - ' + PermScopeCodeRecord.Case__r.CaseNumber + '- Perm Scope Code Assigned');
        }
        mail.setSaveAsActivity(false);
        mail.setSenderDisplayName(PermScopeCodeRecord.Owner.Name);
        mail.setTargetObjectId(AccountSpecialist.MemberID);
        mail.setHTMLBody(EmailBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        } catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_ViewScopeCodeDetailController(ApexPages.standardController con)','High');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));  
        }  
    }
}