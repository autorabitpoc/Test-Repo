//************************************************************************************
// Name             : GEMS_ScreeningCaseControllerBatch.cls
// Description      : This class will create screening cases in batch process (>15 BAs), else it will execute in normal flow
// Created By       : Thimmannagari Siva/Balaram Naidu Chukka
// Created Date     : 7/29/2016 
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 02/15/2018       Ranjit Gandhi       SFDC-8039 GEMS: Prod Issue - Orphan Case creating with certain criteria from the Account Submission Case
// 06/13/2017       Luke Chen           SFDC-3875 don't create dental screening if BA's product category is not dental
// 07/14/2017       Bharath             SFDC-4995 Auto-populate Quality Reviwer and BlueSTAR walkthrough account management from Submission case details for Account Setup cases.
// 07/26/2017       Shankar             SFDC-5155 Removed validations made for "2017 ASO BPA w/PBM (rev date 9/16 or later) attached?" and "Signed 2017 ASA and prior 2017 ASO BPA (rev date 6/16) attached?" checkboxes
// 09/04/2017       Shankar             SFDC-5815 Create Dental screening cases for BA's without Product but with Dental product category in Plan
// 09/08/2017       Malathi.K           SFDC-5089 Don't create Dental screening if BA's Category is Dental for Medical/Pharmacy/Medical UW/Additional UW
// 09/12/2017       Ranjit Gandhi       SFDC-4289 GEMS: Update Medical Coding BA Level Case - Page Layout/Validations
// 10/26/2017       Hari                SFDC-4753 GEMS - Trigger Manual Eligibility Case Upon Release.
// 10/29/2017       Phani K             SFDC-6747 GEMS - trigger Membership case upon "release"
// 11/21/2017       Gokul               SFDC-5205 GEMS SBC Case - code cleanup/tech debt
// 02/20/2018       Gokul               SFDC-4244 GEMS - Acct Structure - Special Handling of Complex/Co-op Accounts (Downstream Processing)
// 06/27/2018 	    Jenny Dalsania		SFDC-10234 GEMS - ID Cards - If ID Card Format question is not answered on Submission, route ID Card case to Account Submission case owner	
// ************************************************************************************

global class GEMS_ScreeningCaseControllerBatch {
    
    public GEMS_ScreeningCaseControllerBatch() {
    }   
    
    /******************************************************************** 
    *    Method Name : validatedocCheckToCreateScreening
    Action
    *   @description :   This method is to validate whether to create screening cases or not
    *   @parameters  :   String caseID
    *   @return type :   String
    ***************************************************************/  
    webservice static String validatedocCheckToCreateScreening(String caseID, Boolean userInput,Boolean reqDocsFlag){  
        String returnString = ''; 
        Case accSubCaseRec = null; 
        try {            
            Id caseBAScreeningCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
            Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();       
            Id accStructCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
            Id baLevelAccSetupRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
            Id caseManualEligibilityId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Manual Eligibility').getRecordTypeId();
            List<Case> screeningCasesNeedsToCreate = new List<Case>();
            Set<String> recordTypeIdsSet = new Set<String>{caseBAScreeningCaseRecordTypeId,accStructCaseRecordTypeId,baLevelAccSetupRecordType,caseManualEligibilityId };
                
            Set<String> divisionsSet = new Set<String>{'IL','MT','NM','OK','TX'};
            List<Case> structureCaseList = new List<Case>();
            String standardFlowCondetion = System.Label.Standard_Flow;
            List<Case> submissionRecList = new List<Case>();
            accSubCaseRec = [select id,OwnerId,GEMS_Additional_Medical_Underwriter__c,GEMS_X2017_ASO_BPA_wRx_Benefits_attached__c ,GEMS_XSigned_2017_ASA_prior_BPA_attached__c,GEMS_X2017_IL_Unified_BPA_attached__c,
                                  GEMS_Is_CBSR_required__c,GEMS_Products__c,account.name,GEMS_Submission_Type__c,GEMS_Is_Eligibility_Required__c,
                                  GEMS_Submission_Sub_Type__c ,GEMS_Line_of_Business__c ,isClosed,GEMS_Benefit_Booklet_Required__c,GEMS_Effective_Date__c,GEMS_BCC_Products__c,
                                  Account.External_ID__c,type,FSU_Location__c,Expected_No_of_paper_application__c,Account_Executive__c,HCSC_Division__c,GEMS_Rx_Vendor__c,GEMS_StdCust_Product__c,
                                  GEMS_Medical_Underwriter__c,Sales_Executive__c,GEMS_OE_Eligibility_Method__c,Productid,status,GEMS_Case_Effective_Date__c,Opportunity_Name__c,Funding_Type__c,
                                  Funding_Type_Multiselect__c,GEMS_AEP_Account__c,GEMS_All_required_documents_attached__c ,GEMS_Integrated__c,GEMS_Grandfathered_benefits__c,GEMS_Bank__c,
                                  GEMS_Are_commissions_paid_for_account__c,GEMS_Are_commissions_changing__c,GEMS_Target_Date_Production_OE_File__c, GEMS_Actual_Date_Production_OE_File__c,
                                  GEMS_Performance_Guarantees__c,Is_screening_case_creation_is_in_progres__c,GEMS_Ready_to_release_to_screening__c,(select Attachment__c,Description__c,Type__c from GEMS_Attachments__r),
                                  (select id,GEMS_Is_Eligibility_Required__c, casenumber,Status,recordTypeId,isClosed, GEMS_Effective_Date__c, Account.External_ID__c,Account.Name, GEMS_Case_Effective_Date__c, GEMS_Account_Submission_Info__c,
                                   Accountid, GEMS_Are_commissions_paid_for_account__c, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, HCSC_Division__c, GEMS_Line_of_Business__c, Opportunity_Name__c,
                                   Funding_Type_Multiselect__c,GEMS_Account_Submission_Info__r.OwnerId,GEMS_Rx_Vendor__c,Is_screening_case_creation_is_in_progres__c, GEMS_Account_Submission_Info__r.FSU_Location__c, 
                                   parentId, GEMS_StdCust_Product__c,GEMS_Submitter__c,GEMS_Account_Submission_Info__r.GEMS_OE_Eligibility_Method__c,GEMS_Products__c from Cases1__r where recordtypeid In : recordTypeIdsSet )                
                                  FROM case WHERE Id =:caseID and recordtypeid=:caseAccountSubmissionId ];                            
                                            
                                 
            system.debug('before');
            
                           
            if(accSubCaseRec != null && !accSubCaseRec.Is_screening_case_creation_is_in_progres__c ) {
                Boolean caseASOFundType = false;
                Boolean attachedString = false;
                List<GEMS_Process_Metadata__mdt> standardMetaDataList = [select Account_Submission_Type__c, Account_Submission_Sub_Type__c, Create_Process__c 
                from GEMS_Process_Metadata__mdt where Create_Process__c = true and Account_Submission_Type__c =: accSubCaseRec.GEMS_Submission_Type__c AND Account_Submission_Sub_Type__c =: accSubCaseRec.GEMS_Submission_Sub_Type__c AND GEMS_Product__c='Process Flow' ];                                
                submissionRecList.add(accSubCaseRec);    
                Case accStructCase = null;
                Boolean screeningsAlreadyExists = false;
                Boolean setupProcessAlreadyExists = false;
                List<Case> screeningStructureCases = accSubCaseRec.Cases1__r;
                for(Case screeningORstructure : screeningStructureCases) {
                    if(screeningORstructure.recordTypeId == accStructCaseRecordTypeId ) {
                        accStructCase = screeningORstructure;
                    }
                    if(screeningORstructure.recordTypeId == caseBAScreeningCaseRecordTypeId) {
                        screeningsAlreadyExists = true;
                        break;
                    }
                    if(screeningORstructure.recordTypeId == baLevelAccSetupRecordType) {
                        setupProcessAlreadyExists = true;
                        break;
                    }
                }
                screeningCasesNeedsToCreate.add(accSubCaseRec);
                if(accStructCase != null && (accStructCase.status =='Client Approval Received' || accStructCase.status == 'BlueSTAR Sent' || accStructCase.status == 'BlueSTAR Shell Created' 
                 || accStructCase.status == 'BlueSTAR Failed' || accStructCase.status == 'BlueSTAR Partial Fail')){
                     
                 }else {
                     returnString = returnString+'Structure case status should be Client Approval Received to create Screening / Process';
                 }
                
                // 5155 - Removed validation on "2017 ASO BPA w/PBM (rev date 9/16 or later) attached?" and "Signed 2017 ASA and prior 2017 ASO BPA (rev date 6/16) attached?" fields                
                
                if(accSubCaseRec.HCSC_Division__c == 'IL' && accSubCaseRec.Funding_Type_Multiselect__c != null && 
                    accSubCaseRec.Funding_Type_Multiselect__c.contains('Cost Plus') &&  accSubCaseRec.GEMS_Rx_Vendor__c != null && accSubCaseRec.GEMS_Rx_Vendor__c.contains('Prime')) {
                    if(accSubCaseRec.GEMS_X2017_IL_Unified_BPA_attached__c == null ) {
                        if(attachedString) {
                            returnString = returnString+'\n   2017 IL Unified HMO/Non-HMO BPA (revision date 8/16 or later) attached?';
                        } else {
                             returnString = returnString+'\n Please fill the following required fields before clicking Release button';
                             returnString = returnString+'\n   2017 IL Unified HMO/Non-HMO BPA (revision date 8/16 or later) attached?';
                         }
                        //returnString = returnString+'\n 2017 IL Unified BPA attached? is Required';
                    }
                }
                if(accSubCaseRec.GEMS_Are_commissions_changing__c == null && accSubCaseRec.GEMS_Submission_Type__c=='Renewal'){
                    if(attachedString) {
                        returnString = returnString+'\n   Are commissions changing?';
                    } else {
                         returnString = returnString+'\n Please fill the following required fields before clicking Release button';
                         returnString = returnString+'\n   Are commissions changing?';
                     }
                }
                if(accSubCaseRec.GEMS_Are_commissions_paid_for_account__c == null && (accSubCaseRec.GEMS_Submission_Type__c=='New Account'||accSubCaseRec.GEMS_Submission_Type__c=='Renewal')) {
                    if(attachedString) {
                        returnString = returnString+'\n   Are commissions paid for this account?';
                    } else {
                         returnString = returnString+'\n Please fill the following required fields before clicking Release button';
                         returnString = returnString+'\n   Are commissions paid for this account?';
                     }
                }
                Boolean excessLossAttachmentFound = false;
                Boolean stopLossAttachmentFound = false;
                Boolean excessLossRequired = false;
                Boolean stopLossRequired = false;
                if(accSubCaseRec.GEMS_Products__c != null && ((accSubCaseRec.GEMS_Products__c.contains('Stop Loss') && accSubCaseRec.Funding_Type_Multiselect__c != null && accSubCaseRec.Funding_Type_Multiselect__c.contains('ASO')) || (accSubCaseRec.GEMS_Products__c.contains('Excess Loss') && accSubCaseRec.Funding_Type_Multiselect__c != null && accSubCaseRec.Funding_Type_Multiselect__c.contains('Cost Plus') )) ) {
                   
                   for(GEMS_Attachment__c attachment : accSubCaseRec.GEMS_Attachments__r ) {
                       if(attachment.Type__c == 'EXCESS LOSS POLICY APPLICATION') {
                           excessLossAttachmentFound = true;
                       }
                       
                       if(attachment.Type__c == 'STOP LOSS APPLICATION') {
                           stopLossAttachmentFound = true;
                       }
                   }
                   if(!excessLossAttachmentFound && accSubCaseRec.GEMS_Products__c.contains('Excess Loss')  && accSubCaseRec.Funding_Type_Multiselect__c != null && accSubCaseRec.Funding_Type_Multiselect__c.contains('Cost Plus')) {
                       excessLossRequired = true;
                   } 
                   if(!stopLossAttachmentFound && (accSubCaseRec.GEMS_Products__c.contains('Stop Loss') && accSubCaseRec.Funding_Type_Multiselect__c != null && accSubCaseRec.Funding_Type_Multiselect__c.contains('ASO'))) {
                       stopLossRequired = true;
                   }
                }
                
                //if database value is true set required docs to true else set reqDocsFlag value
                Boolean databaseReqDocCheck = true;
                System.debug('==========>'+accSubCaseRec.GEMS_Attachments__r);
                System.debug('==========>'+reqDocsFlag);
                
                if(accSubCaseRec.GEMS_Attachments__r == null || accSubCaseRec.GEMS_Attachments__r.isEmpty()){
                    databaseReqDocCheck = false;
                }  
                     
               if((accSubCaseRec.GEMS_StdCust_Product__c == 'Standard Products only' || databaseReqDocCheck) && returnString == '') {                  
                     structureCaseList.add(accStructCase);
                     if(!screeningsAlreadyExists && !setupProcessAlreadyExists) {
                         String confirmString = '';
                         if(!excessLossAttachmentFound && !stopLossAttachmentFound && excessLossRequired && stopLossRequired) {
                             confirmString = 'For Cost Plus groups with Excess Loss, ‘Excess Loss Policy Application’ is required.\nFor ASO groups with Stop Loss, the Stop Loss Application is required.\n';
                          }else if(!excessLossAttachmentFound && excessLossRequired) {
                              confirmString = 'For Cost Plus groups with Excess Loss, ‘Excess Loss Policy Application’ is required.\n';
                          }else if(!stopLossAttachmentFound && stopLossRequired) {
                              confirmString = 'For ASO groups with Stop Loss, the Stop Loss Application is required.\n';
                          }
                         if(userInput) {
                             createManualEligibilityCase(submissionRecList);  
                             if(!accSubCaseRec.Is_screening_case_creation_is_in_progres__c) {
                                accSubCaseRec.Is_screening_case_creation_is_in_progres__c = true;
                                update accSubCaseRec;
                            }
                             if(standardMetaDataList.isEmpty() && accSubCaseRec.GEMS_StdCust_Product__c != 'Standard Products only') {
                                 Integer totalBAs = 0;
                                 AggregateResult[] groupedResults = [select count(Id) totalBA from GEMS_Benefit_Agreement__c where AccountStructureCase__c =:accStructCase.Id and HAS_GROUP_SECTIONS__C = true and ISCANCELLED__C = false and GEMS_BAs_SpHandling__c = true];
                                 for (AggregateResult ar : groupedResults)  {
                                    totalBAs = (Integer)ar.get('totalBA');
                                    break;
                                 }
                                 String baLimit = Label.GEMS_BA_Limit;
                                 Integer baCount = Integer.ValueOf(baLimit);
                                 if(totalBAs <= baCount) {
                                     GEMS_ScreeningCaseControllerBatch.SCFutureClass scClass = new GEMS_ScreeningCaseControllerBatch.SCFutureClass();
                                     scClass.screeningCasesNeedsToCreate = screeningCasesNeedsToCreate;
                                     scClass.accStructCase = accStructCase;
                                     scClass.structureCaseList = structureCaseList;
                                     GEMS_ScreeningCaseControllerBatch.createScreeningCasesFuture(JSON.serializePretty(scClass));
                                 }else {                             
                                     GEMS_ScreeningCaseControllerBatch.createScreeningCasesBatch(screeningCasesNeedsToCreate,accStructCase,structureCaseList  );
                                 }
                                 return 'Screening cases creation is in progress';
                             }else {
                                 GEMS_ScreeningCaseControllerBatch.StandardProductFutureClass scClass = new GEMS_ScreeningCaseControllerBatch.StandardProductFutureClass();
                                 scClass.structureCaseList = structureCaseList;
                                 scClass.subCaseRec = accSubCaseRec;
                                 GEMS_ScreeningCaseControllerBatch.createStandardProductProcessCasesFuture(JSON.serializePretty(scClass));
                                 returnString = 'Process cases creation is in progress';
                             }
                         }else if(accSubCaseRec.GEMS_StdCust_Product__c == 'Standard Products only'){
                             confirmString = confirmString+'Are you sure you want to release this case to Process ?';
                             return confirmString;
                         }else if(!standardMetaDataList.isEmpty()) {
                             confirmString = confirmString+'Are you sure you want to release this case with Standard Product Flow ?';
                             return confirmString;
                         }else {
                             confirmString = confirmString+'Are you sure you want to release this case to Screening ?';
                             return confirmString;
                         }
                         
                     }else if(setupProcessAlreadyExists){
                         return 'Process cases already created';
                     }else {
                         return 'Screening cases already created';
                     }                           
                 }else {                        
                     String reqDocs = '';
                     if(accSubCaseRec.GEMS_StdCust_Product__c != 'Standard Products only' && !databaseReqDocCheck) {                                                
                        reqDocs = '\n Please upload at least one document before release to screening.';                                                       
                     }
                     returnString = returnString+'\n'+reqDocs;                      
                 } 
            }else {
                return 'Screening case creation already initiated Please wait.. ';
            }
        }
        catch(Exception ex) {
            System.debug('Exception'+ex.getMessage());
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'GEMS_ScreeningCaseControllerBatch', 'Case', null, 'validatedocCheckToCreateScreening(String caseID, Boolean userInput,Boolean reqDocsFlag)','High');
            if(accSubCaseRec != null ) {
                accSubCaseRec.Is_screening_case_creation_is_in_progres__c = false;
            }
        }
        if(returnString == '' && returnString.length() == 0) {
            returnString = null;
        }
        return returnString;
    }
    
    
    public class SCFutureClass{
        public List<Case> screeningCasesNeedsToCreate = new list<case>();
        public Case accStructCase = new Case();
        public List<Case> structureCaseList = new List<case>();
    }
    
    public class StandardProductFutureClass{
        public List<Case> structureCaseList = new List<case>();
        public Case subCaseRec = new Case();
    }
    
    @future
    public static void createStandardProductProcessCasesFuture(string scclass) {
        
        GEMS_ScreeningCaseControllerBatch.StandardProductFutureClass hl = (GEMS_ScreeningCaseControllerBatch.StandardProductFutureClass) JSON.deserialize(scclass, GEMS_ScreeningCaseControllerBatch.StandardProductFutureClass.class);
        
        try {
            createStandardProductProcessCases(hl.structureCaseList,hl.subCaseRec);
        } catch (Exception e) {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'GEMS_ScreeningCaseControllerBatch', 'Case', null, 'createStandardProductProcessCasesFuture(string scclass)','High');
        }
        
    }
    
    @future
    public static void createScreeningCasesFuture(string scclass) {
        
        GEMS_ScreeningCaseControllerBatch.SCFutureClass hl = (GEMS_ScreeningCaseControllerBatch.SCFutureClass) JSON.deserialize(scclass, GEMS_ScreeningCaseControllerBatch.SCFutureClass.class);
        
        try {
            createScreeningCases(hl.screeningCasesNeedsToCreate, hl.accStructCase, hl.structureCaseList);
        } catch (Exception e) {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'GEMS_ScreeningCaseControllerBatch', 'Case', null, 'createScreeningCasesFuture(string scclass)','High');
        }
        
    }
    
/******************************************************************** 
*    Method Name : createScreeningCasesBatch
Action
*   @description :   This method to create screening cases through Batch(>15 BAs)
*   @parameters  :   (List<Case> screeningCasesNeedsToCreate, Case accStructCase, List<Case> structureCaseList)
*   @return type :   void
***************************************************************/
    public static void createScreeningCasesBatch(List<Case> screeningCasesNeedsToCreate, Case accStructCase, List<Case> structureCaseList) {
        Map<String,List<Case>> screeningCasesMap = new Map<String,List<Case>>();
        List<Case> screeningCasesInsertList = new List<Case>();
        Id caseBAScreeningCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        try {
        /*Case submissionCaseActual = screeningCasesNeedsToCreate[0];
        if(!submissionCaseActual.Is_screening_case_creation_is_in_progres__c) {
            submissionCaseActual.Is_screening_case_creation_is_in_progres__c = true;
            update submissionCaseActual;
        }*/
        screeningCasesMap = GEMS_AccountScreeningCaseCreation.screeningCasesCreation(screeningCasesNeedsToCreate,true);
        }catch(Exception e) {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'GEMS_ScreeningCaseControllerBatch', 'Case', null, 'createScreeningCasesBatch(List<Case> screeningCasesNeedsToCreate, Case accStructCase, List<Case> structureCaseList)','High');
        }
        Map<Id,List<GEMS_Benefit_Agreement__c>> subCaseIdBenfAggListMap = new Map<Id,List<GEMS_Benefit_Agreement__c>>();
        Map<ID,List<GEMS_Benefit_Agreement__c>> caseIdAndBenefitAgreementMap = new Map<ID,List<GEMS_Benefit_Agreement__c>>();
        
        // SFDC-5815 Added Plan__r.Product__r.Product_Category__c to query
        // SFDC-4244 Added new field filter for selected BA
        List<GEMS_Benefit_Agreement__c> benefitAgreementList = [SELECT ID, Name, AccountStructureCase__c,
                                                                 AccountStructureCase__r.account.name,
                                                                 AccountStructureCase__r.Account.External_ID__c,
                                                                 AccountStructureCase__r.GEMS_Account_Submission_Info__c,
                                                                 AccountStructureCase__r.GEMS_Account_Submission_Info__r.OwnerId,
                                                                 AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_ID_Cards_Format__c,
                                                                 AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c,
                                                                 Product__c, Product__r.name, Product__r.Product_Category__c, Plan__r.Product__r.Product_Category__c
                                                                 from GEMS_Benefit_Agreement__c where AccountStructureCase__c=: accStructCase.Id and HAS_GROUP_SECTIONS__C =true and ISCANCELLED__C = false and GEMS_BAs_SpHandling__c = true];
         
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
         try
         {      
             Case caseRecord = structureCaseList.get(0);
                 List<Case> businessAreaCaseList = screeningCasesMap.get(caseRecord.parentId);
             if( !businessAreaCaseList.isEmpty()) {
             
                 List<GEMS_Benefit_Agreement__c> businessAggrements = caseIdAndBenefitAgreementMap.get(caseRecord.Id);
                 ChildScreeningBatch ascScreeing = new ChildScreeningBatch(businessAreaCaseList,caseRecord,businessAggrements, structureCaseList, subCaseIdBenfAggListMap);
                 Database.executebatch(ascScreeing);
                 
                 if(!screeningCasesNeedsToCreate.isEmpty()) {
                     screeningCasesNeedsToCreate.get(0).GEMS_Ready_to_release_to_screening__c = 'Released';
                     screeningCasesNeedsToCreate.get(0).GEMS_Released_to_Screening_Date__c = System.now();
                     screeningCasesNeedsToCreate.get(0).Is_screening_case_creation_is_in_progres__c = false;
                     update screeningCasesNeedsToCreate;
                 }
             }
         }
         Catch(Exception ex)
         {
             CreateExceptionLog.insertErrorLog(ex, null, null, null, 'GEMS_ScreeningCaseControllerBatch', 'Case', null, 'createScreeningCasesBatch(List<Case> screeningCasesNeedsToCreate, Case accStructCase, List<Case> structureCaseList)','High');
         }
    }
    /******************************************************************** 
*    Method Name : createScreeningCases
Action
*   @description :   This method to create screening cases (<15 BAs) as part of normal flow
*   @parameters  :   (List<Case> screeningCasesNeedsToCreate, Case accStructCase, List<Case> structureCaseList)
*   @return type :   void
***************************************************************/
    public static void createScreeningCases(List<Case> screeningCasesNeedsToCreate, Case accStructCase, List<Case> structureCaseList) {
        Map<String,List<Case>> screeningCasesMap = new Map<String,List<Case>>();
        List<Case> screeningCasesInsertList = new List<Case>();
        Id caseBAScreeningCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        Case submissionCaseActual = screeningCasesNeedsToCreate[0];
        Map<Id,List<GEMS_Benefit_Agreement__c>> subCaseIdBenfAggListMap = new Map<Id,List<GEMS_Benefit_Agreement__c>>();
        Map<ID,List<GEMS_Benefit_Agreement__c>> caseIdAndBenefitAgreementMap = new Map<ID,List<GEMS_Benefit_Agreement__c>>();
        String[] submissionSubtype = null;
        List<GEMS_Process_Metadata__mdt> processMetaData = null;
        try {
            /*if(!submissionCaseActual.Is_screening_case_creation_is_in_progres__c) {
                submissionCaseActual.Is_screening_case_creation_is_in_progres__c = true;
                update submissionCaseActual;
            }*/
            screeningCasesMap = GEMS_AccountScreeningCaseCreation.screeningCasesCreation(screeningCasesNeedsToCreate,true);
            System.debug('screeningCasesMap ====>'+screeningCasesMap );
        }catch(Exception e) {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'GEMS_ScreeningCaseControllerBatch', 'Case', null, 'createScreeningCases(List<Case> screeningCasesNeedsToCreate, Case accStructCase, List<Case> structureCaseList)','High');
        }        
        if(submissionCaseActual.GEMS_Submission_Sub_Type__c != null ) {
            submissionSubtype = submissionCaseActual.GEMS_Submission_Sub_Type__c.split(';');
        }
        
        if(submissionSubtype != null) {
             processMetaData = GEMS_Utility.retriveCustomMetaDataByProductTypeIndividual(submissionCaseActual.GEMS_Submission_Type__c,Label.GEMS_Custom_Products,submissionSubtype);                   
        }
        // SFDC-5815. Added Plan__r.Product__r.Product_Category__c to query
        // SFDC-4244 Added new field filter for selected BA
        List<GEMS_Benefit_Agreement__c> benefitAgreementList = [SELECT ID, Name, AccountStructureCase__c,
                                                                 AccountStructureCase__r.account.name,
                                                                 AccountStructureCase__r.Account.External_ID__c,
                                                                 AccountStructureCase__r.GEMS_Account_Submission_Info__c,
                                                                 AccountStructureCase__r.GEMS_Account_Submission_Info__r.OwnerId,
                                                                 AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_ID_Cards_Format__c,
                                                                 AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c,
                                                                 Product__c, Product__r.name, Product__r.Product_Category__c, Plan__r.Product__r.Product_Category__c
                                                                 from GEMS_Benefit_Agreement__c where AccountStructureCase__c=: accStructCase.Id and HAS_GROUP_SECTIONS__C =true and ISCANCELLED__C = false and GEMS_BAs_SpHandling__c = true];
         
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
          
         if(processMetaData == null || 
            (processMetaData != null && 
             processMetaData.size() > 0 && 
             GEMS_Utility.findBusinessAreaInMetaData(submissionCaseActual,processMetaData,'ID Card'))) {
            	createIdCardParentChildCase(structureCaseList, subCaseIdBenfAggListMap);
         }       
        ////SFDC-6747 GEMS - trigger Membership case upon "release"
        if( processMetaData == null || (processMetaData != null && processMetaData.size() > 0 && GEMS_Utility.findBusinessAreaInMetaData(submissionCaseActual,processMetaData,'Membership'))) {
            createMembershipCase(structureCaseList, subCaseIdBenfAggListMap.keySet());
         }       
        
        /*US-5205
        createSBCParentChildCase(structureCaseList, subCaseIdBenfAggListMap);
        System.debug('==sbc complete==>');
        */
         for(Case caseRecord : structureCaseList) {
             List<Case> businessAreaCaseList = screeningCasesMap.get(caseRecord.parentId);
             System.debug('businessAreaCaseList =====>'+businessAreaCaseList );
             if( !businessAreaCaseList.isEmpty()) {
                 for(Case businessAreacase : businessAreaCaseList) {
                     List<GEMS_Benefit_Agreement__c> businessAggrements = caseIdAndBenefitAgreementMap.get(caseRecord.Id);
                     if( !businessAggrements.isEmpty()) {
                         for(GEMS_Benefit_Agreement__c befAgrRec: businessAggrements) {
                             
                             // SFDC-SFDC-3875 don't create dental screening if BA's product category is not dental
                             // SFDC-5815. Modified condition check to look for dental product cateogry from plan as well
                             if((businessAreacase.Sub_Category__c == 'Dental Benefit Coding Screening' || businessAreacase.Sub_Category__c == 'Dental Underwriting Screening' ) && 
                                     befAgrRec.Product__r.Product_Category__c != 'Dental' && befAgrRec.Plan__r.Product__c != null && befAgrRec.Plan__r.Product__r.Product_Category__c != 'Dental') continue;
                                     
                           // SFDC-5089 Don't create dental screening for Medical/Pharmacy/Medical UW/Additional UW if BA's product category is dental                                     
                             if((businessAreacase.Sub_Category__c == 'Benefit Coding Screening' || businessAreacase.Sub_Category__c == 'Pharmacy Coding Screening' 
                                 || businessAreacase.Sub_Category__c == 'Medical Underwriting Screening' || businessAreacase.Sub_Category__c == 'Additional Underwriting' || businessAreacase.Sub_Category__c == 'Additional Medical Underwriter Screening') && 
                                   (befAgrRec.Product__r.Product_Category__c == 'Dental' || befAgrRec.Plan__r.Product__r.Product_Category__c == 'Dental')) continue;
                                    
                                     
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
                             //Code Changed for October Release
                             screeningCase.GEMS_Submitter__c = befAgrRec.AccountStructureCase__r.GEMS_Account_Submission_Info__r.OwnerId;
                             // This population is for October Hotfix 2016
                             screeningCase.Funding_Type_Multiselect__c = businessAreacase.Funding_Type_Multiselect__c;                
                             screeningCase.GEMS_StdCust_Product__c = businessAreacase.GEMS_StdCust_Product__c;
                             screeningCase.GEMS_Rx_Vendor__c = businessAreacase.GEMS_Rx_Vendor__c;
                             screeningCase.GEMS_Line_of_Business__c=businessAreacase.GEMS_Line_of_Business__c;
                             screeningCase.GEMS_Benefit_Booklet_Required__c = businessAreacase.GEMS_Benefit_Booklet_Required__c;
                             
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
         try
         {
             if(!screeningCasesInsertList.isEmpty()) {
                 insert screeningCasesInsertList;                                                             
             }
             if(!screeningCasesNeedsToCreate.isEmpty()) {
                 screeningCasesNeedsToCreate.get(0).GEMS_Ready_to_release_to_screening__c = 'Released';
                 screeningCasesNeedsToCreate.get(0).GEMS_Released_to_Screening_Date__c = System.now();
                 screeningCasesNeedsToCreate.get(0).Is_screening_case_creation_is_in_progres__c = false;
                 update screeningCasesNeedsToCreate;
             }
         }
         catch(Exception ex)
         {
             CreateExceptionLog.insertErrorLog(ex, null, null, null, 'GEMS_ScreeningCaseControllerBatch', 'Case', null, 'createScreeningCases(List<Case> screeningCasesNeedsToCreate, Case accStructCase, List<Case> structureCaseList)','High');
         }
    }
    
    
    /******************************************************************** 
    *    Method Name : createIdCardParentChildCase
    Action
    *   @description :   This method to create parent child ID card cases
    *   @parameters  :   List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap
    *   @return type :   void
    ***************************************************************/
    public static void createIdCardParentChildCase(List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap) {
        List<Case> custIdParentCasesInsertList = new List<Case>();
        List<Case> custIdChildCasesInsertList = new List<Case>();
        try {
        Id customIdCardParentRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        //Id customIdCardChildRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level ID Card').getRecordTypeId();
        
        Set<ID> subCaseIdsSet = new Set<ID>();
        subCaseIdsSet=subIdListBenfMap.keySet();
        Map<Id,Case> submissionIdMap = new Map<Id,Case>();
        //List<Case> subCaseChildCasesList = [SELECT ID, GEMS_Account_Submission_Info__c,RecordTypeId from Case WHERE GEMS_Account_Submission_Info__c IN: subCaseIdsSet];
        /* --------------- */
        List<GEMS_CaseOwnership_MetaData__mdt> caseOwnerMetadata = [select Case_Team_Member__c,Que_Name__c from GEMS_CaseOwnership_MetaData__mdt where Type_Of_Case__c ='ID Card' ];
        List<case> subCaseRecChildIDCardCasesList = [select id, Status, OwnerId, recordtypeid, GEMS_Accum_Type__c,GEMS_BCC_Products__c, 
                                                     GEMS_Account_Submission_Info__c, GEMS_Case_Effective_Date__c,Account_Number__c,
                                                     FSU_Location__c,GEMS_AEP_Account__c,Opportunity_Name__c,GEMS_Products__c,
                                                     GEMS_Line_of_Business__c,HCSC_Division__c,Account_Name__c,GEMS_StdCust_Product__c,
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
                submissionIdMap.put(subCaseRec.Id, subCaseRec );
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
                parentIdCase.recordTypeId =customIdCardParentRecordTypeId;
                if( benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_ID_Cards_Format__c !=null && 
                   benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_ID_Cards_Format__c=='Standard' && 
                   subIdAccSpecialistMemberMap.containsKey(strCaseRec.GEMS_Account_Submission_Info__c) && 
                   subIdAccSpecialistMemberMap.get(strCaseRec.GEMS_Account_Submission_Info__c).memberid != null ) {
                   		parentIdCase.ownerId=subIdAccSpecialistMemberMap.get(strCaseRec.GEMS_Account_Submission_Info__c).memberid;
                } else if( benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_ID_Cards_Format__c !=null && 
                          benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_ID_Cards_Format__c=='Custom' && 
                          benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.OwnerId != null) {
                    parentIdCase.ownerId=benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.OwnerId;
                } else {
                    //SFDC-10234 Do not assign ID Card case to unmanaged queue when ID card format is blank
                     parentIdCase.ownerId=benfAggList[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.OwnerId;
                    //parentIdCase.ownerId=accSpecGroup.Id;
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
                //parentIdCase.Eligibility_Process_Case_Status__c='In Progress';  //added by harsha 
                parentIdCase.GEMS_OE_Eligibility_Method__c =strCaseRec.GEMS_Account_Submission_Info__r.GEMS_OE_Eligibility_Method__c;//added by harsha 
                parentIdCase.GEMS_Rx_Vendor__c = strCaseRec.GEMS_Rx_Vendor__c;
                // This population is for October Hotfix 2016                 
                parentIdCase.GEMS_StdCust_Product__c = submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).GEMS_StdCust_Product__c;
                parentIdCase.GEMS_Submitter__c = submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).ownerId;
                 
                custIdParentCasesInsertList.add(parentIdCase);
            }
        }
        if(!custIdParentCasesInsertList.isEmpty())
        {
            insert custIdParentCasesInsertList;
        }
        System.Debug('parent insert =====>' +custIdParentCasesInsertList);

        //SFDC-3064 - Remove child ID card cases associations
        
        }
        catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'GEMS_ScreeningCaseControllerBatch', 'Case', null, 'createIdCardParentChildCase(List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap)','High');
        }
    }
    
    
    /******************************************************************** 
    *    Method Name : createMembershipCase
    Action
    *   @description :   This method to create membership case.Created as part of SFDC-6747 GEMS - trigger Membership case upon "release"
    *   @parameters  :   List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap
    *   @return type :   void
    ***************************************************************/
    public static void createMembershipCase(List<Case> clientApprovalReceivedCasesList, Set<ID> subCaseIdsSet) {
        List<Case> membershipParentCasesInsertList = new List<Case>();
        try {
            Id membershipParentRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Membership').getRecordTypeId();
            Map<Id,Case> submissionIdMap = new Map<Id,Case>();
            List<GEMS_CaseOwnership_MetaData__mdt> caseOwnerMetadata = [select Case_Team_Member__c,Que_Name__c from GEMS_CaseOwnership_MetaData__mdt where Type_Of_Case__c ='FSU Membership' ];
            List<case> subCaseRecChildMembershipCasesList = [select id, Status, OwnerId, recordtypeid, GEMS_Accum_Type__c,GEMS_BCC_Products__c, 
                                                         GEMS_Account_Submission_Info__c, GEMS_Case_Effective_Date__c,Account_Number__c,
                                                     FSU_Location__c,GEMS_AEP_Account__c,Opportunity_Name__c,GEMS_Products__c,
                                                     GEMS_Line_of_Business__c,HCSC_Division__c,Account_Name__c,GEMS_StdCust_Product__c,
                                                     GEMS_Submission_Sub_Type__c,Accountid,GEMS_Effective_Date__c,GEMS_Submission_Type__c ,
                                                     (select id,RecordTypeId,status, GEMS_Account_Submission_Info__c 
                                                      from Cases1__r where recordtypeid  =:membershipParentRecordTypeId),
                                                     (select parentId,memberid,TeamRole.name from TeamMembers
                                                      where TeamRole.name =: caseOwnerMetadata[0].Case_Team_Member__c)
                                                     from case where id = :subCaseIdsSet];
        
            Map<Id,Boolean> subCaseIdMembershipRecFoundMap = new Map<Id,Boolean>();
            Map<Id, caseTeamMember> subIdFSUAnalystMemberMap = new Map<Id, caseTeamMember>();
            Group accSpecGroup =[select Id from Group where Name =: caseOwnerMetadata[0].Que_Name__c and Type = 'Queue' LIMIT 1];
            Boolean MembershipRecFound = false;
            if(!subCaseRecChildMembershipCasesList.isEmpty() && subCaseRecChildMembershipCasesList != null) {
                for(case subCaseRec : subCaseRecChildMembershipCasesList) {
                    submissionIdMap.put(subCaseRec.Id, subCaseRec );
                    List<Case> tempCaseList = new List<Case>();
                    tempCaseList=subCaseRec.Cases1__r;
                    if(!subCaseRec.TeamMembers.isEmpty()){
                        subIdFSUAnalystMemberMap.put(subCaseRec.Id,subCaseRec.TeamMembers[0]);
                    }
                    if(tempCaseList.Size()>0){
                        MembershipRecFound=true;
                        subCaseIdMembershipRecFoundMap.put(subCaseRec.Id,MembershipRecFound);
                        break;
                    } else {
                        MembershipRecFound=false;
                        subCaseIdMembershipRecFoundMap.put(subCaseRec.Id,MembershipRecFound);
                    }
                }
            }
            if (!subCaseIdMembershipRecFoundMap.isEmpty()) {
                    for (Case strCaseRec: clientApprovalReceivedCasesList) {
                        Boolean MembershipCaseRecFound = subCaseIdMembershipRecFoundMap.get(strCaseRec.GEMS_Account_Submission_Info__c);
                        if(!MembershipCaseRecFound) {
                            case newCase = new case ();
                            newCase.GEMS_Account_Submission_Info__c = strCaseRec.GEMS_Account_Submission_Info__c;
                            newCase.parentid = strCaseRec.GEMS_Account_Submission_Info__c;
                            newCase.Accountid = strCaseRec.Accountid;
                            newCase.GEMS_Case_Effective_Date__c = strCaseRec.GEMS_Case_Effective_Date__c;
                            newCase.GEMS_Submission_Type__c = strCaseRec.GEMS_Submission_Type__c;
                            newCase.GEMS_Submission_Sub_Type__c = strCaseRec.GEMS_Submission_Sub_Type__c;
                            if(subIdFSUAnalystMemberMap.containsKey(strCaseRec.GEMS_Account_Submission_Info__c) && subIdFSUAnalystMemberMap.get(strCaseRec.GEMS_Account_Submission_Info__c).memberid != null ) {
                                newCase.ownerId=subIdFSUAnalystMemberMap.get(strCaseRec.GEMS_Account_Submission_Info__c).memberid;
                            } else {
                                newCase.ownerId=accSpecGroup.Id;
                            }
                            DateTime effectiveDate = submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).GEMS_Case_Effective_Date__c;
                            newCase.Subject = submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).Account_Name__c + ' ' + submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).Account_Number__c + ' ' + effectiveDate.format('M/d/yyyy') + ' GEMS Membership';
                            newCase.status = 'In Progress';
                            newCase.type = 'Membership';
                            newCase.GEMS_Products__c = submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).GEMS_Products__c;
                            newCase.HCSC_Division__c = strCaseRec.HCSC_Division__c;
                            newCase.GEMS_Line_of_Business__c = strCaseRec.GEMS_Line_of_Business__c;
                            newCase.FSU_Location__c = submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).FSU_Location__c;
                            newCase.Opportunity_Name__c = strCaseRec.Opportunity_Name__c;
                            newCase.GEMS_AEP_Account__c = strCaseRec.GEMS_AEP_Account__c;
                            newCase.recordTypeId = membershipParentRecordTypeId;
                            newCase.GEMS_Effective_Date__c = strCaseRec.GEMS_Effective_Date__c;
                            newCase.Funding_Type_Multiselect__c = strCaseRec.Funding_Type_Multiselect__c;
                            newCase.GEMS_StdCust_Product__c = submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).GEMS_StdCust_Product__c;
                            newCase.GEMS_Rx_Vendor__c = strCaseRec.GEMS_Rx_Vendor__c;
                            newCase.GEMS_Submitter__c = submissionIdMap.get(strCaseRec.GEMS_Account_Submission_Info__c).ownerId;
                            newCase.GEMS_Is_Eligibility_Required__c = strCaseRec.GEMS_Is_Eligibility_Required__c;
                            membershipParentCasesInsertList.add(newCase);
                        }
                    }
                    System.Debug('membership insert =====>' +membershipParentCasesInsertList);
                    List < Task > taskInsertList = new List < Task > ();
                    Database.UpsertResult[]childSaveResult;
                    if (!membershipParentCasesInsertList.isEmpty()) {
                        childSaveResult = Database.upsert(membershipParentCasesInsertList);
                    }
                    integer i = 0;
                    if (childSaveResult != null) {
                        System.debug('======creating task for membership======');
                        for (Database.UpsertResult sr: childSaveResult) {
                            if (sr.isSuccess()) {
                                Case memCase = membershipParentCasesInsertList.get(i);
                                Task memTask = new Task();
                                memTask.WhatId = memCase.Id;
                                memTask.Subject = 'Membership Entry Complete';
                                memTask.Status = 'In Progress';
                                memTask.Priority = 'Normal';
                                memTask.GEMS_Start_Date__c = System.now();
                                System.debug('memCase.GEMS_Account_Submission_Info__c===>' + memCase.GEMS_Account_Submission_Info__c);
                                if (memCase.ownerId == null && subIdFSUAnalystMemberMap.get(memCase.GEMS_Account_Submission_Info__c) != null) {
                                    memTask.ownerId = subIdFSUAnalystMemberMap.get(memCase.GEMS_Account_Submission_Info__c).memberid;
                                } else if (memCase.ownerId != null && !(string.valueOf(memCase.OwnerID).startsWith('00G'))) {
                                    memTask.ownerId = memCase.ownerId;
                                }
                                taskInsertList.add(memTask);
                            }
                            i++;
                        }
                    }
                    if (!taskInsertList.isEmpty())
                        Database.insert(taskInsertList);
                }
            } catch(Exception ex) {
                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'GEMS_ScreeningCaseControllerBatch', 'Case', null, 'createMembershipCase(List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap)','High');
            }
    }
    

    
/******************************************************************** 
*    Method Name : checkRequiredDocuments
Action
*   @description :   This method to validate all the required documents to be attached 
*   @parameters  :   List<Case> accountSubmissionCaseList
*   @return type :   String
***************************************************************/
    public static String checkRequiredDocuments(List<Case> accountSubmissionCaseList) {
        String missedDocs = '';
        String returnString = '';
        Map<String,Set<String>> caseIdsWithAttachmentsmap = new Map<String,Set<String>>();
        try {
        Map<String,Set<String>> caseIdsWithRequiredDocsmap = GEMS_ShowCaseSubmissionRequiredDocuments.retrieveDocsRequiredForCases(accountSubmissionCaseList);
        for(Case accountSubmissionWithAttachments : accountSubmissionCaseList) {
            if(caseIdsWithRequiredDocsmap.get(accountSubmissionWithAttachments.Id) != null) {
                Set<String> attachmentTypes = new Set<String>();
                if(accountSubmissionWithAttachments.GEMS_Attachments__r != null && !accountSubmissionWithAttachments.GEMS_Attachments__r.isEmpty()) {
                    for(GEMS_Attachment__c attachments : accountSubmissionWithAttachments.GEMS_Attachments__r) {                       
                        attachmentTypes.add(attachments.Type__c.toUpperCase());
                    }
                    caseIdsWithAttachmentsmap.put(accountSubmissionWithAttachments.Id,attachmentTypes);
                }
                
                for(String metaAttachmentType : caseIdsWithRequiredDocsmap.get(accountSubmissionWithAttachments.Id)) {
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
        }
        
        
        if(missedDocs != '') {
            returnString = missedDocs;
        }
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'GEMS_ScreeningCaseControllerBatch', 'Case', null, 'checkRequiredDocuments(List<Case> accountSubmissionCaseList)','High');  
        }
        return returnString ;
    }
    
    
    /******************************************************************** 
    *    Method Name : createSBCChildCase
    Action
    *   @description :   This method to create parent child SBC cases
    *   @parameters  :   List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap
    *   @return type :   void
    ***************************************************************/
    /*US-5205
    public static void createSBCParentChildCase(List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap) {
        List<Case> custSbcParentCasesInsertList = new List<Case>();
        List<Case> custSbcChildCasesInsertList = new List<Case>();
        try {
        Id customsbcParentRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();
        Id customsbcChildRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level SBC').getRecordTypeId();
        List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSProcessEntitlementName];
        Set<ID> subCaseIdsSet = new Set<ID>();
        subCaseIdsSet=subIdListBenfMap.keySet();
        Map<Id,Case> submissionCaseIdWithCase = new Map<Id,Case>();
        //List<Case> subCaseChildCasesList = [SELECT ID, GEMS_Account_Submission_Info__c,RecordTypeId from Case WHERE GEMS_Account_Submission_Info__c IN: subCaseIdsSet];
        //List<GEMS_CaseOwnership_MetaData__mdt> caseOwnerMetadata = [select Case_Team_Member__c,Que_Name__c from GEMS_CaseOwnership_MetaData__mdt where Type_Of_Case__c ='ID Card' ];
        List<case> subCaseRecChildsbcCasesList = [select id,ownerId, GEMS_SBC_Required__c,Status, recordtypeid, GEMS_Accum_Type__c,GEMS_StdCust_Product__c, 
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
                //if(!subCaseRec.TeamMembers.isEmpty())
                //{
                //    subIdAccSpecialistMemberMap.put(subCaseRec.Id,subCaseRec.TeamMembers[0]);
                //}
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
                submissionCaseIdWithCase.put(subCaseRec.Id,subCaseRec);
            }
            
        }
        
        for(Case strCaseRec: clientApprovalReceivedCasesList) {
            Boolean sbcCaseRecFound = subCaseIdsbcRecFoundMap.get(strCaseRec.GEMS_Account_Submission_Info__c);
            if(!sbcCaseRecFound) {
                List<GEMS_Benefit_Agreement__c> benfAggList = subIdListBenfMap.get(strCaseRec.GEMS_Account_Submission_Info__c);
                DateTime effectiveDate = strCaseRec.GEMS_Effective_Date__c;
                Case parentSbcCase = new Case();
                if(!activeEntitlement.isEmpty())
                {
                    parentSbcCase.EntitlementId = activeEntitlement[0].id;
                }
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
                parentSbcCase.GEMS_Rx_Vendor__c = strCaseRec.GEMS_Rx_Vendor__c;
                parentSbcCase.ownerId=userInfo.getUserId();
                //Code Added for Orctober Release Hot Fix
                parentSbcCase.GEMS_Submitter__c = submissionCaseIdWithCase.get(strCaseRec.GEMS_Account_Submission_Info__c).ownerId;
                parentSbcCase.GEMS_StdCust_Product__c = submissionCaseIdWithCase.get(strCaseRec.GEMS_Account_Submission_Info__c).GEMS_StdCust_Product__c;
                
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
                //Code Added for Orctober Release Hot Fix
                childSbcCase.GEMS_Submitter__c = submissionCaseIdWithCase.get(custCaseRec.GEMS_Account_Submission_Info__c).ownerId;
                childSbcCase.GEMS_StdCust_Product__c = submissionCaseIdWithCase.get(custCaseRec.GEMS_Account_Submission_Info__c).GEMS_StdCust_Product__c;
                childSbcCase.GEMS_Rx_Vendor__c = custCaseRec.GEMS_Rx_Vendor__c;
                
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
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_ScreeningCaseControllerBatch.createSBCParentChildCase(List<Case> clientApprovalReceivedCasesList, Map<ID,List<GEMS_Benefit_Agreement__c>> subIdListBenfMap)','High');
        }
    }
    */
    
     /******************************************************************** 
    *   @Method Name :   createStandardProductProcessCases
    *   @description :   This method is to create process cases in standard product workflow for Sep 2016 release
    *   @parameters  :   List<Case> newCaseList, Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/
    public static void createStandardProductProcessCases(List<Case> newCaseList, Case subCaseRec) {
        try {
            Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();       
            Id accStructCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
            Id customIdCardParentRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
            //Id customIdCardChildRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level ID Card').getRecordTypeId();
            List<Case> processCasesToCreate = new List<Case>();
            Set<String> recordTypeIdsSet = new Set<String>{accStructCaseRecordTypeId};
            List<Case> accSubCasesList = new List<Case>();
            Set<ID> accSubIdsSet = new Set<ID>();
            Set<ID> strCasesIDsForProcesCaseCreationSet = new Set<ID>();
            List<Case> strCasesListToBeSendToCreateProcessCases = new List<Case>();
            Set<String> submissionCaseTypeSet = new Set<String>();
            Map<Id,List<Case>> submissionCaseStructureCasesMap = new Map<Id,List<Case>>();
            List<Case> aepAccSubCaseListForEligibilityProcess = new List<Case>();
            Map<ID,List<GEMS_Benefit_Agreement__c>> subCaseIdBenfAggListMap = new Map<ID,List<GEMS_Benefit_Agreement__c>>();
            List<Case> allParentCasesList = new List<Case>();
            Map<Id,Map<String,CaseTeammember>> submissionCaseTeamMembers = new Map<Id,Map<String,CaseTeammember>>();
            Map<String,GEMS_CaseOwnership_MetaData__mdt> ownershipMetaDataMap = new Map<String,GEMS_CaseOwnership_MetaData__mdt>();
            List<String> metaDataRoles = new List<String>();
            List<String> queueNames = new List<String>();
            Map<String,Id> groupNameIdMap = new Map<String,Id>();
            Map<String,Id> recordTypeNameIdMap = new Map<String,Id>();
            Map<String,String> parentChildRecordTypeMap = new Map<String,String>();
            List<Case> allChildCasesList = new List<Case>();
            Set<String> submissionCaseSubTypeSet = new Set<String>();
            List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSProcessEntitlementName];
            for(Case caseRec: newCaseList) {
                strCasesIDsForProcesCaseCreationSet.add(caseRec.Id);
                strCasesListToBeSendToCreateProcessCases.add(caseRec);
                submissionCaseTypeSet.add(subCaseRec.GEMS_Submission_Type__c);
                submissionCaseSubTypeSet.add(subCaseRec.GEMS_Submission_Sub_Type__c);
            }
            
            
            if(subCaseRec != null) {
                //Case submissionCaseActual = screeningCasesNeedsToCreate[0];
                /*if(!subCaseRec.Is_screening_case_creation_is_in_progres__c) {
                    subCaseRec.Is_screening_case_creation_is_in_progres__c = true;
                    update subCaseRec;
                }*/
                 aepAccSubCaseListForEligibilityProcess.add(subCaseRec);
                accSubIdsSet.add(subCaseRec.Id);
                Set<String> underwritingStringSet = new Set<String>{'Medical Underwriting', 'Dental Underwriting', 'Additional Underwriting'};                
                 if(subCaseRec != null) {

                    if(!aepAccSubCaseListForEligibilityProcess.isEmpty()) {
                        GEMS_AccountScreeningCaseCreation.screeningCasesCreation(aepAccSubCaseListForEligibilityProcess,false);
                    }
                    // SFDC-4244 Added new field filter for selected BA
                    if(!strCasesIDsForProcesCaseCreationSet.isEmpty()) {
                         List<GEMS_Benefit_Agreement__c> benefitAgreementList = [SELECT ID, Name, AccountStructureCase__c,IsCancelled__c,
                            AccountStructureCase__r.account.name, AccountStructureCase__r.Account.External_ID__c, AccountStructureCase__r.Opportunity_Name__c,
                            AccountStructureCase__r.GEMS_Account_Submission_Info__c, AccountStructureCase__r.GEMS_Account_Submission_Info__r.FSU_Location__c,
                            AccountStructureCase__r.GEMS_Account_Submission_Info__r.GEMS_ID_Cards_Format__c,
                            Product__c, Product__r.name, Account__r.name, Account__r.External_ID__c from GEMS_Benefit_Agreement__c  WHERE AccountStructureCase__c IN:strCasesIDsForProcesCaseCreationSet 
                            AND IsCancelled__c = false AND Has_Group_Sections__c = true and GEMS_BAs_SpHandling__c = true];
                         
                         for(GEMS_Benefit_Agreement__c benefitAggRecord: benefitAgreementList) {
                             if(String.isNotBlank(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c)) {
                                 if(!subCaseIdBenfAggListMap.containsKey(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c)) {
                                     subCaseIdBenfAggListMap.put(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c, new List<GEMS_Benefit_Agreement__c>());
                                 }
                                 subCaseIdBenfAggListMap.get(benefitAggRecord.AccountStructureCase__r.GEMS_Account_Submission_Info__c).add(benefitAggRecord);
                             }
                         }                       
                    }
                }
                if(!submissionCaseTypeSet.isEmpty()) {
                    //
                    List<RecordType> gemsCaseRecordTypeList = [SELECT Id,Name FROM RecordType WHERE SobjectType='Case' And Name like 'GEMS%'];
                    for(RecordType caseRecordType : gemsCaseRecordTypeList) {
                        recordTypeNameIdMap.put(caseRecordType.Name, caseRecordType.Id);
                    }
                    //Get all case ownership metadata for all cases
                    List<GEMS_CaseOwnership_MetaData__mdt> caseOwnerMetadata = [select Case_Team_Member__c,Que_Name__c, Type_Of_Case__c from GEMS_CaseOwnership_MetaData__mdt];
                    for(GEMS_CaseOwnership_MetaData__mdt ownershipMetaData : caseOwnerMetadata) {
                        if(ownershipMetaData.Case_Team_Member__c != null && ownershipMetaData.Case_Team_Member__c.length() >1 ) {
                            metaDataRoles.add(ownershipMetaData.Case_Team_Member__c);
                        }
                        if(ownershipMetaData.Que_Name__c != null) {
                            queueNames.add(ownershipMetaData.Que_Name__c);
                        }
                        ownershipMetaDataMap.put(ownershipMetaData.Type_Of_Case__c,ownershipMetaData);
                    }
                    
                    //Case team member with respective roles
                    List<CaseTeammember> caseTeamMemberList = [select id,parentId,memberid,Teamrole.name from CaseTeammember where teamrole.name in : 
                        metaDataRoles and parentid in :accSubIdsSet];
                    for(CaseTeammember teamMember : caseTeamMemberList){
                        if(submissionCaseTeamMembers.get(teamMember.parentId) != null) {
                            submissionCaseTeamMembers.get(teamMember.parentId).put(teamMember.Teamrole.name,teamMember);
                        }else {
                            submissionCaseTeamMembers.put(teamMember.parentId, new Map<String,CaseTeammember>{teamMember.Teamrole.name=>teamMember});
                        }
                    }
                    
                    //Queue retrieval for case ownership
                    List<Group> groupppList = [select Id,name from Group where Name in : queueNames and Type = 'Queue'];
                    for(Group group_rec : groupppList) {
                        groupNameIdMap.put(group_rec.name,group_rec.Id);
                    }
                    
                    //SFDC-6747 create membership case for all standard product types and all submisson types and sub-types 
                    createMembershipCase(newCaseList, accSubIdsSet);
                    //List<Case> clientApprovalReceivedCasesList, Set<ID> subCaseIdsSet
                    
                    List<GEMS_Process_Metadata__mdt> processMetaData = [select Account_Submission_Sub_Type__c, Account_Submission_Type__c, Business_Process__c, Create_Process__c, 
                         GEMS_Product__c from GEMS_Process_Metadata__mdt 
                         where Account_Submission_Type__c in : submissionCaseTypeSet //and GEMS_Product__c =: 'Standard Products only' 
                         and Business_Process__c not in : underwritingStringSet and Create_Process__c =: true //and Account_Submission_Sub_Type__c In :submissionCaseSubTypeSet 
                          ];
                     Set<String> businessProcessCasesSet = new Set<String>();
                    for(Case strCaseRec : strCasesListToBeSendToCreateProcessCases) {
                        Map<String,CaseTeammember> teamMemberWithRoleMap = submissionCaseTeamMembers.get(strCaseRec.GEMS_Account_Submission_Info__c);
                        for(GEMS_Process_Metadata__mdt metaData: processMetaData ) {
                            //List<GEMS_Benefit_Agreement__c> benfAggList = caseIdAndBenefitAgreementMap.get(caseStructure.Id);
                            if(strCaseRec.GEMS_Submission_Sub_Type__c != null && !strCaseRec.GEMS_Submission_Sub_Type__c.contains(metaData.Account_Submission_Sub_Type__c)) {
                                continue;
                            }
                            if(metaData.Business_Process__c != null && businessProcessCasesSet.contains(metaData.Business_Process__c)) {
                                continue;
                            }
                            DateTime effectiveDate = strCaseRec.GEMS_Effective_Date__c;
                            Case parentScreeningCase = new Case();
                            if(metaData.Business_Process__c != null ) {
                                parentScreeningCase.Type=metaData.Business_Process__c;
                                businessProcessCasesSet.add(parentScreeningCase.Type);
                            }else {
                                continue;
                            } 
                            if(metaData.Business_Process__c != null && metaData.Business_Process__c == 'ID Card') {
                                parentScreeningCase.recordTypeId =customIdCardParentRecordTypeId;
                                //Code unit start for resolving issue for BA Level Id card record type not setting to the case
                                String businessprocess = metaData.Business_Process__c;
                                String childBusinessProcess = 'GEMS BA Level '+businessprocess;
                                businessprocess = 'GEMS '+businessprocess;
                                parentChildRecordTypeMap.put(recordTypeNameIdMap.get(businessprocess),childBusinessProcess);
                                //End Here
                                /*if(strCaseRec.GEMS_Account_Submission_Info__r.OwnerId != null) {
                                    parentScreeningCase.ownerId=strCaseRec.GEMS_Account_Submission_Info__r.OwnerId;
                                }*/
                                if(ownershipMetaDataMap.get(metaData.Business_Process__c) != null && ownershipMetaDataMap.get(metaData.Business_Process__c).Case_Team_Member__c != null
                                     && teamMemberWithRoleMap != null && teamMemberWithRoleMap.get(ownershipMetaDataMap.get(metaData.Business_Process__c).Case_Team_Member__c) != null ) {
                                     
                                    parentScreeningCase.ownerId = teamMemberWithRoleMap.get(ownershipMetaDataMap.get(metaData.Business_Process__c).Case_Team_Member__c).memberId;
                                }
                                else if(ownershipMetaDataMap.get(metaData.Business_Process__c) != null && ownershipMetaDataMap.get(metaData.Business_Process__c).Que_Name__c != null 
                                        && groupNameIdMap.get(ownershipMetaDataMap.get(metaData.Business_Process__c).Que_Name__c) != null ) {
                                    parentScreeningCase.ownerId = groupNameIdMap.get(ownershipMetaDataMap.get(metaData.Business_Process__c).Que_Name__c); //Need to work
                                }
                            } else {
                                String businessprocess = metaData.Business_Process__c;
                                if(metaData.Business_Process__c == 'Account Setup Process') {
                                    businessprocess = 'Account Setup';
                                }
                                String childBusinessProcess = 'GEMS BA Level '+businessprocess;
                                businessprocess = 'GEMS '+businessprocess;
                                parentChildRecordTypeMap.put(recordTypeNameIdMap.get(businessprocess),childBusinessProcess);
                                
                                parentScreeningCase.recordTypeId = recordTypeNameIdMap.get(businessprocess);
                                //4995 Assign Account specialist as Qaulity Reviewer.
                                if(teamMemberWithRoleMap.get('Account Specialist').memberId != NULL){
                                    parentScreeningCase.GEMS_Quality_Reviewer__c = teamMemberWithRoleMap.get('Account Specialist').memberId;
                                }
                                //4995 Assign submission case owner as BlueSTAR Walkthrough Account Mgmt/GET.
                                if(subCaseRec.ownerId != NULL){
                                    parentScreeningCase.GEMS_BlueSTAR_Walkthrough_Resource_1__c = subCaseRec.ownerId;                                
                                }
                                if(!activeEntitlement.isEmpty()){
                                    parentScreeningCase.EntitlementId = activeEntitlement[0].Id;
                                }
                                if(ownershipMetaDataMap.get(metaData.Business_Process__c) != null && ownershipMetaDataMap.get(metaData.Business_Process__c).Case_Team_Member__c != null
                                     && teamMemberWithRoleMap != null && teamMemberWithRoleMap.get(ownershipMetaDataMap.get(metaData.Business_Process__c).Case_Team_Member__c) != null ) {
                                     
                                    parentScreeningCase.ownerId = teamMemberWithRoleMap.get(ownershipMetaDataMap.get(metaData.Business_Process__c).Case_Team_Member__c).memberId;
                               
                                }else if(ownershipMetaDataMap.get(metaData.Business_Process__c) != null && ownershipMetaDataMap.get(metaData.Business_Process__c).Que_Name__c != null 
                                        && groupNameIdMap.get(ownershipMetaDataMap.get(metaData.Business_Process__c).Que_Name__c) != null ) {
                                   
                                    parentScreeningCase.ownerId = groupNameIdMap.get(ownershipMetaDataMap.get(metaData.Business_Process__c).Que_Name__c); //Need to work
                                
                                }
                            }                            
                                                     
                            parentScreeningCase.Subject=strCaseRec.Account.Name+' '+ strCaseRec.Account.External_ID__c +' '+effectiveDate.format('M/d/yyyy')+' '+metaData.Business_Process__c;                            
                            parentScreeningCase.GEMS_Account_Submission_Info__c=strCaseRec.GEMS_Account_Submission_Info__c;
                            parentScreeningCase.Accountid = strCaseRec.Accountid;
                            parentScreeningCase.GEMS_Effective_Date__c=strCaseRec.GEMS_Effective_Date__c;
                            parentScreeningCase.GEMS_Case_Effective_Date__c=strCaseRec.GEMS_Case_Effective_Date__c;
                            parentScreeningCase.GEMS_Submission_Type__c=strCaseRec.GEMS_Submission_Type__c;
                            parentScreeningCase.GEMS_Submission_Sub_Type__c=strCaseRec.GEMS_Submission_Sub_Type__c;
                            parentScreeningCase.FSU_Location__c=strCaseRec.GEMS_Account_Submission_Info__r.FSU_Location__c;
                            parentScreeningCase.HCSC_Division__c=strCaseRec.HCSC_Division__c;                            
                            parentScreeningCase.Opportunity_Name__c=strCaseRec.Opportunity_Name__c;
                            parentScreeningCase.parentid=strCaseRec.GEMS_Account_Submission_Info__c;                            
                            parentScreeningCase.status='In Progress';
                            parentScreeningCase.GEMS_Line_of_Business__c=strCaseRec.GEMS_Line_of_Business__c;
                            parentScreeningCase.Funding_Type_Multiselect__c=strCaseRec.Funding_Type_Multiselect__c;
                            parentScreeningCase.GEMS_Rx_Vendor__c = strCaseRec.GEMS_Rx_Vendor__c;
                            parentScreeningCase.GEMS_StdCust_Product__c = strCaseRec.GEMS_StdCust_Product__c;
                            parentScreeningCase.GEMS_Submitter__c = subCaseRec.ownerId;

                            allParentCasesList.add(parentScreeningCase);
                        }
                    }
                    
                    if(!allParentCasesList.isEmpty()) {
                        //Inserting all parent cases
                        Database.Saveresult[] caseSaveResult = Database.insert(allParentCasesList);
                        Map<Id,Case> accountSetupCaseMap = new Map<Id,Case>();
                        for(Case casesss : allParentCasesList) {
                            if(casesss.type == 'Account Setup Process') {
                                accountSetupCaseMap.put(casesss.Id,casesss);
                            }
                        }
                        List<Task> taskInsertList = new List<Task>();
                        Integer child =0;
                        if(caseSaveResult != null) {
                            for(Database.SaveResult sr:caseSaveResult) {
                                if(sr.isSuccess())
                                {
                                  Case childRecord = allParentCasesList.get(child);
                                  if(accountSetupCaseMap.get(sr.Id) != null ) {
                                    Task baLevelAccSetUpTask= new Task();
                                    baLevelAccSetUpTask.WhatId=childRecord.Id;
                                    baLevelAccSetUpTask.Subject='BlueSTAR Entry Complete';
                                    baLevelAccSetUpTask.Status='In Progress';
                                    baLevelAccSetUpTask.Priority='Normal';
                                    baLevelAccSetUpTask.GEMS_Start_Date__c = System.now();
                                    baLevelAccSetUpTask.ownerId = childRecord.ownerId;
                                    taskInsertList.add(baLevelAccSetUpTask);                                        
                                   }
                                }
                                child++;
                            }
                        }
                        if(!taskInsertList.isEmpty()) {
                            Database.insert(taskInsertList);
                        }
                        
                            for(Case parentCase : allParentCasesList) {
                            List<GEMS_Benefit_Agreement__c> benefitAgreementList = subCaseIdBenfAggListMap.get(parentCase.GEMS_Account_Submission_Info__c);
                            for(GEMS_Benefit_Agreement__c baRecord : benefitAgreementList ) {
                                DateTime effectiveDate = parentCase.GEMS_Effective_Date__c;
                                Case childScreeningCase = new Case();
                                childScreeningCase.type = parentCase.type;
                                String caseType = parentCase.type;
                                if(parentCase.type == 'Account Setup Process') {
                                    continue;    //This line added for avoiding BA leve account setup process creation for standard Products
                                    caseType = 'Account Setup';
                                } else if(parentCase.type == 'ID Card') {//SFDC-3064 
                                    continue;
                                }
                                if(parentCase.ownerId != null) {
                                    childScreeningCase.ownerId = parentCase.ownerId;
                                 }
                                if(parentChildRecordTypeMap.get(parentCase.recordTypeId) != null) {
                                    childScreeningCase.recordTypeId = recordTypeNameIdMap.get(parentChildRecordTypeMap.get(parentCase.recordTypeId));
                                }
                                childScreeningCase.Subject=baRecord.account__r.name+' '+baRecord.Account__r.External_ID__c+' '+effectiveDate.format('M/d/yyyy')+' BA Level '+caseType;                            
                                childScreeningCase.GEMS_Account_Submission_Info__c=parentCase.GEMS_Account_Submission_Info__c;
                                childScreeningCase.Accountid = parentCase.Accountid;
                                childScreeningCase.GEMS_Effective_Date__c=parentCase.GEMS_Effective_Date__c;
                                childScreeningCase.GEMS_Case_Effective_Date__c=parentCase.GEMS_Case_Effective_Date__c;
                                childScreeningCase.GEMS_Submission_Type__c=parentCase.GEMS_Submission_Type__c;
                                childScreeningCase.GEMS_Submission_Sub_Type__c=parentCase.GEMS_Submission_Sub_Type__c;
                                childScreeningCase.FSU_Location__c=parentCase.GEMS_Account_Submission_Info__r.FSU_Location__c;
                                childScreeningCase.HCSC_Division__c=parentCase.HCSC_Division__c;                                
                                childScreeningCase.Opportunity_Name__c=parentCase.Opportunity_Name__c;
                                childScreeningCase.parentid=parentCase.Id;
                                childScreeningCase.GEMS_Benefit_Agreement__c=baRecord.Id;
                                childScreeningCase.status='In Progress';
                                
                                childScreeningCase.GEMS_Rx_Vendor__c = parentCase.GEMS_Rx_Vendor__c;
                                childScreeningCase.GEMS_Line_of_Business__c=parentCase.GEMS_Line_of_Business__c;
                                childScreeningCase.Funding_Type_Multiselect__c=parentCase.Funding_Type_Multiselect__c;
                                childScreeningCase.GEMS_StdCust_Product__c = parentCase.GEMS_StdCust_Product__c;
                                childScreeningCase.GEMS_Submitter__c = parentCase.GEMS_Submitter__c;
                                
                                allChildCasesList.add(childScreeningCase);
                            }
                        }
                        
                        if(!allChildCasesList.isEmpty()) {
                            Database.SaveResult[] childSaveResult = Database.insert(allChildCasesList);
                        }
                                              
                    }
                }
                //if(!screeningCasesNeedsToCreate.isEmpty()) {
                 subCaseRec.GEMS_Ready_to_release_to_screening__c = 'Released';
                 subCaseRec.GEMS_Released_to_Screening_Date__c = System.now();
                 subCaseRec.Is_screening_case_creation_is_in_progres__c = false;
                 update subCaseRec;
             //}                  
            }
            
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_ScreeningCaseControllerBatch.createStandardProductProcessCases(List<Case> newCaseList, Map<Id,Case> oldCaseMap)','High');  
        }
    }
    
   /******************************************************************** 
    *   @Method Name :   createManualEligibilityCase
    *   @description :   US-4753 This method is to create Manual Eligibility case when release button is pressed
    *   @parameters  :   String caseID
    *   @return type :   void
    ***************************************************************/  
   public static void createManualEligibilityCase(List<Case> submissionCases) {
        try {
           
            Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(GEMS_Constants.CaseRecdType_SubmissionCase).getRecordTypeId();
            Id caseManualEligibilityId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(GEMS_Constants.CaseRecdType_ManualEligibilityCase).getRecordTypeId(); 
            Set<String> submissionIds = new Set<String>();
            List<Case> new_cases_list = new List<Case>();
            //List<Case> submissionCases =new List<Case>();
            /*if(caseID!=null) {
               List<Case> submissionCases = [select id,OwnerId,Expected_No_of_paper_application__c,GEMS_Additional_Medical_Underwriter__c,GEMS_Products__c,account.name,GEMS_Submission_Type__c,
                                            GEMS_Submission_Sub_Type__c ,GEMS_Line_of_Business__c ,GEMS_Benefit_Booklet_Required__c,GEMS_Effective_Date__c,
                                             Account.External_ID__c,type,FSU_Location__c,Account_Executive__c,HCSC_Division__c,GEMS_Rx_Vendor__c,GEMS_StdCust_Product__c,
                                            GEMS_Medical_Underwriter__c,Sales_Executive__c,Productid,status,GEMS_Case_Effective_Date__c,Opportunity_Name__c,Funding_Type__c,
                                            Funding_Type_Multiselect__c,GEMS_AEP_Account__c,isClosed,GEMS_Integrated__c,GEMS_Grandfathered_benefits__c,GEMS_Bank__c,GEMS_Performance_Guarantees__c,GEMS_OE_Eligibility_Method__c,(select Attachment__c,Description__c,Type__c from GEMS_Attachments__r),
                                            (select id, casenumber,status, isClosed, recordTypeId from Cases1__r where recordtypeid=:caseManualEligibilityId)from case where Id=:caseID and recordtypeid=:caseAccountSubmissionId];
                */
                //submissionCases.add(SubmCase);
                if(submissionCases != null && !submissionCases.isEmpty()) {
                    Set<String> submissionTypes = new Set<String>();
                    Set<String> submissionSubTypes = new Set<String>();
                    List<GEMS_Process_Metadata__mdt> processMetaData = null;
                    //Iterating over Submission Cases for Submission Type and Sub type
                    for(case subCase : submissionCases) {
                        submissionTypes.add(subCase.GEMS_Submission_Type__c);
                        submissionSubTypes.add(subCase.GEMS_Submission_Sub_Type__c);                    
                    }
                    if(!submissionSubTypes.isEmpty() && !submissionTypes.isEmpty()) {
                        processMetaData = GEMS_Utility.retriveCustomMetaDataByProductType(submissionTypes, Label.GEMS_Custom_Products);
                    }
                  
                    boolean manualEligibilityFound = false;
                    List<caseteamrole> caseTeamRoleList = [select id,name from caseteamrole where name in ('FSU Membership Analyst') limit 1];
                    Map<Id,String> roleIdRoleNameMap = new Map<Id,String>();
                    for(caseteamrole ctr:caseTeamRoleList) {
                        roleIdRoleNameMap.put(ctr.id,ctr.name);
                    }
                    List<caseteammember> caseTeamMembers = [select id,parentId,memberid,TeamRoleId from caseteammember where TeamRoleId in : roleIdRoleNameMap.keySet() and parentId in : submissionIds ];
                    Map<Id,caseteammember> caseIdSpecialistTeamMember = new Map<Id,caseteammember >();
                    for(caseteammember teamMember: caseTeamMembers) {
                        if(roleIdRoleNameMap.containsKey(teamMember.TeamRoleId) ) {
                            caseIdSpecialistTeamMember.put(teamMember.parentId,teamMember);
                        }
                    }
                    Group groupId;
                    if(caseIdSpecialistTeamMember.isEmpty()) {
                        groupId =[select Id from Group where Name = 'GEMS FSU membership' and Type = 'Queue' limit 1];
                        System.debug('===groupId ='+groupId );
                    }
                        //Checking the conditions for creating Manual Eligibility case)
                        for(Case submissionCase : submissionCases) {
                            if(submissionCase.GEMS_StdCust_Product__c !='Standard Products only' && submissionCase.GEMS_Submission_Sub_Type__c != null && processMetaData!= null) {
                                String[] submissionSubTypeArray = submissionCase.GEMS_Submission_Sub_Type__c.split(';');
                                Set<String> subTypesSet = new Set<String>();
                                for(String subType : submissionSubTypeArray) {
                                    subTypesSet.add(subType);
                                }
                                
                                if(!subTypesSet.isEmpty() && !GEMS_Utility.buildSubmissinCaseBusinessAreaToCreate(processMetaData,subTypesSet,'Manual Eligibility')){
                                    continue;
                                }
                            }
                            List<Case> underWrittingCases = submissionCase.Cases1__r;
                            Boolean allCompleted = true;
                            for(Case uwCase : underWrittingCases) {
                                if(uwCase.recordTypeId == caseManualEligibilityId) {
                                    manualEligibilityFound = true;
                                    break;
                                }}
                              //Checking the condition and calling the method to create manual eligibility Case  
                              //SFDC-8039 Initialize new_case  = null so that unwanted cases are not created
                              Case new_case  = null;                                      
                              if(!manualEligibilityFound && !submissionCase.GEMS_AEP_Account__c && (submissionCase.GEMS_OE_Eligibility_Method__c == 'OTL' || submissionCase.GEMS_OE_Eligibility_Method__c == 'LGDE' || submissionCase.GEMS_OE_Eligibility_Method__c == 'Paper/XLS')) {
                              new_case=ManualEligibilityCaseCreation(new_case,submissionCase,caseManualEligibilityId,caseIdSpecialistTeamMember,groupId);
                            }
                      if(new_case != null) {
                           //Inserting the Case and creating Tasks for the new case.
                           Database.SaveResult saveResult = Database.insert(new_case,false);
                           if(saveResult.isSuccess()) {
                                Case caseManualEligibility = new_case;
                                Task newTask = new Task();
                                newTask.subject = 'Manual Eligibility Complete';
                                newTask.whatId = caseManualEligibility.Id;
                                //newTask.ownerId = caseManualEligibility.OwnerId;
                                newTask.status = 'In progress';
                                newTask.Priority = 'Normal';
                                newTask.GEMS_Start_Date__c = System.now();
                                insert newTask;
                              }
                       } 
            }
        }}catch(Exception ex){
                CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_ScreeningCaseControllerBatch.createManualEligibilityCase(String CaseId)','High');              
        } 
    }
    //Helper method to create Manual Eligibility Case.  
    public static case ManualEligibilityCaseCreation(Case new_case ,Case case_screening,Id caseManualEligibilityId,Map<Id,caseteammember> caseIdSpecialistTeamMember,Group groupId) {
                  
                case manualEligibilityProcessCase = new case();
                DateTime effectiveDate1 = case_screening.GEMS_Case_Effective_Date__c;
                if(caseIdSpecialistTeamMember.containsKey(case_screening.Id) ) {
                   manualEligibilityProcessCase.ownerId = caseIdSpecialistTeamMember.get(case_screening.Id).memberid;
                }
                else { if (groupId != null)manualEligibilityProcessCase.ownerId = groupId.id;}
                manualEligibilityProcessCase.GEMS_Account_Submission_Info__c= case_screening.id;
                manualEligibilityProcessCase.parentid= case_screening.id;
                manualEligibilityProcessCase.Expected_No_of_paper_application__c = case_screening.Expected_No_of_paper_application__c;
                manualEligibilityProcessCase.Accountid=case_screening.Accountid;
                manualEligibilityProcessCase.Subject=case_screening.Account.Name+' '+ case_screening.Account.External_ID__c +' '+effectiveDate1.format('M/d/yyyy')+' Manual Eligibility ';
                manualEligibilityProcessCase.GEMS_Submission_Type__c=case_screening.GEMS_Submission_Type__c;
                manualEligibilityProcessCase.FSU_Location__c=case_screening.FSU_Location__c;
                manualEligibilityProcessCase.Account_Executive__c=case_screening.Account_Executive__c;
                manualEligibilityProcessCase.HCSC_Division__c=case_screening.HCSC_Division__c;
                manualEligibilityProcessCase.GEMS_Submission_Sub_Type__c=case_screening.GEMS_Submission_Sub_Type__c;
                manualEligibilityProcessCase.GEMS_Medical_Underwriter__c=case_screening.GEMS_Medical_Underwriter__c;
                manualEligibilityProcessCase.Sales_Executive__c=case_screening.Sales_Executive__c;
                manualEligibilityProcessCase.Productid=case_screening.Productid;
                manualEligibilityProcessCase.GEMS_Case_Effective_Date__c = case_screening.GEMS_Case_Effective_Date__c;
                manualEligibilityProcessCase.GEMS_Effective_Date__c = case_screening.GEMS_Effective_Date__c;
                manualEligibilityProcessCase.status = 'In Progress';            
                manualEligibilityProcessCase.recordTypeId = caseManualEligibilityId;                        
                manualEligibilityProcessCase.Opportunity_Name__c = case_screening.Opportunity_Name__c ;
                manualEligibilityProcessCase.type = 'Manual Eligibility';//ba1[0] + ' ' +ba1[2];
                manualEligibilityProcessCase.GEMS_Products__c=case_screening.GEMS_Products__c;
                // This population is for October Hotfix 2016
                manualEligibilityProcessCase.Funding_Type_Multiselect__c = case_screening.Funding_Type_Multiselect__c;                
                manualEligibilityProcessCase.GEMS_StdCust_Product__c = case_screening.GEMS_StdCust_Product__c;
                manualEligibilityProcessCase.GEMS_Rx_Vendor__c = case_screening.GEMS_Rx_Vendor__c;
                manualEligibilityProcessCase.GEMS_Line_of_Business__c=case_screening.GEMS_Line_of_Business__c;
                manualEligibilityProcessCase.GEMS_Submitter__c = case_screening.ownerId;
                system.debug('end');
                return manualEligibilityProcessCase;
                
    } 
    
    

    
}