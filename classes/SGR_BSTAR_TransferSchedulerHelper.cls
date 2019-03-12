/**************************************************************************************
  Apex Class Name     : SGR_BSTAR_TransferSchedulerHelper     
  Version             			: 1.0
  Function            		: This class is used to create and schedule batch jobs to perform BlueSTAR transfer
  Modification Log    	:
* Developer: Shankar  Date: 12/20/2018                   Initial version
* ----------------------------------------------------------------------------               
* Shankar                  09/05/2018                Original Version
* Shankar					 07/01/2019				Updated SOQL query and method signature to include renewal year
*************************************************************************************/
public class SGR_BSTAR_TransferSchedulerHelper {
	
	public Set<Id> oppIds;	
	
	public SGR_BSTAR_TransferSchedulerHelper() {
			this.oppIds = new Set<Id>();	
	}
	
	//public void scheduleJobs(Id batchRecId, String division, String fundingType, String marketSeg, Integer renMonth,  Integer renYear, DateTime schedDateTime) {
    public void scheduleJobs(Id batchRecId, String division, String fundingType, String marketSeg, Date renewaldate, DateTime schedDateTime) {
		Id sgrProdOppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Production_Opportunity').getRecordTypeId();
		List<Opportunity> opps = [Select Id, AccountId, Account.AccountNumber from Opportunity 
																	WHERE 
																	HCSC_Division__c = :division AND 
																	Funding_Type__c = :fundingType AND
																	//Account_Market_Segment__c = :marketSeg AND
                                  									Renewal_Date__c >=:renewaldate AND 
                                  									Renewal_Date__c <:renewaldate.addMonths(1) AND
																	//CALENDAR_MONTH(Renewal_Date__c) = :renMonth AND
																	//CALENDAR_YEAR(Renewal_Date__c) = :renYear AND
																	Rating_Status__c = 'Sold' AND
																	RecordType.Id = :sgrProdOppRecTypeId AND
                                  									ForeCast_Segment__c='Small Group'
													];		
		
		List<SGR_Renewal_Batch_Oppty__c> rbOpptyList = new List<SGR_Renewal_Batch_Oppty__c>();
		
		if(null == opps || opps.isEmpty()) {
			SGR_Exception ex = new SGR_Exception('No opportunities found with the selected criteria');
			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'SGR_BSTAR_TransferSchedulerHelper', null, 'SGR_BSTAR_TransferSchedulerHelper.scheduleJobs', 'High');
		}
		try {
			for (Opportunity opp: opps) {
				// Create a Bath Renewal Oppty junction record for each opportunity
				SGR_Renewal_Batch_Oppty__c rbOppty = new SGR_Renewal_Batch_Oppty__c();
				rbOppty.Account_Id__c = opp.AccountId;
				rbOppty.Account_Number__c = opp.Account.AccountNumber;
				rbOppty.BatchId__c = batchRecId;
				rbOppty.Opportunity__c = opp.Id;
				rbOppty.Processing_Status__c = 'Bluestar transfer initiated';
				rbOpptyList.add(rbOppty);
				
				oppIds.add(opp.Id);
			}
			
			if (!rbOpptyList.isEmpty()) {
				Database.SaveResult[] results = Database.insert(rbOpptyList, false);
				CreateExceptionLog.insertErrorLog(null, results, null, null, 'Apex Class', 'SGR_BSTAR_TransferSchedulerHelper', null, 'SGR_BSTAR_TransferSchedulerHelper.scheduleJobs', 'High');
			}

			String cronExpr = '';
				
			if (null != schedDateTime) {
				// Build CRON expression to run the job based on user input
				cronExpr = '0 ' + String.valueOf(schedDateTime.minute() + 1) + ' ' + String.valueOf(schedDateTime.hour()) + ' ' + String.valueOf(schedDateTime.day()) + ' ' + String.valueOf(schedDateTime.month()) + ' ? ' +  String.valueOf(schedDateTime.year());
				System.debug('cronExpr:: ' + cronExpr);
				if (!Test.isRunningTest()) {
					System.schedule('B* Transfer One time Job for ' + division + ' - ' + cronExpr , cronExpr, new SGR_BSTAR_OppValidatorBatch(oppIds, batchRecId));
				} 
			} else {
				throw new SGR_Exception('Schedule date & time is missing');
			}
		} catch (Exception ex) {
			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'SGR_BSTAR_TransferSchedulerHelper', null, 'SGR_BSTAR_TransferSchedulerHelper.scheduleJobs', 'High');			
		}
	}
}