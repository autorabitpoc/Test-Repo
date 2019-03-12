/**************************************************************************************
Apex Trigger Name     : CaseTrigger
Version               : 1.0
Function              : This trigger on CAse object is used to perform various operations on trigger events on Case. 
Modification Log      :
* Developer                 Date            Description
* ----------------------------------------------------------------------------                 
*   Suyog Dongaonkar        03/10/2014      Original Version
*   Ranjit Gandhi           06/26/2017      SFDC-4250-GEMS - NO GET case should be created for cosmetic account maintenance case (even if account team has a CIC on it) 
*   Luke Chen               06/09/2017      SFDC-3376 Dental Benefit Coding case change
*   Zachary Campbell        06/23/2017      SFDC-4160 Added call to checkIfGroupNumberRequired
*   Rajeesha/Lakshmi        06/20/2017      SFDC-3820 Automatically Cancel all downstream cases when an account submission case is cancelled
*   Rajeesha                07/03/2017      SFDC-3432 GEMS - Screening Cases - Lock the Status Field on the parent case
*   Bharath                 07/28/2017      SFDC-5102 Call the handler class to populate BA details in case object before insert and update.
*   Malathi.K               07/30/2017      SFDC-5247 Create Eligibility Process case for Account Structure Maintenance.
*   Sree Harsha             07/30/2017      SFDC-5248 AND SFDC-5249 Account Structure Maintenance - Medical and Dental Underwriting Case
*   Phani                   08/01/2017      Optimize SFDC-5248 AND SFDC-5249 Account Structure Maintenance - Medical and Dental Underwriting Case
*   Luke Chen               08/02/2017      SFDC-5246 Account Structure Maintenance - Account Structure case: Page Layout & Functionality
*   Lakshmi                 08/16/2017      SFDC-5589 Account Eligibilty Maintenance - Maintenance Case PageLayout and Functionality
*   Phani Kommareddy        09/04/2017      SFDC-5927 and SFDC-5333 Notifications for commissions and porbob fields
*   Malathi.K               09/12/2017      SFDC-5096 SharePoint for RequestHub/Acct. Maint.
*   Zachary Campbell        09/29/2017      SFDC-5613 Remove code updates from SFDC-4160.
*   Ranjit Gandhi           09/12/2017      SFDC-4289 GEMS: Update Medical Coding BA Level Case - Page Layout/Validations
*   Hari                    09/26/2017      SFDC-4627 Effective date and Case effective date update on Downstream Cases
*   Hari                    10/11/2017      SFDC-6116 GEMS: CIC on an the Account Team is Recognized as the Submitter
*   Zachary Campbell        10/20/2017      SFDC-6677 commented-out checkIfModifiedBlueDirectionsProductRecords
*   Phani Kommareddy        10/16/2017      SFDC-6381 GEMS: Upon cancellation of Case, notifications are sent to Case Owners and Case Team
*   Luke Chen               10/25/2017      SFDC-6129,6871,6872 GEMS Reporting Milestone
*   Phani Kommareddy        11/27/2017      SFDC-6370 GEMS - ID Card Maintenance: Account Setup Maintenance Page Layout & Functionality
*   Gokul Bharati           02/12/2018      SFDC-6946 GEMS - GEMS: Acct Sub - Automatically mark Account Submission Case as "Completed" when Downstream cases complete
*   Malathi.K               05/14/2018      SFDC-8197 GEMS - ID Card Maintenance: Trigger Account Setup Maintenance Case at the same time as ID Card Maintenance Case
*   Gokul Bharati           05/17/2018      SFDC-9232 GEMS - Move Trigger after updates email notifications to future callout Refer GEMS_EmailNotification Class
*************************************************************************************/
trigger CaseTrigger on Case (before insert, before update, after insert, after update , before delete) {
    
    //SFDC - GROUP SALESFORCE- 13986
        Map<ID,Schema.RecordTypeInfo> record_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
    //Case newCase2 = trigger.new[0];
    //if(record_Map.get(newCase2.recordTypeID) != null && record_Map.get(newCase2.recordTypeID).getName().containsIgnoreCase('SGR-Renewals')){      
    if( trigger.isAfter && trigger.isUpdate )
    { system.debug('hi');
        Map<ID,Schema.RecordTypeInfo> record_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
        //  List<case> case1 = new List<case>();
        for(Case newCase1 : trigger.new){
            if(record_Map.get(newCase1.recordTypeID) != null && record_Map.get(newCase1.recordTypeID).getName().containsIgnoreCase('SGR-Renewals')){          
                set<Id> recid = trigger.newMap.keySet();
                List<Id> rectypid = new List<Id>(recid);
                system.debug('came into  sgr case');
                SGR_FutureTriggerClass.opptyUpdate(rectypid); 
                
            }
        }
    }
    //}
    //else{   
    
    CaseTriggerHandler caseTriggerHandlerInstance = new CaseTriggerHandler();
    Map<ID,Schema.RecordTypeInfo> recordType_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
    List<case> caseList = new List<case>();
    if(Trigger.isDelete) {
        for(Case newCase : trigger.old){
            if(recordType_Map.get(newCase.recordTypeID) != null && recordType_Map.get(newCase.recordTypeID).getName().containsIgnoreCase('GEMS')){          
                caseList.add(newCase);
                break;
            }
        }
    }
    else{
        for(Case newCase : trigger.new){
            //if(recordType_Map.get(newCase.recordTypeID) != null && recordType_Map.get(newCase.recordTypeID).getName().containsIgnoreCase('GEMS')){          
            if(recordType_Map.get(newCase.recordTypeID) != null && (recordType_Map.get(newCase.recordTypeID).getName().containsIgnoreCase('GEMS') ||
                                                                    recordType_Map.get(newCase.recordTypeID).getName().containsIgnoreCase('Account Maintenance'))){          
                                                                        caseList.add(newCase);
                                                                        break;
                                                                    }
        }
    }
    if(!caseList.isEmpty()) {
        if( trigger.isAfter && trigger.isUpdate) {
            GEMS_CaseTriggerHandler.updateEligibilityCasesOwner(trigger.new,trigger.oldMap);
            system.debug('came into  other case');
            caseTriggerHandlerInstance.updateAccountComplexityScoreForCase(trigger.new, trigger.oldMap);            
            //GEMS_CaseTriggerHandler.createScreeningCases(trigger.new, trigger.oldMap); // Code to create Screening Cases     
            GEMS_CaseTriggerHandler.updateReadyToReleaseScreeningStatusChange(trigger.new , trigger.oldMap);                
            //GEMS_EmailNotification.sendMedicalBenefitCoderNotification(Trigger.new,Trigger.oldMap);
            //GEMS_EmailNotification.onIdCardCompletesendNotificationToAccSpecialistCICiAccMngmntUsers(trigger.new,trigger.oldMap);
            GEMS_CaseTriggerHandler.createAccountStructureCase(trigger.new,trigger.oldMap);
            //GEMS_CaseTriggerHandler.createSBCCase(trigger.new,trigger.oldMap);  
            //GEMS_CaseTriggerAccountStructureHandler.getContactFromAccount(trigger.new);
            //GEMS_CaseTriggerHandler.parentCaseStatusApprove(trigger.new,trigger.oldmap);
            GEMS_CaseTriggerHandler.createAccountSetupProcessOnBaScreeningComplete(trigger.new, trigger.oldMap);
            //GEMS_CaseTriggerHandler.parentCompleteUpdation(trigger.new,trigger.oldmap);
            GEMS_CaseTriggerHandler.parentStatusChangeAllProcessCaseStatusChange(trigger.new,trigger.oldmap);
            
            GEMS_CaseTriggerHandler.parentReleaseToUnderwriterUpdation(trigger.new,trigger.oldmap);                
            GEMS_CaseTriggerHandler.createMembershipCase(trigger.new,trigger.oldmap);
            // SFDC-3376 Dental Benefit Coding case change
            // Process change, Add new method to create Dental Benefit Coding cases after UW cases are approved
            GEMS_CaseTriggerHandler.createDentalBenefitCodingCase(trigger.new,trigger.oldmap);
            GEMS_CaseTriggerHandler.createFSUClaimsCase(trigger.new,trigger.oldmap);
            GEMS_CaseTriggerHandler.parentStatusChangeAllBAScreeningChange(trigger.new,trigger.oldmap);
            GEMS_CaseTriggerHandler.createManualEligibilityWhenAllUnderwitingCasesComplete(trigger.new,trigger.oldmap);
            //GEMS_CaseTriggerHandler.updateParentStatusToReturnIfAnyChildReturns(trigger.new,trigger.oldmap);
            //GEMS_CaseTriggerHandler.sendEmailNotificationWhenLastBAApproved(trigger.new,trigger.oldmap);
            //GEMS_CaseTriggerHandler.caseAccountSetupProcessApproveStatus(trigger.new,trigger.oldmap);
            GEMS_taskOwnershipHandler.changeTaskOwnerOnCaseOwnerChange(trigger.new,trigger.oldmap);
            //CaseTriggerHandler.updateSharePointFolder(trigger.new, trigger.oldMap);
            //GEMS_ScreeningCaseControllerBatch.createIdCardAndProcessCasesForStandardProduct(trigger.new,trigger.oldmap); // Praveen Added
            //GEMS_ScreeningCaseControllerBatch.createAccountSetupProcessforStandardProduct(trigger.new,trigger.oldmap); // Praveen Added
            // 09/12/2017       Ranjit Gandhi       SFDC-4289 GEMS: Update Medical Coding BA Level Case - Page Layout/Validations
            
            //GEMS_ScreeningCaseControllerBatch.sendMedicalBenefitCodingCaseForDTUApproval(trigger.new,trigger.oldmap); // no longer needed- Ranjit 
            GEMS_CaseTriggerHandler.createAccountSetupOnAllBAsApproved(trigger.new,trigger.oldmap);
            GEMS_EmailNotification.onCaseOwnerChangeUpdateOwnerOnPharmacyScopeCode(trigger.new,trigger.oldmap);
            GEMS_EmailNotification.assignEntitlementToDBCOnceMedUnderwriterCaseApproved(trigger.new,trigger.oldmap);
            GEMS_EmailNotification.updateIdCardFormatFieldOnIdCardParentCase(trigger.new,trigger.oldmap);
            GEMS_CaseTriggerHandler.parentStatusChangeOnChildPharmacyCaseChange(trigger.new,trigger.oldmap);
            //SFDC-5247-GEMS - Create Eligibility process case for Account structure maintenance.                                
            GEMS_CaseTriggerHandler.CreateAcctMaintEligProcessCase(trigger.new , trigger.oldMap); 
            //SFDC-3820:Calling childCaseStatusTOCancelled method in Gems_CaseTriggerHandler
            GEMS_CaseTriggerHandler.childCaseStatusTOCancelled( trigger.new, trigger.oldMap);
            //SFDC-5095:Calling cancelDownstreamAccountMaintenanceCases method in Gems_CaseTriggerHandler
            GEMS_CaseTriggerHandler.cancelDownstreamAccountMaintenanceCases( trigger.new, trigger.oldMap);
            //SFDC-5426:Create Account Set up case for Account Maintenance
            GEMS_CaseTriggerHandler.CreateAcctSetUpProcessCase(trigger.new , trigger.oldMap);
            //SFDC-5248 AND SFDC-5249 Account Structure Maintenance - Medical and Dental Underwriting Case
            //SFDC-5589 Account Eligibilty Maintenance - Membership Case
            GEMS_CaseTriggerHandler.parentStatusUpdation(trigger.new,trigger.oldMap);
            //SFDC-5927 and SFDC-5333 Commissions and PORBOB notifications
            GEMS_CaseTriggerHandler.updateMUW(trigger.new,trigger.oldMap);
            //SFDC-5930 Update testing records of medical benefit coding record.
            GEMS_CaseTriggerHandler.updateMBCTestEmail(trigger.new, trigger.oldMap);
            // reporting milestone SFDC-6129, 6871, 6872
            GEMS_ReportingMilestone_Handler.processReportingMilestone(trigger.newMap,trigger.oldMap);  
            //SFDC-6370 GEMS - ID Card Maintenance: Account Setup Maintenance Page Layout & Functionality
            // SFDC-8197 Comment the call from here and create the Acct. Setup Maint. from GEMS_CosmeticAccountMaintenance in idCardRelease
            //GEMS_CaseTriggerHandler.createIDCardMaintenanceAccountSetup(trigger.new, trigger.oldMap);
            //SFDC-6946 Auto Close Submission Case
            GEMS_CaseTriggerHandler.autoUpdAccSubCaseBPA(trigger.newMap,trigger.OldMap);
            
            if(!System.isFuture() && !System.isBatch() ) {                   
                GEMS_CaseTriggerHandler.updateUnderwriterFlagOnMedicalBenefitCodingCase(trigger.new,trigger.oldmap);
                GEMS_CaseTriggerHandler.updateSubmitterFieldFutureCall(trigger.new,trigger.oldmap);
                //SFDC-4627 Effective date and Case effective date update on Downstream Cases
                GEMS_CaseTriggerHandler.parentEffectivedateUpdateOnChildCaseEffectivedate(trigger.newMap,trigger.oldMap);
                //SFDC-9232 GEMS: Tech Debt - Update Case Trigger Handler - to avoid SOQL Limit/Error
                GEMS_EmailNotification.processEmailNotification(trigger.new,trigger.oldMap); 
            }
                      
            System.debug('1. Number of queries used in the Trigger after update apex code so far: ' + Limits.getQueries());
            System.debug('2. Number of rows queried in the Trigger after update apex code so far: ' + Limits.getDmlRows());
            System.debug('3. Number of script statements used in the Trigger after update apex code so far : ' + Limits.getDmlStatements());
            
   

        }
        if( trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
            //GEMS_CaseTriggerHandler.OnBeforeInsert(trigger.new);//code added for GEMS Application
            //GEMS_CaseTriggerHandler.populateNotificationSendDate(trigger.new );
            //5102 - Method being called to update BA Product and is new flag of BA in Case object.
            GEMS_CaseTriggerHandler.updateBADetails(trigger.new);     
            
            if(trigger.isInsert) {
                //GEMS_CaseTriggerHandler.incrementCaseNumber(trigger.new);
                GEMS_CaseTriggerHandler.OnBeforeInsert(trigger.new);//code added for GEMS Application
                //GEMS_CaseTriggerHandler.setSBCBACaseOwner(trigger.new);
                //6116-GEMS: CIC on an the Account Team is Recognized as the Submitter
                GEMS_CaseTriggerHandler.caseOwnerChange(trigger.new);
                
            }
            if(trigger.isUpdate) {
                GEMS_CaseTriggerHandler.updateBAChildCasesOwner(trigger.new,trigger.oldMap);                                   
                GEMS_CaseFieldvalidationHandler.beforeGetCaseUpdate(Trigger.new,Trigger.newMap);
                GEMS_CaseFieldvalidationHandler.beforeStructureCaseUpdate(Trigger.new,Trigger.newMap,Trigger.oldMap);
                GEMS_CaseTriggerHandler.benefitAdhocMeetingMinutesCheckForGetCase(trigger.new,trigger.oldmap);
                GEMS_CaseTriggerHandler.updateUnderiterCaseOwner(trigger.new,trigger.oldmap);
                // SFDC-5230 Commented the below method call as part of MBC case status cleanup.
                //GEMS_CaseTriggerHandler.updateOwnerToBenefitCoderFeekReceived(trigger.new,trigger.oldmap);
                GEMS_CaseTriggerHandler.completeMilestoneForClosedScreeningCases(trigger.new,trigger.oldmap);
                GEMS_UnderwriterNotification.sendCaseToAccountSpecialist(trigger.new , trigger.oldMap);
                GEMS_UnderwriterNotification.sendNotificationToCaseOwner(trigger.new , trigger.oldMap);
                //SFDC-3432 GEMS - Screening Cases - Lock the Status Field on the parent case
                GEMS_CaseTriggerHandler.preventParentScreeningCaseStatusChange(trigger.new, trigger.oldMap);
                //SFDC-4285 Medical Coding Case - Add Key Dates section and date field
                GEMS_CaseTriggerHandler.preventStatusChange(trigger.new, trigger.oldMap);
                //SFDC-4627 Effective date and Case effective date update on Downstream Cases
                GEMS_CaseTriggerHandler.parentSujectUpdate(trigger.new,trigger.oldMap);
                
                
                
            }
            System.debug('4. Number of queries used in the Trigger before insert/update apex code so far: ' + Limits.getQueries());
            System.debug('5. Number of rows queried in the Trigger before insert/update apex code so far: ' + Limits.getDmlRows());
            System.debug('6. Number of script statements used in the Trigger before insert/update apex code so far : ' + Limits.getDmlStatements());  
        }
        if( trigger.isAfter && trigger.isInsert) {
            
            Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
            caseTriggerHandlerInstance.updateAccountComplexityScoreForCase(trigger.new, new Map<Id, Case>());
            GEMS_CaseTriggerHandler.createCaseTeamMembers(trigger.new);//Method to create submission CaseTeamMembers
            
            GEMS_CaseTriggerAccountStructureHandler.CreateBA_GS_Cat_Assignments(trigger.new);
            
            //Added If Condition: SFDC-4250-GEMS - NO GET case should be created for cosmetic account maintenance case (even if account team has a CIC on it) 
            Id caseCosmeticAccountMaintenanceId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
            if(trigger.new[0].recordtypeid != caseCosmeticAccountMaintenanceId)
                GEMS_CaseTriggerHandler.createGetCase(trigger.new);
            
            
            GEMS_CaseTriggerHandler.firstAndLastBAApproveStatusNotification(trigger.new);
            if(trigger.new[0].recordtypeid == caseAccountSubmissionId )
                CaseTriggerHandler.createSharePointFolder(trigger.new);
                
            
            //SFDC-5096 - Create sharepointfolder for Acct: Maint.    
            if(trigger.new[0].recordtypeid == caseCosmeticAccountMaintenanceId )
                CaseTriggerHandler.createSharePointFolder(trigger.new);
            
            GEMS_CaseTriggerHandler.updateEligibilityCasesOwner(trigger.new,trigger.oldMap);
            // reporting milestone SFDC-6129, 6871, 6872
            GEMS_ReportingMilestone_Handler.processReportingMilestone(trigger.newMap, null);              
            //GEMS_CaseTriggerAccountStructureHandler.getContactFromAccount(trigger.new);
            //GEMS_CaseTriggerHandler.addOwnerForSBCCasesRoundRobin(trigger.new);           
            System.debug('7. Number of queries used in the Trigger after insert apex code so far: ' + Limits.getQueries());
            System.debug('8. Number of rows queried in the Trigger after insert apex code so far: ' + Limits.getDmlRows());
            System.debug('9. Number of script statements used in the Trigger after insert apex code so far : ' +  Limits.getDmlStatements());
        }
        if( trigger.isAfter && trigger.isDelete) {
            caseTriggerHandlerInstance.updateAccountComplexityScoreForCase(trigger.old, new Map<Id, Case>());
            System.debug('10. Number of queries used in the Trigger after delete apex code so far: ' + Limits.getQueries());
            System.debug('11. Number of rows queried in the Trigger after delete apex code so far: ' + Limits.getDmlRows());
            System.debug('12. Number of script statements used in the Trigger after delete apex code so far : ' + Limits.getDmlStatements());
        }
        
    }
    else {
        
        ID recid =Schema.SObjectType.case.getRecordTypeInfosByName().get('SGR-Renewals').getRecordTypeId();
          case c = new case();   
        if (Test.isRunningTest() || (!Test.isRunningTest() && ConstantsController.CheckTriggerExecution(userinfo.getProfileId(), ConstantsController.CaseTriggerField))) {
            //Before insert, check record editability and update case owner/Assigned to
            if(trigger.new !=NULL){
            c = trigger.new[0];
                
            }
            //case c1= trigger.old[0];
           // if(c.RecordTypeId!=recid)
            //{
            if ( trigger.isBefore && trigger.isInsert && c.RecordTypeId!=recid ) {
                
                CaseTriggerHandler.checkCaseEditability( trigger.new );
                CaseTriggerHandler.updateCaseOwnerByQueue( trigger.new );
                CaseTriggerHandler.updateAssignedToOnCase(trigger.new);
                CaseTriggerHandler.updateCaseOwnerByEmail(trigger.new, new map<Id, Case>());
                CaseTriggerHandler.manageCaseAccountLookups( trigger.new);
                CaseTriggerHandler.updateCustomContractFields(trigger.new);
                CaseTriggerHandlerLGNA.UpdateIntegrationAction(trigger.new , trigger.oldmap);
                CaseTriggerHandlerLGNA.changeIntegrationAction(trigger.new , 'Insert');
                caseTriggerHandlerInstance.populateContractSignerFields(trigger.new);
                CaseTriggerHandler.populateSalesExecutiveNameField( trigger.new, new Map<Id, Case>() );
                CaseTriggerHandler.populateCaseDescriptionForCedeCases( trigger.new );
                
            }
            //Before update, check record editability and update case owner/Assigned to
            if ( trigger.isBefore && trigger.isUpdate && c.RecordTypeId!=recid) {
                CaseTriggerHandler.checkCaseEditability( trigger.new, trigger.old );
                CaseTriggerHandler.updateCaseOwnerByQueue( trigger.new, trigger.old);
                CaseTriggerHandler.updateAssignedToOnCase( trigger.new, trigger.old);
                CaseTriggerHandlerLGNA.UpdateIntegrationAction(trigger.new , trigger.oldmap);
                CaseTriggerHandler.updateCaseOwnerByEmail(trigger.new, trigger.oldmap);
                
                CaseTriggerHandler.manageCaseAccountLookups( trigger.new );
                if (!CaseTriggerHandlerLGNA.restrictExecution  && c.RecordTypeId!=recid )
                    CaseTriggerHandlerLGNA.changeIntegrationAction(trigger.new , 'Update');
                //Check for the Carrier History Last 24 months data covered
                CaseTriggerHandlerLGNA.validateCarrierHistoryValidation(trigger.new, trigger.oldMap, trigger.newMap);
                CaseTriggerHandlerLGNA.AppendExternalIdWithCaseNumber(trigger.new , trigger.oldmap);
                CaseTriggerHandlerLGNA.updateUnderwritingDueDates(trigger.new, trigger.oldMap);
                CaseTriggerHandlerLGNA.validateOwnerChange(trigger.new , trigger.oldMap);
                CaseTriggerHandler.privateExchangeCheckSubCasesIfClosed(trigger.new, trigger.newMap, trigger.oldMap);
                CaseTriggerHandler.updatePerformanceGuaranteeStatus(trigger.new, trigger.oldMap);
                CaseTriggerHandler.updatePerformanceGuaranteeCaseOwner(trigger.new, trigger.newMap, trigger.oldMap);
                CaseTriggerHandler.updateLineItemReviews(trigger.oldMap, trigger.newMap);
                caseTriggerHandlerInstance.lockPerformanceGuaranteeForAcctExecs(trigger.new, trigger.newMap, trigger.oldMap);
                CaseTriggerHandler.populateSalesExecutiveNameField( trigger.new, trigger.oldmap );
            }
            
            
            if ( trigger.isAfter && trigger.isInsert && !CaseTriggerHandlerLGNA.restrictExecution && c.RecordTypeId!=recid) {
                caseTriggerHandlerInstance.updateAccountComplexityScoreForCase(trigger.new, new Map<Id, Case>());
                CaseTriggerHandler.createCaseOwnershipTrackingRecord( trigger.new );
                CaseTriggerHandler.createBlueDirectionsProductRecords(trigger.new);
                CaseTriggerHandler.updateBlueDirectionsProductRecords(trigger.new);
                CaseTriggerHandlerLGNA.calloutHelperMethod(trigger.new , 'Insert');
                CaseTriggerHandler.updateOpportunityIfPECase(trigger.new);
                CaseTriggerHandler.createSharePointFolder(trigger.new);
                
            }
            
            if ( trigger.isAfter && trigger.isUpdate && !CaseTriggerHandlerLGNA.restrictExecution && c.RecordTypeId!=recid) {
                caseTriggerHandlerInstance.updateAccountComplexityScoreForCase(trigger.new, trigger.oldMap);
                CaseTriggerHandler.createCaseOwnershipTrackingRecord( trigger.new, trigger.old );
                CaseTriggerHandler.createBlueDirectionsProductRecords(trigger.new);
                /*** start SFDC-6677 ***/
                //CaseTriggerHandler.checkIfModifiedBlueDirectionsProductRecords(trigger.new);
                /*** start SFDC-6677 ***/
                if ( trigger.isAfter && trigger.isUpdate && !CaseTriggerHandlerLGNA.restrictExecution ){
                CaseTriggerHandlerLGNA.DeleteCasesWithCloseMArkedStatus(trigger.new);
                }
                CaseTriggerHandlerLGNA.calloutHelperMethod(trigger.new , 'Update');
                CaseTriggerHandler.clonePrivateExchangeRecords(trigger.new, trigger.oldMap);
                //CaseTriggerHandler.updateSharePointFolder(trigger.new, trigger.oldMap);      
            }
            if ( trigger.isBefore && trigger.isDelete ) {
                CaseTriggerHandlerLGNA.CascadeDeleteDetailsTrigger(trigger.old);
            }
            if ( trigger.isAfter && trigger.isDelete ) {
                caseTriggerHandlerInstance.updateAccountComplexityScoreForCase(trigger.old, new Map<Id, Case>());
            }
            if ( trigger.isBefore && (trigger.isInsert || trigger.isUpdate) && !CaseTriggerHandlerLGNA.restrictExecution && c.RecordTypeId!=recid) {
                ESalesUtilityClass.UpdateCaseRecordESales(trigger.new);
                CaseTriggerHandler.updateTypeFieldOnCustomContract(trigger.new);
            }
            if ( trigger.isAfter && (trigger.isInsert || trigger.isUpdate) && !CaseTriggerHandlerLGNA.restrictExecution && c.RecordTypeId!=recid) {
                ESalesUtilityClass.GenerateXMLFile(trigger.new);
                CaseTriggerHandler.updateAccountNumberEsales(trigger.newMap, trigger.oldMap);
                CaseTriggerHandlerLGNA.SendChatterNotifications( trigger.newMap, trigger.oldMap );
                /*** start SFDC-5613 ***/
                //CaseTriggerHandlerLGNA.checkIfGroupNumberRequired(trigger.new);
                /*** end SFDC-5613 ***/
            }
        //}
        }
    }
    }
//}