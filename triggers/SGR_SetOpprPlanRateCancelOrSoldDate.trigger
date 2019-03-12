trigger SGR_SetOpprPlanRateCancelOrSoldDate on SGR_Opportunity_Plan_Rate__c (before insert, before update){
    if(Trigger.isBefore && Trigger.isInsert){
       SGR_UpdateOpprPlnRteSldOrCanlDt_Handler.InsertPlnRateCancelOrSoldDateCopy(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        SGR_UpdateOpprPlnRteSldOrCanlDt_Handler.UpdatePlnRateCancelOrSoldDateCopy(Trigger.old,Trigger.new);
    }
}