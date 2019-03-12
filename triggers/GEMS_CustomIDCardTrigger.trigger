/************************************************************************************
* Name             : GEMS_CustomIDCardTrigger.tgr
* Description      : Trigger on GEMS Custom Id Card
* Created By       : Praveen
* Created Date     : 8/8/2016
* 
************************Version Updates***********************************************
* Date             Developer           Description
* 8/8/2016         Praveen             Initial Development
* -----------------------------------------------------------------------------------
**************************************************************************************/
trigger GEMS_CustomIDCardTrigger on GEMS_Custom_ID_Request_Form__c (before insert, before update, after insert, after update ,before delete) 
{
    if( trigger.isAfter && trigger.isUpdate) 
    {
        Gems_CustomIDCardEmailHandler.onIdCardSubmitSendNotificationToAccSubmitterCICAccMngmntUsers(trigger.new, trigger.oldMap);
    }
}