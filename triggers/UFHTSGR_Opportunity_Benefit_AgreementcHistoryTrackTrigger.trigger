trigger UFHTSGR_Opportunity_Benefit_AgreementcHistoryTrackTrigger On SGR_Opportunity_Benefit_Agreement__c (after Update, after Delete) { 
 if(UserInfo.isCurrentUserLicensed('UFHT')) {
if(trigger.isAfter && trigger.isUpdate) { 
 UFHT.DynamicTriggerGenericHandler.verifyRecursiveCallForAnObject('SGR_Opportunity_Benefit_Agreement__c') ;
 new UFHT.DynamicTriggerGenericHandler().onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'SGR_Opportunity_Benefit_Agreement__c'); }

if(trigger.isAfter && trigger.isDelete) { 
 new UFHT.DynamicTriggerGenericHandler().processRecordInAfterDelete(trigger.newMap, trigger.oldMap, 'SGR_Opportunity_Benefit_Agreement__c'); }

 }

}