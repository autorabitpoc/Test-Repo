/********************************************************************************************************
Name        : GEMS_ContractAdminReqHelper
Description : New button for Contract Admin Request from the Submission Case screen.
Version History:
Date        Developer               Description
08/21/2017  Bharath, Shankar        SFDC-5647
6/10/2018   Gokul Bharati           SFDC-9541 GEMS: Add Contract Admin Request to Cosmetic and Account Eligibility Maintenance Cases (SBC/BB
*******************************************************************************************************/

global class GEMS_ContractAdminReqHelper {
    webservice static string addNewRecord(Id caseID) {
        try{
            // Get account structure case and opportunity records
            Case accSubCase = [Select Id,GEMS_Line_Of_Business__c,GEMS_Submission_Type__c,Account.HCSC_Division__c, Region__c, Opportunity_Name__c, GEMS_Effective_Date__c, Account.District__c, Account.Cluster__c, Account.Market_Segment__c, 
                               Account.Line_of_Business__c, Account.Open_Enrollment_Date__c, Account.Region__c, GEMS_Case_Effective_Date__c from Case where id = :caseId];
            
            List<GEMS_Contract_Admin_Request__c> reqList = new List<GEMS_Contract_Admin_Request__c>();
            Opportunity opp = new Opportunity();
            GEMS_Contract_Admin_Request__c req = null; 
            
            //SFDC-9541 Check for Submission / Maintenance 
            Boolean check = false; //by default false for submission
            
             if(accSubCase.GEMS_Submission_Type__c!=null){
              if(accSubCase.GEMS_Submission_Type__c.containsIgnoreCase('Maintenance')){
                if(accSubCase.GEMS_Submission_Type__c.containsIgnoreCase('Cosmetic Account Maintenance') || accSubCase.GEMS_Submission_Type__c.containsIgnoreCase('Account Eligibility Maintenance')){
                    check = true;
                }  
                else{
                    string message = 'Applies only to Cosmetic and Account Eligibilty Maintenance types';
                    return message;
                }
              }   
            }
            //SFDC-9541 Check for Submission / Maintenance 
            
            //Submission Scenario
            if(!check){
                opp = [select id, name, AccountId, Requested_Effective_Date__c from Opportunity where id = :accSubCase.Opportunity_Name__c limit 1];
                
                // Get the request record based on opportunity (not using case id), since request created from Request Hub will not have a case associated yet
                reqList = [Select Id, Case__c from GEMS_Contract_Admin_Request__c WHERE Opportunity_Link__c = :opp.Id LIMIT 1];
            }
            //Maintance Scenario get the CAR existing record for the maintenance case.
            else{
                reqList = [Select Id, Case__c from GEMS_Contract_Admin_Request__c WHERE Case__c = :caseID LIMIT 1];
            }
            // Create a new GEMS_Contract_Admin_Request__c record if none exists
            // The If Loop is applicable for both Submission and Maintenance 
            if (reqList.isEmpty()) {
                req = new GEMS_Contract_Admin_Request__c();               
                //Update request fields from associated account and case records
                
                //SFDC-9541 Only for Submission
                if(!check){
                    req.Opportunity_Link__c = accSubCase.Opportunity_Name__c;
                    req.Effective_Date__c = accSubCase.GEMS_Effective_Date__c;
                    req.Line_of_Business__c = accSubCase.Account.Line_of_Business__c;
                }
                else{
                    req.Effective_Date__c = accSubCase.GEMS_Case_Effective_Date__c;
                    req.Line_of_Business__c = accSubCase.GEMS_Line_of_Business__c;
                }    
                
                req.Case__c = accSubCase.id;
                req.Category__c = 'Contract Admin';
                req.Status__c = 'New';
                req.Hidden_HCSC_Division__c = accSubCase.Account.HCSC_Division__c;
                // Non mandatory field values derived from account record
                req.District__c = accSubCase.Account.District__c;
                req.Cluster__c = accSubCase.Account.Cluster__c;
                req.Market_Segment__c = accSubCase.Account.Market_Segment__c;
                req.Region__c = accSubCase.Account.Region__c;             
                req.Open_Enrollment_Start_Date__c = accSubCase.Account.Open_Enrollment_Date__c;
                insert req;
            } 
            //The else if loop is only applicable for Submission  via Opportunity CAR creation
            else if (!reqList.isEmpty()) { 
                req = reqList.get(0);
                if (null != req && null == req.Case__c) {
                    // Probably request created from Opportunity Request Hub. Link this record to submission case
                    req.Case__c = accSubCase.Id;
                    update req;
                }
            }
            
            PageReference ref = new PageReference('/' + req.id);
            return ref.getUrl();
        }   
        catch(Exception e){
            return null; 
        }
    }
}