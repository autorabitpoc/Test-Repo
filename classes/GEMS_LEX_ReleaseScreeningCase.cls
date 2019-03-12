//************************************************************************************
// Name             : GEMS_LEX_ReleaseScreeningCase.cls
// Description      : 
// Created By       : 
// Created Date     : 1/18/2018
// ************************Version Updates********************************************
// Date             Developer           Description
// 01/21/2018       Gokul Bharati       US-6935
// 01/19/2018       Malathi Kethireddy  US-7252
// 02/19/2018       Malathi Kethireddy  US-4243
// -----------------------------------------------------------------------------------
global class GEMS_LEX_ReleaseScreeningCase{

@AuraEnabled
webservice static string valAccSubBeforeRelease(string caseId){
string message='';
 try{
    Case caseRec = [select Id,GEMS_Submission_Type__c,GEMS_OE_Eligibility_Method__c,GEMS_Target_Date_Production_OE_File__c,GEMS_ID_Cards_Format__c,GEMS_Benefit_Booklet_Required__c,GEMS_SBC_Required__c from case where Id=:caseId];
    //SFDC-6935
    if((!string.isBlank(caseRec.GEMS_Submission_Type__c) && caseRec.GEMS_Submission_Type__c != 'Off Cycle') && caseRec.GEMS_Submission_Type__c != 'Renewal' && (caseRec.GEMS_OE_Eligibility_Method__c != 'Portal' && !string.isBlank(caseRec.GEMS_OE_Eligibility_Method__c))){
       if(caseRec.GEMS_Target_Date_Production_OE_File__c == null){
       message +='\nProduction OE File: Target Date is required for all new accounts, unless the OE Eligibility Method is Portal';
       }
    } 
    // SFDC 7252
    if(!string.isBlank(caseRec.GEMS_Submission_Type__c) && caseRec.GEMS_Submission_Type__c != 'Off Cycle'){
       if(string.isBlank(caseRec.GEMS_SBC_Required__c)) {
       message +='\nWill HCSC Create SBC? is required, unless it is an off-cycle submission';
       }
    
       if(string.isBlank(caseRec.GEMS_ID_Cards_Format__c)) { 
       message +='\nID Card Format is required, unless it is an off-cycle submission';
       }
    
       if(string.isBlank(caseRec.GEMS_Benefit_Booklet_Required__c)){  
       message +='\nBenefit Booklet Required? is required, unless it is an off-cycle submission';
       }
    }
    if(!string.isBlank(message)){
       return message;
    } 
 }
 catch(Exception ex){
    string error = 'Failed.Please contact GEMS support for assistance';
    system.debug('Exception Message:'+ex.getMessage()+' Exception Line Number:'+ex.getLineNumber());
    return error;
 }
 return 'validated';
}

// SFDC 7252
@AuraEnabled
webservice static string valAccSubBeforeCreateAcctStruct(string caseId){
string message = '';
 try{
    Case caseRec1 = [select Id,GEMS_Submission_Type__c,GEMS_OE_Eligibility_Method__c,GEMS_Maint_Eligibility_Method__c,GEMS_SBC_Required__c,GEMS_Benefit_Booklet_Required__c from case where Id=:caseId];      
    if(caseRec1.GEMS_Submission_Type__c != 'Off Cycle' && !string.isBlank(caseRec1.GEMS_Submission_Type__c)){
       if(caseRec1.GEMS_OE_Eligibility_Method__c ==''||caseRec1.GEMS_OE_Eligibility_Method__c == null) {
       message +='\nOE Eligibility Method is required, unless it is an off-cycle submission';
       }
        
       if(string.isBlank(caseRec1.GEMS_Maint_Eligibility_Method__c))  {
       message +='\nMaint. Eligibility Method required, unless it is an off-cycle submission';
       }
       
       if(string.isBlank(caseRec1.GEMS_SBC_Required__c)) {
       message +='\nWill HCSC Create SBC? is required, unless it is an off-cycle submission';
       }           
    
       if(string.isBlank(caseRec1.GEMS_Benefit_Booklet_Required__c)){  
       message +='\nBenefit Booklet Required? is required, unless it is an off-cycle submission';
       }
    }
    if(!string.isBlank(message)){
       return message;
    } 
 }
 catch(Exception ex){
    string error = 'Failed.Please contact GEMS support for assistance';
    system.debug('Exception Message:'+ex.getMessage()+' Exception Line Number:'+ex.getLineNumber());
    return error;
 }
 return 'validated'; 
}

// SFDC 4243 - Check if atleast one BA is selected when Special Handling is selected before they send for Approval.
@AuraEnabled
webservice static string valBAselBeforeApproval(string caseId){
string message = '';
 try{
    Case caseStrucRec = [select Id,GEMS_Special_Handling__c from case where Id=:caseId];      
    if(caseStrucRec.GEMS_Special_Handling__c == true )
    {
       List<GEMS_Benefit_Agreement__c> baList = new List<GEMS_Benefit_Agreement__c>();
       baList = [select Id,GEMS_BAs_SpHandling__c from GEMS_Benefit_Agreement__c where AccountStructureCase__c=:caseId and GEMS_BAs_SpHandling__c = true]; 
       if (baList.size() == 0) 
       {
          message +='\nYou need to select atleast one BA before you can Send for Approval';
       }
                   }
    if(!string.isBlank(message)){
       return message;
    } 
 }
 catch(Exception ex){
    string error = 'Failed.Please contact GEMS support for assistance';
    system.debug('Exception Message:'+ex.getMessage()+' Exception Line Number:'+ex.getLineNumber());
    return error;
 }
 return 'validated'; 
}

}