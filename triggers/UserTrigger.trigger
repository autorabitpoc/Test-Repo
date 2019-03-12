/**************************************************************************************
  Apex Trigger Name     : UserTrigger
  Version               : 1.0
  Function              : This trigger on User object is used to perform various operations on trigger events on User.
  Modification Log      :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
*  Mayuri Bhadane       05/12/2015                Original Version
*  Alec Klein           6/6/2016                  Updated
*************************************************************************************/
trigger UserTrigger on User (before update, after insert, after update) {
  UserTriggerHandler userTriggerHandler = new UserTriggerHandler();
  if (Test.isRunningTest() || (!Test.isRunningTest() && ConstantsController.CheckTriggerExecution(userinfo.getProfileId(), ConstantsController.UserTriggerField))) {
    if (trigger.isBefore && trigger.isUpdate) {
      userTriggerHandler.updateUserPermissionSets(trigger.new , trigger.oldMap);
    }
    if ((trigger.isAfter) && (trigger.isInsert || trigger.isUpdate)) {
      userTriggerHandler.updateContactAssociatedFields(trigger.new, trigger.oldMap);
      if (trigger.isInsert) {
        userTriggerHandler.assignUserPermissionSets(trigger.new);
      }
    }
  }
}