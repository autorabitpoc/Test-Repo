public class GEMS_MBCReturnStatusPageController {
    
    public List<GEMS_Return_Reason__c> returnReasonList{get;set;}
    public List<SelectOption> statusPickList{get;set;}
    public GEMS_Return_Reason__c returnreasonRec {set;get;}
    public String caseId{get;set;}
    public Boolean displayReturnReason{get;set;}
    public String selectedCaseIds;
    public String selectedStatus{get;set;}
    public String scopeCode {get;set;}
    public String benefitCode {get;set;}
    public String childComments{get;set;}
    public GEMS_MBCReturnStatusPageController (ApexPages.StandardController controller){
        //displayReturnReason = true;
        returnreasonRec = new GEMS_Return_Reason__c();
        caseId = ApexPages.currentPage().getParameters().get('Id');
        statusPickList = getMyOptions();
        System.debug('statusPickList ===>'+statusPickList );
        returnReasonList = [SELECT ID, Name, GEMS_Case__c, Process_Name__c, GEMS_Type__c, GEMS_Sub_Type__c, Return_Reason__c, GEMS_Comments__c FROM GEMS_Return_Reason__c where GEMS_Case__c =: caseID];
    }
    
    
    
    public List<SelectOption> getMyOptions(){    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select--'));
        options.add(new SelectOption('Return', 'Return'));      
        return options;
    }
    
    public void addRow() {
        //reasonList.add(new GEMS_Return_Reason__c(GEMS_case__c= cases.ID));
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
        //return null;
    }
    
    public pagereference saveStatus() {
        
        try {
            if(caseId != null ){
                List<GEMS_Return_Reason__c> returnReajonsToBeInserted = new List<GEMS_Return_Reason__c>();
                for(GEMS_Return_Reason__c rejectReason : returnReasonList) {
                    if(rejectReason.id == null) {
                        GEMS_Return_Reason__c rrr = new GEMS_Return_Reason__c(GEMS_Sub_Type__c = rejectReason.GEMS_Sub_Type__c,Process_Name__c = rejectReason.Process_Name__c,GEMS_Type__c = rejectReason.GEMS_Type__c,Return_Reason__c = rejectReason.Return_Reason__c, GEMS_Case__c=caseId);    
                        returnReajonsToBeInserted.add(rrr);
                    }
                }
         Case caseRec = [select id,parentid,Recordtypeid, Type,status,GEMS_Account_Submission_Info__r.ownerId,GEMS_Account_Submission_Info__r.Id, GEMS_Returned_user_id__c,OwnerId from Case where id =:caseId];
                if(!returnReajonsToBeInserted.isEmpty()) {
                    insert returnReajonsToBeInserted;
                    
                    if(selectedStatus =='Return') {
                        ID accountSubmissionCaseOwnerId = caseRec.GEMS_Account_Submission_Info__r.ownerId;
                        
                        caseRec.Status='Return';
                        caseRec.GEMS_Returned_user_id__c = caseRec.OwnerId;
                        caseRec.OwnerId=accountSubmissionCaseOwnerId;
                        update caseRec;
                        //US 4943 GEMS: Add validation for Return Reasons on BA Level Cases - Medical Benefit Coding and Pharmacy Coding
                        CaseComment caseCmnt;
                            if(String.isNotBlank(childComments))
                            {
                                caseCmnt = new CaseComment (ParentId = caseRec.id,commentBody = childComments);
                                insert caseCmnt;
                            } // 4943 End
                    }
                    List<Case> parentStatusUpdationList = new List<Case>(); 
                    List<Case> parentChildList;  

                    if (caseRec.Type == 'Pharmacy Coding') { 
                             Id PharmBALevelTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();                                                                 
                             parentChildList = [select id,status,(select id,status from cases where recordtypeid = :PharmBALevelTypeId) from case where id =: caseRec.parentid];    
                     }
                     else {
                      //SFDC-3880 - Add Return functionality to Dental Benefit Coding case
                      if (caseRec.Type == 'Dental Benefit Coding') {                    
                             Id DentalCodBALevelTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Dental Benefit Coding').getRecordTypeId();                                                                 
                             parentChildList = [select id,status,(select id,status from cases where recordtypeid = :DentalCodBALevelTypeId ) from case where id =: caseRec.parentid];    
                             //SFDC-3880 End changes
                        }  
                       else 
                       {
                          Id SBCBALevelTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();                                        
                          parentChildList = [select id,status,(select id,status from cases where recordtypeid = :SBCBALevelTypeId) from case where id =: caseRec.parentid];                            
                      }
                    }                                                                                          
                    Boolean allChildCompleted = true;
                    String childCaseStatus = '';
                    for(Case caseParent : parentChildList ) {
                        allChildCompleted = true;
                        List<Case> childCases = caseParent.cases;
                        for(Case casss : childCases) {
                            if(childCaseStatus == '') {
                                childCaseStatus = casss.status;
                            }
                            
                            if(casss.status != childCaseStatus) {
                                allChildCompleted = false;
                                break;
                            }
                        }
                        if(allChildCompleted) {
                            caseParent.status = childCaseStatus;
                            parentStatusUpdationList.add(new Case(id = caseParent.id,Status =childCaseStatus ));
                        }
                    }
                    
                    if(!parentStatusUpdationList.isEmpty()) {
                        update parentStatusUpdationList;
                    }                
                } 
                //US 4943 GEMS: Add validation for Return Reasons on BA Level Cases - Medical Benefit Coding and Pharmacy Coding
                else {
                     Id PharmaBALevelTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();                                                                 
                     Id MedBenefitBALevelTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();                                                                 
                    if(caseRec.RecordTypeId == PharmaBALevelTypeId || caseRec.RecordTypeId == MedBenefitBALevelTypeId){
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please add Return reason and Comment when Return status is selected'));
                     return null;
                }
                } //4943 End
            }
            // added to change the return status in case and parent case
            
        }
        
        Catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Task', null, 'GEMS_MassCaseStatusChangeController.saveStatus()','High');  
        }
        System.debug('----End saveStatusMethod-----');
        return new Pagereference('/'+caseId);
    }
    
    public void setSelectedStatus() {
        
    }
    
    public pagereference cancel() {
        return new Pagereference('/'+caseId);}
}