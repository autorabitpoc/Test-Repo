/*************************************************************************************
  Apex Class Name     : ScheduledBatchCreateCededRenewalCase
  Version             : 1.0
  Function            : Scheduled class for batch class BatchCreateCededRenewalCase
  Modification Log    :
  Developer               Date                     Description
  -----------------------------------------------------------------------------------
  Zachary Campbell    :   November 8 2016          Original Version
*************************************************************************************/
global with sharing class ScheduledBatchCreateCededRenewalCase implements Schedulable {

	//This Apex class schedules a BatchCreateCededRenewalCase to be run.
	global void execute(SchedulableContext sc) {

		String theQuery = 'SELECT Id FROM Account WHERE Status__c = \'Active\' AND External_id__c != null AND Ceded__c = true';
        BatchCreateCededRenewalCase Batch = new BatchCreateCededRenewalCase();
		Batch.query = theQuery;
		ID batchprocessid = Database.executeBatch(Batch, 2000);
	}
}