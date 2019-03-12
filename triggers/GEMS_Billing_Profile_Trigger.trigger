//************************************************************************************
// Name             : GEMS_Billing_Profile_Trigger.cls
// Description      : Trigger on GEMS_Billing_Profile for SFDC-4900 Update IsDescUpdate field when Name is changed
// Created By       : Ketki
// Created Date     : 7/10/2017 
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// 
// -----------------------------------------------------------------------------------
// ************************************************************************************

trigger GEMS_Billing_Profile_Trigger on GEMS_Billing_Profile__c (before update) {

     //SFDC-3641 : IsDescUpdate__c flag set to true on existing BPs when description changes for a account structure case of type renewal or off cycle
     if(Trigger.isBefore && Trigger.isUpdate && !System.isFuture()){
       List<GEMS_Billing_Profile__c> newBP = Trigger.new;
        for(GEMS_Billing_Profile__c bps : newBP){
            GEMS_Billing_Profile__c oldBP = Trigger.oldMap.get(bps.Id);
         
            if(bps.Name !=oldBP.Name && bps.IsNew__c == false ){
               bps.IsDescUpdate__c= True;
        
            }
            
        }
        
    }

}