//************************************************************************************
// Name             : GEMS_ScreeningCaseController.cls
// Description      : This class will create screening case
// Created By       : Thimmannagari Siva/Bala
// Created Date     : 7/29/2016
// 
// ************************Version Updates********************************************
// Date             Developer           Description
//09/11/2017          Gokul Bharati          SFDC-5880-GEMS: Pre-Populate Quality/QAI Reviewer and BlueSTAR Walkthrough Account Mgmt/GET on ASP Case for Account Structure Maintenance
// -----------------------------------------------------------------------------------
// ************************************************************************************

global class GEMS_ScreeningCaseController {
    //GEMS_ScreeningCaseController() {}
    /*public List<GEMS_Standard_Product_Cases_Creation__mdt> standardProductCasesCreationMetaDataList = [ SELECT Is_Active__c, Is_Standard_product__c, Create_ID_Card_Cases__c,
                                                 Create_Manual_Eligibility_Cases__c, Create_Eligibility_Process_Cases__c,
                                                 Create_Account_Setup_Cases__c, Create_Underwriting_Cases__c
                                                 FROM GEMS_Standard_Product_Cases_Creation__mdt
                                                 WHERE Is_Active__c = true LIMIT 1
                                                ];*/
    
    /******************************************************************** 
    *    Method Name : validatedocCheckToCreateScreening
    Action
    *   @description :   This method to create screening cases
    *   @parameters  :   String caseID
    *   @return type :   String
    ***************************************************************/  
   /* webservice static String validatedocCheckToCreateScreening(String caseID, Boolean userInput){  
        String returnString = '';  
        try {            
            Id caseBAScreeningCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
            Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();       
            Id accStructCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
            
            List<Case> screeningCasesNeedsToCreate = new List<Case>();
            Set<String> recordTypeIdsSet = new Set<String>{caseBAScreeningCaseRecordTypeId,accStructCaseRecordTypeId};
                
            
            List<Case> structureCaseList = new List<Case>();
            
            List<Case> submissionRecList = new List<Case>();
            Case accSubCaseRec = [select id,OwnerId,GEMS_Additional_Medical_Underwriter__c,GEMS_Is_CBSR_required__c,GEMS_Products__c,account.name,GEMS_Submission_Type__c,
                                  GEMS_Submission_Sub_Type__c ,GEMS_Line_of_Business__c ,GEMS_Benefit_Booklet_Required__c,GEMS_Effective_Date__c,GEMS_BCC_Products__c,
                                  Account.External_ID__c,type,FSU_Location__c,Account_Executive__c,HCSC_Division__c,GEMS_Rx_Vendor__c,GEMS_StdCust_Product__c,
                                  GEMS_Medical_Underwriter__c,Sales_Executive__c,Productid,status,GEMS_Case_Effective_Date__c,Opportunity_Name__c,Funding_Type__c,
                                  Funding_Type_Multiselect__c,GEMS_AEP_Account__c,GEMS_All_required_documents_attached__c ,GEMS_Integrated__c,GEMS_Grandfathered_benefits__c,GEMS_Bank__c,
                                  GEMS_Performance_Guarantees__c,GEMS_Ready_to_release_to_screening__c,(select Attachment__c,Description__c,Type__c from GEMS_Attachments__r),
                                  (select id, casenumber,Status,recordTypeId, GEMS_Effective_Date__c, GEMS_Case_Effective_Date__c, GEMS_Account_Submission_Info__c,
                                   Accountid, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, HCSC_Division__c, GEMS_Line_of_Business__c, Opportunity_Name__c,
                                   Funding_Type_Multiselect__c, parentId from Cases1__r where recordtypeid In : recordTypeIdsSet )                
                                  FROM case WHERE Id =:caseID and recordtypeid=:caseAccountSubmissionId
                                 ];
            if(accSubCaseRec != null ) {
                submissionRecList.add(accSubCaseRec);    
                Case accStructCase = null;
                Boolean screeningsAlreadyExists = false;
                List<Case> screeningStructureCases = accSubCaseRec.Cases1__r;
                for(Case screeningORstructure : screeningStructureCases) {
                    if(screeningORstructure.recordTypeId == accStructCaseRecordTypeId ) {
                        accStructCase = screeningORstructure;
                    }
                    if(screeningORstructure.recordTypeId == caseBAScreeningCaseRecordTypeId) {
                        screeningsAlreadyExists = true;
                        break;
                    }
                }
                screeningCasesNeedsToCreate.add(accSubCaseRec);
                if(accStructCase != null && (accStructCase.status =='Client Approval Received' || accStructCase.status == 'BlueSTAR Sent' || accStructCase.status == 'BlueSTAR Shell Created' 
                 || accStructCase.status == 'BlueSTAR Failed' || accStructCase.status == 'BlueSTAR Partial Fail')){
                     
                 }else {
                     returnString = returnString+'Structure case status should be Client Approval Received to create screening';
                 }
                 
                 if(accSubCaseRec.GEMS_All_required_documents_attached__c && returnString == '') {
                     structureCaseList.add(accStructCase);
                     if(!screeningsAlreadyExists) {
                         if(userInput) {
                             GEMS_ScreeningCaseController.SCFutureClass scClass = new GEMS_ScreeningCaseController.SCFutureClass();
                             scClass.screeningCasesNeedsToCreate = screeningCasesNeedsToCreate;
                             scClass.accStructCase = accStructCase;
                             scClass.structureCaseList = structureCaseList;
                             GEMS_ScreeningCaseController.createScreeningCasesFuture(JSON.serializePretty(scClass));
                             return 'Screening cases creation is in progress';
                         }else {
                             return 'Are you sure you want to release this case to Screening ?';
                         }
                         
                     }else {
                         return 'Screening cases already created';
                     }                       
                 }else {
                     String reqDocs = checkRequiredDocuments(submissionRecList);
                     returnString = returnString+'\n'+reqDocs;
                 }
            }
        }
        catch(Exception ex) {
            System.debug('Exception'+ex.getMessage());
        }
        if(returnString == '' && returnString.length() == 0) {
            returnString = null;
        }
        return returnString;
    }
    
    */
    /*public class SCFutureClass{
        public List<Case> screeningCasesNeedsToCreate = new list<case>();
        public Case accStructCase = new Case();
        public List<Case> structureCaseList = new List<case>();
    }
    
    @future
    public static void createScreeningCasesFuture(string scclass) {
        
        GEMS_ScreeningCaseController.SCFutureClass hl = (GEMS_ScreeningCaseController.SCFutureClass) JSON.deserialize(scclass, GEMS_ScreeningCaseController.SCFutureClass.class);
        
        try {
            createScreeningCases(hl.screeningCasesNeedsToCreate, hl.accStructCase, hl.structureCaseList);
        } catch (Exception e) {
            System.debug('Error in JSON deserialization');
        }
        
    }*/
    
/******************************************************************** 
*    Method Name : createScreeningCases
Action
*   @description :   This method to create screening cases in future
*   @parameters  :   (List<Case> screeningCasesNeedsToCreate, Case accStructCase, List<Case> structureCaseList)
*   @return type :   void
***************************************************************/
   /* public static void createScreeningCases(List<Case> screeningCasesNeedsToCreate, Case accStructCase, List<Case> structureCaseList) {
        Map<String,List<Case>> screeningCasesMap = new Map<String,List<Case>>();
        List<Case> screeningCasesInsertList = new List<Case>();
        Id caseBAScreeningCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        try {
        //screeningCasesMap = GEMS_AccountScreeningCaseCreation.screeningCasesCreation(screeningCasesNeedsToCreate);
        }catch(Exception e) {
            System.debug('=====>'+e);
            System.debug('=====>'+e.getMessage());
        }
        Map<Id,List<GEMS_Benefit_Agreement__c>> subCaseIdBenfAggListMap = new Map<Id,List<GEMS_Benefit_Agreement__c>>();
        Map<ID,List<GEMS_Benefit_Agreement__c>> caseIdAndBenefitAgreementMap = new Map<ID,List<GEMS_Benefit_Agreement__c>>();
        
        List<GEMS_Benefit_Agreement__c> benefitAgreementList = [SELECT ID, Name, AccountStructureCase__c,
                                                                 AccountStructureCase__r.account.name,
                                                                 AccountStructureCase__r.Account.External_ID__c,
                                                                 AccountStructureCase__r.GEMS_Account_Submission_Info__c,
                                                                 AccountStructureCase__r.GEMS_Account_Submission_Info__r.OwnerId,
                                                                 AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c,
                                                                 Product__c, Product__r.name from GEMS_Benefit_Agreement__c where AccountStructureCase__c=: accStructCase.Id and IsCancelled__c = false];
         
         for(GEMS_Benefit_Agreement__c benefitAggRecord: benefitAgreementList) {
             if(String.isNotBlank(benefitAggRecord.AccountStructureCase__c)) {
                 if(!caseIdAndBenefitAgreementMap.containsKey(benefitAggRecord.AccountStructureCase__c)) {
                     caseIdAndBenefitAgreementMap.put(benefitAggRecord.AccountStructureCase__c, new List<GEMS_Benefit_Agreement__c>());
                 }
                 caseIdAndBenefitAgreementMap.get(benefitAggRecord.AccountStructureCase__c).add(benefitAggRecord);
             }
         }
         
         for(GEMS_Benefit_Agreement__c benefitAggRecord: benefitAgreementList) {
             if(String.isNotBlank(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c)) {
                 if(!subCaseIdBenfAggListMap.containsKey(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c)) {
                     subCaseIdBenfAggListMap.put(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c, new List<GEMS_Benefit_Agreement__c>());
                 }
                 subCaseIdBenfAggListMap.get(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c).add(benefitAggRecord);
             }
         }
         createIdCardParentChildCase(structureCaseList, subCaseIdBenfAggListMap);
        createSBCParentChildCase(structureCaseList, subCaseIdBenfAggListMap);
         for(Case caseRecord : structureCaseList) {
             List<Case> businessAreaCaseList = screeningCasesMap.get(caseRecord.parentId);
             if( !businessAreaCaseList.isEmpty()) {
                 for(Case businessAreacase : businessAreaCaseList) {
                     List<GEMS_Benefit_Agreement__c> businessAggrements = caseIdAndBenefitAgreementMap.get(caseRecord.Id);
                     if( !businessAggrements.isEmpty()) {
                         for(GEMS_Benefit_Agreement__c befAgrRec: businessAggrements) {
                             Case screeningCase = new Case();
                             DateTime effectiveDate = caseRecord.GEMS_Effective_Date__c;
                             System.debug('businessAreacase.id=====>'+businessAreacase.id);
                             screeningCase.GEMS_Account_Submission_Info__c = caseRecord.GEMS_Account_Submission_Info__c;
                             screeningCase.parentId = businessAreacase.id;
                             screeningCase.GEMS_Benefit_Agreement__c = befAgrRec.Id;
                             screeningCase.Accountid=caseRecord.Accountid;
                             screeningCase.GEMS_Case_Effective_Date__c=caseRecord.GEMS_Case_Effective_Date__c;
                             screeningCase.GEMS_Effective_Date__c=caseRecord.GEMS_Effective_Date__c;
                             screeningCase.GEMS_Submission_Type__c=caseRecord.GEMS_Submission_Type__c;
                             screeningCase.GEMS_Submission_Sub_Type__c=caseRecord.GEMS_Submission_Sub_Type__c;
                             //screeningCase.Subject= accountname + ' ' +befAgrRec.Name+' '+ befAgrRec.Product__r.name+ ' BA Level '+ businessAreacase.Type;
                             //screeningCase.Subject= befAgrRec.AccountStructureCase__r.account.name + ' ' +befAgrRec.AccountStructureCase__r.Account.External_ID__c+' - '+befAgrRec.Name+ ' '+ businessAreacase.Sub_Category__c+' - '+effectiveDate.format('M/d/yyyy'); // Active
                             //screeningCase.Subject= befAgrRec.AccountStructureCase__r.account.name + ' ' +befAgrRec.AccountStructureCase__r.Account.External_ID__c+' - '+befAgrRec.Name+' - '+effectiveDate.format('M/d/yyyy'); // Praveen Added
                             //screeningCase.Subject= befAgrRec.AccountStructureCase__r.account.name + ' ' +befAgrRec.AccountStructureCase__r.Account.External_ID__c+' '+effectiveDate.format('M/d/yyyy')+' '+befAgrRec.Name;
                             screeningCase.Subject= befAgrRec.AccountStructureCase__r.account.name + ' ' +befAgrRec.AccountStructureCase__r.Account.External_ID__c+' '+effectiveDate.format('M/d/yyyy')+' '+businessAreacase.Sub_Category__c;
                             screeningCase.status='In Progress';
                             screeningCase.HCSC_Division__c=businessAreacase.HCSC_Division__c;
                             screeningCase.Opportunity_Name__c = businessAreacase.Opportunity_Name__c;
                             //screeningCase.type=caseRecord.type; <BA#>-BA Level Screening
                             //screeningCase.type=befAgrRec.Name +' BA'+ businessAreacase.Type;
                             screeningCase.type='Screening';
                             screeningCase.Sub_Category__c = businessAreacase.Sub_Category__c;
                             screeningCase.recordTypeId=caseBAScreeningCaseRecordTypeId;
                             screeningCase.GEMS_Medical_Underwriter__c=businessAreacase.GEMS_Medical_Underwriter__c;
                             screeningCase.Sales_Executive__c=businessAreacase.Sales_Executive__c;
                             screeningCase.Productid=businessAreacase.Productid;
                             screeningCase.FSU_Location__c=businessAreacase.FSU_Location__c;
                             screeningCase.GEMS_Products__c=businessAreacase.GEMS_Products__c;
                            
                             screeningCase.Account_Executive__c=businessAreacase.Account_Executive__c;
                             System.debug(' businessAreacase.ownerId===>'+ businessAreacase.ownerId);
                             if( businessAreacase.ownerId != null) 
                                 screeningCase.ownerId = businessAreacase.ownerId;
                             screeningCasesInsertList.add(screeningCase);
                         }
                     }
                 }
             }
         }
         
         if(!screeningCasesInsertList.isEmpty()) {
             insert screeningCasesInsertList;                                                             
         }
         if(!screeningCasesNeedsToCreate.isEmpty()) {
             screeningCasesNeedsToCreate.get(0).GEMS_Ready_to_release_to_screening__c = 'Released to screening';
             update screeningCasesNeedsToCreate;
         }
    }*/
    
    /******************************************************************** 
    *    Method Name : createIdCardParentChildCase
    Action
    *   @description :   This method to create parent child ID card cases
    *   @parameters  :   List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap
    *   @return type :   void
    ***************************************************************/
   /* public static void createIdCardParentChildCase(List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap) {
        List<Case> custIdParentCasesInsertList = new List<Case>();
        List<Case> custIdChildCasesInsertList = new List<Case>();
        try {
        Id customIdCardParentRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Id customIdCardChildRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level ID Card').getRecordTypeId();
        
        Set<ID> subCaseIdsSet = new Set<ID>();
        subCaseIdsSet=subIdListBenfMap.keySet();*/
        
        //List<Case> subCaseChildCasesList = [SELECT ID, GEMS_Account_Submission_Info__c,RecordTypeId from Case WHERE GEMS_Account_Submission_Info__c IN: subCaseIdsSet];
        /* --------------- */
      /*  List<GEMS_CaseOwnership_MetaData__mdt> caseOwnerMetadata = [select Case_Team_Member__c,Que_Name__c from GEMS_CaseOwnership_MetaData__mdt where Type_Of_Case__c ='ID Card' ];
        List<case> subCaseRecChildIDCardCasesList = [select id, Status, recordtypeid, GEMS_Accum_Type__c,GEMS_BCC_Products__c, 
                                                     GEMS_Account_Submission_Info__c, GEMS_Case_Effective_Date__c,Account_Number__c,
                                                     FSU_Location__c,GEMS_AEP_Account__c,Opportunity_Name__c,GEMS_Products__c,
                                                     GEMS_Line_of_Business__c,HCSC_Division__c,Account_Name__c,
                                                     GEMS_Submission_Sub_Type__c,Accountid,GEMS_Effective_Date__c,GEMS_Submission_Type__c ,
                                                     (select id,RecordTypeId,status, GEMS_Account_Submission_Info__c 
                                                      from Cases1__r where recordtypeid  =:customIdCardParentRecordTypeId),
                                                     (select parentId,memberid,TeamRole.name from TeamMembers
                                                      where TeamRole.name =: caseOwnerMetadata[0].Case_Team_Member__c)
                                                     from case where id = :subCaseIdsSet];
        
        Map<Id,Boolean> subCaseIdIDCardRecFoundMap = new Map<Id,Boolean>();
        
        Map<Id, caseTeamMember> subIdAccSpecialistMemberMap = new Map<Id, caseTeamMember>();
        Group accSpecGroup =[select Id from Group where Name =: caseOwnerMetadata[0].Que_Name__c and Type = 'Queue' LIMIT 1];
        
        Boolean IDCardRecFound = false;
        
        if(!subCaseRecChildIDCardCasesList.isEmpty() && subCaseRecChildIDCardCasesList != null) 
        {
            for(case subCaseRec : subCaseRecChildIDCardCasesList) 
            {
                List<Case> tempCaseList = new List<Case>();
                tempCaseList=subCaseRec.Cases1__r;
                if(!subCaseRec.TeamMembers.isEmpty())
                {
                    subIdAccSpecialistMemberMap.put(subCaseRec.Id,subCaseRec.TeamMembers[0]);
                }
                if(tempCaseList.Size()>0)
                {
                    IDCardRecFound=true;
                    subCaseIdIDCardRecFoundMap.put(subCaseRec.Id,IDCardRecFound);
                    break;
                }
                else
                {
                    IDCardRecFound=false;
                    subCaseIdIDCardRecFoundMap.put(subCaseRec.Id,IDCardRecFound);
                }
            }
            
        }
        
        for(Case strCaseRec: clientApprovalReceivedCasesList) {
            Boolean IDCardCaseRecFound = subCaseIdIDCardRecFoundMap.get(strCaseRec.GEMS_Account_Submission_Info__c);
            if(!IDCardCaseRecFound) {
                List<GEMS_Benefit_Agreement__c> benfAggList = subIdListBenfMap.get(strCaseRec.GEMS_Account_Submission_Info__c);
                DateTime effectiveDate = strCaseRec.GEMS_Effective_Date__c;
                Case parentIdCase = new Case();
                parentIdCase.recordTypeId =customIdCardParentRecordTypeId;*/
                /*
                if(subIdAccSpecialistMemberMap.get(strCaseRec.GEMS_Account_Submission_Info__c)!=null)
                {
                    parentIdCase.ownerId=subIdAccSpecialistMemberMap.get(strCaseRec.GEMS_Account_Submission_Info__c).memberid;
                }
                */
                /*if(benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.OwnerId != null)
                {
                    parentIdCase.ownerId=benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.OwnerId;
                }
                else
                {
                    parentIdCase.ownerId=accSpecGroup.Id;
                }
                parentIdCase.Subject=benfAggList[0].AccountStructureCase__r.Account.Name+' '+ benfAggList[0].AccountStructureCase__r.Account.External_ID__c +' '+effectiveDate.format('M/d/yyyy')+' ID Card';
                parentIdCase.GEMS_Account_Submission_Info__c=strCaseRec.GEMS_Account_Submission_Info__c;
                parentIdCase.Accountid = strCaseRec.Accountid;
                parentIdCase.GEMS_Effective_Date__c=strCaseRec.GEMS_Effective_Date__c;
                parentIdCase.GEMS_Case_Effective_Date__c=strCaseRec.GEMS_Case_Effective_Date__c;
                parentIdCase.GEMS_Submission_Type__c=strCaseRec.GEMS_Submission_Type__c;
                parentIdCase.GEMS_Submission_Sub_Type__c=strCaseRec.GEMS_Submission_Sub_Type__c;
                parentIdCase.FSU_Location__c=benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c;
                parentIdCase.HCSC_Division__c=strCaseRec.HCSC_Division__c;
                parentIdCase.GEMS_Line_of_Business__c=strCaseRec.GEMS_Line_of_Business__c;
                parentIdCase.Opportunity_Name__c=strCaseRec.Opportunity_Name__c;
                parentIdCase.Type='ID Card';  //strCaseRec.Type;
                parentIdCase.parentid=strCaseRec.GEMS_Account_Submission_Info__c;
                parentIdCase.Funding_Type_Multiselect__c=strCaseRec.Funding_Type_Multiselect__c;
                parentIdCase.status='In Progress';
                custIdParentCasesInsertList.add(parentIdCase);
            }
        }
        if(!custIdParentCasesInsertList.isEmpty())
        {
            insert custIdParentCasesInsertList;
        }
        System.Debug('parent insert =====>' +custIdParentCasesInsertList);
        for(Case custCaseRec: custIdParentCasesInsertList)
        {
            List<GEMS_Benefit_Agreement__c> benfAggList = subIdListBenfMap.get(custCaseRec.GEMS_Account_Submission_Info__c);
            for(GEMS_Benefit_Agreement__c benfRec: benfAggList)
            {
                DateTime effectiveDate = custCaseRec.GEMS_Effective_Date__c;
                Case childIdCase = new Case();
                childIdCase.recordTypeId=customIdCardChildRecordTypeId;
                childIdCase.parentId=custCaseRec.Id;
                childIdCase.OwnerId=custCaseRec.OwnerId;
                childIdCase.GEMS_Benefit_Agreement__c=benfRec.Id;
                childIdCase.Subject=benfRec.AccountStructureCase__r.account.name+' '+ benfRec.AccountStructureCase__r.Account.External_ID__c +' '+effectiveDate.format('M/d/yyyy')+' BA ID Card';
                childIdCase.GEMS_Account_Submission_Info__c=custCaseRec.GEMS_Account_Submission_Info__c;
                childIdCase.Accountid = custCaseRec.Accountid;
                //childIdCase.GEMS_Account_Name__c = custCaseRec.Accountid;
                childIdCase.GEMS_Effective_Date__c=custCaseRec.GEMS_Effective_Date__c;
                childIdCase.GEMS_Case_Effective_Date__c=custCaseRec.GEMS_Case_Effective_Date__c;
                childIdCase.GEMS_Submission_Type__c=custCaseRec.GEMS_Submission_Type__c;
                childIdCase.GEMS_Submission_Sub_Type__c=custCaseRec.GEMS_Submission_Sub_Type__c;
                childIdCase.FSU_Location__c=benfRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c;
                childIdCase.HCSC_Division__c=custCaseRec.HCSC_Division__c;
                childIdCase.GEMS_Line_of_Business__c=custCaseRec.GEMS_Line_of_Business__c;
                childIdCase.Opportunity_Name__c=custCaseRec.Opportunity_Name__c;
                childIdCase.Type= 'ID Card'; //custCaseRec.Type;
                childIdCase.Funding_Type_Multiselect__c=custCaseRec.Funding_Type_Multiselect__c;
                childIdCase.status='In Progress';
                custIdChildCasesInsertList.add(childIdCase);
            }
        }
        if(!custIdChildCasesInsertList.isEmpty())
        {
            insert custIdChildCasesInsertList;
        }
        System.Debug('Child insert list =====>' +custIdChildCasesInsertList);
        }
        catch(Exception ex) {
            System.debug('==exception='+ex.getMessage());
        }
    }*/
    
    
/******************************************************************** 
*    Method Name : checkRequiredDocuments
Action
*   @description :   This method to check required documents attached or not
*   @parameters  :   List<Case> accountSubmissionCaseList
*   @return type :   String
***************************************************************/
    /*public static String checkRequiredDocuments(List<Case> accountSubmissionCaseList) {
        String missedDocs = '';
        String returnString = '';
        Map<String,Set<String>> caseIdsWithAttachmentsmap = new Map<String,Set<String>>();
        Map<String, Schema.SObjectField> caseFieldsMap = Schema.SObjectType.Case.fields.getMap();
        List<GEMS_Account_Submission_required_doc__mdt> accountSubmissionRequiredDocsList = [SELECT Division__c, Document_Type__c, Fields__c, Funding_Type__c, Products__c, Required_Documents__c, Submission_Sub_type__c, Submission_Type__c FROM GEMS_Account_Submission_required_doc__mdt  where Is_Active__c = true];
        for(Case accountSubmissionWithAttachments : accountSubmissionCaseList) {
            
            Set<String> attachmentTypes = new Set<String>();
            if(accountSubmissionWithAttachments.GEMS_Attachments__r != null && !accountSubmissionWithAttachments.GEMS_Attachments__r.isEmpty()) {
                for(GEMS_Attachment__c attachments : accountSubmissionWithAttachments.GEMS_Attachments__r) {                       
                    attachmentTypes.add(attachments.Type__c.toUpperCase());
                }
                caseIdsWithAttachmentsmap.put(accountSubmissionWithAttachments.Id,attachmentTypes);
            }
            List<String> attachmentTypesMetaData = new List<String>();
            for(GEMS_Account_Submission_required_doc__mdt submissionReqDoc : accountSubmissionRequiredDocsList) {
                
                if(!(accountSubmissionWithAttachments.GEMS_Submission_Type__c != null && accountSubmissionWithAttachments.GEMS_Submission_Type__c.contains(submissionReqDoc.Submission_Type__c)) ) {
                    continue;
                }                
                if((submissionReqDoc.Division__c == 'All' && accountSubmissionWithAttachments.HCSC_Division__c == null ) || (submissionReqDoc.Division__c != 'All' && submissionReqDoc.Division__c != 'N/A' && accountSubmissionWithAttachments.HCSC_Division__c != submissionReqDoc.Division__c) ) {
                    continue;
                }
                if( (submissionReqDoc.Products__c != 'N/A' && accountSubmissionWithAttachments.GEMS_Products__c == null) || (submissionReqDoc.Products__c != 'N/A' && accountSubmissionWithAttachments.GEMS_Products__c != null && !(accountSubmissionWithAttachments.GEMS_Products__c.contains(submissionReqDoc.Products__c) || submissionReqDoc.Products__c.contains(accountSubmissionWithAttachments.GEMS_Products__c)) )) {
                    System.debug('Entered----Rec--Docs--');
                    continue;
                }                
                
                String SearchstringcaseFundingType = '';
                String SearchstringMetadataFundingType = '';
                SearchstringMetadataFundingType = submissionReqDoc.Funding_Type__c;
                SearchstringcaseFundingType = accountSubmissionWithAttachments.Funding_Type_Multiselect__c;
                
                if( (submissionReqDoc.Funding_Type__c == 'All' && accountSubmissionWithAttachments.Funding_Type_Multiselect__c == null) || (submissionReqDoc.Funding_Type__c != 'All' && submissionReqDoc.Funding_Type__c != 'N/A' && (!SearchstringcaseFundingType.contains(SearchstringMetadataFundingType) ) ) ) {
                    continue;
                }  
                if( submissionReqDoc.Fields__c != 'N/A') {
                    try{
                        String[] fieldMetaDataArray = (submissionReqDoc.Fields__c).split(';');
                        Boolean caseFailed = false;
                        String Searchstring = '';
                        for(String fieldMetaData : fieldMetaDataArray ) {
                            String[] fieldData = fieldMetaData.split('=');
                            if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.MultiPicklist) {
                                Searchstring = (String)accountSubmissionWithAttachments.get(caseFieldsMap.get(fieldData[0]));
                                system.debug('Picklist :'+(String)accountSubmissionWithAttachments.get(caseFieldsMap.get(fieldData[0])));
                            }
                            
                            
                            if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.BOOLEAN && ( (fieldData[1] == 'TRUE' && !(Boolean)accountSubmissionWithAttachments.get(caseFieldsMap.get(fieldData[0]))) || (fieldData[1] == 'FALSE' && (Boolean)accountSubmissionWithAttachments.get(caseFieldsMap.get(fieldData[0]))) ) ){
                                caseFailed = true;
                                break;
                            }
                            
                            if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.PICKLIST && ( (fieldData[1] != (String)accountSubmissionWithAttachments.get(caseFieldsMap.get(fieldData[0]))) ) ){
                                caseFailed = true;
                                break;
                            }
                            
                            if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.STRING && ( (fieldData[1] != (String)accountSubmissionWithAttachments.get(caseFieldsMap.get(fieldData[0]))) ) ){
                                caseFailed = true;
                                break;
                            }
                            
                            if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.MultiPicklist && ( !Searchstring.contains(fieldData[1]) ) ){
                                caseFailed = true;
                                break;
                            }
                        }
                        if(caseFailed) {
                            continue;
                        }
                    }catch(Exception ex) {
                        System.debug('======Try===Exception==Fields__c ==='+ex.getMessage());
                    }
                }
                if(submissionReqDoc.Document_Type__c != '?') {
                    attachmentTypesMetaData.add(submissionReqDoc.Document_Type__c.toUpperCase());
                }
            }
            
            for(String metaAttachmentType : attachmentTypesMetaData) {
                if(!attachmentTypes.contains(metaAttachmentType)) {
                    if(!missedDocs.contains(metaAttachmentType)) {
                        if(missedDocs == '') {
                            missedDocs = 'The below attachments are missing for screening creation \n'+metaAttachmentType;
                        }else {
                            missedDocs = missedDocs+'\n'+metaAttachmentType;
                        }
                    }
                }
            }
        }
        
        if(missedDocs != '') {
            returnString = missedDocs;
        }
        return returnString ;
    }*/
    
    /******************************************************************** 
    *    Method Name : createIdCardAndProcessCasesForStandardProduct
    Action
    *   @description :   This method to check required documents attached or not when No is selected for GEMS_StdCust_Product__c and Invoked from CaseTrigger when Account Structure Case is moved to Client Approval received.
    *   @parameters  :   List<Case> newAccStrCaseList, Map<Id,Case> oldAccStrCaseMap
    *   @return type :   
    ***************************************************************/
    
    /*public static void createIdCardAndProcessCasesForStandardProduct(List<Case> newCaseList, Map<Id,Case> oldCaseMap)
    {
        try
        {
            Id caseBAScreeningCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
            Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();       
            Id accStructCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
            
            List<Case> processCasesToCreate = new List<Case>();
            Set<String> recordTypeIdsSet = new Set<String>{caseBAScreeningCaseRecordTypeId,accStructCaseRecordTypeId};
            
            Set<ID> accSubIdsSet = new Set<ID>();
            
            List<Case> accSubCasesList = new List<Case>();
            List<Case> accSubCasesListToBeSendToCreateIDCardAndProcessCase = new List<Case>();
            List<Case> strCasesListToBeSendToCreateIDCardAndProcessCase = new List<Case>();
            Map<ID,Boolean> submissionCaseIdAllDocsAttachedBooleanMap = new Map<ID,Boolean>();
            Set<ID> strCasesIDsForIdCardAndProcesCaseCreationSet = new Set<ID>();
            Map<ID,List<GEMS_Benefit_Agreement__c>> caseIdAndBenefitAgreementMap = new Map<ID,List<GEMS_Benefit_Agreement__c>>();
            
            for(Case caseRec: newCaseList)
            {
                if(caseRec.Status=='Client Approval Received' && caseRec.Status!=oldCaseMap.get(caseRec.Id).Status && caseRec.RecordTypeId==accStructCaseRecordTypeId)
                {
                    accSubIdsSet.add(caseRec.GEMS_Account_Submission_Info__c);
                }
                else if(caseRec.GEMS_All_required_documents_attached__c && caseRec.GEMS_All_required_documents_attached__c!=oldCaseMap.get(caseRec.Id).GEMS_All_required_documents_attached__c && caseRec.RecordTypeId==caseAccountSubmissionId)
                {
                    accSubIdsSet.add(caseRec.id);
                }
                else if(caseRec.GEMS_StdCust_Product__c=='Standard Products only' && caseRec.GEMS_StdCust_Product__c!=oldCaseMap.get(caseRec.Id).GEMS_StdCust_Product__c && caseRec.RecordTypeId==caseAccountSubmissionId)
                {
                    accSubIdsSet.add(caseRec.id);
                }
                else if(caseRec.GEMS_AEP_Account__c && caseRec.GEMS_AEP_Account__c!=oldCaseMap.get(caseRec.Id).GEMS_AEP_Account__c && caseRec.RecordTypeId==caseAccountSubmissionId)
                {
                    accSubIdsSet.add(caseRec.id);
                }
            }
            
            if(!accSubIdsSet.isEmpty())
            {
                accSubCasesList = [select id,OwnerId,GEMS_Additional_Medical_Underwriter__c,GEMS_Is_CBSR_required__c,GEMS_Products__c,account.name,GEMS_Submission_Type__c,
                                  GEMS_Submission_Sub_Type__c ,GEMS_Line_of_Business__c ,GEMS_Benefit_Booklet_Required__c,GEMS_Effective_Date__c, GEMS_StdCust_Product__c, GEMS_Eligibility_required__c,
                                  Account.External_ID__c,type,FSU_Location__c,Account_Executive__c,HCSC_Division__c,GEMS_Rx_Vendor__c,
                                  GEMS_Medical_Underwriter__c,Sales_Executive__c,Productid,status,GEMS_Case_Effective_Date__c,Opportunity_Name__c,Funding_Type__c,
                                  Funding_Type_Multiselect__c,GEMS_AEP_Account__c,GEMS_All_required_documents_attached__c ,GEMS_Integrated__c,GEMS_Grandfathered_benefits__c,GEMS_Bank__c,
                                  GEMS_Performance_Guarantees__c,GEMS_BCC_Products__c,
                                  (select Attachment__c,Description__c,Type__c from GEMS_Attachments__r),
                                  (select id, casenumber,Status,recordTypeId, GEMS_Effective_Date__c, GEMS_Case_Effective_Date__c, GEMS_Account_Submission_Info__c,
                                   Accountid, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, HCSC_Division__c, GEMS_Line_of_Business__c, Opportunity_Name__c,
                                   Funding_Type_Multiselect__c, parentId, GEMS_StdCust_Product__c from Cases1__r where recordtypeid In : recordTypeIdsSet )                
                                  FROM case WHERE Id IN: accSubIdsSet and recordtypeid=:caseAccountSubmissionId
                                 ];
            }
            
            for(Case subCaseRec: accSubCasesList)
            {
                for(Case childCaseRec: subCaseRec.Cases1__r)
                {
                    if(childCaseRec.RecordTypeID == accStructCaseRecordTypeId)
                    {
                        if(subCaseRec.GEMS_All_required_documents_attached__c && subCaseRec.GEMS_StdCust_Product__c=='Standard Products only' && ( childCaseRec.Status == 'Client Approval Received' || childCaseRec.Status == 'BlueSTAR Sent' || childCaseRec.Status == 'BlueSTAR Failed' || childCaseRec.Status == 'BlueSTAR Partial Fail' || childCaseRec.Status == 'BlueSTAR Shell Created'))
                        {
                            strCasesIDsForIdCardAndProcesCaseCreationSet.add(childCaseRec.Id);
                            strCasesListToBeSendToCreateIDCardAndProcessCase.add(childCaseRec);
                        }
                    }
                }
            }
            if(!strCasesIDsForIdCardAndProcesCaseCreationSet.isEmpty()) 
            {
                List<GEMS_Benefit_Agreement__c> benefitAgreementList = [SELECT ID, Name, AccountStructureCase__c,IsCancelled__c,
                                                                        AccountStructureCase__r.account.name,
                                                                        AccountStructureCase__r.Account.External_ID__c,
                                                                        AccountStructureCase__r.GEMS_Account_Submission_Info__c,
                                                                        AccountStructureCase__r.GEMS_Account_Submission_Info__r.OwnerId,
                                                                        AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c, 
                                                                        Product__c, Product__r.name from GEMS_Benefit_Agreement__c 
                                                                        where AccountStructureCase__c=:strCasesIDsForIdCardAndProcesCaseCreationSet 
                                                                        AND IsCancelled__c=false];
                
                
                Map<Id,List<GEMS_Benefit_Agreement__c>> subCaseIdBenfAggListMap = new Map<Id,List<GEMS_Benefit_Agreement__c>>();
                for(GEMS_Benefit_Agreement__c benefitAggRecord: benefitAgreementList) 
                {
                    if(String.isNotBlank(benefitAggRecord.AccountStructureCase__c))
                    {
                        if(!caseIdAndBenefitAgreementMap.containsKey(benefitAggRecord.AccountStructureCase__c)) 
                        {
                            caseIdAndBenefitAgreementMap.put(benefitAggRecord.AccountStructureCase__c, new List<GEMS_Benefit_Agreement__c>());
                        }
                        caseIdAndBenefitAgreementMap.get(benefitAggRecord.AccountStructureCase__c).add(benefitAggRecord);
                    }
                }
            
                for(GEMS_Benefit_Agreement__c benefitAggRecord: benefitAgreementList) 
                {
                    if(String.isNotBlank(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c))
                    {
                        if(!subCaseIdBenfAggListMap.containsKey(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c)) 
                        {
                            subCaseIdBenfAggListMap.put(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c, new List<GEMS_Benefit_Agreement__c>());
                        }
                        subCaseIdBenfAggListMap.get(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c).add(benefitAggRecord);
                    }
                }
                GEMS_CaseTriggerHandler.createIdCardParentChildCase(strCasesListToBeSendToCreateIDCardAndProcessCase, subCaseIdBenfAggListMap);
            }
        }
        catch(Exception ex)
        {
            System.debug('Exception'+ex.getMessage());
        }
    }
    
    public static void createAccountSetupProcessforStandardProduct(List<Case> newCaseList, Map<Id,Case> oldCaseMap)
    {
        Set<Id> accSubIdsSet = new Set<Id>();
        Set<Id> strCaseIdsSet = new Set<Id>();
        List<Case> accSubChildCasesList = new List<Case>();
        
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();       
        Id accStructCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Id accSetupRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        Id baLevelAccSetupRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
        Id manualEligibilityCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Manual Eligibility').getRecordTypeId();
        Id eligibilityProcessCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Eligibility').getRecordTypeId();
        
        Map<ID, Case> accSubCaseIDandStrCaseMap = new Map<ID, Case>();
        Map<ID, Case> accSubCaseIDandStrCaseForAepAccountMap = new Map<ID, Case>();
        Map<ID, Case> accSubCaseIDandStrCaseForNonAepAccountMap = new Map<ID, Case>();
        List<Case> aepAccSubCaseListForEligibilityProcess = new List<Case>();
        
        Map<ID, List<Case>> accSubCaseIDandAccSetUpProcessChildCaseMap = new Map<ID, List<Case>>();
        Map<ID, List<Case>> accSubCaseIDandManualEligibilityChildCaseMap = new Map<ID, List<Case>>();
        Map<ID, List<Case>> accSubCaseIDandEligibilityProcessChildCaseMap = new Map<ID, List<Case>>();
        
        Map<ID, List<GEMS_Benefit_Agreement__c>> accSubCaseIDandBAListMap = new Map<ID, List<GEMS_Benefit_Agreement__c>>();
        List<GEMS_Benefit_Agreement__c> benefitAgreementList = new List<GEMS_Benefit_Agreement__c>();
        List<Case> strCasesListToProcess = new List<Case>();
        List<Case> parentAccSetUpProcessCasesListToInsert = new List<Case>();
        List<Case> childAccSetUpProcessCasesListToInsert = new List<Case>();
        
        List<Case> manualEligibilityCasesListToInsert = new List<Case>();
        List<Case> eligibilityProcessCasesListToInsert = new List<Case>();
        
        List<Task> taskInsertList = new List<Task>();
        
        Map<Id, caseTeamMember> subIdAccSpecialistMemberMap = new Map<Id, caseTeamMember>();
        Group accSpecGroup;
        
        try
        {
            for(Case caseRec: newCaseList)
            {
                if(caseRec.Status=='Client Approval Received' && caseRec.Status!=oldCaseMap.get(caseRec.Id).Status && caseRec.RecordTypeId==accStructCaseRecordTypeId)
                {
                    accSubIdsSet.add(caseRec.GEMS_Account_Submission_Info__c);
                }
                else if(caseRec.GEMS_All_required_documents_attached__c && caseRec.GEMS_All_required_documents_attached__c!=oldCaseMap.get(caseRec.Id).GEMS_All_required_documents_attached__c && caseRec.RecordTypeId==caseAccountSubmissionId)
                {
                    accSubIdsSet.add(caseRec.id);
                }
                else if(caseRec.GEMS_StdCust_Product__c=='Standard Products only' && caseRec.GEMS_StdCust_Product__c!=oldCaseMap.get(caseRec.Id).GEMS_StdCust_Product__c && caseRec.RecordTypeId==caseAccountSubmissionId)
                {
                    accSubIdsSet.add(caseRec.id);
                }
                else if(caseRec.GEMS_AEP_Account__c && caseRec.GEMS_AEP_Account__c!=oldCaseMap.get(caseRec.Id).GEMS_AEP_Account__c && caseRec.RecordTypeId==caseAccountSubmissionId)
                {
                    accSubIdsSet.add(caseRec.id);
                }
            }
            if(!accSubIdsSet.isEmpty())
            {
                accSubChildCasesList = [select id,OwnerId,GEMS_Additional_Medical_Underwriter__c,GEMS_Is_CBSR_required__c,GEMS_Products__c,account.name,GEMS_Submission_Type__c,
                                  GEMS_Submission_Sub_Type__c ,GEMS_Line_of_Business__c ,GEMS_Benefit_Booklet_Required__c,GEMS_Effective_Date__c, GEMS_StdCust_Product__c, GEMS_Eligibility_required__c,
                                  Account.External_ID__c,type,FSU_Location__c,Account_Executive__c,HCSC_Division__c,GEMS_Rx_Vendor__c,
                                  GEMS_Medical_Underwriter__c,Sales_Executive__c,Productid,status,GEMS_Case_Effective_Date__c,Opportunity_Name__c,Funding_Type__c,
                                  Funding_Type_Multiselect__c,GEMS_AEP_Account__c,GEMS_All_required_documents_attached__c ,GEMS_Integrated__c,GEMS_Grandfathered_benefits__c,GEMS_Bank__c,
                                  GEMS_Performance_Guarantees__c,GEMS_BCC_Products__c,
                                  (select Attachment__c,Description__c,Type__c from GEMS_Attachments__r),
                                  (select id, casenumber,Status,recordTypeId, GEMS_Effective_Date__c, GEMS_Case_Effective_Date__c, GEMS_Account_Submission_Info__c,
                                   Accountid, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, HCSC_Division__c, GEMS_Line_of_Business__c, Opportunity_Name__c,
                                   Funding_Type_Multiselect__c, parentId, GEMS_StdCust_Product__c, FSU_Location__c,
                                   Account.name, Account.External_ID__c, GEMS_Account_Submission_Info__r.GEMS_Private_Exchange__c, GEMS_Account_Submission_Info__r.GEMS_Private_Exchange_Values__c
                                   from Cases1__r),
                                   (select parentId,memberid,TeamRole.name from TeamMembers
                                   where TeamRole.name ='Account Specialist')
                                  FROM case WHERE Id IN: accSubIdsSet and recordtypeid=:caseAccountSubmissionId
                                 ];
            }
            if(!accSubChildCasesList.isEmpty())
            {
                for(Case accSubCaseRec: accSubChildCasesList)
                {
                    if(!accSubCaseRec.TeamMembers.isEmpty())
                    {
                        subIdAccSpecialistMemberMap.put(accSubCaseRec.Id, accSubCaseRec.TeamMembers[0]);
                    }
                    if(accSubCaseRec.Status=='In Progress' && accSubCaseRec.GEMS_All_required_documents_attached__c && accSubCaseRec.GEMS_StdCust_Product__c=='Standard Products only')
                    {
                        for(Case childCaseRec: accSubCaseRec.Cases1__r)
                        {
                            if(childCaseRec.RecordtypeId==accStructCaseRecordTypeId && ( childCaseRec.Status == 'Client Approval Received' || childCaseRec.Status == 'BlueSTAR Sent' || childCaseRec.Status == 'BlueSTAR Failed' || childCaseRec.Status == 'BlueSTAR Partial Fail' || childCaseRec.Status == 'BlueSTAR Shell Created'))
                            {
                                accSubCaseIDandStrCaseMap.put(childCaseRec.GEMS_Account_Submission_Info__c, childCaseRec);
                                strCaseIdsSet.add(childCaseRec.Id);
                                if(accSubCaseRec.GEMS_AEP_Account__c)
                                {
                                    accSubCaseIDandStrCaseForAepAccountMap.put(childCaseRec.GEMS_Account_Submission_Info__c, childCaseRec);
                                    aepAccSubCaseListForEligibilityProcess.add(accSubCaseRec);
                                }
                                else if(!accSubCaseRec.GEMS_AEP_Account__c)
                                {
                                    accSubCaseIDandStrCaseForNonAepAccountMap.put(childCaseRec.GEMS_Account_Submission_Info__c, childCaseRec);
                                }
                            }
                            else if(childCaseRec.RecordtypeId==accSetupRecordTypeId)
                            {
                                if(!accSubCaseIDandAccSetUpProcessChildCaseMap.containsKey(childCaseRec.GEMS_Account_Submission_Info__c)) 
                                {
                                    accSubCaseIDandAccSetUpProcessChildCaseMap.put(childCaseRec.GEMS_Account_Submission_Info__c, new List<Case>());
                                }
                                accSubCaseIDandAccSetUpProcessChildCaseMap.get(childCaseRec.GEMS_Account_Submission_Info__c).add(childCaseRec);
                            }
                        }
                    }
                }
            }
            if(!aepAccSubCaseListForEligibilityProcess.isEmpty())
            {
                //GEMS_AccountScreeningCaseCreation.screeningCasesCreation(aepAccSubCaseListForEligibilityProcess);
            }
            
            if(!strCaseIdsSet.isEmpty())
            {
                 benefitAgreementList = [SELECT ID, Name, AccountStructureCase__c,IsCancelled__c,
                                                                    AccountStructureCase__r.account.name,
                                                                    AccountStructureCase__r.Account.External_ID__c,
                                                                    AccountStructureCase__r.Opportunity_Name__c,
                                                                    AccountStructureCase__r.GEMS_Account_Submission_Info__c,
                                                                    AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c, 
                                                                    Product__c, Product__r.name from GEMS_Benefit_Agreement__c 
                                                                    WHERE AccountStructureCase__c IN:strCaseIdsSet
                                                                    AND IsCancelled__c=false AND Has_Group_Sections__c = true
                                                                    ];
            }
            if(!benefitAgreementList.isEmpty())
            {
                for(GEMS_Benefit_Agreement__c benefitAggRecord: benefitAgreementList) 
                {
                    if(String.isNotBlank(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c))
                    {
                        if(!accSubCaseIDandBAListMap.containsKey(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c)) 
                        {
                            accSubCaseIDandBAListMap.put(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c, new List<GEMS_Benefit_Agreement__c>());
                        }
                        accSubCaseIDandBAListMap.get(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c).add(benefitAggRecord);
                    }
                }
            }
            strCasesListToProcess = accSubCaseIDandStrCaseMap.Values();
            if(!strCasesListToProcess.isEmpty())
            {
                accSpecGroup =[select Id from Group where Name = 'Account Setup Business Area Queue' and Type = 'Queue' LIMIT 1];
                for(Case strCaseRec: strCasesListToProcess)
                {
                    List<Case> accSubCaseChildCasesListNotStrCase = new List<Case>();
                    List<Case> accSubCaseChildCasesListNotStrCaseForAepAccount = new List<Case>();
                    List<Case> accSubCaseChildCasesListNotStrCaseForNonAepAccount = new List<Case>();
                    if(accSubCaseIDandAccSetUpProcessChildCaseMap.containsKey(strCaseRec.GEMS_Account_Submission_Info__c))
                    {
                        accSubCaseChildCasesListNotStrCase = accSubCaseIDandAccSetUpProcessChildCaseMap.get(strCaseRec.GEMS_Account_Submission_Info__c);
                    }
                    if(accSubCaseChildCasesListNotStrCase.size()==0)
                    {
                        DateTime effectiveDate = strCaseRec.GEMS_Effective_Date__c;
                        Case accSetUpProcessNewParentCase = new Case();
                        accSetUpProcessNewParentCase.Type = 'Account Setup Process';
                        accSetUpProcessNewParentCase.recordtypeid=accSetupRecordTypeId;
                        accSetUpProcessNewParentCase.Accountid=strCaseRec.Accountid;
                        accSetUpProcessNewParentCase.GEMS_Effective_Date__c=strCaseRec.GEMS_Effective_Date__c;
                        accSetUpProcessNewParentCase.GEMS_Case_Effective_Date__c = strCaseRec.GEMS_Case_Effective_Date__c;
                        accSetUpProcessNewParentCase.GEMS_Submission_Type__c=strCaseRec.GEMS_Submission_Type__c;
                        accSetUpProcessNewParentCase.FSU_Location__c=strCaseRec.FSU_Location__c;
                        accSetUpProcessNewParentCase.Status='In Progress';
                        accSetUpProcessNewParentCase.HCSC_Division__c=strCaseRec.HCSC_Division__c;
                        accSetUpProcessNewParentCase.GEMS_Submission_Sub_Type__c=strCaseRec.GEMS_Submission_Sub_Type__c;
                        accSetUpProcessNewParentCase.GEMS_Account_Submission_Info__c=strCaseRec.GEMS_Account_Submission_Info__c;
                        accSetUpProcessNewParentCase.Subject=strCaseRec.Account.name+' '+strCaseRec.Account.External_ID__c+' '+effectiveDate.format('M/d/yyyy')+' Account Setup Process';
                        accSetUpProcessNewParentCase.GEMS_Private_Exchange__c = strCaseRec.GEMS_Account_Submission_Info__r.GEMS_Private_Exchange__c;     
                        accSetUpProcessNewParentCase.GEMS_Private_Exchange_Values__c = strCaseRec.GEMS_Account_Submission_Info__r.GEMS_Private_Exchange_Values__c;
                        accSetUpProcessNewParentCase.Opportunity_Name__c = strCaseRec.Opportunity_Name__c;
                        if(subIdAccSpecialistMemberMap.get(strCaseRec.GEMS_Account_Submission_Info__c)!=null)
                        {
                            accSetUpProcessNewParentCase.ownerId=subIdAccSpecialistMemberMap.get(strCaseRec.GEMS_Account_Submission_Info__c).memberid;
                            acctSetupCase.GEMS_Quality_Reviewer__c = subIdAccSpecialistMemberMap.get(strCaseRec.GEMS_Account_Submission_Info__c).memberid;
                        }
                        else
                        {
                            accSetUpProcessNewParentCase.ownerId = accSpecGroup.Id;
                            acctSetupCase.GEMS_BlueSTAR_Walkthrough_Resource_1__c = accSpecGroup.Id;
                        }
                        //accSetUpProcessNewParentCase.Underwriter_Lookup__c = strCaseRec.Underwriter_Lookup__c;
                        
                        parentAccSetUpProcessCasesListToInsert.add(accSetUpProcessNewParentCase);
                    }
                }
            }
            //accSubCaseIDandStrCaseForAepAccountMap
            if(!parentAccSetUpProcessCasesListToInsert.isEmpty())
            {
                insert parentAccSetUpProcessCasesListToInsert;
            }
            if(!parentAccSetUpProcessCasesListToInsert.isEmpty())
            {
                for(Case parentAccSetUpCaseRec: parentAccSetUpProcessCasesListToInsert)
                {
                    DateTime effectiveDate = parentAccSetUpCaseRec.GEMS_Effective_Date__c;
                    List<GEMS_Benefit_Agreement__c> benfAggsListToProcess = new List<GEMS_Benefit_Agreement__c>();
                    if(accSubCaseIDandBAListMap.containsKey(parentAccSetUpCaseRec.GEMS_Account_Submission_Info__c))
                    {
                        benfAggsListToProcess = accSubCaseIDandBAListMap.get(parentAccSetUpCaseRec.GEMS_Account_Submission_Info__c);
                    }
                    if(!benfAggsListToProcess.isEmpty())
                    {
                        for(GEMS_Benefit_Agreement__c benfAggRec: benfAggsListToProcess)
                        {
                            Case accSetUpProcessNewChildCase = new Case();
                            accSetUpProcessNewChildCase.ParentId=parentAccSetUpCaseRec.id;
                            accSetUpProcessNewChildCase.RecordTypeId=baLevelAccSetupRecordType;
                            accSetUpProcessNewChildCase.Type = 'Account Setup Process';
                            accSetUpProcessNewChildCase.Subject=benfAggRec.AccountStructureCase__r.account.name+' '+benfAggRec.AccountStructureCase__r.Account.External_ID__c+' '+effectiveDate.format('M/d/yyyy')+' BA Level Account Setup';
                            accSetUpProcessNewChildCase.Accountid=parentAccSetUpCaseRec.AccountId;
                            accSetUpProcessNewChildCase.GEMS_Benefit_Agreement__c = benfAggRec.id;
                            //accSetUpProcessNewChildCase.Account_Executive__c = executiveTeamMembers.get(baRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c).memberId;
                            accSetUpProcessNewChildCase.GEMS_Effective_Date__c = parentAccSetUpCaseRec.GEMS_Effective_Date__c;
                            accSetUpProcessNewChildCase.GEMS_Case_Effective_Date__c = parentAccSetUpCaseRec.GEMS_Case_Effective_Date__c;
                            accSetUpProcessNewChildCase.GEMS_Submission_Type__c=parentAccSetUpCaseRec.GEMS_Submission_Type__c;
                            accSetUpProcessNewChildCase.FSU_Location__c=parentAccSetUpCaseRec.FSU_Location__c;
                            accSetUpProcessNewChildCase.Status='In Progress';
                            //accSetUpProcessNewChildCase.GEMS_Is_BlueSTAR_Walkthrough_Needed__c ='No';
                            accSetUpProcessNewChildCase.GEMS_Private_Exchange__c = parentAccSetUpCaseRec.GEMS_Private_Exchange__c;
                            accSetUpProcessNewChildCase.GEMS_Private_Exchange_Values__c = parentAccSetUpCaseRec.GEMS_Private_Exchange_Values__c;
                            accSetUpProcessNewChildCase.HCSC_Division__c=parentAccSetUpCaseRec.HCSC_Division__c;
                            accSetUpProcessNewChildCase.GEMS_Submission_Sub_Type__c=parentAccSetUpCaseRec.GEMS_Submission_Sub_Type__c;
                            accSetUpProcessNewChildCase.GEMS_Account_Submission_Info__c=parentAccSetUpCaseRec.GEMS_Account_Submission_Info__c;
                            if(subIdAccSpecialistMemberMap.get(benfAggRec.AccountStructureCase__r.GEMS_Account_Submission_Info__c)!=null)
                            {
                                accSetUpProcessNewChildCase.ownerId=subIdAccSpecialistMemberMap.get(benfAggRec.AccountStructureCase__r.GEMS_Account_Submission_Info__c).memberid;
                            }
                            else
                            {
                                accSetUpProcessNewChildCase.ownerId = accSpecGroup.Id;
                            }
                            accSetUpProcessNewChildCase.Opportunity_Name__c = benfAggRec.AccountStructureCase__r.Opportunity_Name__c;
                            
                            childAccSetUpProcessCasesListToInsert.add(accSetUpProcessNewChildCase);
                        }
                    }
                }
            }
            if(!childAccSetUpProcessCasesListToInsert.isEmpty())
            {
                insert childAccSetUpProcessCasesListToInsert;
            }
            if(!childAccSetUpProcessCasesListToInsert.isEmpty())
            {
                for(Case childAccSetUpCaseRec: childAccSetUpProcessCasesListToInsert)
                {
                    integer i = 0;
                    Case insertedChildCaseRec = childAccSetUpProcessCasesListToInsert.get(i);
                    Task baLevelAccSetUpTask1 = new Task();
                    baLevelAccSetUpTask1.WhatId=childAccSetUpCaseRec.Id;
                    baLevelAccSetUpTask1.Subject='BlueSTAR Entry Complete';
                    baLevelAccSetUpTask1.Status='In Progress';
                    baLevelAccSetUpTask1.Priority='Normal';
                    baLevelAccSetUpTask1.GEMS_Start_Date__c = System.now();
                    if(!(string.valueOf(insertedChildCaseRec.OwnerID).startsWith('00G')))
                    {
                        baLevelAccSetUpTask1.OwnerId = insertedChildCaseRec.OwnerId;
                    }
                    taskInsertList.add(baLevelAccSetUpTask1);
                    
                    i++;
                }
            }
            if(!taskInsertList.isEmpty())
            {
                insert taskInsertList;
            }
        }
        catch(Exception ex)
        {
            System.debug('Exception'+ex.getMessage());
        }
    }*/
    
        /******************************************************************** 
    *    Method Name : createSBCChildCase
    Action
    *   @description :   This method to create parent child SBC cases
    *   @parameters  :   List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap
    *   @return type :   void
    ***************************************************************/
    /*public static void createSBCParentChildCase(List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap) {
        List<Case> custSbcParentCasesInsertList = new List<Case>();
        List<Case> custSbcChildCasesInsertList = new List<Case>();
        try {
        Id customsbcParentRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();
        Id customsbcChildRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level SBC').getRecordTypeId();
        
        Set<ID> subCaseIdsSet = new Set<ID>();
        subCaseIdsSet=subIdListBenfMap.keySet();

        //List<GEMS_CaseOwnership_MetaData__mdt> caseOwnerMetadata = [select Case_Team_Member__c,Que_Name__c from GEMS_CaseOwnership_MetaData__mdt where Type_Of_Case__c ='ID Card' ];
        List<case> subCaseRecChildsbcCasesList = [select id, GEMS_SBC_Required__c,Status, recordtypeid, GEMS_Accum_Type__c, 
                                                     GEMS_Account_Submission_Info__c, GEMS_Case_Effective_Date__c,Account_Number__c,
                                                     FSU_Location__c,GEMS_AEP_Account__c,Opportunity_Name__c,GEMS_Products__c,
                                                     GEMS_Line_of_Business__c,HCSC_Division__c,Account_Name__c,GEMS_BCC_Products__c,
                                                     GEMS_Submission_Sub_Type__c,Accountid,GEMS_Effective_Date__c,GEMS_Submission_Type__c ,
                                                     (select id,RecordTypeId,status, GEMS_Account_Submission_Info__c 
                                                      from Cases1__r where recordtypeid  =:customsbcParentRecordTypeId)

                                                     from case where id = :subCaseIdsSet];
        
        Map<Id,Boolean> subCaseIdsbcRecFoundMap = new Map<Id,Boolean>();
        
        Map<Id, caseTeamMember> subIdAccSpecialistMemberMap = new Map<Id, caseTeamMember>();
        //Group accSpecGroup =[select Id from Group where Name =: caseOwnerMetadata[0].Que_Name__c and Type = 'Queue' LIMIT 1];
        
        Boolean sbcRecFound = false;
        
        if(!subCaseRecChildsbcCasesList.isEmpty() && subCaseRecChildsbcCasesList != null) 
        {
            for(case subCaseRec : subCaseRecChildsbcCasesList) 
            {
                List<Case> tempCaseList = new List<Case>();
                tempCaseList=subCaseRec.Cases1__r;

                if(tempCaseList.Size()>0 || subCaseRec.GEMS_SBC_Required__c == 'No')
                {
                    sbcRecFound = true;
                    subCaseIdsbcRecFoundMap.put(subCaseRec.Id,sbcRecFound);
                    break;
                }
                else
                {
                    sbcRecFound = false;
                    subCaseIdsbcRecFoundMap.put(subCaseRec.Id,sbcRecFound);
                }
            }
            
        }
        
        for(Case strCaseRec: clientApprovalReceivedCasesList) {
            Boolean sbcCaseRecFound = subCaseIdsbcRecFoundMap.get(strCaseRec.GEMS_Account_Submission_Info__c);
            if(!sbcCaseRecFound) {
                List<GEMS_Benefit_Agreement__c> benfAggList = subIdListBenfMap.get(strCaseRec.GEMS_Account_Submission_Info__c);
                DateTime effectiveDate = strCaseRec.GEMS_Effective_Date__c;
                Case parentSbcCase = new Case();
                parentSbcCase.recordTypeId =customsbcParentRecordTypeId;
                parentSbcCase.Subject=benfAggList[0].AccountStructureCase__r.Account.Name+' '+ benfAggList[0].AccountStructureCase__r.Account.External_ID__c +' '+effectiveDate.format('M/d/yyyy')+' SBC';
                parentSbcCase.GEMS_Account_Submission_Info__c=strCaseRec.GEMS_Account_Submission_Info__c;
                parentSbcCase.parentId=strCaseRec.GEMS_Account_Submission_Info__c;
                parentSbcCase.Accountid = strCaseRec.Accountid;
                parentSbcCase.GEMS_Effective_Date__c=strCaseRec.GEMS_Effective_Date__c;
                parentSbcCase.GEMS_Case_Effective_Date__c=strCaseRec.GEMS_Case_Effective_Date__c;
                parentSbcCase.GEMS_Submission_Type__c=strCaseRec.GEMS_Submission_Type__c;
                parentSbcCase.GEMS_Submission_Sub_Type__c=strCaseRec.GEMS_Submission_Sub_Type__c;
                parentSbcCase.FSU_Location__c=benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c;
                parentSbcCase.HCSC_Division__c=strCaseRec.HCSC_Division__c;
                parentSbcCase.GEMS_Line_of_Business__c=strCaseRec.GEMS_Line_of_Business__c;
                parentSbcCase.Opportunity_Name__c=strCaseRec.Opportunity_Name__c;
                parentSbcCase.Type='SBC';  //strCaseRec.Type;
                parentSbcCase.Funding_Type_Multiselect__c=strCaseRec.Funding_Type_Multiselect__c;
                parentSbcCase.status='In Progress';
                parentSbcCase.ownerId=userInfo.getUserId();
                custSbcParentCasesInsertList.add(parentSbcCase);
            }
        }
        if(!custSbcParentCasesInsertList.isEmpty())
        {
            insert custSbcParentCasesInsertList;
        }
        System.Debug('parent insert =====>' +custSbcParentCasesInsertList);
        for(Case custCaseRec: custSbcParentCasesInsertList)
        {
            List<GEMS_Benefit_Agreement__c> benfAggList = subIdListBenfMap.get(custCaseRec.GEMS_Account_Submission_Info__c);
            System.debug('==benfAggList =='+benfAggList);
            for(GEMS_Benefit_Agreement__c benfRec: benfAggList)
            {
                DateTime effectiveDate = custCaseRec.GEMS_Effective_Date__c;
                Case childSbcCase = new Case();
                childSbcCase.recordTypeId=customsbcChildRecordTypeId;
                childSbcCase.parentId=custCaseRec.Id;
                childSbcCase.OwnerId=custCaseRec.OwnerId;
                childSbcCase.GEMS_Benefit_Agreement__c=benfRec.Id;
                childSbcCase.Subject=benfRec.AccountStructureCase__r.account.name+' '+ benfRec.AccountStructureCase__r.Account.External_ID__c +' '+effectiveDate.format('M/d/yyyy')+'BA Level SBC';
                childSbcCase.GEMS_Account_Submission_Info__c=custCaseRec.GEMS_Account_Submission_Info__c;
                childSbcCase.Accountid = custCaseRec.Accountid;
                childSbcCase.GEMS_Effective_Date__c=custCaseRec.GEMS_Effective_Date__c;
                childSbcCase.GEMS_Case_Effective_Date__c=custCaseRec.GEMS_Case_Effective_Date__c;
                childSbcCase.GEMS_Submission_Type__c=custCaseRec.GEMS_Submission_Type__c;
                childSbcCase.GEMS_Submission_Sub_Type__c=custCaseRec.GEMS_Submission_Sub_Type__c;
                childSbcCase.FSU_Location__c=benfRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c;
                childSbcCase.HCSC_Division__c=custCaseRec.HCSC_Division__c;
                childSbcCase.GEMS_Line_of_Business__c=custCaseRec.GEMS_Line_of_Business__c;
                childSbcCase.Opportunity_Name__c=custCaseRec.Opportunity_Name__c;
                childSbcCase.Type= 'SBC'; //custCaseRec.Type;
                childSbcCase.Funding_Type_Multiselect__c=custCaseRec.Funding_Type_Multiselect__c;
                childSbcCase.status='In Progress';
                custSbcChildCasesInsertList.add(childSbcCase);
            }
        }
        if(!custSbcChildCasesInsertList.isEmpty())
        {
            insert custSbcChildCasesInsertList;
        }
        System.Debug('Child insert list =====>' +custSbcChildCasesInsertList);
        }
        Catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_ScreeningCaseController.createSBCParentChildCase(List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap)','High');  
            System.debug('==Exception='+ex.getMessage());
        }
    }*/
    /******************************************************************** 
    *   @Method Name :   sendMedicalBenefitCodingCaseForDTUApproval
    *   @description :   This method updated the BA Level Medical Benefit Coding Case to DTU Approval Pending when Gems_Medical_BC_Flag__c is true on BA Level Medical Benefit Coding Case and  Medical under Writing Case is in Approved status.
    *   @parameters  :   List<Case> newCaseList, Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/
    /*
    public static void sendMedicalBenefitCodingCaseForDTUApproval(List<Case> newCaseList, Map<Id,Case> oldCaseMap)
    {
        Id medicalunderWriterRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
        id medicalBenefitCodinghildCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();
        
        Map<Id,Case> accountSubmissionCaseIdAndApprovedUnderWritingCaseMap = new map<Id,Case>();
        Set<Id> accountSubmissionCasesIdSet = new Set<Id>();
        List<Case> medicalBenefitCodingchilCasesList = new List<Case>();
        List<Case> medicalBenefitCodingchilCasesUpdateList = new List<Case>();
        for(Case caseRec: newCaseList)
        {
            if(caseRec.RecordtypeId==medicalunderWriterRecordTypeId && caseRec.Status != oldCaseMap.get(caseRec.Id).Status && caseRec.Status == 'Approved')
            {
                accountSubmissionCaseIdAndApprovedUnderWritingCaseMap.put(caseRec.GEMS_Account_Submission_Info__c, caseRec);
                accountSubmissionCasesIdSet.add(caseRec.GEMS_Account_Submission_Info__c);
            }
        }
        if(!accountSubmissionCasesIdSet.isEmpty() && accountSubmissionCasesIdSet!=null)
        {
            medicalBenefitCodingchilCasesList = [SELECT Id, CaseNumber, Status, GEMS_Account_Submission_Info__c, Gems_Medical_BC_Flag__c,
                                                    Gems_Medical_BC_FEAK_Flag__c , Gems_Medical_BC_Accum_Flag__c 
                                                    FROM Case WHERE GEMS_Account_Submission_Info__c IN: accountSubmissionCasesIdSet
                                                    AND RecordtypeId =: medicalBenefitCodinghildCasesRecordTypeId
                                                    ];
        }
        if(!medicalBenefitCodingchilCasesList.isEmpty() && medicalBenefitCodingchilCasesList!=null)
        {
            for(Case medBenfCodCaseRec: medicalBenefitCodingchilCasesList)
            {
                if(medBenfCodCaseRec.Status == 'In Progress'&& medBenfCodCaseRec.Gems_Medical_BC_Flag__c==true && medBenfCodCaseRec.Gems_Medical_BC_FEAK_Flag__c==false && medBenfCodCaseRec.Gems_Medical_BC_Accum_Flag__c == false)
                {
                    medBenfCodCaseRec.Status = 'DTU Approval Pending';
                    medicalBenefitCodingchilCasesUpdateList.add(medBenfCodCaseRec);
                }
                else if(medBenfCodCaseRec.Status == 'DTU Approval Received'&& medBenfCodCaseRec.Gems_Medical_BC_Flag__c==true && medBenfCodCaseRec.Gems_Medical_BC_FEAK_Flag__c==true && medBenfCodCaseRec.Gems_Medical_BC_Accum_Flag__c == false)
                {
                    medBenfCodCaseRec.Status = 'FEAK Approval Pending';
                    medicalBenefitCodingchilCasesUpdateList.add(medBenfCodCaseRec);
                }
                else if(medBenfCodCaseRec.Status == 'FEAK Approval Received'&& medBenfCodCaseRec.Gems_Medical_BC_Flag__c==true && medBenfCodCaseRec.Gems_Medical_BC_FEAK_Flag__c==true && medBenfCodCaseRec.Gems_Medical_BC_Accum_Flag__c == true)
                {
                    medBenfCodCaseRec.Status = 'Shared Accum Approval Pending';
                    medicalBenefitCodingchilCasesUpdateList.add(medBenfCodCaseRec);
                }
            }
        }
        if(!medicalBenefitCodingchilCasesUpdateList.isEmpty() && medicalBenefitCodingchilCasesUpdateList!=null)
        {
            Database.SaveResult[] SR = Database.update(medicalBenefitCodingchilCasesUpdateList);
        }
    }*/
}