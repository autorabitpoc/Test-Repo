/**************************************************************************************
  Apex Trigger Name     : AccountTrigger
  Version               : 1.0
  Function              : This trigger on Acount object is used to perform various operations on trigger events on Account.
  Modification Log      :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
*   Suyog Dongaonkar       21/11/2014                Original Version
*   Bharath				   11/20/2017				 SFDC-4729 Call included for cancellation of Submission Case when the Account is cancelled.
*/

trigger AccountTrigger on Account (after insert, after update, before update, before insert) {
  AccountTriggerHandler accountTriggerHandlerInstance = new AccountTriggerHandler();
  if (Test.isRunningTest() || (!Test.isRunningTest() && ConstantsController.CheckTriggerExecution(userinfo.getProfileId(), ConstantsController.AccountTriggerField))) {
    if (trigger.isBefore) {
      AccountTriggerHandler.CarryOverMemberValues(trigger.newMap, trigger.oldMap);
      AccountTriggerHandler.validateUniqueNPN(trigger.new);
      AccountTriggerHandler.updateRegion(trigger.new);
      AccountTriggerHandler.clientProfileFieldCompletion(trigger.new, trigger.oldMap, trigger.isInsert);
      AccountTriggerHandler.populateForecastSegment(trigger.new);
      AccountTriggerHandler.complexityScoreFieldCompletion(trigger.new, trigger.oldMap, trigger.isInsert);
      if (trigger.isUpdate){
        AccountTriggerHandler.updateOpportunityWeeklyActivityModifiedDate(trigger.newMap, trigger.oldMap);
      }
        System.debug('1. LGNA Number of queries used in the Trigger after update apex code so far: ' + Limits.getQueries());
        System.debug('2. LGNA Number of rows queried in the Trigger after update apex code so far: ' + Limits.getDmlRows());
        System.debug('3.LGNA Number of script statements used in the Trigger after update apex code so far : ' + Limits.getDmlStatements());
    }

    if (trigger.isAfter) {
      AccountTriggerHandler.updateProducerParent(trigger.newMap, trigger.oldMap);
        AccountTriggerHandler.GS_BA_BP_Cancellation(trigger.newMap, trigger.oldMap);
        System.debug('4. LGNA Number of queries used in the Trigger after update apex code so far: ' + Limits.getQueries());
        System.debug('5.LGNA Number of rows queried in the Trigger after update apex code so far: ' + Limits.getDmlRows());
        System.debug('6. LGNA Number of script statements used in the Trigger after update apex code so far : ' + Limits.getDmlStatements());

      if (trigger.isInsert) {
        System.debug('1. LGNA Number of queries used in the Trigger after update apex code so far: ' + Limits.getQueries());
        System.debug('2. LGNA Number of rows queried in the Trigger after update apex code so far: ' + Limits.getDmlRows());
        System.debug('3. LGNA Number of script statements used in the Trigger after update apex code so far : ' + Limits.getDmlStatements());
        AccountTriggerHandler.updateCustomContractCaseStatus(trigger.new,new Map<Id,Account>());
        AccountTriggerHandler.createProducerContact( trigger.new );
        AccountTriggerHandler.createChatterPost(trigger.new);
        AccountTriggerHandler.addAE2AndUnderwriterOnInsert( trigger.new );
        AccountTriggerHandler.createSharePointFolder(trigger.new);  

      } else if (trigger.isUpdate) {
        System.debug('1. LGNA Number of queries used in the Trigger after update apex code so far: ' + Limits.getQueries());
        System.debug('2. LGNA Number of rows queried in the Trigger after update apex code so far: ' + Limits.getDmlRows());
        System.debug('3. LGNA Number of script statements used in the Trigger after update apex code so far : ' + Limits.getDmlStatements());
        AccountTriggerHandler.updateCustomContractCaseStatus(trigger.new,trigger.oldMap);
        System.debug('4. LGNA Number of queries used in the Trigger after update apex code so far: ' + Limits.getQueries());
        System.debug('5. LGNA Number of rows queried in the Trigger after update apex code so far: ' + Limits.getDmlRows());
        System.debug('6. LGNA Number of script statements used in the Trigger after update apex code so far : ' + Limits.getDmlStatements());
        AccountTriggerHandler.createProducerContact( trigger.old, trigger.new );
        AccountTriggerHandler.createChatterPost(trigger.old, trigger.new);
        AccountTriggerHandler.addAE2AndUnderwriterOnUpdate( trigger.new , trigger.oldMap);
        //AccountTriggerHandler.CreateRenewalOpportunity(trigger.newMap, trigger.oldMap);
        AccountTriggerHandler.ReatainPreviousOwnersAccess(trigger.new, trigger.oldMap);
        accountTriggerHandlerInstance.populateContractSignerFields(trigger.newMap, trigger.oldMap);
        AccountTriggerHandler.updateSharePointFolder(trigger.new, trigger.oldMap);
        AccountTriggerHandlerInstance.populatePrimaryContactField(trigger.newMap, trigger.oldMap);
          //SFDC-4729 - Call to cancel Submission case when Account is cancelled.
          AccountTriggerHandler.cancelSubmissionCase(trigger.new, trigger.oldmap);          
      }
      
    }
  }
}