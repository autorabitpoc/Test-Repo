/***********************************************************************************************************
* Apex Class Name     : QuoteRequestTrigger
* Version             : 1.0
* Function            : This is the trigger class for the Quote Reqeust (Quote_Request_Summary__c) object.
* Modification Log    :
* Developer             Date            Description
* ----------------------------------------------------------------------------
* Zachary Campbell      12/22/17        SFDC-4784 - Initial version creation
***********************************************************************************************************/
trigger QuoteRequestTrigger on Quote_Request_Summary__c (after insert) {
    
    LGNAFeatureFlags__c featureFlag = LGNAFeatureFlags__c.getInstance();
    boolean qrSP = featureFlag.LGNA_Quote_Request_SharePoint__c;
    
    if(qrSP && trigger.isInsert){
        QuoteRequestTriggerHandler.createSharePointFolder(trigger.new);
    }
    
}