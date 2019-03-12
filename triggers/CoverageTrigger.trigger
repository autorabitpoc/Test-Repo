trigger CoverageTrigger on Coverage__c (after insert, after update, after delete)  { 
	if ( trigger.isAfter && ( trigger.isUpdate || trigger.isInsert ) ) {
		CoverageTriggerHandler.updateBenefitAgreementComplexityScore( trigger.new );
	}
	if ( trigger.isAfter && trigger.isDelete ) {
		CoverageTriggerHandler.updateBenefitAgreementComplexityScore( trigger.old );
	}
}