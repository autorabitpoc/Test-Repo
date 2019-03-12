/**************************************************************************************
Apex Class Name     : SGR_BSTAR_TransferBatch  
Version             			: 1.0
Function            		: This class is used to make calls to BlueSTAR transfer callout method
Modification Log    	:
* Developer: Shankar  Date: 12/20/2018                   Initial version
* ----------------------------------------------------------------------------               
* Shankar                  09/05/2018                Original Version
*************************************************************************************/
global  class SGR_BSTAR_TransferBatch implements Queueable, Database.AllowsCallouts {
    public static Integration_Log_Switcher__c bStarTransferLog = Integration_Log_Switcher__c.getInstance('BlueSTAR Transfer Service');

    Id renBatchRecId;
    public List<String> recipientEmailAddr;
    public Set<Id> validOppIds; 
    Id sgrProdOppRecTypeId; 
    
    global SGR_BSTAR_TransferBatch(Set<Id> validOppIds) {
        this.validOppIds = validOppIds;		
        String className = 'SGR_BSTAR_TransferBatch';	
        List<SGR_EmailDL__c> dlSettingVals = new  List<SGR_EmailDL__c>();
        
        if (!Test.isRunningTest()) {
        	dlSettingVals = SGR_EmailDL__c.getAll().values();
        
        	recipientEmailAddr = new List<String>();    	
        
        	if (null != dlSettingVals) {
            	for (SGR_EmailDL__c dl: dlSettingVals) {
                	if (dl.TaskName__c == className) {
                    	recipientEmailAddr.add(dl.To__c);
                	}	
            	}
        	}    	
        }
    }
    
    global void execute(QueueableContext qc) {
        if (!Test.isRunningTest()) {
        	SGR_BlueStarTransferCallout.sendPlanOrRateChangeReqListToBStar(validOppIds);        
        }
    }
    
    
    global void finish(Database.BatchableContext bc) {
        String body, subject;
        if (!Test.isRunningTest()) {
        	body = 'BlueSTAR transfer batch completed. Check BR Validation Log & Error log to see if any error occured.<br/>Regards,<br/>SGR BlueSTAR Transfer Batch';
        	subject = 'BlueSTAR transfer batch job completed';
        	EmailUtility.circulateEmail(recipientEmailAddr, subject, body);        
        }
    }
}