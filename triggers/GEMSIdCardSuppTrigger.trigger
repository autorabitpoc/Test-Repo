/************************************************************************************
* Name             : GEMSIdCardSuppressionTrigger.tgr
* Description      : Trigger on GEMS Id Card Suppression
* Created By       : Malathi Kethireddy
* Release          : 09/16/2016
* 
************************Version Updates***********************************************
* Date             Developer           Description
* 8/22/2016        Malathi Kethireddy  Initial Development
* -----------------------------------------------------------------------------------
**************************************************************************************/
trigger GEMSIdCardSuppTrigger on GEMS_ID_Card_Suppression__c (before insert, before update, after insert, after update ,before delete)
{
    if( trigger.isAfter && trigger.isUpdate) 
    {
        GEMS_IDCardSuppEmailHandler.onIdCardUpdateSendNotificationToAccSubmitterCICAccMngmntUsers(trigger.new, trigger.oldMap);
    }
}