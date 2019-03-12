public with sharing class GEMS_ReturnReasonUnderwritingController {

    public List<Task> taskList{get;set;}
    public Case caseRecord{get;set;}
    public String selectedIds{get;set;}
    public Boolean errorCheck {get;set;}
    public Boolean allSelected{get;set;}
    public Boolean combineFlag{get;set;}
    public String unSelectedIds{get;set;}
    public Boolean buttonDisable{get;set;}
    public Boolean allChecked{get;set;}
    public Integer unselectedTaskStage {get;set;}
    public String parentId {set;get;}
    public String errorMsg {get;set;}
    public Boolean errorFlag{get;set;}
    
   
    public GEMS_ReturnReasonUnderwritingController(ApexPages.StandardController contrl) {
    
        errorFlag = false;
        combineFlag = false;
        allChecked = false;
        unselectedTaskStage = -1;
        errorCheck = false;
        buttonDisable = false;
        Case caseRec = (case)contrl.getRecord();
        caseRecord = [Select ID,Recordtype.Name,GEMS_Return_Reason__c,HCSC_Division__c,Funding_Type_Multiselect__c,GEMS_Rx_Vendor__c,GEMS_Account_Submission_Info__c,GEMS_XAccountHas_signed_2017BPA_attached__c,GEMS_Account_Submission_Info__r.ownerId,status from Case where ID =: caseRec.ID];
        taskList = [ select id, GEMS_UnderWriting_N_A__c,GEMS_UnderWriting_Yes_No__c,status, subject,GEMS_Start_Date__c,GEMS_End_Date__c,WhatId,ownerId from task where whatid =: caseRec.Id order by ID ASC ];        
        parentId = caseRecord.GEMS_Account_Submission_Info__c;
        if(taskList != null) {
            for(Task ttt : taskList) {
                if(ttt.status != 'Approved' && ttt.status != 'Cancelled') {
                    buttonDisable = true;
                }
            }
        }
        if(caseRecord.status == 'Return') {
            buttonDisable = false;
        }
    }
    
    public PageReference returnCase() {
    
        if(caseRecord != null && caseRecord.GEMS_Return_Reason__c == null) {
            ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please select Reject Reason');
            ApexPages.addMessage(myMsg);    
            combineFlag = true;                
            return null;
        }
        if(caseRecord != null && caseRecord.GEMS_Return_Reason__c.contains('ASO Billing/BlueSTAR Issue')) {
            CaseTeamMember  specialist = [select parentId,memberid,TeamRole.name from caseteammember where parentId =: caseRecord.GEMS_Account_Submission_Info__c and TeamRole.name = 'Account Specialist'];
            if(specialist != null) {
                caseRecord.ownerId = specialist.memberId;
            }else {
                caseRecord.ownerId = caseRecord.GEMS_Account_Submission_Info__r.ownerId;
            }
            caseRecord.status='Return';           
        }
         update caseRecord;
        return null;
    
    }
    
    public void approveDummy() {
        
    }
        
    public pagereference updateTasksToApprove() {
    
        Boolean b11 = Boolean.valueOf(Apexpages.currentPage().getParameters().get('firstRecParam1'));
        Boolean b12 = Boolean.valueOf(Apexpages.currentPage().getParameters().get('firstRecParam2'));
        Boolean b2 = Boolean.valueOf(Apexpages.currentPage().getParameters().get('secondParam'));
        Boolean b31 = Boolean.valueOf(Apexpages.currentPage().getParameters().get('thirdRecParam1'));
        Boolean b32 = Boolean.valueOf(Apexpages.currentPage().getParameters().get('thirdRecParam2'));
        taskList[0].GEMS_UnderWriting_Yes_No__c = b11;
        taskList[0].GEMS_UnderWriting_N_A__c= b12;
        taskList[1].GEMS_UnderWriting_Yes_No__c = b2;
        taskList[2].GEMS_UnderWriting_Yes_No__c = b31;
        taskList[2].GEMS_UnderWriting_N_A__c= b32;
        System.debug('==check values='+b11+b12+b2+b31+b32);
        List<Task> updatingTaskList = new List<Task>();
        Set<String> divisionsSet = new Set<String>{'IL','MT','NM','OK','TX'};
        try {
        /* SFDC - 5155 Removed validation on Signed 2017 BPA attached check box 
        if(caseRecord.RecordType.Name != 'GEMS Dental Underwriting' && (((divisionsSet.contains(caseRecord.HCSC_Division__c) && caseRecord.Funding_Type_Multiselect__c != null && 
        caseRecord.Funding_Type_Multiselect__c.contains('ASO') &&  caseRecord.GEMS_Rx_Vendor__c != null && 
        caseRecord.GEMS_Rx_Vendor__c.contains('Prime'))|| (caseRecord.HCSC_Division__c == 'IL' && caseRecord.Funding_Type_Multiselect__c != null && 
        caseRecord.Funding_Type_Multiselect__c.contains('Cost Plus') &&  caseRecord.GEMS_Rx_Vendor__c != null && caseRecord.GEMS_Rx_Vendor__c.contains('Prime'))) ))
        {
            if(caseRecord.GEMS_XAccountHas_signed_2017BPA_attached__c == '' || caseRecord.GEMS_XAccountHas_signed_2017BPA_attached__c == null)
            {
                ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Please select Appropriate signed 2017 BPA attached?');
                ApexPages.addMessage(myMsg);
                errorFlag = true;
                errorCheck = true;
                return null;
            }
        }
        */
        if(!errorFlag)
        {
            for(Task taskk : taskList) 
            {
                 taskk.status = 'Approved';
                 taskk.GEMS_End_Date__c = System.now();
                 updatingTaskList.add(taskk);
            }
        
            if(!updatingTaskList.isEmpty()) 
            {
                update taskList;
                
                caseRecord.status='Approved';
                update caseRecord;
                
            }
        }
        
        }
        catch(exception ex) {
        errorCheck = true;
        errorMsg  = ex.getMessage();
        System.debug('=exception=='+ex.getMessage());
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
        ApexPages.addmessage(myMsg);
        //return null;
        }
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return null;
    }
    
}