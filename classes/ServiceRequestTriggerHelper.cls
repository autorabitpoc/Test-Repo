public with sharing class ServiceRequestTriggerHelper {
    
    /* SFDC-7243 - 11/2017 */
    public static void UpdateCommentsOnServiceRequest(List<Service_Request__c> InputNewServiceRequests,List<Service_Request__c> InputOldServiceRequests){
        
        System.debug('ServiceRequestTriggerHelper:isBefore:Checkpoint1');
        
        Map<Id, Service_Request__c> TheServiceRequests = new Map<Id, Service_Request__c>();
        Map<Id, String> FinalComments = new Map<Id, String>();        
        
        for(Service_Request__c AServiceRequest: InputNewServiceRequests){
            
            /* Ensure to trap on only appropriate Service Requests */            
            /* Custom Setting with List of the Service Request Record Types to Process */
            List<ServiceRequestTriggerRecordTypes__c> CustomSettingAppropriateRecordTypes = ServiceRequestTriggerRecordTypes__c.getAll().values();
            
            /* Map to hold the RecordType ID for each Custom Setting entry */
            Map<Id,String> AppropriateRecTypeMap = new Map<Id,String>();
            
            /* Run thru the List of Custom Setting entries */
            for (ServiceRequestTriggerRecordTypes__c AnEntry: CustomSettingAppropriateRecordTypes){
                /* Get the RecordType ID */
                Id TemporaryId = Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get(AnEntry.Record_Type_Name__c).getRecordTypeId();
                /* Put the ID and the Name in the Map */
                AppropriateRecTypeMap.put(TemporaryId, AnEntry.Record_Type_Name__c); 
                System.debug('Added a Record Type to Process: ' + AppropriateRecTypeMap);
            }
            
            /* Ensure that what is being processed has a Record Type listed in the Custom Setting */
            if(AppropriateRecTypeMap.containsKey(AserviceRequest.RecordTypeId)){
                
                for (Service_Request__c FindAMatch : InputOldServiceRequests){
                    if (FindAMatch.Id == AServiceRequest.Id){
                        Service_Request__c oldServiceRequest = FindAMatch;
                    }
                }
 
                Service_Request__c oldServiceRequest = (Service_Request__c)Trigger.oldMap.get(AServiceRequest.Id);
                
                /* See if moved from non-Rejected to Rejected Status */
                if (oldServiceRequest.History_Tracking__c != 'Rejected' 
                    && AServiceRequest.History_Tracking__c == 'Rejected')
                { 
                    /* add the Service Request to the List for further Processing */
                    TheServiceRequests.put(AServiceRequest.Id, AServiceRequest);  
                    System.debug('Added a Rejected Service Request to the List: ' + AServiceRequest.Name);
                }       
                
                /* See if moved from non-Approved to Approved Status */
                if (oldServiceRequest.History_Tracking__c != 'Approved' 
                    && AServiceRequest.History_Tracking__c == 'Approved')
                { 
                    /* add the Service Request to the List for further Processing */
                    TheServiceRequests.put(AServiceRequest.Id, AServiceRequest);  
                    System.debug('Added an Approved Service Request to the List: ' + AServiceRequest.Name);
                }
            }
        }
        
        if (!TheServiceRequests.isEmpty()){
            
            System.debug('ServiceRequestTriggerHelper:isBefore:Checkpoint2');
            
            List<Id> processInstanceIds = new List<Id>();
            
            for (Service_Request__c servicereq : [SELECT (SELECT ID FROM ProcessInstances ORDER BY CreatedDate DESC LIMIT 1)
                                                  FROM Service_Request__c
                                                  WHERE ID IN :TheServiceRequests.keySet()]){                                                    
                                                      processInstanceIds.add(servicereq.ProcessInstances[0].Id);                                                    
                                                  }
            
            for (ProcessInstance AProcessInstance : [SELECT TargetObjectId, (SELECT Id, StepStatus, Comments FROM Steps ORDER BY CreatedDate DESC LIMIT 1)
                                                     FROM ProcessInstance
                                                     WHERE Id IN :processInstanceIds
                                                     ORDER BY CreatedDate DESC]){
                                                         
                                                         /* Add the ID of the Service Request and the Comment to the Map */
                                                         FinalComments.put(AProcessInstance.TargetObjectId,AProcessInstance.Steps[0].Comments);
                                                         System.debug('Added an entry to the FinalComments Map: '+ AProcessInstance.Id + ' ' + AProcessInstance.Steps[0].Comments);                                                         
                                                     }        
        }
        
        /* if there were Approved/Rejected Service Requests with Comments on the Approvals take those */
        /* and update the Service Request with those same Comments.                                    */ 
        if (!FinalComments.isEmpty()){
            
            System.debug('ServiceRequestTriggerHelper:isBefore:Checkpoint3');
            
            System.debug('FinalComments: ' + FinalComments);
            
            for (Service_Request__c SecondPassServiceRequest: InputNewServiceRequests){
                /* see if ID exists in Map */
                String Comment = FinalComments.get(SecondPassServiceRequest.Id);
                /* if Comment not null add to the Service Request for updating */
                if (Comment != null){
                    SecondPassServiceRequest.Rejection_Reason__c = Comment;
                    SecondPassServiceRequest.Is_Rejection_Reason__c=true; //used to indicate rejection reason is provied in configuration.                    
                    System.debug('Updated the Service Request with the Comments: '+ SecondPassServiceRequest.Id);
                }
            }                 
        }
    }  
    
    /**
    *** this method is to update the status from 'Pending for Rejection" to "Rejected"
    **   when user come back to add rejetion reason after reminded by integration.
    **   backgroud: If rejected request without Rejection Reasion sent to Adj tool service, it will be rejected with asking for rejection reason, and udpated status from Rejected to Pending for Rejection. 
    **                Once user updates the request with rejection reason, the trigger will update status back to "Rejected" and service callout again.
    **/
    public static void updateStatuForRejectionReason(list<Service_Request__c> newSRs, list<Service_Request__c> oldSRs){
        system.debug('calling updateStatuForRejectionReason');
           Service_Request__c newSR=null;
           Service_Request__c oldSR=null;
        for(integer i=0;i<newSRs.size();i++){
            
            newSR=newSRs[i];
            oldSR=oldSRs[i];
             
            if(oldSR!=null && newSR!=null && oldSR.status__c!=null && oldSR.status__c.equalsIgnoreCase(system.label.SR_GFRA_Status_Pending_For_Rejection) && newSR.Rejection_Reason__c!=null && newSR.Rejection_Reason__c!=oldSR.Rejection_Reason__c){//update the Rejection Reason field
                system.debug('rejection reason is updated....');
                newSR.status__c='Rejected';
                newSR.Is_Rejection_Reason__c=true;
            //update newSR;
           } 
        }
        
    }       
    
    public static void  sendAdjustmentCallout(list<Service_Request__c> newSRs, list<Service_Request__c> oldSRs){
        
        Service_Request__c oldSR=null;
        Service_Request__c newSR=null;
        
        Id gfraRecTypeId=Schema.SObjectType.Service_Request__c.getRecordTypeInfosByName().get(system.label.SR_Record_Type_GFRA_Adjustment).getRecordTypeId();
        
        for(integer i=0;i<newSRs.size();i++){
            oldSR=oldSRs[i];
            newSR=newSRs[i];
            
            try{
            
            if(newSR!=null && newSR.recordTypeId==gfraRecTypeId && oldSR!=null && newSR.status__c!=oldSR.status__c && (newSR.status__c.equalsIgnoreCase('In Process')|| newSR.status__c.equalsIgnoreCase('Approved') || newSR.status__c.equalsIgnoreCase('Rejected'))){
                system.debug('callinig out adju ws for SR: '+newSR.id);
            
                GFRA_AdjustmentRequestWebServiceHelper.GFRA_MakeAdjusterWSCall(newSR.id);
            
            }
            
            }catch (Exception e){
                system.debug(' calling Adjsutmetn wx excepton : '+e);
             
            }
        }
    }
}