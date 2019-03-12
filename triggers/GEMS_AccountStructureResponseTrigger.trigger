//************************************************************************************
// Name             : GEMS_AccountStructureResponseTrigger.trigger
// Description      : Trigger to create & update  GEMS_Account_Structure_Response__c records for a B* transaction
// Created By       : Shankar
// Created Date     : 9/16/2017
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// 09/16/2017		Shankar				Initial version. SFDC-5090 Changes to restructure request-response pattern			
// 11/02/2017		Shankar				SFDC-7239 Avoid setting isRetrievalRequestSubmitted__c flag during failures & resetting during success
// -----------------------------------------------------------------------------------
// ************************************************************************************
trigger GEMS_AccountStructureResponseTrigger on GEMS_Account_Structure_Response__c (after update, after insert) {
    String errCodes = 'EI';
    for (GEMS_Account_Structure_Response__c newRec : Trigger.new) {
        if (Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)) {
            GEMS_Account_Structure_Response__c oldRec = new GEMS_Account_Structure_Response__c();
            if (Trigger.isUpdate) {
                oldRec = (GEMS_Account_Structure_Response__c) Trigger.oldMap.get(newRec.Id);
            }

            if (newRec.Call_1_Status__c == 'S' && oldRec.Call_1_Status__c != newRec.Call_1_Status__c) {
            	// SFDC-7239. Set isRetrievalRequestSubmitted__c for first call.  
                GEMS_AccountRetrieveServiceHelper.updateCallDetailsInCase(newRec.AccStructCaseId__c, newRec.Call_1_response_txt__c, newRec.Request_Time__c, null, true);
                // SFDC-7239 End
            } else if (newRec.Call_1_Status__c == 'R' && oldRec.Call_1_Status__c != newRec.Call_1_Status__c) {
                // Account structure details for 1st request call is received from BlueSTAR. 
                // Make 2nd Retreive Account Structure request to BlueSTAR
                GEMS_AccountRetrieveServiceHelper.retrieveAccountStructureInFuture(oldRec.AccStructCaseId__c, 'Call2', oldRec.Id);
            } else if (newRec.Call_2_Status__c == 'R' && oldRec.Call_2_Status__c != newRec.Call_2_Status__c) {
                // Account structure details for 1st request call is received from BlueSTAR. 
                // Make 2nd Retreive Account Structure request to BlueSTAR
                GEMS_AccountRetrieveServiceHelper.retrieveAccountStructureInFuture(oldRec.AccStructCaseId__c, 'Call3', oldRec.Id);
            } else if (newRec.Call_3_Status__c == 'R' && oldRec.Call_3_Status__c != newRec.Call_3_Status__c) {
                // All 3 calls completed successfully
                // 1. Update acc structure details in  Account Structure record
                // 2. Mark the Account Structure Response object for deletion                
                // SFDC-7239 Don't set isRetrievalRequestSubmitted__c in the case during success
                GEMS_AccountRetrieveServiceHelper.updateCallDetailsInCase(newRec.AccStructCaseId__c, newRec.Call_3_response_txt__c, newRec.Request_Time__c, newRec.Response_Time__c, null);
                // SFDC-7239 End
                // SFDC-7239 Don't set isRetrievalRequestSubmitted__c in the case during failures
            } else if (null != newRec.Call_1_Status__c && errCodes.contains(newRec.Call_1_Status__c) && newRec.Call_1_status__c != oldRec.Call_1_status__c) {
                GEMS_AccountRetrieveServiceHelper.updateCallDetailsInCase(newRec.AccStructCaseId__c, newRec.Call_1_response_txt__c, newRec.Request_Time__c, newRec.Response_Time__c, null);
            } else if (null != newRec.Call_2_Status__c && errCodes.contains(newRec.Call_2_Status__c) && newRec.Call_2_status__c != oldRec.Call_2_status__c) {
                GEMS_AccountRetrieveServiceHelper.updateCallDetailsInCase(newRec.AccStructCaseId__c, newRec.Call_2_response_txt__c, newRec.Request_Time__c, newRec.Response_Time__c, null);
            } else if (null != newRec.Call_3_Status__c && errCodes.contains(newRec.Call_3_Status__c) && newRec.Call_3_status__c != oldRec.Call_3_status__c) {
                GEMS_AccountRetrieveServiceHelper.updateCallDetailsInCase(newRec.AccStructCaseId__c, newRec.Call_3_response_txt__c, newRec.Request_Time__c, newRec.Response_Time__c, null);
            }
            // SFDC-7239 End
        }
    }
}