/*******************************************************************************
 * This class is to capture all the static string values used in all the classes/triggers
 * and define static variables for them.
 * 
 * DO NOT prefix GEMS to the variables as the class name already has it. This will save lots of apex code characters
 * 
 * Date              Name                            Description
 * ============================================================================================
 * 07/26/2017        Luke Chen                       Pharmacy Scope Code related values
 * 07/28/2017        Phani Kommareddy                Pharmacy Scope code task subjects
 * 08/01/2017        Phani Kommareddy                Added categories
 * 08/11/2017        Malathi.K                       Added Type Eligibility Process and new status.
 * 08/16/2017        Lakshmi                         Added Membership Type in Categories
 * 09/27/2017        Ranjit Gandhi                   Added Account Setup Case task names
 * 10/13/2017        Hari                            Added effective date and Case effective date
 * 09/28/2017        Luke Chen                       SFDC-6129,6871,6872 GEMS Reporting Milestone
 * 10/26/2107        Vijay                           US 6753 Case Standard/Custom products picklist values
 * 11/03/2017        Luke Chen                       SFDC-2702 GEMS - SBC/BB integration CBDM - form data transfer to CBDM
 * 10/26/2107        Vijay                           US 6960 GEMS: DB Coding - Route DB Coding Cases to the DB Coding Screener, not the Queue
 * 11/27/2017        Phani Kommareddy                SFDC-6369 GEMS - ID Card Maintenance: ID Card Case Page Layout & Functionality
 * 11/25/2017        Vijay                           SFCD-4263 Added Case RecordTypes
 * 2/4/2018          Luke Chen                       SFDC-7463 GEMS: Reporting - Adjust all 3 Reporting Milestones to include Submissions where any screening case = "Routed in Error"
 * 01/31/2018        Gokul Bharati                   SFDC-6946 Auto Close Account Submission Case
 * 03/26/2018        Gokul Bharati                   SFDC-7734 GEMs Account Maintenance - Incorrect Case Subject
 *******************************************************************************/
public class GEMS_Constants{
    // General Status
    public static String StatusCompleted = 'Completed';
    public static String StatusInProgress = 'In Progress';
    public static String StatusNotStarted = 'Not Started';
    public static String StatusApproved = 'Approved';
    public static String StatusProdComp = 'Production Completed';
    public static String statusnew = 'New';
    public static String StatusCancelled = 'Cancelled';
    public static String StatusRouteErr = 'Routed In Error';
        
    // Case Record Type
    public static String CaseRecdType_PharmacyCode = 'GEMS Pharmacy Scope Code';
    public static String CaseRecdType_SubmissionCase = 'GEMS Account Submission';
    public static String CaseRecdType_ManualEligibilityCase = 'GEMS Manual Eligibility';
    public static String CaseRecdType_GEMSEligibilityCase = 'GEMS Eligibility';
    public static String CaseRecdType_GEMSMedicalBenefitCodingCase = 'GEMS Medical Benefit Coding';
    public static String CaseRecdType_GEMSGetCase = 'GEMS GET';
    public static String CaseRecdType_GEMSMedicalUnderwritingCase = 'GEMS Medical Underwriting';
    public static String CaseRecdType_GEMSIdCardCase = 'GEMS ID Card';
    public static String CaseRecdType_Screening = 'GEMS Screening';
    public static String CaseRecdType_BAScreening = 'GEMS BA Level Screening';
    
    // pharmacy Scope code status
    public static String RxScopeBETReq = 'BET Submission Required';
    public static String RxScopeNoChanges = 'No Scope Code Changes';
    public static String RxScopeNoBETSub = 'Scope Change Only - NoBETSub';
    

    //Pharmacy Scope Code Task Subjects
    public static String RxTaskSubjPharmaScopeCode = 'Pharmacy Scope Code';
    public static String RxTaskSubjBETCreation = 'BET Creation';
    public static String RxTaskSubjPeerReview = 'Peer Review';
    public static String RxTaskSubjPrimeBuild = 'Prime Build';  
    public static String RxTaskSubjUpdtBSAS400 = 'Update BlueSTAR & AS400';
    public static String BSAS400Started = 'Update BlueSTAR & AS400 Started';
    
    
    //categories AKA Type
    public static String TypeMedicalUnderwriting = 'Medical Underwriting';
    public static String TypeDentalUnderwriting = 'Dental Underwriting';
    public static String TypeEligibilityProcess = 'Eligibility Process';
    public static String TypeMembership = 'Membership';
    public static String TypeAccountSubmission = 'Account Submission';
    public static String TypeAccountMaintenance = 'Account Maintenance';    
    public static String TypeAccountSetupMaintenance = 'Account Setup Maintenance';    
    
    //SFDC-6369 GEMS - ID Card Maintenance: ID Card Case Page Layout & Functionality
    public static String IDCardAssignTypeBA = 'Benefit Agreement';
    public static String IDCardAssignTypeGS = 'Group Section';
    public static String IDCardAssignTypeNone = 'None';
    public static String IDCardAssignTypeBoth = 'Both';
    
    // Env
    public static String PROD = 'PROD';
    public static String UAT = 'UAT';
    public static String SIT = 'SIT';
    
    
    //submission types
    public static String SubmissionTypeNewAc = 'New Account';
    public static String SubmissionTypeRenewal = 'Renewal';
    public static String SubmissionTypeOffCycle = 'Off Cycle';
    public static String SubmissionTypeASM = 'Account Structure Maintenance';
    public static String SubmissionTypeRCM = 'Rate Change/Stop Loss Maintenance';//SFDC-7734
    public static String SubmissionTypeRCMSubType = 'Changes to Rates Only with Dental, No Benefit Changes';
    public static String SubmissionTypeRCMSubTypeStopLoss ='Stop Loss Changes Only with Dental, No Benefit Changes';
    public static String SubmissionTypeIDCardMaintenance = 'ID Card Maintenance';
    
    //Case Standard/Custom Products picklist values US 6753
    public static String standardProducts = 'Standard Products only';
 
    
      // Ranjit - SFDC-6374 Account setup task names
    public static String AccountSetupTaskQualityReview='Quality Review';
    public static String AccountSetupTaskBlueSTARWalkthrough='BlueSTAR Walkthrough';
    
     // Hari - SFDC - 4627 Effective date and Caseeffective date constants
     
    public static String EffDatesBoth ='both';
    public static String EffectiveDate='effdate';
    public static String CaseEffectiveDate='caseffdate';
    
    // Reporting Milestone
    public static Set<String> DentalCaseSet = new Set<String>{'GEMS Dental Underwriting','GEMS Dental Benefit Coding'};
    public static Set<String> MedicalCaseSet = new Set<String>{'GEMS Medical Underwriting','GEMS Medical Benefit Coding'};
    public static Set<String> AdditionalUWSet = new Set<String>{'GEMS Additional Underwriting'};
    public static Set<String> RxCaseSet = new Set<String>{'GEMS Pharmacy Coding'};  
    public static String Released = 'Released';
    public static String MemberReady = 'Member Ready';
    public static String MemberIDCardReady = 'Member Ready + ID Cards Mailed';
    public static String ServiceReady = 'Service Ready';
    public static String IDCardCaseRecordType = 'GEMS ID Card';
    
    // SBC-BB forms
    public static String SbcTypeReq = 'Custom SBC';
    public static String BbTypeReq  = 'Custom Benefit Booklet';
    public static String CbdmSuccess = 'SUCCESS';
    
    //OwnerType
    public static String ownerTypeUser = 'User'; 
    
    //DocTypes
    public static Set<String> docTypes = new Set<String>{'BPA - ASO SIGNED','BPA - ASO UNSIGNED','BPA - DENTAL SIGNED','BPA - DENTAL UNSIGNED','BPA - HCA SIGNED','BPA - HCA UNSIGNED','BPA - HEALTH SIGNED','BPA - HEALTH UNSIGNED','BPA - SIGNED','BPA - UNSIGNED'}; 
    
}