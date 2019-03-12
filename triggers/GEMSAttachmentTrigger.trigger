trigger GEMSAttachmentTrigger on GEMS_Attachment__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
    GEMS_AttachmentTriggerHandler handler = new GEMS_AttachmentTriggerHandler();
    if((Trigger.isInsert  || Trigger.isUpdate ) && Trigger.isAfter){
        GEMS_AttachmentTriggerHandler.updateRequiredDocumentFlag(Trigger.new,Trigger.OldMap);
        //SFDC-8501
        GEMS_AttachmentTriggerHandler.autoUpdAccSubCaseBPA(Trigger.newMap.keySet()); 
        //SFDC-8501   
    }
    if(Trigger.isDelete && Trigger.isAfter){
        GEMS_AttachmentTriggerHandler.updateRequiredDocumentFlag(Trigger.old,Trigger.OldMap);
    }
}