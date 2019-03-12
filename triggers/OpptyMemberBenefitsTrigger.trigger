trigger OpptyMemberBenefitsTrigger on SGR_Opportunity_Member_Benefits__c (before Insert, after Insert, before update, after update, before delete, after delete, after undelete) {

if(Trigger.isBefore) System.debug('OpptyMemberBenefitsTrigger  : Trigger.isBefore');
if(Trigger.isAfter) System.debug('OpptyMemberBenefitsTrigger  : Trigger.isAfter');
if(Trigger.isInsert) System.debug('OpptyMemberBenefitsTrigger  : Trigger.isInsert');
if(Trigger.isUpdate) System.debug('OpptyMemberBenefitsTrigger  : Trigger.isUpdate');
if(Trigger.isDelete) System.debug('OpptyMemberBenefitsTrigger  : Trigger.isDelete');
if(Trigger.isUnDelete) System.debug('OpptyMemberBenefitsTrigger  : Trigger.isUnDelete');

if(Trigger.old != null)
for(SGR_Opportunity_Member_Benefits__c  recd :Trigger.old)
System.Debug('OpptyMemberBenefitsTrigger  : Record (Old) = ' + recd);

if(Trigger.new != null)
for(SGR_Opportunity_Member_Benefits__c  recd :Trigger.new)
System.Debug('OpptyMemberBenefitsTrigger  : Record (New) = ' + recd);


}