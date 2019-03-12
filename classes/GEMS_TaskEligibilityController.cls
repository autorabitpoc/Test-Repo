/**************************************************************************************
Apex Class Name     : GEMS_TaskEligibilityController 
Version             : 1.0
Function            : This class to show all tasks exists for the case
Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Offshore            04/26/2016             Original Version
* Luke Chen           05/07/2017             Eligibility dates user input
* Luke Chen           06/26/2017             SFDC-4719 GEMS - Cosmetic Account Maintenance workflow
* Gokul               07/12/2017             SFDC-5005 GEMS Acct Setup Process – WT Task and Approval Creation
* Gokul               07/12/2017             SFDC-5006 GEMS Acct Setup Process – WT Approval Process
* Ranjit Gandhi       07/13/2017             SFDC-5003 GEMS Acct Setup Process - Auto create QR approval
* Bharath             07/14/2017             SFDC-4999 Skip Quality Review if Account Setup owner chooses so.
* Rajeesha            07/14/2017             SFDC-4996 GEMS Acct Setup Process - Validation Rule for BlueSTAR Entry Complete Task
* Shankar			  09/25/2017			 SFDC-6446 Update case status to BlueSTAR Entry Complete if QR is not needed
* Ranjit Gandhi       09/27/2017             SFDC-6374 GEMS - Prod Issue - Cannot Release to UW on Account Setup Case
* Luke Chen			  04/22/2018			 SFDC-9342 GEMS: Prod Issue - 360 view showing a different open/closed date than actual cases
*************************************************************************************/

public with sharing class GEMS_TaskEligibilityController {
    
    public Case caseRecord{get;set;}
    public List<Task> taskList{get;set;}
    public Integer currentTask{get;set;}
    public Integer selectedVal{get;set;}
    public Boolean selectdPaperWork{get;set;}
    Public List<SelectOption> options{get;set;}
    public String selectParamVal{get;set;}
    public Boolean disableCompleteButton{get;set;}
    public Boolean fileTestingErrorFlag {get;set;}
    
    // Rajeesha SFDC-4996 GEMS: Acct Setup Process - Validation Rule for BlueSTAR Entry Complete Task
    public Boolean blueStarTaskCompleteError{get;set;}
    public Boolean blueStarTaskCompleteError1{get;set;}
    public Boolean qrReviewerError{get;set;}
    public Boolean qrReviewerError1{get;set;}
    public Boolean qrReviewerError2{get;set;}
    public Boolean qrReviewerError3{get;set;}
    public Boolean qrReviewerError4{get;set;}
    public Boolean qrReviewerError5{get;set;}
    public Boolean qrReviewerErrorA{get;set;}
    // Ranjit - SFDC-6374 GEMS - When someone tries to complete the Release to UW Task – we throw a message:  You must be the assigned case owner to complete this task.

    public Boolean releaseUnderwriterError{get;set;}
    
    public Boolean eligibilityFileToProd{get;set;}
    public Boolean combineFlag{get;set;}
    public Boolean isEdgeError {get;set;}
    public Boolean isDatesError {get;set;}
    public Boolean isDatesErrorSetupTesting {get;set;}
    public List<GEMS_Return_Reason__c> returnReasonList{get;set;}
    public GEMS_Return_Reason__c returnreasonRec {set;get;}
    public Boolean displayReturnReason{get;set;}
    public Boolean renderCancelProjectButton{get;set;}
    public Boolean taskNotSelected{get;set;}
    public Double offset{set;get;}
    //SFDC-5005 Use this variable to show error.
    public Boolean WTReviewerError{get; set;}
    //SFDC-5005 
    public GEMS_TaskEligibilityController(ApexPages.standardController con) {
        try {
            offset = GEMS_Utility.getLocalTimeZoneOffset(); // SFDC-9342
            Case caseRec = (case)con.getRecord();
            currentTask = 0;
            selectedVal = -1;
            selectParamVal = 'No';
            combineFlag = false;
            qrReviewerError = false;
            qrReviewerErrorA = false;
            qrReviewerError1 = false;
            // Ranjit - SFDC-6374 GEMS - if current user is not case owner – we throw a message:  You must be the assigned case owner to complete this task.
            	releaseUnderwriterError=false;
            qrReviewerError2 = false;
            qrReviewerError3 = false;
            qrReviewerError4 = false;
            qrReviewerError5 = false;
            taskNotSelected = false;
            renderCancelProjectButton = true;
            isEdgeError = false;
            isDatesError = false;
            isDatesErrorSetupTesting = false;
            WTReviewerError=false;
            Id caswManualEligibilityId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Manual Eligibility').getRecordTypeId();
            caseRecord = [Select ID, GEM_Is_group_loading_eligty_via_LGDE__c,GEMS_Date_LGDE_File_was_Received__c,GEMS_Return_Check__c,GEMS_Submission_Type__c, GEMS_ReviewDocuments__c,HCSC_Division__c,GEMS_Products__c,Funding_Type__c, GEMS_Approve__c,GEMS_Return__c,GEMS_Routed_In_Error__c, 
                          Status, GEMS_Account_Submission_Info__c,RecordTypeId,RecordType.name,GEMS_Test_File_Receipt_Date__c,GEMS_Account_Setup_QR_Approval_Received__c, GEMS_Account_Setup_WT_Approval_Received__c,
                          GEMS_Test_Files_Sent_to_Client_Vendor__c, GEMS_Request_for_Reports_Sent_to_ITG__c, GEMS_AEP_Reports_Received_from_ITG__c,GEMS_Release_to_Compare_date__c,
                          GEMS_Authorization_to_valid_date__c,GEMS_Actual_Date_for_Production_File_1__c,GEMS_Actual_Date_for_Production_File_2__c, GEMS_Target_Date_for_Production_File_1__c,
                          GEMS_Target_Date_for_Production_File_2__c,GEMS_Quality_Reviewer__c,GEMS_Account_Submission_Info__r.ownerId,ownerId,GEMS_Is_BlueSTAR_Walkthrough_Needed__c,GEMS_Date_BlueSTAR_Walkthrough_Held__c, 
                          GEMS_Account_Submission_Info__r.id, GEMS_Account_Submission_Info__r.status,GEMS_BlueSTAR_Walkthrough_Resource_1__c, Is_QR_Needed__c from Case where ID =: caseRec.ID];
            
            if(caseRecord.recordtype.name == 'GEMS Eligibility')
                taskList = [ select id, status, subject,GEMS_Start_Date__c,GEMS_End_Date__c,WhatId,ownerId, createddate from task where whatid =: caseRec.Id order by ID ASC];
            else 
                taskList = [ select id, status, subject,GEMS_Start_Date__c,GEMS_End_Date__c,WhatId,ownerId, createddate from task where whatid =: caseRec.Id order by createddate ASC];
            // taskList.sort();
            returnReasonList = [SELECT ID, Name, GEMS_Case__c, Process_Name__c, GEMS_Type__c, GEMS_Sub_Type__c, Return_Reason__c, GEMS_Comments__c  FROM GEMS_Return_Reason__c where GEMS_Case__c =: caseRec.Id ];
            if(caseRecord.RecordTypeId == caswManualEligibilityId) {
                renderCancelProjectButton = false;
            }
            Integer noOfTasks= taskList.Size();
            Integer completedTasks=0;
            fileTestingErrorFlag = false;
            eligibilityFileToProd = false;
            returnreasonRec = new GEMS_Return_Reason__c();
            if(caseRecord.status == 'Project Cancelled') {
                currentTask = noOfTasks;
                disableCompleteButton=true;
            }
            for(Task taskk : taskList ) {
                system.debug('enter inside');
                if(taskk.status == 'Completed'|| taskk.status == 'Closed' || taskk.status == 'Cancelled') {
                    currentTask++;
                }
                if(taskk.Status == 'Completed' || taskk.status == 'Closed' || taskk.status == 'Cancelled')
                {
                    completedTasks=completedTasks+1;
                }
                if(noOfTasks == completedTasks)
                {
                    system.debug('*****////'+noOfTasks);
                    disableCompleteButton=true;
                }
                
                if(taskk.subject == 'Eligibility File Testing' && caseRecord.GEMS_Test_File_Receipt_Date__c == null && caseRecord.GEMS_Test_Files_Sent_to_Client_Vendor__c== null &&
                   caseRecord.GEMS_Request_for_Reports_Sent_to_ITG__c == null && caseRecord.GEMS_AEP_Reports_Received_from_ITG__c== null  ) 
                {
                    fileTestingErrorFlag=false;
                }
                if(taskk.subject == 'Release Eligibility File to Production' && caseRecord.GEMS_Release_to_Compare_date__c== null && caseRecord.GEMS_Authorization_to_valid_date__c == null &&
                   caseRecord.GEMS_Actual_Date_for_Production_File_1__c == null && caseRecord.GEMS_Actual_Date_for_Production_File_2__c == null 
                   && caseRecord.GEMS_Target_Date_for_Production_File_1__c == null && caseRecord.GEMS_Target_Date_for_Production_File_2__c == null ) 
                {
                    eligibilityFileToProd=false;
                }
            }
        } catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_TaskEligibilityController(ApexPages.standardController con)','High');  
        }
    }
    
/******************************************************************** 
*   Method Name  :   changeTaskStatus Action
*   @description :   This method to update tasks and case object when task completing
*   @parameters  :   None
*   @return type :   PageReference
***************************************************************/
    public PageReference changeTaskStatus() {
        isDatesError = false;
        isDatesErrorSetupTesting = false;
        taskNotSelected = false;
        combineFlag = false;
        fileTestingErrorFlag=false;
        eligibilityFileToProd=false;
        Datetime setupEndDate = null;
        //4999 - Flag to skip QR task and submit downstream tasks if case owner chooses to do so.
        boolean bypass_QR_Task = false;
        
        System.debug('Started====='+currentTask );
        try {
         
            Set<String> taskSubject = new Set<String>();            
            for(Task taskRec:taskList) {
                taskSubject.add(taskRec.Subject);
                if(taskRec.Subject == 'AEP Initial Setup' && taskRec.GEMS_End_Date__c != null)
                    setupEndDate = taskRec.GEMS_End_Date__c;                
            }
            // #RANJIT SFDC-5003 GEMS Acct Setup Process - Auto create QR approval
            // check if QR is rejected? status=closed implies that the task was rejected.
            List<string> tasksubject1= new List<string>();
            for(Task taskRec:taskList) {               
                if(taskRec.Subject == 'Quality Review' && taskRec.status =='closed')
                     taskSubject1.add(taskRec.Subject);              
            }
            List<Task> taskList_upsert = new List<Task>();
            List<Task> inProgressTaskUpdateList = new List<Task>();
            if(!taskList.isEmpty() && currentTask <= taskList.size() ) {
                System.debug('taskList.get(currentTask)====>'+taskList.get(currentTask));
                System.debug('selectedVal ====>'+selectedVal );
                
                if(selectedVal == -1 && caseRecord.recordtype.name == 'GEMS Eligibility') {
                    taskNotSelected = true;
                    System.debug('testing for no task');
                    ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please select below task');
                    ApexPages.addMessage(myMsg); 
                    combineFlag = true;                   
                    return null;
                }
                //GEMS_Eligibility_Testing__c eligibilityTesting = [select id,name from GEMS_Eligibility_Testing__c where Eligiblity_Case__c =:caseRecord.id];
                //case caseRecordtest =[select id,(select id,name from Eligibility_Testing__r) from case where id=:caseRecord.id limit 1];
               /* case caseRecordprod =[select id,(select id,name from GEMS_Eligibility_Production__r) from case where id=:caseRecord.id limit 1];
                Boolean eligibilityTestsize = false;
                Boolean eligibilityProdsize = false;
                if (caseRecordtest .Eligibility_Testing__r != null && caseRecordtest .Eligibility_Testing__r.size() > =1) {
                    eligibilityTestsize = true;
                } 
                if (caseRecordprod .GEMS_Eligibility_Production__r != null && caseRecordprod.GEMS_Eligibility_Production__r.size() > =1) 
                {
                    eligibilityProdsize = true;
                } */
                Task taskkk = taskList.get(currentTask);
                System.debug('==taskkk=='+taskkk);
                //System.debug('===eligibilityProdsize =='+eligibilityProdsize );
                /*if(taskkk.subject == 'AEP Testing' && !eligibilityTestsize  ) {
                    fileTestingErrorFlag=true;
                    combineFlag = true;
                    return null;
                }else if(taskkk.subject == 'AEP Testing' && taskkk.GEMS_Start_Date__c != null && setupEndDate != null && setupEndDate > taskkk.GEMS_Start_Date__c){
                    isDatesErrorSetupTesting = true;
                    combineFlag = true;
                    return null;                    
                }
                if(taskkk.subject == 'AEP Production Ready' && !eligibilityProdsize) {                    
                    eligibilityFileToProd=true;
                    combineFlag = true;                 
                    return null;
                }                
                if(taskkk.GEMS_Start_Date__c != null && taskkk.GEMS_End_Date__c != null && taskkk.GEMS_Start_Date__c > taskkk.GEMS_End_Date__c){
                    isDatesError = true;
                    combineFlag = true;
                    return null;
                } */
                // Rajeesha SFDC-fGEMS: Acct Setup Process - Validation Rule for BlueSTAR Entry Complete Task
                //if((taskkk.subject == 'BlueSTAR Entry Complete') && ((caseRecord.GEMS_Quality_Reviewer__c == null) || (caseRecord.Is_QR_Needed__c == null) || (caseRecord.GEMS_Is_BlueSTAR_Walkthrough_Needed__c == null) || (caseRecord.GEM_Is_group_loading_eligty_via_LGDE__c == null)) && (caseRecord.RecordType.Name != 'GEMS Account Setup Maintenance')){
                if((taskkk.subject == 'BlueSTAR Entry Complete') && ((caseRecord.GEMS_Quality_Reviewer__c == null && caseRecord.Is_QR_Needed__c != 'No') ||  (caseRecord.Is_QR_Needed__c == null) ||
                   (caseRecord.GEMS_Is_BlueSTAR_Walkthrough_Needed__c == null)) && 
                   (caseRecord.RecordType.Name != 'GEMS Account Setup Maintenance')){
                        if(caseRecord.Is_QR_Needed__c == 'No'){
                            System.debug('===========taskkk.subject======='+taskkk.subject );
                            blueStarTaskCompleteError1= true;                    
                            ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please select Is QR Needed, Is BlueStar Walkthrough Needed and finish approval before completing the task');
                            ApexPages.addMessage(myMsg);                    
                            return null;                           
                       }
                       else{
                            System.debug('===========taskkk.subject======='+taskkk.subject );
                            blueStarTaskCompleteError= true;                    
                            ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please select Quality Reviewer, Is QR Needed, Is BlueStar Walkthrough Needed and finish approval before completing the task');
                            ApexPages.addMessage(myMsg);                    
                            return null;                           
                       }
                   }
                //End of SFDC-4996
                if((taskkk.subject == 'Quality Review') && (caseRecord.GEMS_Quality_Reviewer__c == null) ) {
                    System.debug('===========taskkk.subject======='+taskkk.subject );
                    qrReviewerErrorA= true;                    
                    ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please select Quality Reviewer and finish approval before completing the task');
                    ApexPages.addMessage(myMsg);                    
                    return null;
                }
                if((taskkk.subject == 'Quality Review') && (caseRecord.GEMS_Is_BlueSTAR_Walkthrough_Needed__c == null ) ) {
                    System.debug('===========taskkk.subject======='+taskkk.subject );
                    qrReviewerError= true;                    
                    ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please select Quality Reviewer and finish approval before completing the task');
                    ApexPages.addMessage(myMsg);                    
                    return null;
                }
                
          
                
                
                
                if((taskkk.subject == 'Quality Review') && !(caseRecord.GEMS_Account_Setup_QR_Approval_Received__c)) { 
                    System.debug('===========taskkk.subject======='+taskkk.subject );
                    qrReviewerError4= true;                    
                    ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please select Quality Reviewer and finish approval before completing the task');
                    ApexPages.addMessage(myMsg);                    
                    return null;
                }
                
                if(taskkk.subject == 'BlueSTAR Walkthrough' &&  !caseRecord.GEMS_Account_Setup_WT_Approval_Received__c) {
                    System.debug('===========taskkk.subject======='+taskkk.subject );
                    qrReviewerError2= true;
                    ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please get BlueSTAR WR Approval before completing the task');
                    ApexPages.addMessage(myMsg);                    
                    return null;
                }
                //SFDC-5005 Used to check whether user enter BlueSTAR Walkthrough Account Mgmt/GET
                if((taskkk.subject == 'BlueSTAR Walkthrough Meeting Setup Complete') && caseRecord.GEMS_BlueSTAR_Walkthrough_Resource_1__c == null){
                    System.debug('===========taskkk.subject======='+taskkk.subject );
                    WTReviewerError=true;
                    ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please enter the BlueSTAR walk-through approver (BlueSTAR Walkthrough Account Mgmt/GET) before proceeding.');
                    ApexPages.addMessage(myMsg);                    
                    return null;
                }
                //SFDC-5005
                if((taskkk.subject == 'BlueSTAR Walkthrough') && (caseRecord.GEMS_Date_BlueSTAR_Walkthrough_Held__c == null) ) {
                    System.debug('===========taskkk.subject======='+taskkk.subject );
                    qrReviewerError1= true;                    
                    ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please complete Blue Star Walkthorough Approval and select Date BlueSTAR Walkthrough Held before completing the task.');
                    ApexPages.addMessage(myMsg);                    
                    return null;
                }
                // Ranjit - SFDC-6374 GEMS - When user tries to complete any task except Quality Review Task and Bluestar Walk through- as these have approvals and diff message
                //For all other Account setup tasks- we throw a message:  You must be the assigned case owner to complete this task.
				
                    
                /*if(taskkk.ownerId!=UserInfo.getUserId())
                        {
                            System.debug('UserInfo.getUserId()'+UserInfo.getUserId());
                            System.debug('taskkk.ownerId'+taskkk.ownerId);
                            taskkk.status='In Progress';
                            update taskkk;
                            System.debug('UserInfo.getUserId()'+UserInfo.getUserId());
                            System.debug('taskkk.ownerId'+taskkk.ownerId);
                        }*/

                 if((taskkk.subject != GEMS_Constants.AccountSetupTaskQualityReview && 
                     taskkk.subject !=GEMS_Constants.AccountSetupTaskBlueSTARWalkthrough) && 
                    (UserInfo.getUserId() != caseRecord.ownerId) ) {
                    System.debug('===========taskkk.subject======='+taskkk.subject );
                    releaseUnderwriterError= true;                    
                    ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'You must be the assigned case owner to complete this task.');
                    ApexPages.addMessage(myMsg);                    
                    return null;
                }
             //SFDC - 9101 GEMS: Account Setup Remove LGDE Question from Account Setup Case and from Workflow 
               /*
                      if((taskkk.subject == 'Release to Enroll/LGDE Eligibility Load') && (caseRecord.GEMS_Date_LGDE_File_was_Received__c == null ) ) {
                    System.debug('===========taskkk.subject======='+taskkk.subject );
                    isEdgeError= true;                    
                    ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please select Date LGDE File was Received before completing the task');
                    ApexPages.addMessage(myMsg);                    
                    return null;
                }
				*/
                //if(selectParamVal == 'No' && taskkk.subject == 'Paperwork Review Requested by Account Specialist' ) {                
                if(taskkk.subject == 'BlueSTAR Entry Complete' ) {   
                    
                    
                    
                    // #LUKE SFDC-4719 GEMS Maintenance Account Setup flow                    
                    //#4999 - If condition is being modified to include check on question 'Is QR Needed?'
                    if(!taskSubject.contains('Quality Review') &&  
                       caseRecord.recordtype.name != 'GEMS Account Setup Maintenance' 
                       && caseRecord.Is_QR_Needed__c != 'No' 
                      ) {
                        taskList_upsert.add(createTask('Quality Review', taskkk.whatId, taskkk.OwnerId));                        
                    }
                    
                    // #RANJIT SFDC-5003 GEMS Acct Setup Process - Auto create QR approval
                    // QR task must be created when QR approval is rejected.
                    else if(caseRecord.recordtype.name != 'GEMS Account Setup Maintenance' 
                       && caseRecord.Is_QR_Needed__c != 'No' && !tasksubject1.isEmpty()
                            //caseRecord.status=='QR Approval Rejected'
                      ) {
                        taskList_upsert.add(createTask('Quality Review', taskkk.whatId, taskkk.OwnerId));                        
                    }
                    
                    //4999 - flag to bypass qr task is set to true when the BlueSTAR Entry Complete task is closed and when QR is not needed.
                    else if(!taskSubject.contains('Quality Review') && caseRecord.recordtype.name != 'GEMS Account Setup Maintenance' && caseRecord.Is_QR_Needed__c == 'No') {
                        bypass_QR_Task = true;
                    }
                }
                
                
                if (taskkk.subject == 'Quality Review' && caseRecord.GEMS_Is_BlueSTAR_Walkthrough_Needed__c == 'Yes' 
                    && !caseRecord.GEMS_Account_Setup_QR_Approval_Received__c ) {   
                    ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please get the Quality Review Approval before completing Quality Review Task');
                    ApexPages.addMessage(myMsg);
                    qrReviewerError5 = true;
                    return null;
                }
                

                //4999 - Condition included to bypass QR task. 
                // SFDC-6446. Create 'BlueSTAR Walkthrough Meeting Setup Complete' task if current task is either 
              	// 'Quality Review' or 'Blue STAR Entry Complete'
                if (((caseRecord.Is_QR_Needed__c == 'Yes' && taskkk.subject == 'Quality Review') || (caseRecord.Is_QR_Needed__c == 'No' && taskkk.subject == 'BlueSTAR Entry Complete')) && 
                    caseRecord.GEMS_Is_BlueSTAR_Walkthrough_Needed__c == 'Yes' 
                     && (caseRecord.GEMS_Account_Setup_QR_Approval_Received__c || caseRecord.Is_QR_Needed__c =='No'))
                     {
                    if(!taskSubject.contains('BlueSTAR Walkthrough Meeting Setup Complete')) {
                        taskList_upsert.add(createTask('BlueSTAR Walkthrough Meeting Setup Complete', taskkk.whatId, caseRecord.OwnerId));
                    }
                }
                
              //4999 - Check if quality review is required.
              // SFDC-6446. Create 'Release to Underwriting' task if current task is either 
              // 'Quality Review' or 'Blue STAR Entry Complete'
                if ( ((caseRecord.Is_QR_Needed__c == 'Yes' && taskkk.subject == 'Quality Review') || (caseRecord.Is_QR_Needed__c == 'No' && taskkk.subject == 'BlueSTAR Entry Complete')) && 
                      (caseRecord.GEMS_Is_BlueSTAR_Walkthrough_Needed__c == 'No') && 
                      (caseRecord.GEMS_Account_Setup_QR_Approval_Received__c || caseRecord.Is_QR_Needed__c =='No')) 
                   {
                    if(!taskSubject.contains('Release to Underwriting')) {
                        taskList_upsert.add(createTask('Release to Underwriting', taskkk.whatId, caseRecord.OwnerId));
                    }
                }
                
                                
                if(taskkk.subject == 'BlueSTAR Walkthrough Meeting Setup Complete' || (taskkk.subject == 'BlueSTAR Entry Correction' && taskkk.Status == 'Closed')) {      
                    if(!taskSubject.contains('BlueSTAR Walkthrough')) {
                        taskList_upsert.add(createTask('BlueSTAR Walkthrough', taskkk.whatId, taskkk.OwnerId));
                    }
                }
                //SFDC-5006 Create Blue Star WalkThrough Task after BlueStar Entry Correction
                if(taskkk.subject == 'BlueSTAR Entry Correction') {      
                    if(!(taskSubject.contains('BlueSTAR Walkthrough') && taskkk.Status == 'Closed' )) {
                        taskList_upsert.add(createTask('BlueSTAR Walkthrough', taskkk.whatId,caseRecord.OwnerId)); 
                    }
                }
                //SFDC-5006
             
              
           
                
                //modifed below if condition  by Praveen
                if(taskkk.subject == 'BlueSTAR Update Complete'  && !caseRecord.GEMS_Account_Setup_WT_Approval_Received__c ) {  //caseRecord.Status == 'BW Approval Rejected'
                    if(!taskSubject.contains('Release to Underwriting')) {
                        taskList_upsert.add(createTask('Release to Underwriting', taskkk.whatId, caseRecord.OwnerId));
                    }
                    
                }
                /* SFDC-9101 GEMS: Account Setup Remove LGDE Question from Account Setup Case and from Workflow
                //modifed below if condition  by Shiva/Praveen
                if(taskkk.subject == 'BlueSTAR Walkthrough' && caseRecord.GEMS_Account_Setup_WT_Approval_Received__c && caseRecord.GEM_Is_group_loading_eligty_via_LGDE__c == 'Yes' ) {  //caseRecord.Status == 'BW Approval Received'
                    if(!taskSubject.contains('Release to Enroll/LGDE Eligibility Load')) {
                        taskList_upsert.add(createTask('Release to Enroll/LGDE Eligibility Load', taskkk.whatId, caseRecord.OwnerId));
                    }
                }
                
                
                //modifed below if condition  by Shiva/Praveen
                //4999 - Checking if quality review is needed.                
                // SFDC-6446. Create 'Release to Enroll/LGDE Eligibility Load' task if current task is either 
              	// 'Quality Review' or 'Blue STAR Entry Complete'
                if(((caseRecord.Is_QR_Needed__c == 'Yes' && taskkk.subject == 'Quality Review') || (caseRecord.Is_QR_Needed__c == 'No' && taskkk.subject == 'BlueSTAR Entry Complete')) && 
                   caseRecord.GEMS_Is_BlueSTAR_Walkthrough_Needed__c == 'No'  
                    && caseRecord.GEM_Is_group_loading_eligty_via_LGDE__c == 'Yes' )
                   {
                    if(!taskSubject.contains('Release to Enroll/LGDE Eligibility Load')) {
                        taskList_upsert.add(createTask('Release to Enroll/LGDE Eligibility Load', taskkk.whatId, caseRecord.OwnerId));
                    }
                }
                */
                //added below if condition  by Shiva for October release
                if((taskkk.subject == 'BlueSTAR Walkthrough'&& caseRecord.GEMS_Account_Setup_WT_Approval_Received__c )) {   
                       if(!taskSubject.contains('Release to Underwriting')) {
                           taskList_upsert.add(createTask('Release to Underwriting', taskkk.whatId, caseRecord.OwnerId));
                       }
                   }
                
                if(selectParamVal == 'Yes' && taskkk.subject == 'Paperwork Review Requested by Account Specialist') {
                    ID accountSubmissionCaseOwnerId = caseRecord.GEMS_Account_Submission_Info__r.ownerId;
                    List<GEMS_Return_Reason__c > reasonListtoBeInserted = new List<GEMS_Return_Reason__c >();
                    if(returnReasonList != null && !returnReasonList.isEmpty()) {
                        for(GEMS_Return_Reason__c returnReason: returnReasonList) {
                            if(returnReason.Id == null) {
                                returnReason.GEMS_Case__c = caseRecord.Id;
                                reasonListtoBeInserted.add(returnReason);
                            }
                        }
                        if(!reasonListtoBeInserted.isEmpty()){
                            insert reasonListtoBeInserted;
                        }                        
                    }
                    
                    //ID accountSubmissionCaseOwnerId = [SELECT ID, OwnerId from Case where ID =: caseRecord.GEMS_Account_Submission_Info__c].ownerId;
                    //totalCount = totalCount + 1;
                    caseRecord.GEMS_ReviewDocuments__c=false;
                    caseRecord.GEMS_Approve__c=false;
                    caseRecord.GEMS_Return__c=true;
                    caseRecord.GEMS_Return_Check__c = true;
                    caseRecord.GEMS_Routed_In_Error__c=false;
                    //caseRecord.GEMS_Return_Counter__c= totalCount; 
                    caseRecord.Status='Return';
                    caseRecord.GEMS_Returned_user_id__c = caseRecord.OwnerId;
                    caseRecord.OwnerId=accountSubmissionCaseOwnerId;
                    
                }
                taskkk.status = 'Completed';
                if(taskkk.GEMS_End_Date__c == null) taskkk.GEMS_End_Date__c = System.now();
                System.debug('before update=====');
                if(taskList.size() > currentTask+1)
                {
                    task nextTaskToInProgress = taskList.get(currentTask+1);                    
                    if(nextTaskToInProgress.subject != 'AEP Testing' && nextTaskToInProgress.subject != 'AEP Production Ready') {
                        nextTaskToInProgress.GEMS_Start_Date__c =system.now();
                        nextTaskToInProgress.Status='In Progress';
                        
                        taskList_upsert.add(nextTaskToInProgress);
                    }
                    
                    
                /*nextTaskToInProgress.Status='In Progress';
                nextTaskToInProgress.GEMS_Start_Date__c = System.now();
                inProgressTaskUpdateList.add(nextTaskToInProgress);*/
                                }
                                //update taskkk;
                                taskList_upsert.add(taskkk);
                                System.debug('+testing+');
                                /*if(!inProgressTaskUpdateList.isEmpty()) {
                update inProgressTaskUpdateList;
                }*/
                if(!taskList_upsert.isEmpty()) {
                    System.debug('+testing1+');
                    Database.UpsertResult[] sr= Database.upsert(taskList_upsert);
                    //tasklist = taskList_upsert;
                    System.debug('+++saveresult+'+sr);
                    Integer noOfTasks=taskList_upsert.Size();
                    Integer completedTasks=0;
                    Boolean caseToUpdate = false, maintAcctCasesToUpdate = false;
                    for(Task tsk: taskList_upsert)
                    {
                        if(tsk.Status=='Completed')
                        {
                            completedTasks=completedTasks+1;
                            
                            if(noOfTasks == completedTasks)
                            {
                                disableCompleteButton=true;
                                caseRecord.Status='Completed';
                                
                            }
                            //update caseRecord;
                            
                        }
                        if(tsk.subject == 'AEP Initial Setup') {
                            //updateTaskStartDate(tsk);
                        }
                        if(tsk.subject == 'AEP Testing') {
                            //updateTaskStartDate(tsk);
                        }
                        
                        // if(tsk.subject == 'AEP Production Ready' && tsk.Status=='Completed') {caseRecord.Status='Complete'; update caseRecord;}
                        //if(taskkk.subject == 'Paperwork Review' && taskkk.status=='Completed' && selectParamVal=='Yes' ) {caseRecord.Status='Complete'; update caseRecord;} 
                        if(taskkk.subject == 'BlueSTAR Entry Complete' && taskkk.status=='Completed') 
                        {
                            // #LUKE SFDC-4719
                            if(caseRecord.recordtype.name == 'GEMS Account Setup Maintenance'){
                                caseRecord.Status = 'Completed';
                                caseRecord.GEMS_Account_Submission_Info__r.status = 'Completed';
                                maintAcctCasesToUpdate = true;
                            //}else{                                
                            //4999 - Mark as QR pending only if QR is needed.
                            }else if(caseRecord.Is_QR_Needed__c != 'No') {                                
                                // Ranjit- SFDC-5003-GEMS: Acct Setup Process - Auto create QR approval
                                //caseRecord.Status='BlueSTAR Entry Complete'; 
                                caseRecord.Status='QR Approval Pending';                                                                
                                caseToUpdate = true;
                            } else {
                                //4999 - If Quality review is not needed, update status as QR completed after BlueSTAR Entry is Completed. 
                                // SFDC - 6446. Update case status to 'Blue STAR Entry Completed' if QR is not required
                                // caseRecord.Status='Quality Review Completed';
                                caseRecord.Status='BlueSTAR Entry Complete';
                                caseToUpdate = true;
                            }
                        }
                        if(selectParamVal == 'Yes' && taskkk.subject == 'Paperwork Review Requested by Account Specialist'){caseRecord.Status='Paperwork Review Complete'; caseToUpdate = true;}
                        
                        //if(taskkk.subject == 'BlueSTAR Walkthrough' && taskkk.status=='Completed') {caseRecord.Status='Complete'; update caseRecord;}
                        
                        if(taskkk.subject == 'BlueSTAR Update Complete' && taskkk.status=='Completed') 
                                {caseRecord.Status='BlueSTAR Walkthrough Complete'; caseToUpdate = true;}
                        if(taskkk.subject == 'BlueSTAR Walkthrough' && taskkk.status=='Completed') {caseRecord.Status='BlueSTAR Walkthrough Complete'; caseToUpdate = true;}
                        if(taskkk.subject == 'Release to Underwriting' && taskkk.status=='Completed') {caseRecord.Status='Release Underwriting Complete'; caseToUpdate = true;}
                        
                        if(tsk.subject == 'AEP Initial Setup' && tsk.Status=='Completed') {caseRecord.Status='Initial Setup Completed'; caseToUpdate = true;}
                        //added by Shiva for December Release-JIRA-3065
                        //if(tsk.subject == 'Release to Enroll/LGDE Eligibility Load' && tsk.Status=='Completed') {caseRecord.Status='Eligibility Load Completed'; caseToUpdate = true;}
                        if(tsk.subject == 'AEP Testing' && tsk.Status=='Completed') {caseRecord.Status='Testing Completed'; caseToUpdate = true;}
                        if(tsk.subject == 'AEP Production Ready' && tsk.Status=='Completed') {caseRecord.Status='Production Completed'; caseToUpdate = true;}
                        if(tsk.subject == 'Quality Review' && tsk.Status=='Completed') {caseRecord.Status='Quality Review Completed'; caseToUpdate = true;}
                        if(tsk.subject == 'Manual Eligibility Complete' && tsk.Status=='Completed') {caseRecord.Status='Completed'; caseToUpdate = true;}
                        
                        if(tsk.Subject=='Release Eligibility File to Production' && tsk.Status=='Completed' && caseRecord.GEMS_Release_to_Compare_date__c!= null && caseRecord.GEMS_Authorization_to_valid_date__c != null &&
                           caseRecord.GEMS_Actual_Date_for_Production_File_1__c != null && caseRecord.GEMS_Actual_Date_for_Production_File_2__c != null 
                           && caseRecord.GEMS_Target_Date_for_Production_File_1__c != null && caseRecord.GEMS_Target_Date_for_Production_File_2__c != null)
                        {
                            caseRecord.Status='Completed';
                            caseToUpdate = true;
                        }
                        //SFDC-5005 Trigger BT Approval Process automatically by updating status to 'BW Approval Pending'
                        if(tsk.subject == 'BlueSTAR Walkthrough Meeting Setup Complete' && tsk.status == 'Completed'){
                            caseRecord.Status='BW Approval Pending'; 
                            caseToUpdate = true;
                        }
                        //SFDC-5005
                        //SFDC-5006 Trigger BT Approval Process automatically by updating status to 'BW Approval Pending'
                        if(tsk.subject == 'BlueSTAR Entry Correction' && tsk.status == 'Completed') {
                            caseRecord.Status='BW Approval Pending'; 
                            caseToUpdate = true;
                        }
                        //SFDC-5006
                    }
                    // #LUKE SFDC-4719
                    if(maintAcctCasesToUpdate){
                        List<Case> maintAcctCaseListToUpdate = new List<Case>{caseRecord, caseRecord.GEMS_Account_Submission_Info__r};
                            update maintAcctCaseListToUpdate;
                    }else if(caseToUpdate) {
                        update caseRecord;
                    }
                }
                currentTask++;
            }
            return null;
        } catch(Exception ex) {
            
            System.debug('++exception++'+ex.getMessage());
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_TaskEligibilityController.changeTaskStatus()','High');
            return null;  
        }
        
        return null;
    }
    
    
/******************************************************************** 
*   Method Name : cancelProject Action
*   @description :   This method to cancel the case
*   @parameters  :   None
*   @return type :   PageReference
***************************************************************/
    public PageReference cancelProject() {
        if(!taskList.isEmpty() && currentTask <= taskList.size() ) {
            //System.debug('taskList.get(currentTask)====>'+taskList.get(currentTask));
            /*if(selectedVal == -1) {            
ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please select below task');
ApexPages.addMessage(myMsg);                    
return null;
}*/
            Task taskkk = null;
            for(Task tass : taskList) {
                if(tass.status=='In progress') {
                    taskkk = tass;
                    break;
                }
            }
            if(taskkk != null) {
                taskkk.GEMS_End_Date__c = System.now();
                taskkk.status = 'Project Cancelled';
                update taskkk;
                //taskkk = taskList.get(currentTask);
            }
            caseRecord.Status='Project Cancelled';
            update caseRecord;
        }
        return null;
    }
    
    /******************************************************************** 
*    Method Name : areDatesOk
*   @description :   This method to verify dates rule
*   @parameters  :   None
*   @return type :   boolean
***************************************************************/    
    @TestVisible private boolean areDatesOk(){
        isDatesError = false;
        isDatesErrorSetupTesting = false;
        combineFlag = false;
        Datetime setupEndDate = null;
        Datetime testingStartDate = null;    
        if(null!= taskList && !taskList.isEmpty() ) {
            System.debug('GEMS_TaskEligibilityController.areDatesOk(), size=' + taskList.size());
            Task taskkk = null;
            for(Task tass : taskList) {
                if(tass.GEMS_Start_Date__c != null && tass.GEMS_End_Date__c != null)
                    if( ! isDatesError && tass.GEMS_Start_Date__c > tass.GEMS_End_Date__c){
                        isDatesError = true;
                        combineFlag = true;
                    }
                
                if(tass.Subject == 'AEP Initial Setup' && tass.GEMS_End_Date__c != null)
                    setupEndDate = tass.GEMS_End_Date__c;
                if(tass.Subject == 'AEP Testing' && tass.GEMS_Start_Date__c != null){
                    if(testingStartDate == null) testingStartDate = tass.GEMS_Start_Date__c;
                    else if( tass.GEMS_Start_Date__c < testingStartDate ) testingStartDate = tass.GEMS_Start_Date__c;
                }
            }
            if(setupEndDate != null && testingStartDate != null && setupEndDate > testingStartDate){
                isDatesErrorSetupTesting = true;
                combineFlag = true;
            }
            
            if( !isDatesError && !isDatesErrorSetupTesting) return true;
        }
        return false;
    }
    
    
    public void assignSelectedVal() {
        System.debug('selectedVal---->'+selectedVal);
    }
    
/*********************************************************************
*   Method Name : showYesOrNoPage Action
*   @description :   This method to show yes or know radiobuttons on the screen
*   @parameters  :   None
*   @return type :   PageReference
***************************************************************/
    public PageReference showYesOrNoPage() {
        selectdPaperWork = true;
        System.debug('======----------====');
        
        try {
            options = new List<SelectOption>(); 
            options.add(new SelectOption('Yes','Yes')); 
            options.add(new SelectOption('No','No',false)); 
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_TaskEligibilityController.showYesOrNoPage()','High');  
        }
        System.debug('======----------====');
        return null;
    }
    
 
    
    public void showReturnReasonBlock()  {
        displayReturnReason = true;        
        System.debug('-----called---');
        //return null;
    }
    public void addRow() {
        //reasonList.add(new GEMS_Return_Reason__c(GEMS_case__c= cases.ID));        
        returnReasonList.add(returnreasonRec);
        system.debug('ret list : '+returnReasonList);
        returnreasonRec = new GEMS_Return_Reason__c(GEMS_case__c= caseRecord.Id);
    }
/******************************************************************** 
*   Method Name : createTask Action
*   @description :   This method to update startdate in task while adding testing and production record. #4999
*   @parameters  :   None
*   @return type :   Task
***************************************************************/
    public Task createTask(String parSubject, Id parWhat, Id parOwner){
        Task task_new = new Task();
        task_new.subject = parSubject;
        task_new.whatId = parWhat;
        task_new.ownerId = parOwner;
        task_new.Status = 'In Progress';
        task_new.Priority = 'Normal';
        task_new.GEMS_Start_Date__c = System.now();
        return task_new;
    }
}