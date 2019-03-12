/*US-13467
Author:Padmini*/
trigger condel on ContentDocument (before delete) {

if (Trigger.isBefore) {

  if (Trigger.isDelete) {   
                SGRCountOpportunityNotes.CountEnhanceNotesOnBeforeDelete(Trigger.old);
                }
}
}