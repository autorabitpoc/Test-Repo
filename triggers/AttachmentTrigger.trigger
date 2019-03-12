/**************************************************************************************************************************************
Apex Trigger Name     : AttachmentTrigger
Function              : This trigger on Attachment object is used to perform various operations on trigger events on Attachment. 
-------------------------------------------------------------------------------------------------------------------------------------                 
Developer                  Date			Description
-------------------------------------------------------------------------------------------------------------------------------------               
Phani Kommareddy		   05/16/2018	SFDC-6974 GEMS: ID Cards - Allow Prospective IDs to be attached to Prospective ID Card Form
*************************************************************************************************************************************/

trigger AttachmentTrigger on Attachment (after insert, after delete,before insert) {
    if(Test.isRunningTest() || (!Test.isRunningTest() && ConstantsController.CheckTriggerExecution(userinfo.getProfileId(), ConstantsController.AttachmentTriggerField))){
        if(trigger.isbefore && trigger.isInsert)  
            AtttachmentHandler.validateCBSRStatusforAttachment(Trigger.new);
        
        if(trigger.isAfter && trigger.isInsert)
            AtttachmentHandler.UpdateIntegrationActionObject(Trigger.new);
        
        if(Trigger.isDelete)
            AtttachmentHandler.DeleteIntegrationActionObject(Trigger.old);
            
        if(trigger.isAfter && trigger.isInsert)
            AtttachmentHandler.validationForMIMETypes(trigger.new);
    }
    
  /* commented by MC, no more needed it
    if(trigger.isAfter){//after insert or update
         AtttachmentHandler.updateQuoteRequestAttachmentCounter(Trigger.new);
    }*/
    
    
    //SFDC-6974 - hanlde beforeDelete and AfterInsert attachments on GEMS Prosective ID Card
    if((trigger.isAfter && trigger.isDelete) || (trigger.isAfter && trigger.isInsert)) {
        Set<Id> prospectiveIdCardAttachmentParentIds = new Set<Id>();
        
        List<Attachment> triggerList = new List<Attachment>();
        
        String operation = '';
        if(trigger.isAfter && trigger.isDelete) {
            triggerList = Trigger.old;            
        } else {
            triggerList = Trigger.new;            
        }
        
        for(Attachment attachmentNew : triggerList) {
            String sObjName = attachmentNew.parentId.getSObjectType().getDescribe().getName();
            if('GEMS_Prospective_ID_Card__c' ==  sObjName) {
                prospectiveIdCardAttachmentParentIds.add(attachmentNew.parentId);
                
            }
        }
        if(!prospectiveIdCardAttachmentParentIds.isEmpty()) {
         	List<Id> tempList = new List<Id>();
            tempList.addAll(prospectiveIdCardAttachmentParentIds);
            AtttachmentHandler.updateProspectiveIDAttachmentFlag(tempList);		
        }
    }
	
}