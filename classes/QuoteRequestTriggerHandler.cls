/***********************************************************************************************************
* Apex Class Name     : QuoteRequestTriggerHandler
* Version             : 1.0
* Function            : This is the apex handling class for the Quote Request Trigger.
* Modification Log    :
* Developer				Date			Description
* ----------------------------------------------------------------------------
* Zachary Campbell		12/22/17		SFDC-4784 - Initial version creation
***********************************************************************************************************/
public with sharing class QuoteRequestTriggerHandler {   
    /*
	* @author			Zachary Campbell
	* @description		Creates SharePoint Folders for Quote Requests
	* @parameters		newQRs from Trigger.new
	*/
    public static void createSharePointFolder(List<Quote_Request_Summary__c> newQRs) {
        try {
           
            List<Quote_Request_Summary__c> QRsForCreate = new List<Quote_Request_Summary__c>();
            
            for (Quote_Request_Summary__c currQR : newQRs) {
                    QRsForCreate.add( currQR );
            }
            
            if (!QRsForCreate.isEmpty() ) {
				System.enqueueJob(new SharePointQuoteRequestManager(QRsForCreate));
            }
        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Quote_Request_Summary__c', 'QuoteRequestTrigger', 'QuoteRequestTriggerHandler.createSharePointFolder()', 'High');
        }
    }
   
}