/**************************************************************************************
* Apex Class Name       : GEMS_IDCardSuppressionBAAssignCntlr
* Version               : 1.0
* Function              : This Class is for assigning BA to ID card supression
* Modification Log      :
* Developer           Date                   Description
* ------------------------------------------------------------------------------------
* Malathi K           09/16/2016             New Apex class called in VF Page GEMSIDCardSuppressionBAAssignment.
* Phani Kommareddy    06/12/2017             SFDC-3064 Change how BAs are associated to Custom ID Card, Prospective and Suppression requests
* Phani Kommareddy    09/13/2017             SFDC-4483 GEMS - Ability to request ID Card Suppression/Unsuppression by Group Section
* Phani Kommareddy    11/27/2017             SFDC-6369 GEMS - ID Card Maintenance: ID Card Case Page Layout & Functionality
* Phani Kommareddy	  02/19/2017			 SFDC-4244 GEMS: Acct Structure - Special Handling of Complex/Co-op Accounts (Downstream Processing)
*************************************************************************************/
public with sharing class GEMS_IDCardSuppressionBAAssignCntlr {
    public Id caseId {get; set;}
    public Case parentIdCardCase {get; set;}
    public Id suppressionRecId{get;set;}
    public GEMS_ID_Card_Suppression__c idCardSuppressionRecord{get;set;}
    public List<GEMS_Benefit_Agreement__c> benefitAgreementsList{set;get;}
    public List<GEMS_BAIdWrapper> listOfBARecords{get; set;}
    public List<GEMS_GSIdWrapper> listOfGSRecords{get; set;}
    public String baCaseNums{set;get;}
    public String gsCaseNums{set;get;}
    public boolean disableSubmitButton{set;get;}
    public List<Case> structureBAs{get;set;}
    public String assignmentType = 'Benefit Agreement';
    
    public GEMS_IDCardSuppressionBAAssignCntlr(ApexPages.StandardController controller) {
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        suppressionRecId = ApexPages.currentPage().getParameters().get('id');
        Id caseAccountStructureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        if(caseId!=null) {
            disableSubmitButton = true;
            parentIdCardCase = [SELECT Id, CaseNumber, HCSC_Division__c, GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, 
                            GEMS_Line_of_Business__c, GEMS_Account_Submission_Info__c, Market_Segment__c, Status, Owner.Name, GEMS_Type__c,
                            Account.AccountNumber, Account.External_ID__c, Account.Name,Gems_Assigned_BAs__c
                            FROM Case WHERE id =: caseId];
                            
            idCardSuppressionRecord = new GEMS_ID_Card_Suppression__c();
            idCardSuppressionRecord.Parent_ID_Card_Case__c=caseId;
            idCardSuppressionRecord.OwnerID=parentIdCardCase.OwnerId;
            idCardSuppressionRecord.Actual_Owner__c=parentIdCardCase.OwnerId;
        } else if(suppressionRecId != null) {
           idCardSuppressionRecord = [SELECT ID, Name, Parent_ID_Card_Case__c, ID_card_Requested_date__c, Status__c,ownerid,Actual_Owner__c,
                                   Applicable_BAs__c,Applicable_GSs__c,Assignment_Type__c,ID_Card_Suppression_Date__c,Removal_of_ID_Card_Suppression_Date__c,Suppression_Removal_Requested_Date__c 
                                   FROM GEMS_ID_Card_Suppression__c WHERE ID=:suppressionRecId];
                                
            parentIdCardCase = [SELECT Id, CaseNumber, HCSC_Division__c, GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, 
                            GEMS_Line_of_Business__c, GEMS_Account_Submission_Info__c, Market_Segment__c, Status, Owner.Name, GEMS_Type__c,
                            Account.AccountNumber, Account.External_ID__c, Account.Name,Gems_Assigned_BAs__c
                            FROM Case WHERE id =: idCardSuppressionRecord.Parent_ID_Card_Case__c];
             if(idCardSuppressionRecord.Assignment_Type__c != null && idCardSuppressionRecord.Assignment_Type__c != '') {
                assignmentType = idCardSuppressionRecord.Assignment_Type__c;
            } else {
                assignmentType = 'Benefit Agreement';
            }
        }
        
        
        //SFDC-4244 - Added GEMS_BAs_SpHandling__c condition
        structureBAs = [SELECT id, 
                        (SELECT ID, Name, BA_Description__c, BA_Fund_Type__c, product__r.Name from GEMS_Benefit_Agreements__r where GEMS_BAs_SpHandling__c = true  order by Name),
                        (select name,group_no__c,section_no__c,section_description__c from Group_Sections__r) 
                        FROM Case WHERE RecordTypeId= :caseAccountStructureRecordTypeId AND GEMS_Account_Submission_Info__c= :parentIdCardCase.GEMS_Account_Submission_Info__c  LIMIT 1];
        
        listOfBARecords = new List<GEMS_BAIdWrapper>();
        listOfGSRecords = new List<GEMS_GSIdWrapper>();
        
        if(!structureBAs.isEmpty()){
            Case baCase = structureBAs.get(0);
            List<GEMS_Benefit_Agreement__c> baList = new List<GEMS_Benefit_Agreement__c>();
            baList = baCase.GEMS_Benefit_Agreements__r;
            for(GEMS_Benefit_Agreement__c ba: baList) {
                listOfBARecords.add(new GEMS_BAIdWrapper(false, ba));                
            }
            
            List<GEMS_Group_Section__c> gsList = new List<GEMS_Group_Section__c>();
            gsList = baCase.Group_Sections__r;
            for(GEMS_Group_Section__c gs: gsList) {
                listOfGSRecords.add(new GEMS_GSIdWrapper(false, gs));                
            }
        }     
    }
    
    public PageReference saveAndAssignBAs() {    
      try {
        if(idCardSuppressionRecord.Status__c == null) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select the status.'));
        } else if(idCardSuppressionRecord.Status__c == 'Suppression Completed' && idCardSuppressionRecord.ID_Card_Suppression_Date__c == null) {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter ID Card Suppression Date.'));
        } else if(idCardSuppressionRecord.Status__c == 'Removal of Suppression Completed' && idCardSuppressionRecord.Removal_of_ID_Card_Suppression_Date__c == null){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Removal of ID Card Suppression Date.'));        
        }
        if(idCardSuppressionRecord.Status__c == 'Suppression Completed' || idCardSuppressionRecord.Status__c == 'Removal of Suppression Completed'){          
           idCardSuppressionRecord.ownerid = parentIdCardCase.ownerid;            
           //update idCardSuppressionRecord;           
        }
        idCardSuppressionRecord.Applicable_BAs__c=baCaseNums;
        idCardSuppressionRecord.Applicable_GSs__c=gsCaseNums;
        //SFDC-6369 GEMS - ID Card Maintenance: ID Card Case Page Layout & Functionality
        if(parentIdCardCase.GEMS_Submission_Type__c == GEMS_Constants.SubmissionTypeIDCardMaintenance) {
            if(String.isNotBlank(baCaseNums) && String.isNotBlank(gsCaseNums))
                idCardSuppressionRecord.Assignment_Type__c  = GEMS_Constants.IDCardAssignTypeBoth;
            else if(String.isNotBlank(baCaseNums)) {
                idCardSuppressionRecord.Assignment_Type__c  = GEMS_Constants.IDCardAssignTypeBA;
            } else if(String.isNotBlank(gsCaseNums))  {
                idCardSuppressionRecord.Assignment_Type__c  = GEMS_Constants.IDCardAssignTypeGS;
            } else {
                idCardSuppressionRecord.Assignment_Type__c  = GEMS_Constants.IDCardAssignTypeNone;
            }
        } else {
            idCardSuppressionRecord.Assignment_Type__c  = assignmentType;
        }
        upsert idCardSuppressionRecord;
          
        if(idCardSuppressionRecord.id !=null) {
            suppressionRecId = idCardSuppressionRecord.id;
        }
        //SFDC-6369 GEMS - ID Card Maintenance: ID Card Case Page Layout & Functionality
        if(parentIdCardCase.GEMS_Submission_Type__c != GEMS_Constants.SubmissionTypeIDCardMaintenance) {
            List<GEMS_ID_Card_Suppression__c> suppressionIDCardOfParentIDCard = 
                [Select ID, Applicable_BAs__c,Applicable_GSs__c,Assignment_Type__c from GEMS_ID_Card_Suppression__c where parent_id_card_case__c=:parentIdCardCase.id];
            Map<Id, GEMS_ID_Card_Suppression__c> suppressionIDMap = new Map<Id, GEMS_ID_Card_Suppression__c>();
            for(GEMS_ID_Card_Suppression__c sidForm : suppressionIDCardOfParentIDCard) {
                suppressionIDMap.put(sidForm.id,sidForm);
            }
            List<GEMS_IDCompare> idCompareList = GEMS_IDCardUtil.CopySuppressionIDFormToIDCompare(suppressionIDCardOfParentIDCard);
            GEMS_CustomFormInput customFormInput = new GEMS_CustomFormInput(suppressionRecId,assignmentType,baCaseNums,gsCaseNums,idCompareList);
            List<GEMS_IDCompare> idcompareListUpdated = GEMS_IDCardUtil.updateExistingAssignments(customFormInput);
            List<GEMS_ID_Card_Suppression__c> suppressionIdUpdateList = GEMS_IDCardUtil.copyIDCompareToSuppressionIDForm(idcompareListUpdated, suppressionIDMap);
            update suppressionIdUpdateList; 
        }
        return new pageReference('/'+suppressionRecId); 
      } catch(Exception ex) {
            String msg = ex.getMessage();
            if(msg.contains('Queue not associated')){
                msg = 'Please check the case owner associated to the ID Card';
            } 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));      
            return null;
        }
    }
    
    public PageReference submitIdCardSuppression() {   
        if(idCardSuppressionRecord.Status__c == 'Suppression Completed' && idCardSuppressionRecord.ID_Card_Suppression_Date__c == null) {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter ID Card Suppression Completed Date.'));
        } else if(idCardSuppressionRecord.Status__c == 'Removal of Suppression Completed' && idCardSuppressionRecord.Removal_of_ID_Card_Suppression_Date__c == null){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Suppression Removal Completed Date.'));        
        }                  
        if(idCardSuppressionRecord.Status__c=='Request for Suppression') {            
            CaseTeamMember caseTemMem = [SELECT Id, memberid, TeamRole.name FROM CaseTeamMember WHERE ParentId =: parentIdCardCase.GEMS_Account_Submission_Info__c AND TeamRole.name = 'Account Specialist'];
            idCardSuppressionRecord.OwnerId=caseTemMem.memberid;
        } else if(idCardSuppressionRecord.Status__c=='Suppression Completed') {
            User actualOwnerRec = [SELECT ID FROM User WHERE ID=:idCardSuppressionRecord.Actual_Owner__c];
            idCardSuppressionRecord.OwnerId=actualOwnerRec.Id;
        }
        if(idCardSuppressionRecord.Status__c=='Request for Removal Of Suppression') {            
            CaseTeamMember caseTemMem = [SELECT Id, memberid, TeamRole.name FROM CaseTeamMember WHERE ParentId =: parentIdCardCase.GEMS_Account_Submission_Info__c AND TeamRole.name = 'Account Specialist'];
            idCardSuppressionRecord.OwnerId=caseTemMem.memberid;
        } else if(idCardSuppressionRecord.Status__c=='Removal Of Suppression Completed') {
            User actualOwnerRec = [SELECT ID FROM User WHERE ID=:idCardSuppressionRecord.Actual_Owner__c];
            idCardSuppressionRecord.OwnerId=actualOwnerRec.Id;
        }
        update idCardSuppressionRecord; 
        return null;
    }
    

    
    public PageReference gotoCase() {
        Id returnId;
        if(caseId!=null) {
            returnId=caseId;
        } else {
            returnId=parentIdCardCase.Id;
        }
        return new PageReference('/'+returnId);
    }
    
    public void dummy() {
       
    }
    
    public String getAssignmentType() {
        return assignmentType;
    }
    
    public void setAssignmentType(String assignmentType) {
        this.assignmentType = assignmentType;
    }
    
    public List<SelectOption> getAssignmentItems() {
        return GEMS_IDCardUtil.getAssignmentItems();    
    }
}