trigger OpptyCensusTrigger on SGR_Opportunity_Census__c (before Insert, after Insert, before update, after update, before delete, after delete, after undelete) {

if(Trigger.isBefore) System.debug('OpptyCensusTrigger  : Trigger.isBefore');
if(Trigger.isAfter) System.debug('OpptyCensusTrigger  : Trigger.isAfter');
if(Trigger.isInsert) System.debug('OpptyCensusTrigger  : Trigger.isInsert');
if(Trigger.isUpdate) System.debug('OpptyCensusTrigger  : Trigger.isUpdate');
if(Trigger.isDelete) System.debug('OpptyCensusTrigger  : Trigger.isDelete');
if(Trigger.isUnDelete) System.debug('OpptyCensusTrigger  : Trigger.isUnDelete');

if(Trigger.old != null)
for(SGR_Opportunity_Census__c recd :Trigger.old)
System.Debug('OpptyCensusTrigger  : Record (Old) = ' + recd);

if(Trigger.new != null)
for(SGR_Opportunity_Census__c recd :Trigger.new)
System.Debug('OpptyCensusTrigger  : Record (New) = ' + recd);


}