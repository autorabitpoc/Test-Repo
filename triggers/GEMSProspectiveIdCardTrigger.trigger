/************************************************************************************
* Name             : GEMSProspectiveIdCardTrigger.tgr
* Description      : Trigger on GEMS Prospective Id Card
* Created By       : Praveen
* Created Date     : 8/8/2016
* 
************************Version Updates***********************************************
* Date             Developer           Description
* 8/8/2016         Praveen             Initial Development
* -----------------------------------------------------------------------------------
**************************************************************************************/
trigger GEMSProspectiveIdCardTrigger on GEMS_Prospective_ID_Card__c (before insert, before update, after insert, after update ,before delete)
{
    if( trigger.isAfter && trigger.isUpdate) 
    {
        GEMS_ProspectiveIdCardEmailHandler.onIdCardUpdateSendNotificationToAccSubmitterCICAccMngmntUsers(trigger.new, trigger.oldMap);
    }
}