trigger GEMS_MBCTestingTrigger on GEMS_MBC_Testing__c(before insert, before update, after insert, after update , before delete){

    if( trigger.isAfter && trigger.isUpdate) {
        GEMS_MBCTestingTriggerHandler.updateMBCBALevelStatus(trigger.new, trigger.oldmap);
        GEMS_MBCTestingTriggerHandler.updateDTUSignOffDate(trigger.new, trigger.oldmap);
        
    }
    if(trigger.isAfter && trigger.isInsert){
        GEMS_MBCTestingTriggerHandler.insertMBCBALevelStatus(trigger.new);
    }
}