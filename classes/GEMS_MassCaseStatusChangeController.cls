/**************************************************************************************
  Apex Class Name       : GEMS_MassCaseStatusChangeController
  Version               : 1.0
  Function              : The controller that is used to mass update case status changes
  Modification Log      :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Offshore            05/30/2016             Original Version
* Praveen             10/17/2016             Added logic to make Return reasons required when return id selected
* Ranjit Gandhi       06/01/2017             SFDC-4804- Display Message when trying to return a BA Level Case when the status is in a Closed State
* Phani Kommareddy    06/09/2017             SFDC-4678 GEMS - Add additional status values to multi-select case status updates on Medical Benefit Coding parent case
* Hari                09/25/2017             SFDC-5228: GEMS - Case Statuses Cleanup: GEMS BA Level Screening Cases   
* Malathi.K           10/11/2017             SFDC-3880: GEMS - Add Return functionality to Dental Benefit Coding case. 
* Vijay               10/13/2017             US 4943 GEMS: Add validation for Return Reasons on BA Level Cases - Medical Benefit Coding and Pharmacy Coding
* Vijay				  11/06/2017			 SFDC-5230 : GEMS - Case Statuses Cleanup: Medical Benefit Coding Case
*************************************************************************************/

public with Sharing class GEMS_MassCaseStatusChangeController {

    public List<GEMS_Return_Reason__c> returnReasonList{get;set;}
    public List<SelectOption> statusPickList{get;set;}
     public GEMS_Return_Reason__c returnreasonRec {set;get;}
     public String caseId{get;set;}
     public String comments{get;set;}
     public String childComments{get;set;}
     public Boolean displayReturnReason{get;set;}
     public String selectedCaseIds;
     public String selectedStatus{get;set;}
     public String scopeCode {get;set;}
     public String benefitCode {get;set;}
     public Case caseRecord {get;set;}
     public Boolean pageHasErrors {get;set;}

    public GEMS_MassCaseStatusChangeController(ApexPages.StandardController controller){
    
        returnreasonRec = new GEMS_Return_Reason__c();
        caseId = ApexPages.currentPage().getParameters().get('Id');
        scopeCode = ApexPages.currentPage().getParameters().get('scopecode');
        benefitCode = ApexPages.currentPage().getParameters().get('benefitcode');
        selectedCaseIds = ApexPages.currentPage().getParameters().get('selectedCaseIds');
        caseRecord = [select id, Sub_Category__c, casenumber,isclosed,type from case where id =: caseId ];
        
        //System.debug('selectedCaseIds ===>'+selectedCaseIds );  System.debug('caseRecord ===>'+caseRecord );
        
        if(scopeCode == 'true'){
            statusPickList = getMyScopeOptions();
        } else{
            if(benefitcode == 'true'){
                statusPickList = getMybenefitOptions();
            }else{
                statusPickList = getMyOptions();
            }
            //System.debug('statusPickList ===>'+statusPickList );
        }
        returnReasonList = [SELECT ID, Name, GEMS_Case__c, Process_Name__c, GEMS_Type__c, GEMS_Sub_Type__c, Return_Reason__c, GEMS_Comments__c FROM GEMS_Return_Reason__c where GEMS_Case__c =: caseID];
    }
    
    //Retrieves selection options to display as a drop-down list on bulk status changes
    public List<SelectOption> getMyOptions(){
    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select--'));
        //SFDC-5228 GEMS - Case Statuses Cleanup: GEMS BA Level Screening Cases.
        //options.add(new SelectOption('New', 'New'));
        options.add(new SelectOption('In Progress', 'In Progress'));
        //SFDC-4678 GEMS - Add additional status values to multi-select case status updates on Medical Benefit Coding parent case
        //SFDC-5230 - Added 'Cancelled' status to selectoptions
        if(caseRecord.type != null && caseRecord.type == 'Medical Benefit Coding') {        
            options.add(new SelectOption('Medical Benefits Production Ready', 'Medical Benefits Production Ready'));
            options.add(new SelectOption('Medical Coding Complete', 'Medical Coding Complete'));
            options.add(new SelectOption('No GCPS Action Required','No GCPS Action Required'));
            options.add(new SelectOption(GEMS_Constants.StatusCancelled,GEMS_Constants.StatusCancelled));
        }
        else {
            //SFDC-3880 GEMS - Add additional status values to multi-select case status updates on Dental Benefit Coding parent case
            if(caseRecord.type != null && caseRecord.type == 'Dental Benefit Coding') {
                options.add(new SelectOption('Closed','Closed'));
                options.add(new SelectOption('Peer Review Approval Pending', 'Peer Review Approval Pending'));
                options.add(new SelectOption('Peer Reviewer Approved', 'Peer Reviewer Approved'));
                options.add(new SelectOption('Completed','Completed'));
                // SFDC-3880 End changes
           }          
            else {
              options.add(new SelectOption('Approved', 'Approved'));
         }
        }
        
        options.add(new SelectOption('Return', 'Return'));
        if(caseRecord.Sub_Category__c != null && caseRecord.Sub_Category__c != 'Account Setup Screening') {        
            options.add(new SelectOption('Routed In Error', 'Routed In Error'));
        }
        
        return options;
    }
    
     public List<SelectOption> getMyScopeOptions(){
    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--', '--None--'));
        options.add(new SelectOption('Return', 'Return'));
        options.add(new SelectOption('Routed In Error', 'Routed In Error'));
        
        return options;
     }
    
     public List<SelectOption> getMybenefitOptions(){
    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--', '--None--'));
        options.add(new SelectOption('Return', 'Return'));
       
        
        return options;
     }
    
     public void addRow() {
        if(returnReasonList == null) {
            returnReasonList = new List<GEMS_Return_Reason__c>();
        }
        returnReasonList.add(returnreasonRec);
        system.debug('ret list : '+returnReasonList);
        returnreasonRec = new GEMS_Return_Reason__c(GEMS_case__c= caseID);
     }
    
     public void showReturnReasonBlock()  {
         if(selectedStatus == 'Return') {
             displayReturnReason = true;        
         }else if(selectedStatus == 'Routed In Error') {
             displayReturnReason = false;
         }else {
             displayReturnReason = false;
         }
         
        System.debug('-----called---');
     }
    
     public pagereference saveStatus() {                 
        try {
            // LUKE FIX
            List<String> idListString = selectedCaseIds.split(',');
            List<Id> idList = new List<Id>();
            for(String s : idListString)
                idList.add(Id.valueOf(s));
            List<Case>  childCount = [select id from case where id in :idList and isclosed = true  ];
            integer ChildIsCloseCount = childCount.size();
             System.debug('**************selectedStatus'+selectedStatus);
            
            if(selectedStatus == null || selectedStatus.length() == 0) {
                System.debug('selectedStatus == null || selectedStatus.length() == 0');
                ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please select status');
                ApexPages.addMessage(myMsg);                    
                return null;
            }
            //Cases in approved status cannot be returned
            else if(selectedStatus == 'Return' && (caserecord.isclosed == true || ChildIsCloseCount > 0))
                {
                    System.debug('selectedStatus == Return && caserecord.isclosed == true');
                    ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'At least one of the Cases has been completed. Cannot return in bulk.');
                    ApexPages.addMessage(myMsg);                    
                    return null;
            }
            
            else if(caseId != null && benefitCode == 'true' && selectedStatus == 'Return' ){
                
                System.debug('caseId != null && benefitCode == true && selectedStatus == Return');
               List<Case> casesList = [select id,status,CaseNumber,GEMS_Account_Submission_Info__r.ownerId,GEMS_Account_Submission_Info__r.Id,
                                       ownerId,GEMS_ReviewDocuments__c,GEMS_Approve__c,GEMS_Return__c,
                                       GEMS_Return_Check__c,GEMS_Routed_In_Error__c,GEMS_Return_Counter__c  from Case where id =:caseId];
                 for(Case case_db : casesList) {
                 
                    ID accountSubmissionCaseOwnerId = case_db.GEMS_Account_Submission_Info__r.ownerId;
                    Integer totalCount = 1;
                    case_db.GEMS_ReviewDocuments__c=false;
                    case_db.GEMS_Approve__c=false;
                    case_db.GEMS_Return__c=true;
                    case_db.GEMS_Return_Check__c = true;
                    case_db.GEMS_Routed_In_Error__c=false;
                    case_db.GEMS_Return_Counter__c= totalCount;
                    case_db.GEMS_Returned_user_id__c = case_db.ownerId;         
                    case_db.Status='Return';
                 }
                 update casesList;
                
            }
            else if(selectedCaseIds != null && ( selectedCaseIds.length() > 1 || benefitCode == 'true' ) && selectedStatus == 'Return') {
                 System.debug('selectedCaseIds != null && ( selectedCaseIds.length() > 1 || benefitCode == true) && selectedStatus == Return');
                List<String> casesTobeUpdated = new List<String>();
                System.debug('----Start saveStatusMethod-----'+casesTobeUpdated);
                if(selectedCaseIds.contains(',')) {
                    String[] casesIds = selectedCaseIds.split(',');
                    casesTobeUpdated = casesIds;
                }else {
                    casesTobeUpdated.add(selectedCaseIds);
                }
                
                if( benefitCode == 'true') {
                    casesTobeUpdated.add(caseId);
                }
                if(!casesTobeUpdated.isEmpty()) {
                    System.debug('----casesTobeUpdated.isEmpty()-----'+casesTobeUpdated.isEmpty());
                    List<GEMS_Return_Reason__c> returnReajonsToBeInserted = new List<GEMS_Return_Reason__c>();
                    List<CaseComment> comments = new List<CaseComment>();
                    set<ID> caseIds = new set<ID>();
                    for(GEMS_Return_Reason__c rejectReason : returnReasonList) {
                        for(String caseId : casesTobeUpdated) {
                            GEMS_Return_Reason__c rrr = new GEMS_Return_Reason__c(GEMS_Sub_Type__c = rejectReason.GEMS_Sub_Type__c,Process_Name__c = rejectReason.Process_Name__c,GEMS_Type__c = rejectReason.GEMS_Type__c,Return_Reason__c = rejectReason.Return_Reason__c, GEMS_Case__c=caseId); 
                            CaseComment caseCmnt;
                            if(String.isNotBlank(childComments))
                            {
                                if(!caseIds.contains(caseId))
                                {
                                    caseCmnt = new CaseComment (ParentId = caseId,commentBody = childComments);
                                    comments.add(caseCmnt);
                                }
                            }
                            returnReajonsToBeInserted.add(rrr);
                            caseIds.add(caseId);
                        }
                    }
                    if(returnReajonsToBeInserted.isEmpty())
                    {
                        //US 4943 - Changed the Error message 
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please add Return reason and Comment when Return status is selected'));
                        return null;
                    }
                    else if(!returnReajonsToBeInserted.isEmpty())
                    {
                        /*****************************/
                        for(GEMS_Return_Reason__c retReasonRec: returnReajonsToBeInserted)
                        {
                           if(retReasonRec.GEMS_Type__c!=null && retReasonRec.GEMS_Type__c.contains('ABS') && retReasonRec.GEMS_Sub_Type__c==null)
                           {
                               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select ABS/Matirx Sub Document Type'));
                               return null;
                           }
                        }
                        ApexPages.Message[] messages = ApexPages.getMessages();
                        
                        /*******************************/
                        if(!returnReajonsToBeInserted.isEmpty() && messages.size()<1)
                        {
                            insert returnReajonsToBeInserted;
                            if(!comments.isEmpty())
                            {
                                insert comments;
                            }
                            List<Case> casesList = [select id,status,CaseNumber,GEMS_Account_Submission_Info__r.ownerId,GEMS_Benefit_Agreement__r.Name,
                                                    GEMS_Account_Submission_Info__r.Id,ownerId from Case where id in : casesTobeUpdated];
                            for(Case case_db : casesList) {
                                if(selectedStatus =='Approved') {
                                    case_db.GEMS_Approve__c=true;
                                    case_db.GEMS_Return__c=false;
                                    case_db.GEMS_Return_Check__c=false;
                                    case_db.GEMS_Routed_In_Error__c=false;
                                    case_db.Status='Approved';
                                }
                                else if(selectedStatus =='In Progress') {
                                    System.debug('----selectedStatus ==In Progress-----');
                                    case_db.GEMS_Approve__c=true;
                                    case_db.GEMS_Return__c=false;
                                    case_db.GEMS_Return_Check__c=false;
                                    case_db.GEMS_Routed_In_Error__c=false;
                                    case_db.Status='In Progress';
                                }
                                else if(selectedStatus =='Return') {
                                    System.debug('----selectedStatus ==Return-----');
                                    ID accountSubmissionCaseOwnerId = case_db.GEMS_Account_Submission_Info__r.ownerId;
                                    Integer totalCount = 1;
                                    case_db.GEMS_ReviewDocuments__c=false;
                                    case_db.GEMS_Approve__c=false;
                                    case_db.GEMS_Return__c=true;
                                    case_db.GEMS_Return_Check__c = true;
                                    case_db.GEMS_Routed_In_Error__c=false;
                                    case_db.GEMS_Return_Counter__c= totalCount; 
                                    case_db.Status='Return';
                                    case_db.GEMS_Returned_user_id__c = case_db.ownerId; 
                                    case_db.OwnerId=accountSubmissionCaseOwnerId;
                                    }
                                else if(selectedStatus =='Routed In Error') {
                                    case_db.GEMS_Approve__c=false;
                                    case_db.GEMS_Return__c=false;
                                    case_db.GEMS_Return_Check__c = false;
                                    case_db.GEMS_Routed_In_Error__c=true;
                                    case_db.Status='Routed In Error';
                                }
                                
                            }
                            update casesList;
                        }
                    }
                }           
            }
            else if(selectedCaseIds != null && ( selectedCaseIds.length() > 1 || benefitCode == 'true') && selectedStatus != 'Return' )
            {
                 System.debug('selectedCaseIds != null && ( selectedCaseIds.length() > 1 || benefitCode == true) && selectedStatus != Return');
                List<String> casesTobeUpdated = new List<String>();
                if(selectedCaseIds.contains(','))
                {
                    String[] casesIds = selectedCaseIds.split(',');
                    casesTobeUpdated = casesIds;
                }
                else
                {
                    casesTobeUpdated.add(selectedCaseIds);
                }
                List<Case> casesList = [select id,status,GEMS_Account_Submission_Info__r.ownerId,GEMS_Account_Submission_Info__r.Id,
                                        ownerId,GEMS_ReviewDocuments__c,GEMS_Approve__c,GEMS_Return__c,GEMS_Return_Check__c,
                                        GEMS_Routed_In_Error__c,GEMS_Return_Counter__c  from Case where id =: casesTobeUpdated];
               
                for(Case case_db : casesList)
                {
                    case_db.Status = selectedStatus;
                }
                update casesList;
            }   
        }Catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_MassCaseStatusChangeController.saveStatus()','High');  
            /*Commented this method as part of US 5230 for MBC case status cleanup
            if(selectedStatus == 'Medical Benefits Production Ready' || selectedStatus == 'Medical Coding Complete' || selectedStatus == 'No GCPS Action Required' ) {    
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please check your BA cases, DTU/FEAK/CDHP/Shared Accums approval(s) still needed.'));
                pageHasErrors = true;
            }*/
                
            
            
            return null;                                
        }
        System.debug('----End saveStatusMethod-----');
        return new Pagereference('/'+caseId);
    }
    
    public void setSelectedStatus() {
    
    }
}