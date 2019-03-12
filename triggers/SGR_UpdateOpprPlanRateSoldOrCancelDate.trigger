trigger SGR_UpdateOpprPlanRateSoldOrCancelDate on SGR_Opportunity_Group_Section__c(after update, before delete){
    
    if(Trigger.isAfter && Trigger.isUpdate){
        
        SGR_UpdateOpprPlnRteSldOrCanlDt_Handler.updateSoldOrCancelDate(Trigger.old,Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isDelete){
        
        SGR_UpdateOpprPlnRteSldOrCanlDt_Handler.emptySoldAndCancelDate(Trigger.old);
    }
    
}