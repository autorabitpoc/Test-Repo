/**************************************************************************************
  Apex Class Name     : SGR_BSTAR_TransferBatch  
  Version             			: 1.0
  Function            		: This class is used to make calls to BlueSTAR transfer callout method
  Modification Log    	:
* Developer: Shankar  Date: 12/20/2018                   Initial version
* ----------------------------------------------------------------------------               
* Shankar                  09/05/2018                Original Version
*************************************************************************************/
global  class SGR_BSTAR_OppValidatorBatch implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
	public static Integration_Log_Switcher__c bStarTransferLog = Integration_Log_Switcher__c.getInstance('BlueSTAR Transfer Service');
	Set<Id> oppIds;
	Id renBatchRecId;
	public List<String> recipientEmailAddr;
	public Set<Id> validOppIds; 
	Id sgrProdOppRecTypeId; 
	
	global SGR_BSTAR_OppValidatorBatch(Set<Id> oppIds, Id renBatchRecId) {
		this.oppIds = oppIds;
		this.renBatchRecId = renBatchRecId;
		this.sgrProdOppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SGR_Production_Opportunity').getRecordTypeId();
		String className = 'SGR_BSTAR_TransferBatch';	
    	List<SGR_EmailDL__c> dlSettingVals = new List<SGR_EmailDL__c>();

		recipientEmailAddr = new List<String>();    	
		validOppIds = new Set<Id>();
		if (!Test.isRunningTest()) {
			dlSettingVals = SGR_EmailDL__c.getAll().values();
			if (null != dlSettingVals) {
				for (SGR_EmailDL__c dl: dlSettingVals) {
					if (dl.TaskName__c == className) {
						recipientEmailAddr.add(dl.To__c);
					}
				}
			}
		}    	
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		
		
		String query = 'Select Id ' +                        			
                      			 'FROM Opportunity ' +
                     			 'WHERE Id IN :oppIds AND Rating_Status__c = \'Sold\' AND (Plan_Change_Needed__c = \'\' OR Plan_Change_Needed__c = \'Complete\')';
		System.debug('Opp query::'+ query);                     			        
        return Database.getQueryLocator(query);        
    }
    
	global void execute(Database.BatchableContext bc, List<Opportunity> scope) {
		String body, subject;
		// Validate opportunities using eligibility rule validation helper
		SGR_BRValidationManager validator = new SGR_BRValidationManager('SGR_BlueSTAREligibilityRules');
		Set<Id> oppIds = new Set<Id>();			   
		for (Opportunity o: scope) {
			oppIds.add(o.Id);
		} 	
		if (!Test.isRunningTest()) {
			validOppIds = validator.validate(oppIds);
		}
		
		if (null == validOppIds || validOppIds.isEmpty()) {
			body = 'No valid opportunities found after validation. Check BR Validation logs.<br/>Regards,<br/>SGR BlueSTAR Transfer Batch';
			subject = 'SGR BlueSTAR Transfer Batch  job failed';
			if (!Test.isRunningTest()) {
				EmailUtility.circulateEmail(recipientEmailAddr, subject, body);
			}
			SGR_Exception ex = new SGR_Exception('No valid opportunities found after validation. Check BR Validation logs');
			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'SGR_BSTAR_TransferBatch', null, 'SGR_BSTAR_TransferBatch.execute', 'High');
			return;
		}
	}

  	
  	global void finish(Database.BatchableContext bc) {
				String body, subject;
				/*body = 'BlueSTAR transfer batch completed. Check BR Validation Log & Error log to see if any error occured.<br/>Regards,<br/>SGR BlueSTAR Transfer Batch';
				subject = 'BlueSTAR transfer batch job completed';
				EmailUtility.circulateEmail(recipientEmailAddr, subject, body);
				*/
				if (!validOppIds.isEmpty()) {
                    System.enqueueJob(new SGR_BSTAR_TransferBatch(validOppIds));			    
				} else {

					if (!Test.isRunningTest()) {
						body = 'No valid opportunities found after validation. Check BR Validation logs.<br/>Regards,<br/>SGR BlueSTAR Transfer Batch';
						subject = 'SGR BlueSTAR Transfer Batch  job failed';
						EmailUtility.circulateEmail(recipientEmailAddr, subject, body);
					}
					SGR_Exception ex = new SGR_Exception('No valid opportunities found after validation. Check BR Validation logs');
					CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'SGR_BSTAR_TransferBatch', null, 'SGR_BSTAR_TransferBatch.execute', 'High');
				}				
  	}
  	
  	global void execute(System.SchedulableContext sc) {
		Database.executeBatch(new SGR_BSTAR_OppValidatorBatch(this.oppIds, this.renBatchRecId));
  	}
    
}