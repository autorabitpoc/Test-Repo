trigger UFHTSGR_Opportunity_Plan_RatecHistoryTrackTrigger On SGR_Opportunity_Plan_Rate__c (after Update, after Delete , before Insert,before update) { 
 if(UserInfo.isCurrentUserLicensed('UFHT')) {
if(trigger.isAfter && trigger.isUpdate) { 
 UFHT.DynamicTriggerGenericHandler.verifyRecursiveCallForAnObject('SGR_Opportunity_Plan_Rate__c') ;
 new UFHT.DynamicTriggerGenericHandler().onUpdateStoreHistoryData(trigger.newMap, trigger.oldMap, 'SGR_Opportunity_Plan_Rate__c'); }

if(trigger.isAfter && trigger.isDelete) { 
 new UFHT.DynamicTriggerGenericHandler().processRecordInAfterDelete(trigger.newMap, trigger.oldMap, 'SGR_Opportunity_Plan_Rate__c'); }

 }
    //Akbar - Start - This below code added as part of E2E testing requirement
	if(Trigger.isBefore && Trigger.isInsert){
       SGR_UpdateOpprPlnRteSldOrCanlDt_Handler.InsertPlnRateCancelOrSoldDateCopy(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        SGR_UpdateOpprPlnRteSldOrCanlDt_Handler.UpdatePlnRateCancelOrSoldDateCopy(Trigger.old,Trigger.new);
    }
    //End
}