trigger ContractAdministrationTrigger on Contract_Administration__c (after insert, after update, after delete)  { 
	if ( trigger.isAfter && ( trigger.isUpdate || trigger.isInsert ) ) {
		ContractAdministrationTriggerHandler.updateContractAdministrationComplexityScore( trigger.new );
	}
	if ( trigger.isAfter && trigger.isDelete ) {
		ContractAdministrationTriggerHandler.updateContractAdministrationComplexityScore( trigger.old );
	}
}