/**************************************************************************************
  Apex Class Name     : GEMS_AccountScreeningCaseCreation 
  Version             : 1.0
  Function            : This Class is to create parent screening cases
  Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Offshore            22/06/2016             Original Version
* 4/24/2017           Ranjit Gandhi          SFDC-4485- GEMS - Add Sub-Category for Eligibility Process Case to be AEP Eligibility
* 6/2/2017            Luke Chen              SFDC-4666 field should populate from Acct Submission "Production OE File: Target Date"
* 07/30/2017          Malathi.K              SFDC-5247 - Create Eligibility Process case for Account Structure Maintenance.
* 07/30/2017          Luke Chen              SFDC-5246-Account Structure Maintenance - Account Structure case: Page Layout & Functionality
* 09/11/2017          Gokul Bharati          SFDC-5880-GEMS: Pre-Populate Quality/QAI Reviewer and BlueSTAR Walkthrough Account Mgmt/GET on ASP Case for Account Structure Maintenance
* 09/30/2017          Malathi.K              SFDC-5089 - Do not create Medical/Pharmacy/UW Parent cases in only 1 BA with Dental product
* 10/27/2017          Malathi.K              SFDC-7134 - Additional UW cases being created when there is no Add. UW on case team.
* 02/20/2018          Gokul                  SFDC-4244 - GEMS: Acct Structure - Special Handling of Complex/Co-op Accounts (Downstream Processing)
* 05/30/2018          Gokul                  SFDC-4112 GEMS: Dental Only Cases should not Create Medical Underwriting Cases
*************************************************************************************/
public class GEMS_AccountScreeningCaseCreation {
    
    /******************************************************************** 
    *    Method Name : screeningCasesCreation
    Action
    *   @description :   This Class is to create parent screening cases
    *   @parameters  :   List<Case> casesList
    *   @return type :   void
    ***************************************************************/
    public static Map<String,List<Case>> screeningCasesCreation(List<Case> casesList,Boolean createScreening) {
        Map<String,List<Case>> caseidListOfScreeningCases = new Map<String,List<Case>>();
        try {
            Map<String, List<GEMS_Account_Setting__mdt>> accountSettingMetadataMap = new Map<String,List<GEMS_Account_Setting__mdt>>();
            Map<String,GEMS_CaseOwnership_MetaData__mdt> screeningAreaMetaDataMap = new Map<String,GEMS_CaseOwnership_MetaData__mdt>();
            Map<Id,Map<String,CaseTeammember>> submissionCaseTeamMembers = new Map<Id,Map<String,CaseTeammember>>();
            Map<String,String> caseIdTeamMemberIdMap = new Map<String,String>();
            Map<String,Id> groupNameIdMap = new Map<String,Id>();
            List<Case> allScreeningCasesList = new List<Case>();
            List<String> metaDataRoles = new List<String>();
            List<String> queueNames = new List<String>();
            List<Id> caseIds = new List<Id>();            
            Id casesubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
            // SFDC-5247 Create Eligibility for Account Structure Maintenance.
            Id caseAccountMaintenanceId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId(); 
            /*String GEMSProduct = '';            
            for(Case casesubmission : casesList) {
                if(casesubmission.recordTypeId == casesubmissionId) {
                GEMSProduct = casesubmission.GEMS_StdCust_Product__c ;}
            }*/
            
            String GEMSProduct=casesList[0].GEMS_StdCust_Product__c;
            
            String s1=casesList[0].GEMS_Submission_Type__c;
            if(casesList[0].GEMS_Submission_Type__c != null && casesList[0].GEMS_Submission_Type__c.contains('New')) {
                s1 = 'New';
            }
            List<GEMS_Account_Setting__mdt> listAccountSetting = new List<GEMS_Account_Setting__mdt>();
            Map<Id,Case> submissionIdStructCase = new Map<Id,Case>();
            Map<String,Case> businessAreaCase = new Map<String,Case>();
            Id caseScreeningId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
            Id casaccountStructId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
            Id caswEligibilityProcessId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Eligibility').getRecordTypeId();
            Id caswManualEligibilityId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Manual Eligibility').getRecordTypeId();
            List<GEMS_Account_Setting__mdt> accountSettingMetaData = [select Account_Submission_Sub_Type__c,Account_Submission_Type__c,Additional_Underwriter__c,
                AEP__c,BCC__c,BCC_Product__c,Benefit_Booklet_Required__c,Business_Area_Processes__c,Custom_HCA_CDHP__c,Dental__c,Division__c,FSA_CDHP__c,HSA_Blueprint__c,
                HSA_Custom__c,Incetives_CDHP__c,Is_the_account_Derivated__c,Line_of_Business__c,Medical__c,Non_AEP__c,Non_Prime_Vendor__c,Pharmacy_Rx__c,
                Prime_Vendor__c,RBP_CDHP__c,SCP__c,VBID__c from GEMS_Account_Setting__mdt where Is_Rule_Active_del__c = true and Account_Submission_Type__c =:s1 and GEMS_Product__c =:GEMSProduct]; 
            List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSScreeningEntitlementName];
            List<GEMS_CaseOwnership_MetaData__mdt> ownerShipMetaDataList = [select Type_Of_Case__c, Case_Team_Member__c, Que_Name__c from GEMS_CaseOwnership_MetaData__mdt];
            
            
            for(Case case_screening : casesList) {
                caseIds.add(case_screening.Id);
            }
            for(GEMS_CaseOwnership_MetaData__mdt ownershipMetaData : ownerShipMetaDataList) {
                if(ownershipMetaData.Case_Team_Member__c != null && ownershipMetaData.Case_Team_Member__c.length() >1 ) {
                    metaDataRoles.add(ownershipMetaData.Case_Team_Member__c);
                }
                if(ownershipMetaData.Que_Name__c != null) {
                    queueNames.add(ownershipMetaData.Que_Name__c);
                }
                screeningAreaMetaDataMap.put(ownershipMetaData.Type_Of_Case__c,ownershipMetaData);
            }
            for(GEMS_Account_Setting__mdt accountSetting : accountSettingMetaData) {
                String keyAccountSetting = accountSetting.Business_Area_Processes__c; 
                if(accountSettingMetadataMap.get(keyAccountSetting) != null) {
                    accountSettingMetadataMap.get(keyAccountSetting).add(accountSetting);
                }else {
                    listAccountSetting = new List<GEMS_Account_Setting__mdt>();
                    listAccountSetting.add(accountSetting);
                    accountSettingMetadataMap.put(keyAccountSetting,listAccountSetting);
                }
            }
            List<CaseTeammember> caseTeamMemberList = [select id,parentId,memberid,Teamrole.name from CaseTeammember where teamrole.name in : 
                metaDataRoles and parentid in :caseIds];
            for(CaseTeammember teamMember : caseTeamMemberList){
                if(submissionCaseTeamMembers.get(teamMember.parentId) != null) {
                    submissionCaseTeamMembers.get(teamMember.parentId).put(teamMember.Teamrole.name,teamMember);
                }else {
                    submissionCaseTeamMembers.put(teamMember.parentId, new Map<String,CaseTeammember>{teamMember.Teamrole.name=>teamMember});
                }
            }
            Set<String> recordTypeSet = new Set<String>{casaccountStructId,caswEligibilityProcessId};

            List<Case> submissionAndStructureCases = [select id,status,GEMS_AEP_Account__c,GEMS_Account_Submission_Info__c,recordTypeId,(select id,status,GEMS_AEP_Account__c,GEMS_Account_Submission_Info__c, recordTypeId from Cases1__r where recordTypeId in : recordTypeSet )  from case where Id in : caseIds];        
            List<Case> structureCases = new List<Case>();
            Map<Id,Boolean> submissionEligibilityExistMap = new Map<Id,Boolean>();
            System.debug('==============');
            for(Case caseSubmission : submissionAndStructureCases) { 
                for(Case structEligibility : caseSubmission.Cases1__r) {
                    if(structEligibility.recordTypeId == casaccountStructId) {
                        structureCases.add(structEligibility);
                    }
                    if(structEligibility.recordTypeId == caswEligibilityProcessId) {
                        submissionEligibilityExistMap.put(caseSubmission.Id,true);
                    }
                }
            }
            //SFDC-5089 Get the list of Sturcture case ID's
             List<Id> structCaseIds = new List<Id>();
            for(Case caseStruct : structureCases) {
             submissionIdStructCase.put(caseStruct.GEMS_Account_Submission_Info__c , caseStruct);
             structCaseIds.add(caseStruct.id);
            }
            
            //SFDC-5089 Get the Benefit Agreements.
            //SFDC-4244 Added new field filter for selected BA
            List<GEMS_Benefit_Agreement__c> benefitAgreementList = [SELECT ID, Name, AccountStructureCase__c,                                                               
                                                                 Product__c, Product__r.name, Product__r.Product_Category__c, Plan__r.Product__r.Product_Category__c
                                                                 from GEMS_Benefit_Agreement__c where AccountStructureCase__c in :structCaseIds and HAS_GROUP_SECTIONS__C = true and ISCANCELLED__C = false and GEMS_BAs_SpHandling__c = true];
             
             System.debug('benefitAgreementList >>>>>' +benefitAgreementList );
             List<GEMS_Benefit_Agreement__c> listBenAgr = new List<GEMS_Benefit_Agreement__c>();                                                                 
             Map<Id,List<GEMS_Benefit_Agreement__c>> benAgrMap = new Map<Id,List<GEMS_Benefit_Agreement__c>>();
             
             for(GEMS_Benefit_Agreement__c benAgr_rec : benefitAgreementList ) {
                String keyAccountStruct = benAgr_rec.AccountStructureCase__c;
                if(benAgrMap.get(keyAccountStruct) != null) {
                    benAgrMap.get(keyAccountStruct).add(benAgr_rec);
                }else {
                    listBenAgr = new List<GEMS_Benefit_Agreement__c >();
                    listBenAgr.add(benAgr_rec);
                    benAgrMap.put(keyAccountStruct,listBenAgr);
                }               
            }                                                                 
            
            System.debug('benAgrMap>>>>>' +benAgrMap);  
            System.debug('listBenAgr >>>>>' +listBenAgr); 
                                                             
            List<Group> groupppList = [select Id,name from Group where Name in : queueNames and Type = 'Queue'];
            for(Group group_rec : groupppList) {
                groupNameIdMap.put(group_rec.name,group_rec.Id);
            }

            for(Case case_screening : casesList) {
               List<Case> new_cases_list = new List<Case>();
               Boolean renewalNoChangeCase = false;
               if(case_screening.GEMS_Is_Eligibility_Required__c == 'Yes' ) {
                  if (case_screening.GEMS_AEP_Account__c == true || (submissionIdStructCase.get(case_screening.Id) != null 
                    && submissionIdStructCase.get(case_screening.Id).GEMS_AEP_Account__c == true) )   { 
                     /* if((case_screening.GEMS_Submission_Type__c == 'New Account' || case_screening.GEMS_Submission_Type__c == 'Cancellation')
                       || (case_screening.GEMS_Submission_Type__c == 'Off Cycle' && case_screening.GEMS_Submission_Sub_Type__c=='Funding Change') 
                       || (case_screening.GEMS_Submission_Type__c == 'Renewal' && (case_screening.GEMS_Submission_Sub_Type__c.contains('Account Structure Change') 
                       || case_screening.GEMS_Submission_Sub_Type__c.contains( 'Funding Change')) )) {*/
                       if(submissionEligibilityExistMap.get(case_screening.id) ==null && (case_screening.GEMS_Submission_Type__c == 'New Account' || case_screening.GEMS_Submission_Type__c == 'Cancellation' || case_screening.GEMS_Submission_Type__c == 'Account Structure Maintenance'|| ((case_screening.GEMS_Submission_Type__c == 'Renewal' || case_screening.GEMS_Submission_Type__c == 'Off Cycle' )
                            && (case_screening.GEMS_Submission_Sub_Type__c.contains('Account Structure Change') || case_screening.GEMS_Submission_Sub_Type__c.contains( 'Funding Change') || 
                                case_screening.GEMS_Submission_Sub_Type__c.contains('Benefit Change') || case_screening.GEMS_Submission_Sub_Type__c.contains('No Changes') || case_screening.GEMS_Submission_Sub_Type__c.contains('Eligibility Change')) ))) {
                       List<GEMS_Process_Metadata__mdt> processMetaData = null;
                       String[] submissionSubtype = null;
                       if(case_screening.GEMS_Submission_Sub_Type__c != null ) {
                            submissionSubtype = case_screening.GEMS_Submission_Sub_Type__c.split(';');
                        }
                        
                        if(submissionSubtype != null && case_screening.GEMS_StdCust_Product__c != null && case_screening.GEMS_StdCust_Product__c.contains(Label.GEMS_Custom_Products)) {
                             processMetaData = GEMS_Utility.retriveCustomMetaDataByProductTypeIndividual(case_screening.GEMS_Submission_Type__c,Label.GEMS_Custom_Products,submissionSubtype);                   
                        }
                       if(processMetaData == null ||  (processMetaData != null && processMetaData.size() > 0 && GEMS_Utility.findBusinessAreaInMetaData(case_screening,processMetaData,'Eligibility Process')) ) {
                           case eligibilityProcessCase = new case();
                        GEMS_CaseOwnership_MetaData__mdt ownerMetaData = screeningAreaMetaDataMap.get('Eligibility Process');
                        Map<String,CaseTeammember> submissionCaseTeamMap = submissionCaseTeamMembers.get(case_screening.Id);
                        if(submissionCaseTeamMap != null) {
                            if(ownerMetaData != null && ownerMetaData.Case_Team_Member__c != null
                                &&  submissionCaseTeamMap.get(ownerMetaData.Case_Team_Member__c) != null ) {
                                eligibilityProcessCase.ownerId = submissionCaseTeamMap.get(ownerMetaData.Case_Team_Member__c).memberid;
                            }else if(ownerMetaData.Que_Name__c != null && groupNameIdMap.get(ownerMetaData.Que_Name__c) != null) {
                                eligibilityProcessCase.ownerId = groupNameIdMap.get(ownerMetaData.Que_Name__c);
                            }
                        }
                        DateTime effectiveDate1 = case_screening.GEMS_Effective_Date__c;
                        //SFDC-5247 Populate Eff.Dt from Case Eff. Dt.
                        DateTime caseffDate1 = case_screening.GEMS_Case_Effective_Date__c;
                        eligibilityProcessCase.GEMS_Account_Submission_Info__c= case_screening.id;
                        eligibilityProcessCase.parentid= case_screening.id;
                        eligibilityProcessCase.Accountid=case_screening.Accountid;
                        //SFDC-5247 Populate Subject using the respective Eff.Dt
                        if (case_screening.GEMS_Submission_Type__c == 'Account Structure Maintenance'){
                         eligibilityProcessCase.Subject=case_screening.Account.Name+' '+ case_screening.Account.External_ID__c +' '+caseffDate1.format('M/d/yyyy')+' Eligibility Process';                        
                        }   
                        else {
                        eligibilityProcessCase.Subject=case_screening.Account.Name+' '+ case_screening.Account.External_ID__c +' '+effectiveDate1.format('M/d/yyyy')+' Eligibility Process';
                        }
                        eligibilityProcessCase.GEMS_Submission_Type__c=case_screening.GEMS_Submission_Type__c;
                        eligibilityProcessCase.FSU_Location__c=case_screening.FSU_Location__c;
                        // populate GEMS_Target_Date_Production_OE_File__c field from submission case's
                        eligibilityProcessCase.GEMS_Target_Date_Production_OE_File__c = case_screening.GEMS_Target_Date_Production_OE_File__c;
                        eligibilityProcessCase.Account_Executive__c=case_screening.Account_Executive__c;
                        eligibilityProcessCase.HCSC_Division__c=case_screening.HCSC_Division__c;
                        eligibilityProcessCase.GEMS_Submission_Sub_Type__c=case_screening.GEMS_Submission_Sub_Type__c;
                        eligibilityProcessCase.GEMS_Medical_Underwriter__c=case_screening.GEMS_Medical_Underwriter__c;
                        eligibilityProcessCase.Sales_Executive__c=case_screening.Sales_Executive__c;
                        eligibilityProcessCase.Productid=case_screening.Productid;
                        eligibilityProcessCase.GEMS_Case_Effective_Date__c = case_screening.GEMS_Case_Effective_Date__c;
                        eligibilityProcessCase.GEMS_Effective_Date__c = case_screening.GEMS_Effective_Date__c;
                        eligibilityProcessCase.status = 'In Progress';            
                        eligibilityProcessCase.recordTypeId = caswEligibilityProcessId ;         
                        eligibilityProcessCase.GEMS_Target_Date_Production_OE_File__c = case_screening.GEMS_Target_Date_Production_OE_File__c;
                        //eligibilityProcessCase.GEMS_Actual_Date_Production_OE_File__c = case_screening.GEMS_Actual_Date_Production_OE_File__c;              
                        eligibilityProcessCase.Opportunity_Name__c = case_screening.Opportunity_Name__c ;
                        eligibilityProcessCase.type = 'Eligibility Process';//ba1[0] + ' ' +ba1[2];
                        eligibilityProcessCase.Sub_Category__c = 'AEP Eligibility';//ba1[0] + ' ' +ba1[2];
                        eligibilityProcessCase.GEMS_Products__c=case_screening.GEMS_Products__c;
                        eligibilityProcessCase.GEMS_Submitter__c = case_screening.ownerId; //Code Added for October Release
                        // This population is for October Hotfix 2016
                         eligibilityProcessCase.Funding_Type_Multiselect__c = case_screening.Funding_Type_Multiselect__c;                
                         eligibilityProcessCase.GEMS_StdCust_Product__c = case_screening.GEMS_StdCust_Product__c;
                         eligibilityProcessCase.GEMS_Rx_Vendor__c = case_screening.GEMS_Rx_Vendor__c;
                         eligibilityProcessCase.GEMS_Line_of_Business__c=case_screening.GEMS_Line_of_Business__c;
                         
                        if(!activeEntitlement.isEmpty()) {
                            eligibilityProcessCase.EntitlementId = activeEntitlement[0].id;
                        }
                        new_cases_list.add(eligibilityProcessCase);
                       }
                                        
                      }
                  }  
                 }

                
                //SFDC-5247 Add the other downstream cases only if the Sub. type is not Acct. Struct. Maint.
                //SFDC 5089  
               List<GEMS_Benefit_Agreement__c> benAgrDataList = benAgrMap.get(submissionIdStructCase.get(case_screening.Id).Id);
               //SFDC-4112
               Boolean createParentmed = false;
               Boolean createParentden = false;
               for(GEMS_Benefit_Agreement__c benAgrData: benAgrDataList) 
               {                                   
                   if (benAgrData.Product__r.Product_Category__c != null || benAgrData.Plan__r.Product__r.Product_Category__c != null){
                          if(benAgrData.Product__r.Product_Category__c == 'Dental'|| benAgrData.Plan__r.Product__r.Product_Category__c == 'Dental'){
                            createParentden = true;
                          }
                          else{
                            createParentmed = true;
                          }
                    }      
               } 
               //SFDC-4112             
               if (case_screening.GEMS_Submission_Type__c != 'Account Structure Maintenance'){ 
                   for(String businessArea : accountSettingMetadataMap.keySet() ) {
                       List<GEMS_Account_Setting__mdt> accountSettingMetaDataList = accountSettingMetadataMap.get(businessArea);
                       
                       for(GEMS_Account_Setting__mdt accountSettingMetData: accountSettingMetaDataList) {
                       
                        System.debug('accountSettingMetData>>>>>' +accountSettingMetData);
                         System.debug('accountSettingMetaDataList >>>>>' +accountSettingMetaDataList);
                          System.debug('businessArea >>>>>' +businessArea);
                           
                           String Search_BCC_Product = '';
                           Search_BCC_Product =  case_screening.GEMS_BCC_Products__c;
                           
                           Boolean BCC_Or_Blue_Care_Connection;
                           If (case_screening.GEMS_Products__c.contains('BCC') || case_screening.GEMS_Products__c.contains('Blue Care Connection'))
                           {
                           BCC_Or_Blue_Care_Connection = true;}
                           else
                           {BCC_Or_Blue_Care_Connection = false;
                           }
                           
                           
                           if(case_screening.GEMS_Products__c != null) {
                               
                               if(accountSettingMetData.Custom_HCA_CDHP__c != null && accountSettingMetData.Custom_HCA_CDHP__c && !case_screening.GEMS_Products__c.contains('HCA') ) {                                   
                                   continue;
                               }
                               if(accountSettingMetData.HSA_Custom__c != null && accountSettingMetData.HSA_Custom__c && !case_screening.GEMS_Products__c.contains('HSA')) {
                                   continue;
                               }
                               if(accountSettingMetData.Incetives_CDHP__c != null && accountSettingMetData.Incetives_CDHP__c && !case_screening.GEMS_Products__c.contains('Incentives')) {
                                   continue;
                               }
                               if(accountSettingMetData.VBID__c != null && accountSettingMetData.VBID__c && !case_screening.GEMS_Products__c.contains('VBID')) {
                                   continue;
                               }
                               if(accountSettingMetData.FSA_CDHP__c != null && accountSettingMetData.FSA_CDHP__c && !case_screening.GEMS_Products__c.contains('FSA')) {
                                   continue;
                               }
                               if(accountSettingMetData.RBP_CDHP__c != null && accountSettingMetData.RBP_CDHP__c && !case_screening.GEMS_Products__c.contains('Reference Based Pricing')) {
                                   continue;
                               } 
                              
                            
                               if (accountSettingMetData.Pharmacy_Rx__c != null && accountSettingMetData.Pharmacy_Rx__c  && accountSettingMetData.Prime_Vendor__c != null
                                && accountSettingMetData.Prime_Vendor__c && (!case_screening.GEMS_Products__c.contains('RX') || !case_screening.GEMS_Rx_Vendor__c.contains('Prime')))
                                 {
                                   continue;
                                 }                              
                               
                                 
                              
                               if(accountSettingMetData.BCC__c != null && accountSettingMetData.BCC__c && accountSettingMetData.BCC_Product__c !=null && (!BCC_Or_Blue_Care_Connection || (Search_BCC_Product != null && !accountSettingMetData.BCC_Product__c.contains(Search_BCC_Product)))) {                               
                                   continue;
                               }                               
                               
                               //SFDC-4112
                               if(accountSettingMetData.Dental__c != null && accountSettingMetData.Dental__c && !(createParentden == true && case_screening.GEMS_Products__c != null && case_screening.GEMS_Products__c.contains('Dental'))) {
                                   continue;
                               }
                               //SFDC-4112
                                System.debug('alertbeforemed >>>>>' );
                                if(accountSettingMetData.Medical__c != null && accountSettingMetData.Medical__c && createParentmed == false) {
                                   continue;
                                 }  
                                 System.debug('alertaftermed >>>>>');
                                     
                               /*if(accountSettingMetData.Medical__c != null && accountSettingMetData.Medical__c && !case_screening.GEMS_Products__c.contains('Medical')) {
                                   continue;
                               }*/
                               CaseTeammember addTeamMember = submissionCaseTeamMembers.get(case_screening.Id).get('Additional Underwriter');
                               
                               if(((accountSettingMetData.Additional_Underwriter__c != null && accountSettingMetData.Additional_Underwriter__c && case_screening.GEMS_Products__c != null ) && addTeamMember == null) ) {
                                   continue;
                               }
                               
                               //SFDC 5089 - Added additional Medical criteria
                               //SFDC-7134 - Changed the citeria to not create Add. UW cases when there is no Add. UW on the case team or when there is only one Dental BA.
                               if(((accountSettingMetData.Additional_Underwriter__c != null && accountSettingMetData.Additional_Underwriter__c && case_screening.GEMS_Products__c != null ) && (addTeamMember != null && createParentmed == false)   ) ) {
                                   continue;
                               }
                               System.debug('case_screening.GEMS_Products__c::'+case_screening.GEMS_Products__c);
                           }

                           /*if( accountSettingMetData.Benefit_Booklet_Required__c) {
                                   continue;
                           }*/
                           
                           System.debug('case_screening.GEMS_Submission_Type__c==>'+case_screening.GEMS_Submission_Type__c+'   '+accountSettingMetData.Account_Submission_Type__c);
                           System.debug('case_screening.Account_Submission_Sub_Type__c==>'+case_screening.GEMS_Submission_Sub_Type__c+'   '+accountSettingMetData.Account_Submission_Sub_Type__c);
                           System.debug('case_screening.GEMS_Line_of_Business__c ==>'+case_screening.GEMS_Line_of_Business__c +'   '+accountSettingMetData.Line_of_Business__c );

                          //if(case_screening.GEMS_StdCust_Product__c!='Standard Products only' && case_screening.GEMS_Submission_Type__c != null && accountSettingMetData.Account_Submission_Type__c != null && case_screening.GEMS_Submission_Type__c.contains(accountSettingMetData.Account_Submission_Type__c)
                          if(createScreening && case_screening.GEMS_Submission_Type__c != null && accountSettingMetData.Account_Submission_Type__c != null && case_screening.GEMS_Submission_Type__c.contains(accountSettingMetData.Account_Submission_Type__c)
                           && ((case_screening.GEMS_Submission_Sub_Type__c != null && accountSettingMetData.Account_Submission_Sub_Type__c != null && case_screening.GEMS_Submission_Sub_Type__c.contains(accountSettingMetData.Account_Submission_Sub_Type__c)) || (accountSettingMetData.Account_Submission_Sub_Type__c == null) ) 
                           && ((case_screening.GEMS_Line_of_Business__c != null && accountSettingMetData.Line_of_Business__c != null && case_screening.GEMS_Line_of_Business__c.contains(accountSettingMetData.Line_of_Business__c)) ||(case_screening.GEMS_Line_of_Business__c != null && accountSettingMetData.Line_of_Business__c == null))
                           // just for back up of original cond - && case_screening.GEMS_Benefit_Booklet_Required__c != null && case_screening.GEMS_Benefit_Booklet_Required__c == accountSettingMetData.Benefit_Booklet_Required__c
                           //&& ((case_screening.GEMS_Benefit_Booklet_Required__c == 'Yes' && accountSettingMetData.Benefit_Booklet_Required__c == TRUE) || (case_screening.GEMS_Benefit_Booklet_Required__c == 'No' && accountSettingMetData.Benefit_Booklet_Required__c == FALSE))
                           
                           ) {
                              if(businessAreaCase.get(businessArea) == null) {
                                case newCase = new case();
                                //System.debug('===caseIdBusinessAreaTeamMemMap==='+caseIdBusinessAreaTeamMemMap);
                                
                                GEMS_CaseOwnership_MetaData__mdt owner2MetaData = screeningAreaMetaDataMap.get(businessArea);
                             
                                Map<String,CaseTeammember> submission2CaseTeamMap = submissionCaseTeamMembers.get(case_screening.Id);
                                     System.debug('===Entered==businessArea=2==');
                                if(owner2MetaData != null && submission2CaseTeamMap != null && submission2CaseTeamMap.get(owner2MetaData.Case_Team_Member__c) != null) {
                                    newCase.ownerId = submission2CaseTeamMap.get(owner2MetaData.Case_Team_Member__c).memberId;
                                }else if(owner2MetaData != null && owner2MetaData.Que_Name__c != null && groupNameIdMap.get(owner2MetaData.Que_Name__c) != null ) {
                                    newCase.ownerId = groupNameIdMap.get(owner2MetaData.Que_Name__c);
                                }

                                DateTime effectiveDate = case_screening.GEMS_Effective_Date__c;
                                newCase.GEMS_Account_Submission_Info__c= case_screening.id;
                                newCase.parentid= case_screening.id;
                                newCase.Accountid=case_screening.Accountid;
                                newCase.Subject=case_screening.Account.Name+' '+ case_screening.Account.External_ID__c +effectiveDate.format('M/d/yyyy') +' '+businessArea;
                                newcase.GEMS_Submission_Type__c=case_screening.GEMS_Submission_Type__c;
                                newCase.FSU_Location__c=case_screening.FSU_Location__c;
                                newCase.HCSC_Division__c=case_screening.HCSC_Division__c;
                                newCase.GEMS_Submission_Sub_Type__c=case_screening.GEMS_Submission_Sub_Type__c;
                                newCase.GEMS_Medical_Underwriter__c=case_screening.GEMS_Medical_Underwriter__c;
                                newCase.Sales_Executive__c=case_screening.Sales_Executive__c;
                                newCase.Productid=case_screening.Productid;
                                newCase.GEMS_Case_Effective_Date__c = case_screening.GEMS_Case_Effective_Date__c;
                                newCase.GEMS_Effective_Date__c = case_screening.GEMS_Effective_Date__c;
                                newCase.status = 'In Progress';            
                                newCase.recordTypeId = caseScreeningId;                        
                                newCase.Opportunity_Name__c = case_screening.Opportunity_Name__c ;
                                String[] ba=businessArea.split(' ');
                                newCase.type = 'Screening';//ba[0] + ' ' +ba[2];
                                newCase.Sub_Category__c = businessArea;
                                newCase.GEMS_Products__c=case_screening.GEMS_Products__c;
                                
                                newCase.GEMS_Rx_Vendor__c = case_screening.GEMS_Rx_Vendor__c;
                                newCase.GEMS_Line_of_Business__c = case_screening.GEMS_Line_of_Business__c ;                                
                                // This population is for October Hotfix 2016
                                newCase.Funding_Type_Multiselect__c = case_screening.Funding_Type_Multiselect__c;                
                                newCase.GEMS_StdCust_Product__c = case_screening.GEMS_StdCust_Product__c;                                 
                                newCase.GEMS_Benefit_Booklet_Required__c = case_screening.GEMS_Benefit_Booklet_Required__c;
                                newCase.GEMS_Submitter__c = case_screening.ownerId;
                                if(!activeEntitlement.isEmpty()) {
                                    newCase.EntitlementId = activeEntitlement[0].id;
                                }

                                businessAreaCase.put(businessArea,newCase);
                                new_cases_list.add(newCase); 
                              }
                           }
                       }
                        
                   }
                   } // SFDC-5247 Close If block
               if(!new_cases_list.isEmpty()) {
                   allScreeningCasesList.addAll(new_cases_list);
               }
            }

            System.debug('allScreeningCasesList::'+allScreeningCasesList);
        List<Task> insertTaskList = new List<Task>();
        if(!allScreeningCasesList.isEmpty()) {
            insert allScreeningCasesList;
           
            for(Case caseScreening : allScreeningCasesList) {                
                if(caseScreening.type == 'Eligibility Process') {
                    String ownerIdString = caseScreening.OwnerId;
                    Task newTask = new Task();
                    newTask.subject = 'AEP Initial Setup';
                    newTask.whatId = caseScreening.Id;
                    //Condetion added for October release to fix the insufficiat access while completing task in Eligibility Process case                    
                    if(caseScreening.OwnerId != null && !(ownerIdString.startsWith('00G'))) 
                        newTask.ownerId = caseScreening.OwnerId;
                                            
                    newTask.status = 'In progress';
                    newTask.Priority = 'Normal';
                    newTask.GEMS_Start_Date__c = System.now();
                    insertTaskList.add(newTask);
                    
                    Task newTask1 = new Task();
                    newTask1.subject = 'AEP Testing';
                    newTask1.whatId = caseScreening.Id;
                    //Condetion added for October release to fix the insufficiat access while completing task in Eligibility Process case
                    if(caseScreening.OwnerId != null && !(ownerIdString.startsWith('00G')))
                        newTask1.ownerId = caseScreening.OwnerId;
                        
                    newTask1.status = 'Not Started';
                    newTask1.Priority = 'Normal';
                    //newTask1.GEMS_Start_Date__c = System.now();
                    insertTaskList.add(newTask1);
                    
                    Task newTask2 = new Task();
                    newTask2.subject = 'AEP Production Ready';
                    newTask2.whatId = caseScreening.Id;
                    //Condetion added for October release to fix the insufficiat access while completing task in Eligibility Process case
                    if(caseScreening.OwnerId != null && !(ownerIdString.startsWith('00G')))
                        newTask2.ownerId = caseScreening.OwnerId;
                        
                    newTask2.status = 'Not Started';
                    newTask2.Priority = 'Normal';
                    //newTask2.GEMS_Start_Date__c = System.now();
                    insertTaskList.add(newTask2);
                    
                }else {
                    if(caseidListOfScreeningCases.get(caseScreening.parentId) != null ) {
                        caseidListOfScreeningCases.get(caseScreening.parentId).add(caseScreening);
                    }else {
                        List<Case> screening = new List<Case>();
                        screening.add(caseScreening);
                        caseidListOfScreeningCases.put(caseScreening.parentId,screening);
                    }
                }
            }
        }
        if(!insertTaskList.isEmpty()) {
            insert insertTaskList;
        }
        System.debug('new cases list====>'+caseidListOfScreeningCases);
        
        }
        Catch(Exception ex) {
            GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', 'CaseTrigger', 'GEMS_AccountScreeningCaseCreation.screeningCasesCreation(List<Case> casesList)','High'); 
            return null;
        }
        
        return caseidListOfScreeningCases;
    }
    
    /******************************************************************* 
    *   Method Name : CreateAccountMaintenanceDownstreamCases
        Action
    *   @description :   This method is to create Account Setup Process case and its tasks for Account Structure Maintenance.
    *   @parameters  :   Set<Id> CaseIds,List<string> TypeofCases,string TypeOfTask
    *   @return type :   void
    ***************************************************************/
    public static void CreateAccountMaintenanceDownstreamCases(Set<Id> CaseIds,List<string> TypeofDownStCases,string TypeOfTask){
        
        //Fetch the GEMS Process Entitlement Id
        List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSProcessEntitlementName LIMIT 1];
        
        //Create a List of Account Set Up Case to be created
        Id accSetupRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        
        //Create a List of Account Set Up Case to be created
        List<Case> acctsetUpCases =new List<Case>();
        
        //Create a List of BlueSTAR Task to be created
        List<Task> BlueStrCompTask =new List<Task>();
        try{
            // Collect the fields from submission cases to pass to the new Account Setup cases
            for(Case acctMaintCase : [select id,GEMS_Products__c ,ownerId,status,GEMS_Line_of_Business__c, Funding_Type_Multiselect__c, accountId, GEMS_Effective_Date__c, 
                 GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, FSU_Location__c, HCSC_Division__c, GEMS_Account_Submission_Info__c, GEMS_StdCust_Product__c,
                 GEMS_Submission_Sub_Type__c, Account.name, Account.External_ID__c, GEMS_Rx_Vendor__c, GEMS_Private_Exchange__c, GEMS_Private_Exchange_Values__c, 
                 Underwriter_Lookup__c, Opportunity_Name__c, GEMS_Ready_to_release_to_screening__c, (select id from Cases1__r where recordTypeId = :accSetupRecordTypeId) ,(Select Id,MemberId  From TeamMembers where TeamRole.Name='Account Specialist' LIMIT 1)
                 from case where Id in:CaseIds]){
                for(string TypDwnCase :TypeofDownStCases){
                        if(TypDwnCase == 'GEMS Account Setup'){
                                Case acctSetupCase = new Case();
                                Date effectiveDate = acctMaintCase.GEMS_Case_Effective_Date__c;
                                acctSetupCase.Type = 'Account Setup Process';
                                acctSetupCase.recordtypeid=accSetupRecordTypeId;
                                acctSetupCase.GEMS_Line_of_Business__c = acctMaintCase.GEMS_Line_of_Business__c;
                                acctSetupCase.GEMS_Rx_Vendor__c = acctMaintCase.GEMS_Rx_Vendor__c;
                                acctSetupCase.Accountid=acctMaintCase.accountId;
                                acctSetupCase.GEMS_Effective_Date__c=acctMaintCase.GEMS_Effective_Date__c;
                                acctSetupCase.GEMS_Case_Effective_Date__c = acctMaintCase.GEMS_Case_Effective_Date__c;
                                acctSetupCase.GEMS_Submission_Type__c=acctMaintCase.GEMS_Submission_Type__c;
                                acctSetupCase.FSU_Location__c=acctMaintCase.FSU_Location__c;
                                acctSetupCase.Status='In Progress';
                                acctSetupCase.parentid = acctMaintCase.Id;
                                acctSetupCase.HCSC_Division__c=acctMaintCase.HCSC_Division__c;                        
                                acctSetupCase.GEMS_Submission_Sub_Type__c=acctMaintCase.GEMS_Submission_Sub_Type__c;
                                acctSetupCase.GEMS_Account_Submission_Info__c=acctMaintCase.Id;
                                acctSetupCase.Subject=acctMaintCase.Account.name+' '+acctMaintCase.Account.External_ID__c + ' ' + effectiveDate.format() + ' Account Setup Process';
                                acctSetupCase.GEMS_Private_Exchange__c = acctMaintCase.GEMS_Private_Exchange__c;     
                                acctSetupCase.GEMS_Private_Exchange_Values__c = acctMaintCase.GEMS_Private_Exchange_Values__c;
                                acctSetupCase.Opportunity_Name__c = acctMaintCase.Opportunity_Name__c;
                                acctSetupCase.Underwriter_Lookup__c = acctMaintCase.Underwriter_Lookup__c;
                                acctSetupCase.GEMS_Submitter__c = acctMaintCase.ownerId;
                                acctSetupCase.Funding_Type_Multiselect__c = acctMaintCase.Funding_Type_Multiselect__c;                
                                acctSetupCase.GEMS_StdCust_Product__c =acctMaintCase.GEMS_StdCust_Product__c;                                                                        
                                acctSetupCase.GEMS_Products__c = acctMaintCase.GEMS_Products__c;
                                acctSetupCase.EntitlementId=activeEntitlement[0].Id!=null?activeEntitlement[0].Id:null;
                                if(acctMaintCase.TeamMembers[0].MemberId !=null){
                                acctSetupCase.ownerId=acctMaintCase.TeamMembers[0].MemberId;
                                acctSetupCase.GEMS_Quality_Reviewer__c = acctMaintCase.TeamMembers[0].MemberId;
                                }
                                acctSetupCase.GEMS_BlueSTAR_Walkthrough_Resource_1__c = acctMaintCase.ownerId;
                                acctsetUpCases.add(acctSetupCase);  
                        }
                }
            }   
            if(!acctsetUpCases.isEmpty()){
                insert acctsetUpCases;
            }
            if( TypeOfTask == 'BlueSTAR Entry Complete'){
                if(!acctsetUpCases.isEmpty()){
                    for(Case acctsetCase : acctsetUpCases)
                        //create BlueStar Complete Entry Task record
                        BlueStrCompTask.add(GEMS_Utility.createTask('In Progress', acctsetCase.Id, acctsetCase.ownerId, 'BlueSTAR Entry Complete', 'Normal', System.now(), null, null));
                    if(!BlueStrCompTask.isEmpty())
                        insert BlueStrCompTask;
                }   
            }
            
      }  
      catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_AccountScreeningCaseCreation.CreateAccountMaintenanceDownstreamCases(Set<Id> CaseIds,List<string> TypeofDownStCases,string TypeOfTask)','High');              
      } 
     }
}