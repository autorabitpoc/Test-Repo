/**********************************************************************************/
/* SFDC-7243 - 11/2017 - Take Comments from Approval Process */
/**********************************************************************************/

trigger ServiceRequestTrigger on Service_Request__c (before update, after update) {    
    /* SFDC-7243 - 11/2017 - BEGIN */    
    System.debug('ServiceRequestTrigger:isBefore:Checkpoint0');
   /* if (Trigger.isBefore && Trigger.isUpdate){
        ServiceRequestTriggerHelper.UpdateCommentsOnServiceRequest(Trigger.New,Trigger.Old);
        system.debug('ending calling UpdateCommentsOnServiceRequest');*/
        /* SFDC-7243 - 11/2017 - END   */ 
       /* ServiceRequestTriggerHelper.updateStatuForRejectionReason(Trigger.New,Trigger.Old);
        system.debug('ending calling updateStatuForRejectionReason');
       
    }
    if(Trigger.isUpdate && Trigger.isAfter){
        ServiceRequestTriggerHelper.sendAdjustmentCallout(Trigger.New, Trigger.Old);
        system.debug(' callout adjustment WS ending.....');
    }*/
           
}