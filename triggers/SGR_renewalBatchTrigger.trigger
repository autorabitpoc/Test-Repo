trigger SGR_renewalBatchTrigger on SGRRenewalBatch__c (after update) {
    list<SGRRenewalBatch__c> allsetInsertedIds = new list<SGRRenewalBatch__c>();
    allsetInsertedIds =trigger.new;
    SGR_FutureTriggerClass.captureFuture(allsetInsertedIds); 
}