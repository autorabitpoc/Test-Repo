/**************************************************************************************
* Apex Class Name     : LGNA_EIN_Trigger 
* Version             : 1.0
* Function            : This is trigger for Employer Identification Number object.
* Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Bharath            04/09/2018             Original Version
*************************************************************************************/
trigger LGNA_EIN_Trigger on EIN__c (before insert, before update, after update, after insert) {
    
    //EIN Trigger disabled using Custom Label
    string disableEIN = System.Label.EIN_Trigger_Disabled;
    if(!string.isBlank(disableEIN) && disableEIN.containsIgnoreCase('Yes')){
      return;
    } 
    //EIN Trigger disabled using Custom Label
    if(trigger.isBefore){
        if(trigger.isUpdate){
            LGNA_EIN_TriggerHelper.checkUpdateEIN(trigger.newMap,trigger.oldMap);    
        } else if (trigger.isInsert){
            LGNA_EIN_TriggerHelper.checkCreateEIN(trigger.new);
        }
        
    } 
    if(trigger.isAfter){
        if(trigger.isUpdate){
            LGNA_EIN_TriggerHelper.clearPrimaryUpdate(trigger.new,trigger.oldMap);
            LGNA_EIN_TriggerHelper.initiateEINTransmit(trigger.new,trigger.oldMap);            
        }
        if(trigger.isInsert){
            LGNA_EIN_TriggerHelper.clearPrimaryInsert(trigger.new);
        }
    }
}