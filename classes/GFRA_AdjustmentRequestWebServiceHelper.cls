@RestResource(urlMapping='/createAdjRequest/*')
global with sharing class GFRA_AdjustmentRequestWebServiceHelper {
    
     private static final String calloutName='GFRA_Callout';
    /*
    ** @author Mei Chen
    ** @initial Release 12/25/2017
    ** Inbound Call to Adjuster Tool to Salesforce.
    ** The callout is triggered by the Service Request Trigger and callout to Adjsuter Tool Service with Approval result data. 
    **
    **/
    
   /*   @InvocableMethod
      
      public static void GFRA_sendCallOut(list<Id> srId){
         system.debug('calling out to Adjuster Took ws..'+srId);
         
     //    GFRA_MakeAdjusterWSCall(srId);
          
      }*/
      
      @future (callout=true)
      public static void GFRA_MakeAdjusterWSCall(Id sReqId){
       
       list<Service_Request__c> updateList=new list<Service_Request__c>();
    
       if(sReqId!=null){//if( reqSrIds!=null && !reqSrIds.isEmpty()){   
            //it will just have one
          list<Service_Request__c> srList=[select id,status__c,Integration_Date_Time__c,Rejection_Reason__c,Integration_Error_Message__c,Integration_Status__c,Integration_Message__c, Final_Approver_Name__c,Adjustment_Request_ID__c from Service_Request__c where id =:sReqId];
           
         if(srList!=null && !srList.isEmpty()){
            
            DTOStatus calloutStatus=new DTOStatus();
            
            Service_Request__c sReq=srList[0];
        
           system.debug(' sending Service Request: '+sReq.id+' status: '+sReq.status__c+' reject reason::'+sReq.Rejection_Reason__c);
           if(sReq.Status__c=='Rejected' && (sReq.Rejection_Reason__c==null || sReq.Rejection_Reason__c=='')){
                    system.debug('missing reject reason....');
                    sReq.Integration_Status__c='Failed To Sent';
                    sReq.Integration_Message__c='Please Provide Rejection Reason for Rejected request.';
                    sReq.Integration_Error_Message__c='Missing Rejection Reason for Rejected request.';
                    sReq.Integration_Date_Time__c=system.now();
                    sReq.status__c=system.label.SR_GFRA_Status_Pending_For_Rejection;//SR_Status_Pending_For_Pending;//'Pending for Rejection';
                
                    updateList.add(sReq);
                    
            }else{
                 system.debug(' reading to call Adjuster tool ws....');
                try{
                    
                     DTOGFRA_AdjustmentResponse reqDTO=new DTOGFRA_AdjustmentResponse();
                    
                     reqDTO.adjustmentRequestID=sReq.Adjustment_Request_ID__c;
                     reqDTO.finalApproverName=sReq.Final_Approver_Name__c;
                     reqDTO.status=sReq.Status__c;
                     if(sReq.Status__c!=null && sReq.Status__c.equalsIgnoreCase('Rejected')){
                      
                           reqDTO.rejectionReason=sReq.Rejection_Reason__c;
                      }
                     
                    system.debug('reqDTO:'+reqDTO);
                   
                    APICallOutRestWSUtility calloutUtil=new APICallOutRestWSUtility(calloutName);
                    calloutStatus=calloutUtil.SendAdjustmentWSCallOut(reqDTO);
                   
                    system.debug('callout result status:'+calloutStatus);
                    system.debug('calling out to Adjuster Tool ws..');
                    if(calloutStatus!=null){
                        sReq.Integration_Status__c=calloutStatus.statusCode;//'Sent Success';
                        sReq.Integration_Message__c=calloutStatus.statusMessage;//'Successfully sent Approval Result to Adjuster Tool system';
                        sReq.Integration_Error_Message__c=calloutStatus.errorMessage;
                    }
                
                    sReq.Integration_Date_Time__c=system.now();
                //update sReq;
                    updateList.add(sReq);
                }catch (Exception e){
                    sReq.Integration_Status__c='Sent Failed';
                    sReq.Integration_Message__c='Callout Exception. Please contact System Administrator.' ;
                    sReq.Integration_Error_Message__c=e.getMessage();
                    sReq.Integration_Date_Time__c=system.now();
                    ///;    update sReq; 
                    updateList.add(sReq);
                
                }
                
              }//else
               
          // }// end of if sReq
        
        } 
         if(updateList!=null && !updateList.isEmpty()){
            try{
               update updateList;
            }catch(System.dmlException e){
                system.debug(' dml exception: '+e);
             }
         }
          system.debug('ending calling out to Adjuster Took ws..');
        }
     }
     
     
     
    @HttpPost
    /*****************************************************************************************************
    ** @Author Mei Chen
    ** @initial release 12/15/2017
    ** Outbound Call to Hcsc Adjuster Tool system.
    **This SF service is called by Adjsuter Took throught integration as OutBound Call from Adjudter Tool. The purpose of this service to 
    ** create or update Service Request base on the adjuster Request ID.
    **
    ********************************************************************************************************/
    global static DTOGFRA_AdjustmentRequestRTResponse CreateAdjustmentRequest(DTOGFRA_AdjustmentRequest  adjustmentRequest){
        
        String accountNumber=null;
        String adjustmentReqId=null;
        String requestType=null;
        
        DTOGFRA_AdjustmentRequestRTResponse resp=new DTOGFRA_AdjustmentRequestRTResponse();
        DTOStatus status=new DTOStatus();
        system.debug('adjustment request::::: '+adjustmentRequest);
        try{
        
        if(adjustmentRequest!=null){
            
        
            
           Service_Request__c newSRreq=new Service_Request__c();
           
            if(adjustmentRequest.adjustmentRequestID==null ||adjustmentRequest.adjustmentRequestID==''){
                status.statusCode='Rejected';
                status.statusMessage='Missing required information. Please provide Adjustment Request Id.';
                status.errorMessage='Error! Adjustment Request Id can not be blank.';
                resp.status=status;
                return resp;
            }
            
            Service_Request__c existingSR=findExistingServiceRequest(adjustmentRequest.adjustmentRequestID);
        
            if(existingSR!=null && existingSR.status__c!=null ){
                if(!existingSR.status__c.equalsIgnoreCase('New')){
                    status.statusCode='Rejected';
                    status.statusMessage='Invalid Update Request. Adjustment Request' + adjustmentRequest.adjustmentRequestID+' has been processed and can not be updated.';//'You can update the Adjustment Request for '+adjustmentRequest.adjustmentRequestID+' because it has been completed the Approval process in Salesforce.';
                    status.errorMessage='Error! blocking for any update on exising Adjustment Request if it has been processed.';
                    resp.status=status;
                    return resp;
                }else{//process as update the exsiting request record
                    
                  resp=updateExistingRequest(adjustmentRequest, existingSR);
                  return resp;
            
                }
            }
            
             resp.adjustmentRequestID=adjustmentRequest.adjustmentRequestID;
           
        /*  if(!isNewRequest(adjustmentRequest.adjustmentRequestID)){
                
                
                status.statusCode='Rejected';
                status.statusMessage='Invalid Input! Adjustment Request '+ adjustmentRequest.adjustmentRequestID+' is already existing in Salesforce.';
                status.errorMessage='Error! Duplicate Record found from Salesforce.';
                resp.status=status;
                return resp;
            }*/
          
            if(adjustmentRequest.adjustmentAmount==null || adjustmentRequest.adjustmentAmount==0){
                status.statusCode='Rejected';
                status.statusMessage='Invalid Input! You have Zero or Empty Adjustment Amount provided for your request.';
                status.errorMessage='Error! Adjustment Amount can not be blank.';
                resp.status=status;

                return resp;
            }
            
              if(adjustmentRequest.adjustmentRequestTypeIndicator==null || adjustmentRequest.adjustmentRequestTypeIndicator==''){
                status.statusCode='Rejected';
                status.statusMessage='Invalid Input! Please provide Adjustment Request Type Indicator (Single/Mass)';
                status.errorMessage='Error! Adjustment Request Type Indicator can not be blank.';
                resp.status=status;

                return resp;
            }
            
            
            if(adjustmentRequest.adjustmentRequestTypeIndicator.equalsIgnoreCase('Single')){
            
             if(adjustmentRequest.accountNumber==null ||adjustmentRequest.accountNumber==''){
                    
                status.statusCode='Rejected';
                status.statusMessage='Missing required information. Account Number is not provided.';
                status.errorMessage='Error! Account number can not be blank for adjustment request is Single.';
                resp.status=status;
                return resp;
             }
             
             if(adjustmentRequest.barsCustomerNumber==null ||adjustmentRequest.barsCustomerNumber==''){
                status.statusCode='Rejected';
                status.statusMessage='Missing required information: BARS Customer Number is not provided for Single Request.';
                status.errorMessage='Error! BARS Custom Number can not be blank for adjustment request is Single.';
                resp.status=status;
                return resp;
            
              }
             
             Account srAcct=getAccount(adjustmentRequest.accountNumber);
             if(srAcct!=null){
                newSRreq.Account__c=srAcct.id;
                newSRreq.Account_Number__c=srAcct.External_ID__c;
            //  newSRreq.BARS_Customer_Number__c=adjustmentRequest.barsCustomerNumber;
                Id arId=getAccountReceivableUserId(srAcct.id);
                if(arId!=null){
                 newSRreq.ownerId=arId;//getAccountReceivableUserId(srAcct.id);
               }
             }else{
              newSRreq.ownerId=getQueueId(system.label.SR_queue_name_GFRA_Manager);//('GFRA Manager');
              newSRreq.Account_Number__c=adjustmentRequest.accountNumber;
             }
             
        }else{//mass request
            newSRreq.ownerId=getQueueId(system.label.SR_queueName_GFRA_Queue);//'GFRA Queue');
        }
         newSRreq.BARS_Customer_Number__c=adjustmentRequest.barsCustomerNumber;
         newSRreq.RecordTypeId=Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get(system.label.SR_Record_Type_GFRA_Adjustment).getRecordTypeId();     
         newSRreq.Adjustment_Request_ID__c=adjustmentRequest.adjustmentRequestID;
         newSRreq.Adjustment_Request_Type_Indicator__c=adjustmentRequest.adjustmentRequestTypeIndicator;
         newSRreq.Adjustment_Type__c=adjustmentRequest.adjustmentType;
         newSRreq.Adjustment_Amount__c=adjustmentRequest.adjustmentAmount;
         newSRreq.Adjustment_Process_Date__c=adjustmentRequest.adjustmentProcessedDate;
         newSRreq.Adjustment_Entry_Date__c=adjustmentRequest.adjustmentEntryDate;
         newSRreq.Submitter_Name__c=adjustmentRequest.submitterName;
         newSRreq.Submitter_Email__c=adjustmentRequest.submitterEmail;
         newSRreq.Adjustment_Request_Link__c=adjustmentRequest.adjustmentRequestLink;//+'?id='+newSRreq.Adjustment_Request_ID__c;
        
         try{
            
            status.statusCode=system.label.SR_GFRA_Integration_Status_OK;
            status.statusMessage='Yes, your request '+adjustmentRequest.adjustmentRequestID+' has been received by Salesforce service.';
            status.errorMessage=null;
            
          //set the integration status info
            newSRreq.Integration_Message__c='Successfully Received Initial Request from Adjuster Tool, request id: '+adjustmentRequest.adjustmentRequestID;
            newSRreq.Integration_Error_Message__c='';
            newSRreq.Integration_Date_Time__c=system.now();
            newSRReq.Integration_Status__c='Received Request';
            newSRReq.Status__c='New';
            insert newSRreq;
            system.debug('insert new service request:'+newSRreq.id);
         
         }catch(system.DMLException e){
            system.debug('insert new service request dml exception: '+e);
            status.statusCode=system.label.SR_GFRA_Integration_Status_Failed;//'Failed';
            status.statusMessage='Exception from Salesforce service, your request: '+adjustmentRequest.adjustmentRequestID+' can not be processed. Please Contact System Administrator.';
            status.errorMessage=e.getMessage();
            CreateExceptionLog.insertErrorLog(e, null,null,null,'ApexClass', 'CreateAdjustmentRequest.dmlException',null,'GFRA_AdjustmentRequestWebServiceHelper.CreateAdjustmentRequest','high');        
           
         }
        
      }
      
     }catch( Exception e){
    
       system.debug('CreateAdjustmentRequest exception: '+e);   
       status.statusCode=system.label.SR_GFRA_Integration_Status_Failed;
       status.statusMessage='Exception from Salesforce service, your request: '+adjustmentRequest.adjustmentRequestID+' can not be processed. Please Contact System Administrator.';
       status.errorMessage=e.getMessage();
       CreateExceptionLog.insertErrorLog(e, null,null,null,'ApexClass', 'CreateAdjustmentRequest.Exception',null,'GFRA_AdjustmentRequestWebServiceHelper.CreateAdjustmentRequest','high');        
       
     }
     
        resp.status=status;
        return resp;
    }
    
 /*   private static boolean IsNewRequest(String adjRequestId){

        if(findExistingServiceRequest(adjRequestId)!=null){//already existing
            return false;
        }
        return true;
    }*/
    
  private static DTOGFRA_AdjustmentRequestRTResponse updateExistingRequest(DTOGFRA_AdjustmentRequest adjustmentRequest, Service_Request__c existingSR){
  
    DTOStatus status=new DTOStatus();
    DTOGFRA_AdjustmentRequestRTResponse updateResp=new DTOGFRA_AdjustmentRequestRTResponse();
    
     if(adjustmentRequest==null ||existingSR==null){
         status.statusCode=system.label.SR_GFRA_Integration_Status_Failed;
         status.statusMessage='Invalid Request for update with empty data.';
         status.errorMessage='error! Adjustment Request Data equals null';
         updateResp.status=status;
         return  updateResp;
     }
     
     try{
            
        updateResp.adjustmentRequestID=adjustmentRequest.adjustmentRequestID;
        if(adjustmentRequest.accountNumber!=null && existingSR.Account_Number__c!=adjustmentRequest.accountNumber){
                        
          Account act=getAccount(adjustmentRequest.accountNumber);
          if(act!=null){
            existingSR.Account__c=act.id;
            existingSR.Account_Number__c=act.External_ID__c;
            Id arId=getAccountReceivableUserId(act.id);
            if(arId!=null){
                existingSR.ownerId=arId;//getAccountReceivableUserId(srAcct.id);
            }
            
          }else{
              existingSR.ownerId=getQueueId(system.label.SR_queue_name_GFRA_Manager);
          }
                    
        }
        if(adjustmentRequest.barsCustomerNumber!=null && adjustmentRequest.barsCustomerNumber!=''){
            existingSR.BARS_Customer_Number__c=adjustmentRequest.barsCustomerNumber;
        }
        if(adjustmentRequest.adjustmentType!=null && adjustmentRequest.adjustmentType!=''){
            existingSR.Adjustment_Type__c=adjustmentRequest.adjustmentType;
         }
    
        if(adjustmentRequest.adjustmentAmount!=null && adjustmentRequest.adjustmentAmount >0){
            existingSR.Adjustment_Amount__c=adjustmentRequest.adjustmentAmount;
        }
        if(adjustmentRequest.adjustmentProcessedDate!=null){
            existingSR.Adjustment_Process_Date__c=adjustmentRequest.adjustmentProcessedDate;            
        }
        if(adjustmentRequest.adjustmentEntryDate!=null){
           existingSR.Adjustment_Entry_Date__c=adjustmentRequest.adjustmentEntryDate;       
        }
                     
        if(adjustmentRequest.submitterName!=null && adjustmentRequest.submitterName!=''){
            existingSR.Submitter_Name__c=adjustmentRequest.submitterName;
        }
        if(adjustmentRequest.submitterEmail!=null && adjustmentRequest.submitterEmail!=''){
            existingSR.Submitter_Email__c=adjustmentRequest.submitterEmail;         
        }
        if((adjustmentRequest.adjustmentRequestLink!=null && existingSR.Adjustment_Request_Link__c==null ||existingSR.Adjustment_Request_Link__c=='')){
            existingSR.Adjustment_Request_Link__c=adjustmentRequest.adjustmentRequestLink;
        }
        
        existingSR.Integration_Message__c='Successfully Completed Update Adjusment Request for '+adjustmentRequest.adjustmentRequestID;
        existingSr.Integration_Error_Message__c=null;
        existingSR.Integration_Date_Time__c=system.now();
        existingSR.Integration_Status__c='Request Updated';
         
      
        update existingSR;
        
        status.statusCode=system.label.SR_GFRA_Integration_Status_OK;
        status.statusMessage='Yes, your request to update '+adjustmentRequest.adjustmentRequestID+' is completed in Salesforce.';
        status.errorMessage=null; 
        
        
      }catch (Exception e){
         system.debug('exception from update adjustment reqeust.'+e);
         status.statusCode=system.label.SR_GFRA_Integration_Status_Failed;//'Failed';
         status.statusMessage='Exception from Salesforce service, your request: '+adjustmentRequest.adjustmentRequestID+' can not be processed. Please Contact System Administrator.';
         status.errorMessage=e.getMessage();
         
         CreateExceptionLog.insertErrorLog(e, null,null,null,'ApexClass', 'CreateAdjustmentRequest.dmlException',null,'GFRA_AdjustmentRequestWebServiceHelper.CreateAdjustmentRequest','high');           
            
      }
      updateResp.status=status;
      return updateResp;
    }
    
     private static Service_Request__c findExistingServiceRequest(String adjRequestId){
        list<Service_Request__c> sr=[select id,status__c,Account_Number__c,Submitter_Email__c,Adjustment_Request_Link__c,Submitter_Name__c,Adjustment_Entry_Date__c,Adjustment_Process_Date__c,Adjustment_Amount__c,Adjustment_Type__c,Adjustment_Request_Type_Indicator__c,Integration_Date_Time__c,Integration_Error_Message__c,Integration_Status__c,Rejection_Reason__c,Integration_Message__c, Final_Approver_Name__c,Adjustment_Request_ID__c from Service_Request__c where Adjustment_Request_ID__c=:adjRequestId];
    
        if(sr!=null && !sr.isEmpty()){//already existing
            return sr[0];
        }
        return null;
    }
    
    private static Account getAccount(String acctNum){
        
        if(acctNum!=null && acctNum!=''){
            list<Account> acct=[select id,name, AccountNumber,External_ID__c from Account where  External_ID__c=:acctNum limit 1];
            if(acct!=null && !acct.isEmpty()){
                return acct[0];
            }
        }
        return null;
    }
    
    
    //retrieve the related account Team AR member, expect the only AR member, but if there are multiple, return the first one
    private static Id getAccountReceivableUserId(Id accountId){
        list<AccountTeamMember> ar=[select Id, userId,accountId,TeamMemberRole, title, lastmodifiedDate from AccountTeamMember where accountId=: accountId and TeamMemberRole='Accounts Receivable' order by lastModifiedDate DESC limit 1];
        if(ar!=null && !ar.isEmpty()){
            return ar[0].userId;
        }else {
            return getQueueId(system.label.SR_queue_name_GFRA_Manager);
        }
       // return null;
    }
    
    private static Id getQueueId(String queueName){
        list<Group> gp =[select id, type,name from Group where type='Queue' and name=:queueName limit 1];
        if(gp!=null && !gp.isEmpty()){
          return gp[0].id;  
        }
        return null;
    }
}