trigger UFHTActuary_GatecHistoryTrackTrigger On Actuary_Gate__c (after Update, after Delete) { 
 if(UserInfo.isCurrentUserLicensed('UFHT')) {
if(trigger.isAfter && trigger.isUpdate) { 
 UFHT.DynamicTriggerGenericHandler.verifyRecursiveCallForAnObject('Actuary_Gate__c') ;
 new UFHT.DynamicTriggerGenericHandler().onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'Actuary_Gate__c'); }

if(trigger.isAfter && trigger.isDelete) { 
 new UFHT.DynamicTriggerGenericHandler().processRecordInAfterDelete(trigger.newMap, trigger.oldMap, 'Actuary_Gate__c'); }

 }

}