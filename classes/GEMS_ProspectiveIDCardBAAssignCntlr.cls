/**************************************************************************************
* Apex Class Name       : GEMS_ProspectiveIDCardBAAssignCntlr
* Version               : 1.0
* Function              : This Class is for assigning Prospective ID Card record to ID Card Child Case under Selected BA(For GEMS Project).
* Modification Log      :
* Developer           Date                  Description
* ------------------------------------------------------------------------------------
* Praveen             06/10/2016            Original Version
* Mark Naumann        08/15/2016            remove two fields: ID_Card_Suppression_Date__c & Removal_of_ID_Card_Suppression_Date__c
* Phani Kommareddy    06/12/2017            SFDC-3064 Change how BAs are associated to Custom ID Card, Prospective and Suppression requests
* Phani Kommareddy    09/13/2017            SFDC-2835 GEMS - Ability to request ID Card Prospective by Group Section
* Phani Kommareddy    11/27/2017            SFDC-6369 GEMS - ID Card Maintenance: ID Card Case Page Layout & Functionality
* Phani Kommareddy	  02/19/2017			SFDC-4244 GEMS: Acct Structure - Special Handling of Complex/Co-op Accounts (Downstream Processing)
*************************************************************************************/

public without sharing class GEMS_ProspectiveIDCardBAAssignCntlr {
    public Id caseId {get; set;}
    public Case parentIdCardCase {get; set;}
    public Id prospectiveRecId{get;set;}
    public GEMS_Prospective_ID_Card__c prospectiveRec{get;set;}
    public List<GEMS_Benefit_Agreement__c> benefitAgreementsList{set;get;}
    public List<Case> structureBAs{get;set;}
    public String assignmentType = 'Benefit Agreement';
    public List<GEMS_BAIdWrapper> listOfBARecords{get; set;}
    public List<GEMS_GSIdWrapper> listOfGSRecords{get; set;}
    public String baCaseNums{set;get;}    
    public String gsCaseNums{set;get;}    
    public boolean disableSubmitButton{set;get;}
    
    public GEMS_ProspectiveIDCardBAAssignCntlr(ApexPages.StandardController controller) {
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        prospectiveRecId = ApexPages.currentPage().getParameters().get('id');
        Id caseAccountStructureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Id  balevelIdCardCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level ID Card').getRecordTypeId();
        if(caseId!=null) {
            disableSubmitButton = true;
            parentIdCardCase = [SELECT Id, CaseNumber, HCSC_Division__c, GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, 
                                GEMS_Line_of_Business__c, GEMS_Account_Submission_Info__c, Market_Segment__c, Status, Owner.Name, GEMS_Type__c, OwnerId,
                                Account.AccountNumber, Account.External_ID__c, Account.Name,Gems_Assigned_BAs__c
                                FROM Case WHERE id =: caseId];
            prospectiveRec = new GEMS_Prospective_ID_Card__c();
            prospectiveRec.Parent_ID_Card_Case__c=caseId;
            prospectiveRec.OwnerID=parentIdCardCase.OwnerId;
            prospectiveRec.Actual_Owner__c=parentIdCardCase.OwnerId;            
        } else if(prospectiveRecId!=null) {
            prospectiveRec = [SELECT ID, Name, ID_Card_Mailed__c, Parent_ID_Card_Case__c, Prospective_ID_card_Requested_date__c,
                              Prospective_ID_sent_for_approval_date__c, ID_Card_Mailed_Date__c,Prospective_ID_Card_Approved__c,Actual_Owner__c,
                              Prospective_ID_Card_Approved_Date__c, Status__c, Account_Setup_OSS_User__c,ownerid, Applicable_BAs__c,Applicable_GSs__c,Assignment_Type__c 
                              FROM GEMS_Prospective_ID_Card__c WHERE ID=:prospectiveRecId];
            
            parentIdCardCase = [SELECT Id, CaseNumber, HCSC_Division__c, GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, 
                                GEMS_Line_of_Business__c, GEMS_Account_Submission_Info__c, Market_Segment__c, Status, Owner.Name, GEMS_Type__c,
                                Account.AccountNumber, Account.External_ID__c, Account.Name,Gems_Assigned_BAs__c, OwnerId
                                FROM Case WHERE id =: prospectiveRec.Parent_ID_Card_Case__c];
            if(prospectiveRec.Assignment_Type__c != null && prospectiveRec.Assignment_Type__c != '') {
                assignmentType = prospectiveRec.Assignment_Type__c;
            } else {
                assignmentType = 'Benefit Agreement';
            }
        }
        
        
        //SFDC-4244 - Added GEMS_BAs_SpHandling__c condition
        structureBAs = [SELECT id, 
                        (SELECT ID, Name, BA_Description__c, BA_Fund_Type__c, product__r.Name from GEMS_Benefit_Agreements__r where GEMS_BAs_SpHandling__c = true  order by Name),
                        (select name,group_no__c,section_no__c,section_description__c from Group_Sections__r) 
                        FROM Case WHERE RecordTypeId= :caseAccountStructureRecordTypeId AND GEMS_Account_Submission_Info__c= :parentIdCardCase.GEMS_Account_Submission_Info__c LIMIT 1];
        
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
    
    public List<SelectOption> getAssignmentItems() {
        return GEMS_IDCardUtil.getAssignmentItems();    
    }
    
    
    public PageReference saveAndAssignBAs() {
        try {
            prospectiveRec.Applicable_BAs__c=baCaseNums;
            prospectiveRec.Applicable_GSs__c=gsCaseNums;
            //SFDC-6369 GEMS - ID Card Maintenance: ID Card Case Page Layout & Functionality
            if(parentIdCardCase.GEMS_Submission_Type__c == GEMS_Constants.SubmissionTypeIDCardMaintenance) {
                if(String.isNotBlank(baCaseNums) && String.isNotBlank(gsCaseNums))
                    prospectiveRec.Assignment_Type__c = GEMS_Constants.IDCardAssignTypeBoth;
                else if(String.isNotBlank(baCaseNums)) {
                    prospectiveRec.Assignment_Type__c = GEMS_Constants.IDCardAssignTypeBA;
                } else if(String.isNotBlank(gsCaseNums))  {
                    prospectiveRec.Assignment_Type__c = GEMS_Constants.IDCardAssignTypeGS;
                } else {
                    prospectiveRec.Assignment_Type__c = GEMS_Constants.IDCardAssignTypeNone;
                }
            } else {
                prospectiveRec.Assignment_Type__c   = assignmentType;
            }
            upsert prospectiveRec;
            
            if(prospectiveRec.id !=null) {
                prospectiveRecId = prospectiveRec.id;
            }
            //SFDC-6369 GEMS - ID Card Maintenance: ID Card Case Page Layout & Functionality
            if(parentIdCardCase.GEMS_Submission_Type__c != GEMS_Constants.SubmissionTypeIDCardMaintenance) {
                List<GEMS_Prospective_ID_Card__c> prospectiveIDCardOfParentIDCard =
                    [Select ID, Applicable_BAs__c,Applicable_GSs__c,Assignment_Type__c from GEMS_Prospective_ID_Card__c where Parent_ID_Card_Case__c=:parentIdCardCase.id];
                Map<Id, GEMS_Prospective_ID_Card__c> prospectiveIDMap = new Map<Id, GEMS_Prospective_ID_Card__c>();
                for(GEMS_Prospective_ID_Card__c pidForm : prospectiveIDCardOfParentIDCard) {
                    prospectiveIDMap.put(pidForm.id,pidForm);
                }
                
                List<GEMS_IDCompare> idCompareList = GEMS_IDCardUtil.CopyProspectiveIDFormToIDCompare(prospectiveIDCardOfParentIDCard);
                GEMS_CustomFormInput customFormInput = new GEMS_CustomFormInput(prospectiveRecId,assignmentType,baCaseNums,gsCaseNums,idCompareList);
                List<GEMS_IDCompare> idcompareListUpdated = GEMS_IDCardUtil.updateExistingAssignments(customFormInput);
                List<GEMS_Prospective_ID_Card__c> prospectiveIdUpdateList = GEMS_IDCardUtil.copyIDCompareToProspectiveIDForm(idcompareListUpdated, prospectiveIDMap);
                update prospectiveIdUpdateList; 
            }
            return new pageReference('/'+prospectiveRecId);   
        } catch(Exception ex) {
            String msg = ex.getMessage();
            if(msg.contains('Queue not associated')){
                msg = 'Please check the case owner associated to the ID Card';
            } 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));      
            return null;
        }

    }
    
    
    
    public PageReference submitProspectiveIdCard() {
        if(prospectiveRec.Status__c=='Request for prospective ID'){
            CaseTeamMember caseTemMem = [SELECT Id, memberid, TeamRole.name FROM CaseTeamMember WHERE ParentId =: parentIdCardCase.GEMS_Account_Submission_Info__c AND TeamRole.name = 'Account Specialist'];
            prospectiveRec.OwnerId=caseTemMem.memberid;
        } else if(prospectiveRec.Status__c=='Prospective ID Card Completed') {
            User actualOwnerRec = [SELECT ID FROM User WHERE ID=:prospectiveRec.Actual_Owner__c];
            prospectiveRec.OwnerId=actualOwnerRec.Id;
        }
        update prospectiveRec;
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
}