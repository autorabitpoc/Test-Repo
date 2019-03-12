trigger Trigger_SGR_Opportunity_Census on SGR_Opportunity_Census__c (after insert, after update, after delete, before delete) {
   
    Map<String,SGR_Trigger_Settings__c> mapActiveTriggerControls = SGR_Trigger_Settings_Utility.activeSGRTriggerSettings('Trigger_SGR_Opportunity_Census');
    Map<String,SGR_Trigger_Settings__c> mapAllTriggerControls = SGR_Trigger_Settings_Utility.allSGRTriggerSettings('Trigger_SGR_Opportunity_Census');
    
    if(Trigger.isAfter){
        
        //Insert decision branch
        if(Trigger.isInsert){            
            if(mapActiveTriggerControls.containsKey('createSGROpportunityMemberBenefits')){
                Trigger_SGR_Opportunity_Census_Helper.createSGROpportunityMemberBenefits(Trigger.new);    
            }
        }
        
        //Update decision branch
        if(Trigger.isUpdate){            
            if(mapActiveTriggerControls.containsKey('updateSGROpportunityMemberBenefits')){
                Trigger_SGR_Opportunity_Census_Helper.updateSGROpportunityMemberBenefits(Trigger.new, Trigger.oldMap);    
            }            
        }        
    }  
    
    if(Trigger.isBefore){
        
        //Delete decision branch
        if(Trigger.isDelete){            
            //This method has to be in the isBefore to ensure that the SGR Opportunity Member Benefits records are 
            //deleted before the SGR Opportunity Census record is deleted or else the referential integrity is lost
            //and the SGR Opportunity Member Benefits relationship is orphaned from the SGR Opportunity Census record
            if(mapActiveTriggerControls.containsKey('deleteSGROpportunityMemberBenefits')){
                Trigger_SGR_Opportunity_Census_Helper.deleteSGROpportunityMemberBenefits(Trigger.old); 
            }            
        }                
    } 
}