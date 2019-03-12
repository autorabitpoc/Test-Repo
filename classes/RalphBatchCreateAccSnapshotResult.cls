global class RalphBatchCreateAccSnapshotResult implements Database.Batchable<sObject>, Database.Stateful {
	public String query;
	public String firstMonth;
	public String secondMonth;
	public Double startBound;
	public Double endBound;
	public Map<Id, Complete_Account_Snapshot__c> firstMonthMap = new Map<Id, Complete_Account_Snapshot__c>();
	public Set<Id> idList = new Set<Id>();

	public RalphBatchCreateAccSnapshotResult (String firstMonth, String secondMonth, Double startBound, Double endBound) {
		this.firstMonth = firstMonth;
		this.secondMonth = secondMonth;
		this.startBound = startBound;
		this.endBound = endBound;
	}

	global Database.querylocator start(Database.BatchableContext batchContext) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext batchContext, List<sObject> scope) {
		for (Complete_Account_Snapshot__c accSnapshot : (List<Complete_Account_Snapshot__c>) scope) {
			firstMonthMap.put(accSnapshot.Account__r.Id, accSnapshot);
			idList.add(accSnapshot.Account__r.Id);
		}
	}

	global void finish(Database.BatchableContext batchContext) {
		//String stringBound = String.valueOf(curBound);
		System.debug('endBound: ' + endBound);

		/*if (firstMonthMap.size() > 0) {
			RalphBatchCreateAccSnapshotResultHelper myBatch = new RalphBatchCreateAccSnapshotResultHelper(firstMonth, secondMonth, firstMonthMap, idList, startBound, endBound);
			String myQuery = 'SELECT Id, Name, Account__c, Account__r.Id, Carrier_Count__c, Sliced__c, Exchange__c, Status__c, Snapshot_Number__c FROM Complete_Account_Snapshot__c';
			myQuery = myQuery + ' WHERE (Name =\'' + myBatch.secondMonth + '\'';
			myQuery = myQuery + ' AND Account__r.Id IN :idList)';
			System.debug('Query: ' + myQuery);
			myBatch.query = myQuery;
			Id myBatchProcessId = Database.executeBatch(myBatch, 2000);
		}*/
	}
}