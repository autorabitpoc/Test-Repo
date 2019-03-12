/**************************************************************************************
  Apex Class Name       : GEMS_FSUClaimsTaskController
  Version               : 1.0
  Function              : (For GEMS Project).
  Modification Log      :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Offshore            05/30/2016             Original Version
*************************************************************************************/
public with sharing class GEMS_FSUClaimsTaskController {
    
    public Case caseRecord{get;set;}
    public List<Task> taskList{get;set;}
    public Integer selectedVal{get;set;}
    public Integer currentTask{get;set;}
    public Boolean disableCompleteButton{get;set;}
    
    public Boolean noTaskSelectedError{get;set;}
    public Boolean combineFlag{get;set;}
    public Boolean accumsFileReceivedDateError{get;set;}
    public Boolean tempLocksReleased{set;get;}
    public Boolean loadTestBenfAccRecvDateError{set;get;}
    public Boolean loadTestBenfAccVolError{set;get;}
    public Boolean loadTestBenfAccloadDateError{set;get;}
    public Boolean caseToUpdate = false;
    
    public GEMS_FSUClaimsTaskController(ApexPages.StandardController controller) {
        try{
            Case caseRec = (case)controller.getRecord();
            
            noTaskSelectedError =false;
            currentTask = 0;
            selectedVal = -1;
            combineFlag = false;
            tempLocksReleased = false;
            loadTestBenfAccRecvDateError = false;
            loadTestBenfAccVolError = false;
            loadTestBenfAccloadDateError = false;
            
            caseRecord = [Select ID, GEMS_Return_Check__c,GEMS_Submission_Type__c, GEMS_ReviewDocuments__c,HCSC_Division__c,GEMS_Products__c,Funding_Type__c, GEMS_Approve__c,GEMS_Return__c,
                          GEMS_Routed_In_Error__c, Status, GEMS_Account_Submission_Info__c,RecordType.name,GEMS_Test_File_Receipt_Date__c,
                          GEMS_Test_Files_Sent_to_Client_Vendor__c, GEMS_Request_for_Reports_Sent_to_ITG__c, GEMS_AEP_Reports_Received_from_ITG__c,GEMS_Release_to_Compare_date__c,
                          GEMS_Authorization_to_valid_date__c,GEMS_Actual_Date_for_Production_File_1__c,GEMS_Actual_Date_for_Production_File_2__c, GEMS_Target_Date_for_Production_File_1__c,
                          GEMS_Target_Date_for_Production_File_2__c,GEMS_Quality_Reviewer__c,GEMS_Is_BlueSTAR_Walkthrough_Needed__c,GEMS_Date_BlueSTAR_Walkthrough_Held__c,GEMS_Account_Submission_Info__r.ownerId,
                          GEMS_Accums_received_date__c, GEMS_Accums_Volume__c, GEMS_Accums_loaded_date__c, GEMS_Accums_file_received_date__c, GEMS_AreAllTemporaryCliam_Locks_Released__c 
                          from Case where ID =: caseRec.ID];
                          
            taskList = [ select id, status, subject,GEMS_Start_Date__c,GEMS_End_Date__c,WhatId,ownerId from task where whatid =: caseRec.Id order by ID ASC ];
            
            Integer noOfTasks= taskList.Size();
            Integer completedTasks=0;
            
            for(Task taskk : taskList) {
                system.debug('enter inside');
                if(taskk.status == 'Completed' || taskk.status == 'Cancelled') {
                    currentTask++;
                }
                if(taskk.Status == 'Completed' || taskk.status == 'Cancelled')
                {
                    completedTasks=completedTasks+1;
                }
                if(noOfTasks == completedTasks)
                {
                    system.debug('*****////'+noOfTasks);
                    disableCompleteButton=true;
                }
                /*
                if(taskk.Subject=='Confirm Accums Tested' && caseRecord.Status=='In Progress' && caseRecord.GEMS_Accums_file_received_date__c!=null){
                    combineFlag = true;
                    accumsFileReceivedDateError = false;
                }
                */
            }
            
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_FSUClaimsTaskController (ApexPages.standardController controller)','High');  
        }
    }
    
    public void assignSelectedVal() {
        
    }
    
    public PageReference changeTaskStatus(){
        System.debug('into changeStatusMeth');
        Database.saveResult[] sr;
        try{
            combineFlag = false;
            List<Task> taskUpdateList = new List<Task>();
            if(!taskList.isEmpty() && currentTask <= taskList.size() ) {
                System.debug('taskList.get(currentTask)====>'+taskList.get(currentTask));
                if(selectedVal == -1) {
                    System.debug('testing for no task');
                    combineFlag = true;
                    noTaskSelectedError = true;
                    ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please select below task');
                    ApexPages.addMessage(myMsg);
                    return null;
                }
                
                Task taskkk = taskList.get(currentTask);
                
                if(taskkk.Subject=='Load and Test Benefit Accums' && caseRecord.GEMS_Accums_received_date__c==null){
                    System.debug('Load and Test Benefit Accums - GEMS_Accums_received_date__c=======>' +caseRecord.GEMS_Accums_received_date__c);
                    combineFlag = true;
                    noTaskSelectedError = false;
                    loadTestBenfAccRecvDateError = true;
                }
                
                else if(taskkk.Subject=='Load and Test Benefit Accums' && caseRecord.GEMS_Accums_Volume__c==null){
                    System.debug('Load and Test Benefit Accums - GEMS_Accums_Volume__c =======>' +caseRecord.GEMS_Accums_Volume__c);
                    combineFlag = true;
                    noTaskSelectedError = false;
                    loadTestBenfAccVolError = true;
                }
                
                else if(taskkk.Subject=='Load and Test Benefit Accums' && caseRecord.GEMS_Accums_loaded_date__c==null){
                    System.debug('Load and Test Benefit Accums - GEMS_Accums_loaded_date__c=======>' +caseRecord.GEMS_Accums_loaded_date__c);
                    combineFlag = true;
                    noTaskSelectedError = false;
                    loadTestBenfAccloadDateError = true;
                }
                
                if(taskkk.Subject=='Confirm Accums Tested' && caseRecord.GEMS_Accums_file_received_date__c==null){
                    System.debug('Confirm Accums Tested - GEMS_Accums_file_received_date__c =======>' +caseRecord.GEMS_Accums_file_received_date__c);
                    combineFlag = true;
                    noTaskSelectedError = false;
                    accumsFileReceivedDateError = true;
                }
                
                if(taskkk.Subject=='Release Claims Hold' && caseRecord.GEMS_AreAllTemporaryCliam_Locks_Released__c==null){
                    System.debug('Release Claims Hold=======>' +caseRecord.GEMS_AreAllTemporaryCliam_Locks_Released__c);
                    combineFlag = true;
                    noTaskSelectedError = false;
                    tempLocksReleased=true;
                }
                
                if(taskList.size() > currentTask+1){
                    System.debug('into next in progress logic ====>');
                    task nextTaskToInProgress = taskList.get(currentTask+1);
                    nextTaskToInProgress.Status='In Progress';
                    nextTaskToInProgress.GEMS_Start_Date__c =system.now();
                    taskUpdateList.add(nextTaskToInProgress);
                }
                String taskstatus = taskkk.subject;
                taskkk.status = 'Completed';
                taskkk.GEMS_End_Date__c = System.now();
                taskUpdateList.add(taskkk);
                
                if(!combineFlag)
                {
                    sr = Database.update(taskUpdateList);
                    noTaskSelectedError = false;
                    for(Database.saveResult saveRes:sr) {
                        if(saveRes.isSuccess()) {
                            if(taskkk.id == saveRes.getId()) {
                                caseToUpdate = true;
                            if(taskkk.subject== 'Release Claims Hold')
                                caseRecord.status = 'Completed';
                            else
                                caseRecord.status = taskstatus;
                            }
                        }
        
                    }
                    if(caseToUpdate) 
                    update caseRecord;
                    noTaskSelectedError = false;        
                }
                }

        }catch(Exception ex) {
           
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'changeTaskStatus()','High');  
            return null;
        }

        return null;
    }
}