trigger RequestTypeTrigger on Request_Type__c (after insert, after update, after delete){
	if(Trigger.isAfter){	
		if(Trigger.isInsert || Trigger.isUpdate){
			RequestTypeTriggerHandler.setCaseNITypeSelections(trigger.new);
		}
		else if(Trigger.isDelete){
			RequestTypeTriggerHandler.setCaseNITypeSelections(trigger.old);	
		}
	}
}