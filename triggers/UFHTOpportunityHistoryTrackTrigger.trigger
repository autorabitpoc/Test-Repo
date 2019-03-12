trigger UFHTOpportunityHistoryTrackTrigger On Opportunity (after Update, after Delete) { 
 if(UserInfo.isCurrentUserLicensed('UFHT')) {
if(trigger.isAfter && trigger.isUpdate) { 
 UFHT.DynamicTriggerGenericHandler.verifyRecursiveCallForAnObject('Opportunity') ;
 new UFHT.DynamicTriggerGenericHandler().onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'Opportunity'); }

if(trigger.isAfter && trigger.isDelete) { 
 new UFHT.DynamicTriggerGenericHandler().processRecordInAfterDelete(trigger.newMap, trigger.oldMap, 'Opportunity'); }

 }

}