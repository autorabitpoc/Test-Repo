global without sharing class GEMS_AccountStructureStatusService {
    
    webService static GEMS_AccountStructureStatusServiceOutput updateStatus(GEMS_AccountStructureStatusServiceInput input) {
        
        GEMS_AccountStructureStatusServiceOutput output = new GEMS_AccountStructureStatusServiceOutput();
        output.accountStructureCaseID = input.accountStructureCaseID;
        
        DateTime executionStartTime = system.now();
        DateTime executionEndTime;
        //Bharath
        boolean startEIN = false;
        
        try{
            ID id = input.accountStructureCaseID;
            String objectAPIName = id.getSObjectType().getDescribe().getName();
            system.debug('objectAPIName::::::::::'+objectAPIName);
            
            If(objectAPIName == 'Case'){
                CASE accountStructureCase;
                
                list<CASE> cases = [SELECT Id, GEMS_Integration_Status__c, GEMS_Integration_Message__c, GEMS_Integration_Response_Time__c, RecordTypeId, AccountId, GEMS_Submission_Type__c,
                                    GEMS_Failed_Account_Message__c, GEMS_Failed_Addresses__c, GEMS_Failed_Benefit_Agreements__c, GEMS_Failed_Categories__c, GEMS_Failed_Group_Sections__c 
                                    FROM CASE
                                    WHERE id = : input.accountStructureCaseID];
                
                if(cases != null && cases.size() > 0)
                    accountStructureCase = cases[0];
                //accountStructureCase.RecordTypeId
                Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Cancellation').getRecordTypeId();
                String caseAccCanRTId = String.valueOf(caseRecordTypeId).substring(0, 15);
                system.debug('caseRecordTypeId::::::'+caseAccCanRTId);                
                if(accountStructureCase != null){
                    accountStructureCase.GEMS_Integration_Response_Time__c = system.now();
                    
                    if(input.status == 'S'){
                        accountStructureCase.GEMS_Integration_Status__c = 'Success';
                        
                        accountStructureCase.GEMS_Failed_Account_Message__c = null;
                        accountStructureCase.GEMS_Failed_Addresses__c = null;
                        accountStructureCase.GEMS_Failed_Benefit_Agreements__c = null;
                        accountStructureCase.GEMS_Failed_Categories__c = null;
                        accountStructureCase.GEMS_Failed_Group_Sections__c = null;
                        if(accountStructureCase.RecordTypeId == caseAccCanRTId){
                            accountStructureCase.GEMS_Integration_Message__c = 'Cancellation process completed.';               
                            accountStructureCase.Status = 'Closed';
                        }
                        else{
                            accountStructureCase.GEMS_Integration_Message__c = 'Account Structure details has been sent to BlueSTAR successfully.';             
                            accountStructureCase.Status = 'BlueSTAR Shell Created';
                            //Bharath
                            if(accountStructureCase.GEMS_Submission_Type__c == 'New Account'){
                                startEIN = true;
                            }
                        }
                    }
                    else{
                        accountStructureCase.GEMS_Integration_Message__c = input.message;
                        if(input.errorData != null){
                            accountStructureCase.GEMS_Failed_Account_Message__c = input.errorData.acctErrorMessage;
                            accountStructureCase.GEMS_Failed_Addresses__c = input.errorData.acctAddrErrorMessage;
                            accountStructureCase.GEMS_Failed_Benefit_Agreements__c = input.errorData.benAgmtErrorMessage;
                            accountStructureCase.GEMS_Failed_Categories__c = input.errorData.catErrorMessage;
                            accountStructureCase.GEMS_Failed_Group_Sections__c = input.errorData.grpSectErrorMessage;
                        }
                        
                        if(input.status == 'P'){
                            if(accountStructureCase.RecordTypeId == caseAccCanRTId){
                                accountStructureCase.GEMS_Integration_Status__c = 'Partial';
                                accountStructureCase.GEMS_Integration_Message__c = 'Cancellation process partially success in BlueSTAR.';
                                accountStructureCase.Status = 'Closed';
                            }
                            else{
                                accountStructureCase.GEMS_Integration_Status__c = 'Partial';
                                accountStructureCase.GEMS_Integration_Message__c = 'Account Structure details has been partially set up in BlueSTAR.';
                                accountStructureCase.Status = 'BlueSTAR Partial Fail';
                                //Bharath
                                if(accountStructureCase.GEMS_Submission_Type__c == 'New Account'){
                                    startEIN = true;
                                }                            
                            }
                            
                        }
                        else{
                            if(accountStructureCase.RecordTypeId == caseAccCanRTId){
                                accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                                accountStructureCase.GEMS_Integration_Message__c = 'BlueSTAR failed to process Account Cancellation. Please contact System Admin.';                           
                                accountStructureCase.Status = 'Closed';
                            }
                            else{
                                accountStructureCase.GEMS_Integration_Status__c = 'Fail';
                                accountStructureCase.GEMS_Integration_Message__c = 'BlueSTAR failed to create Account Structure. Please contact System Admin.';
                                accountStructureCase.Status = 'BlueSTAR Failed';
                            }                           
                        }
                    }                   
                    
                    output.status = 'S';            
                    output.message = 'The Account Strcuture status has been updated successfully.';
                }
                else{                   
                    output.status = 'E';
                    output.message = 'No Case found with the Account Structure.' + ' Env : ' + URL.getSalesforceBaseUrl().getHost();                        
                }
                
                update accountStructureCase;
                executionEndTime = system.now();
                //Bharath
                if(startEIN == true){
                    LGNA_EIN_TransmitServiceHelper.sendNewAcctEIN(accountStructureCase.AccountId);
                }
            }else if(objectAPIName == 'Account'){
                Account acc;
                list<Account> accounts = [select Cancellation_Date__c,Integration_Status__c,Integration_Message__c,Requested_Cancellation_Date__c
                                          from Account where id=: input.accountStructureCaseID];
                if(accounts != null && accounts.size() > 0)
                    acc = accounts[0];
                if(acc != null){
                    
                    if(input.status == 'S' && input.message == 'ACCOUNT CANCELLATION SUCCESSFUL'){
                        acc.Integration_Status__c = 'Success';
                        acc.Integration_Message__c = 'Account Successfully cancelled in Blue Star.';
                        if(acc.Requested_Cancellation_Date__c != NULL && acc.Requested_Cancellation_Date__c > system.today()){
                            acc.Cancellation_Status__c = 'Cancelled with Future CD'; 
                        }else {
                            acc.Cancellation_Status__c = 'Cancelled';
                        }
                        // acc.Status__c = 'Cancelled';
                        acc.Cancellation_Date__c = acc.Requested_Cancellation_Date__c;
                        
                    } else if(input.status == 'S' && input.message == 'ACCOUNT CANCELLATION PENDED'){
                        acc.Integration_Status__c = 'Success';
                        acc.Integration_Message__c = 'Account Successfully Marked as Cancel Pend in Blue Star.';
                        acc.Cancellation_Status__c = 'Cancel Pend'; 
                        // acc.Status__c = 'Cancel Pend';
                        acc.Cancellation_Date__c = acc.Requested_Cancellation_Date__c;
                    } else if(input.status == 'S' && input.message == 'MEIN SETUP PROCESS EXECUTED SUCCESSFULLY'){
                        //Bharath - Change for EIN.
                        List<String> succEIN = new List<String>();
                        succEIN.add('000000000');
                        LGNA_EIN_TransmitServiceHelper.processResponse(acc.id,succEIN);
                    }else{
                        acc.Integration_Message__c = input.message;
                        if(input.status == 'P' && input.message == 'MEIN SETUP PROCESS EXECUTED PARTIALLY'){
                            List<String> failEIN = input.errorData.einInfoErrorMessage.split(',');
                            for(String fe : failEIN){
                                fe = fe.deleteWhitespace();
                            }
                            LGNA_EIN_TransmitServiceHelper.processResponse(acc.id,failEIN);                            
                        } else if(input.status == 'P'){
                            acc.Integration_Status__c = 'Partial';
                            acc.Integration_Message__c = 'Account Cancellation is partial Success in Blue Star.';
                            acc.Cancellation_Status__c = 'Submitted';
                        } else if(input.message == 'MEIN SETUP PROCESS FAILED'){
                            if(!String.isBlank(input.errorData.einInfoErrorMessage) && input.errorData.einInfoErrorMessage!= '' && input.errorData.einInfoErrorMessage!= null){
                                List<String> failEIN = input.errorData.einInfoErrorMessage.split(',');
                                for(String fe : failEIN){
                                    fe = fe.deleteWhitespace();
                                }
                                LGNA_EIN_TransmitServiceHelper.processResponse(acc.id,failEIN);                                                        
                            } else {
                                LGNA_EIN_TransmitServiceHelper.resetEINs(acc.id);
                            }
                        } else{
                            acc.Integration_Status__c = 'Fail';
                            acc.Integration_Message__c = 'Account Cancellation is failed in Blue Star.';
                            acc.Cancellation_Status__c = 'Submitted';
                        }
                    }
                    output.status = 'S';            
                    output.message = 'ACCOUNT AUTOMATION PROCESS TRIGERRED SUCCESSFULLY.';
                }else{                  
                    output.status = 'E';
                    output.message = 'No Case found with the Account Structure.' + ' Env : ' + URL.getSalesforceBaseUrl().getHost();                        
                }
                update acc;
                executionEndTime = system.now();
            }
        }
        catch(Exception ex){
            output.status = 'E';
            output.message = ex.getLineNumber() + ' : ' + ex.getMessage();
            executionEndTime = system.now();
        }
        
        try{
            System.Debug('Log Service Status START');
            FW_Service_Status_Log__c statusLog = new FW_Service_Status_Log__c();
            statusLog.Name = 'GEMS_AccountStructureStatusService';
            statusLog.UID__c = input.accountStructureCaseID;
            statusLog.Status__c = input.status;          
            //statusLog.ErrorCode__c = serviceStatus.errorCode;
            statusLog.ErrorDescription__c = input.message;
            statusLog.StartTime__c = executionStartTime;
            //statusLog.InputProcessingTime__c = serviceInputProcessingTime;
            //statusLog.CalloutTime__c = serviceCalloutTime;                  
            //statusLog.OutputProcessingTime__c = serviceOutputProcessingTime;  
            statusLog.EndTime__c = executionEndTime;
            //statusLog.Log_Type__c = ServiceHelper.SERVICE_LOG;
            statusLog.RequestBody__c = string.valueof(input);
            statusLog.ResponseBody__c = string.valueof(output);
            
            System.Debug('Log Service Status BEFORE INSERT' + statusLog);
            
            insert statusLog;
            
            System.Debug('Log Service Status END');
        }
        catch(Exception ex){
            //DO NOTHING
        }
        
        return output;          
    }
    
}