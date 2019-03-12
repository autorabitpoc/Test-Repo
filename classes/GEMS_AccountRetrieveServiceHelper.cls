//************************************************************************************
// Name             : GEMS_AccountRetrieveServiceHelper .cls
// Description      : Helper class to retrieve Account Structure from the Service.
// Created By       : Janakiram Jonnadula
// Created Date     : 6/22/2016
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// 09/16/2016		GEMS				Initial version
// 09/10/2017		Shankar				SFDC-5090 Changes to restructure request-response pattern
// 11/02/2017		Shankar				SFDC-7239 Avoid setting isRetrievalRequestSubmitted__c flag during failures & resetting during success
// 05/31/2018       Rakesh              SFDC-9979 Adde a Method SubmitAccountCalloutLighning, checkChildRecordCount For LGNA Lightning 
// -----------------------------------------------------------------------------------
// ************************************************************************************

global class GEMS_AccountRetrieveServiceHelper {

public static string transactionId=null;    
	@auraEnabled
    webService static string retrieveAccountStructure(Id accountStructureCaseID, String requestCode, String accStructResponseId){
        
        string result;
        
        try{
                        
            if(accountStructureCaseID != null){
                
                CASE accountStructureCase = [SELECT 
                                             Account.HCSC_Division__c,Account.Id, Account.Name, Account.External_Id__c, Status,
                                             Opportunity_Name__r.HCSC_Division__c, Id, GEMS_Submission_Type__c,
                                             GEMS_Integration_Status__c, GEMS_Integration_Message__c,isRetrievalRequestSubmitted__c, 
                                             GEMS_Integration_Request_Time__c, GEMS_Integration_Response_Time__c                                                                                           
                                             FROM CASE WHERE Id = : accountStructureCaseID];
                
                
                GEMS_Account_Structure_Response__c retrieveAccStrucResponse;
                System.debug('accStructResponseId::'+accStructResponseId);
                
                if (accStructResponseId == '') { 
                    // Call made from button click. Create new response record for this transaction
                    retrieveAccStrucResponse = new GEMS_Account_Structure_Response__c(AccStructCaseId__c = accountStructureCaseID); 
                    string accountstrucIdMin = string.valueOf(accountStructureCaseID).right(5);
                    transactionId=(accountstrucIdMin + string.valueOf(system.now())).replaceAll('[^a-zA-Z0-9]','');
                    retrieveAccStrucResponse.transaction_Id__c=transactionId;              
                } else {
                    // Call made to fetch other parts of account structure. Get the existing response record
                    retrieveAccStrucResponse = [Select Transaction_Id__c, AccStructCaseId__c, Call_1_status__c, Call_2_status__c, Call_3_status__c from GEMS_Account_Structure_Response__c where Id = :accStructResponseId];   
                }
                
                if(accountStructureCase.GEMS_Submission_Type__c == 'New Account'){
                    result = 'Account Structure details can not be requested for new business account.';
                }
                else{
                    GEMS_AccountRetrieveServiceInput input = new GEMS_AccountRetrieveServiceInput();    
                    
                    string accountNumber = accountStructureCase.Account.External_Id__c;
                    
                    if(accountNumber!= null){                    
                        if(accountNumber.length() > 6)
                            accountNumber = accountNumber.substring(2, accountNumber.length());                
                        input.acctNbr = accountNumber;                    
                    } else {
                        result = 'Please reserve an Account Number';
                        accountStructureCase.GEMS_Integration_Message__c = result;
                        update accountStructureCase;
                        // Mark the response object for deletion
                        retrieveAccStrucResponse.Should_delete__c = true;
                        update retrieveAccStrucResponse;                         
                        return result;
                    }
                    
                    input.accountStructureCaseID = accountStructureCaseID;                   
                    input.corpEntCd = (accountStructureCase.Opportunity_Name__r.HCSC_Division__c!=null?accountStructureCase.Opportunity_Name__r.HCSC_Division__c:accountStructureCase.Account.HCSC_Division__c) + '1';
                    input.requestCode = retrieveAccStrucResponse.Transaction_Id__c+'-'+requestCode;
                    
                    FW_Service s = new FW_Service('GEMS_Account_Retrieve');      
 
                    GEMS_AccountRetrieveServiceOutput output = (GEMS_AccountRetrieveServiceOutput) s.callout(input);
                    
                    if(output.status == 'S' ) {
                        if (requestCode=='Call1') {
                            retrieveAccStrucResponse.transaction_Id__c=transactionId;  
                        }
                        result = 'A Request has been sent to BlueSTAR for Account Structure details.';
                        // accountStructureCase.isRetrievalRequestSubmitted__c = true;                                                                           
                    } else if(output.status == 'I') {
                        if (requestCode=='Call1') {
                            retrieveAccStrucResponse.transaction_Id__c=transactionId;  
                        }
                        result = 'System failed to send the request for Account Structure details.';                        
                        // Update response time in response record
                        retrieveAccStrucResponse.Response_time__c = System.now();  
                        retrieveAccStrucResponse.Should_delete__c = true;
                    } else {
                        if (requestCode=='Call1') {
                            retrieveAccStrucResponse.transaction_Id__c=transactionId;  
                        }
                        result = output.message;                            
                        // Update response time in response record
                        retrieveAccStrucResponse.Response_time__c = System.now();
                        retrieveAccStrucResponse.Should_delete__c = true;
                        if(result == null)
                            result = 'BlueSTAR failed to send the Account Structure details. Please contact System Admin.';                            
                    }                               
                    
                    
                    if (requestCode == 'Call1') {
                        retrieveAccStrucResponse.Call_1_status__c = output.status;
                        retrieveAccStrucResponse.Call_1_response_txt__c = result;
                        retrieveAccStrucResponse.Request_Time__c = system.now();
                    } else if (requestCode == 'Call2') {
                        retrieveAccStrucResponse.Call_2_status__c = output.status;
                        retrieveAccStrucResponse.Call_2_response_txt__c = result;
                    } else if (requestCode == 'Call3') {
                        retrieveAccStrucResponse.Call_3_status__c = output.status;
                        retrieveAccStrucResponse.Call_3_response_txt__c = result;
                    } 
                    // accountStructureCase.GEMS_Integration_Message__c = result;
                    // update accountStructureCase;  
                    System.debug('retrieveAccStrucResponse to upsert:'+retrieveAccStrucResponse);
                    
                    upsert retrieveAccStrucResponse;
                }
            }            
        }
        catch(Exception ex){
            result = ex.getLineNumber() + ' : ' + ex.getMessage();
        }
        
        return result;
        
    }
    
    // LGNA Lightning SFDC-9979 Begins Here -  Rakesh Nunna
   
    @future (callout=true)
    public static void retrieveAccountStructureInFuture(Id caseId, String requestCode, String accStructResponseId){
        //for(id caseId : caseIds){            
        string result = retrieveAccountStructure(caseId, requestCode, accStructResponseId);
        //}
    }
    
    public static void updateCallDetailsInCase(String accStructCaseId, String message, DateTime reqTime, DateTime respTime, Boolean isSub) {
        Case accStructCase = [Select GEMS_Integration_Message__c, isRetrievalRequestSubmitted__c from Case where Id = :accStructCaseId];
        if (null != accStructCase) {
            if (null != message)            
                accStructCase.GEMS_Integration_Message__c = message;
            
            if (null != reqTime) 
                accStructCase.GEMS_Integration_Request_Time__c = reqTime;
                        
            accStructCase.GEMS_Integration_Response_Time__c = respTime;
            
            // SFDC-7239 Set isRetrievalRequestSubmitted__c only if requested by caller
            if (null != isSub)            
            	accStructCase.isRetrievalRequestSubmitted__c = isSub;
            // SFDC-7239 End
            
            update accStructCase;
        }
    }
    @AuraEnabled
    public static boolean checkChildRecordCount(String caseId){
        List<Case> childCases = [select Id,External_Id__c,Status,Integration_Status__c from Case where Status ='New' AND ParentId=:caseId];        
        if(childCases.size()>0){
            return true; 
        }
        else{
            return false;
        }
    }
    @AuraEnabled
    webservice static void SubmitAccountCalloutLighning(String caseId){
        try{
            List<Case> caselist = [select Id,CaseNumber,Performance_Guarantees__c,Priority,Reasons_for_Request__c ,Requested_Effective_Date__c, owner.name,Recordtypeid,External_ID__c,Time_Sent__c,Integration_Action__c,Integration_Status__c,lastmodifiedbyid,createdbyid,status from case where id =: caseid ];
            CaseTriggerHandlerLGNA.restrictExecution = true;
            caselist[0].time_sent__c = system.now();
            caselist[0].Integration_Action__c= 'Account Submit';
            caselist[0].Integration_Status__c = 'Sent';
            caselist[0].Status = 'Submitted';    
            Update caselist[0];
            CaseTriggerHandlerLGNA.restrictExecution = false;
            CaseTriggerHandlerLGNA.calloutHelperMethod(caselist, 'Button');
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class','Case' , null, 'CalloutHelperclass.SubmitAccountCallout()','High');
        }
    }  
     //LGNA Lightning SFDC-9979 Ends Here -  Rakesh Nunna

}