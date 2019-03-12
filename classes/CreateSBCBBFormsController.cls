public with sharing class CreateSBCBBFormsController {
    @AuraEnabled
    public static GEMS_Contract_Admin_Request__c getSBCBBForms(id sCARId){
        GEMS_Contract_Admin_Request__c CAMObj=[Select Id,Name,Category__c,Cluster__c,District__c,Effective_Date__c,Line_of_Business__c,Market_Segment__c,Open_Enrollment_Start_Date__c, Hidden_HCSC_Division__c, Account_Number__c , Region__c,Case__r.Account.HCSC_Division__c,Opportunity_Link__c,Opportunity_Link__r.HCSC_Division__c,Case__c From GEMS_Contract_Admin_Request__c Where Id =:sCARId];
        return CAMObj;
    }
    @AuraEnabled
    public static string getSBCBBFormsRecordType(string sRecordType){
        return Schema.SObjectType.GEMS_SBC_BB_Form__c.getRecordTypeInfosByName().get(sRecordType).getRecordTypeId();
    }
}