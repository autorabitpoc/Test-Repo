/*US-13467
Author:Padmini*/
trigger ContentDocumentLinkTrigger on ContentDocumentLink (
	after insert, 
	after update, 
	after delete, 
	after undelete) {

	if(Test.isRunningTest() || (!Test.isRunningTest() && ConstantsController.CheckTriggerExecution(userinfo.getProfileId(), ConstantsController.ContentDocumentLinkTriggerField))){
		if(trigger.isAfter && trigger.isInsert){
	        ContentDocumentLinkTriggerHandler.UpdateContentDocumentFields(trigger.new);
		}

		if (Trigger.isAfter) {
			if(Trigger.IsInsert || Trigger.IsUndelete){
				SGRCountOpportunityNotes.CountEnhanceNotes(Trigger.New);
			}
			if(Trigger.IsDelete){
				SGRCountOpportunityNotes.CountEnhanceNotes(Trigger.Old);
			}
	    
		} 
	}
}