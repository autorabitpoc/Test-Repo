/***********************************************************************************************************
* Apex Class Name     : QuoteTrigger
* Version             : 1.0
* Function            : This is the trigger class for the Quote object.
* Modification Log    :
* Developer             Date            Description
* ----------------------------------------------------------------------------
* Zachary Campbell      2/23/18        SFDC-7961 - Initial version creation
***********************************************************************************************************/
trigger QuoteTrigger on Quote (before delete) {

	LGNAFeatureFlags__c featureFlag = LGNAFeatureFlags__c.getInstance();
    boolean qrD = featureFlag.LGNA_Quote_Request_Deletion__c;    
    
    if(trigger.isBefore){
    	
        if(trigger.isDelete && qrD){
        	QuoteTriggerHandler.deleteQuoteRequestRecords(trigger.old);
    	}
        
    }
    
}