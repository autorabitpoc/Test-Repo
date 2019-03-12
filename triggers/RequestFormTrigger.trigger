/**************************************************************************************
Apex Class Name     : RequestFormTrigger 
Version             : 1.0
Function            : This is a trigger for Request Form
Developer         : Date                   Description
----------------------------------------------------------------------------                 
Gokul Bharati       09/07/2017             US-3044
Malathi Kethireddy  06/11/2018             US-9337
*************************************************************************************/
trigger RequestFormTrigger on GEMS_SBC_BB_Form__c (before insert,before update,after insert,after update) {
   
   if(Trigger.IsAfter){
    if(Trigger.isInsert || Trigger.isUpdate){
       GEMS_RequestFormTriggerHandler.ChildtoParentStatusUpdate(Trigger.NewMap,Trigger.OldMap,Trigger.New,Trigger.Old);
    }
    if (Trigger.isUpdate){
       GEMS_RequestFormTriggerHandler.SendEmailandFlagUpdate(Trigger.NewMap,Trigger.OldMap,Trigger.New,Trigger.Old);
    } 
    
   }
   
}