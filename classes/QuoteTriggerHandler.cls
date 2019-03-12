/***********************************************************************************************************
* Apex Class Name     : QuoteTriggerHandler
* Version             : 1.0
* Function            : This is the apex handling class for the Quote Trigger.
* Modification Log    :
* Developer				Date			Description
* ----------------------------------------------------------------------------
* Zachary Campbell		2/23/18		SFDC-7961 - Initial version creation
***********************************************************************************************************/
public class QuoteTriggerHandler {
    
    public static void deleteQuoteRequestRecords(List<Quote> delQuoteList) {
        
    	try {
            for (Quote currQ : delQuoteList) {
				List<Quote_Request_Summary__c> QRsForDelete = [Select id from Quote_Request_Summary__c where Quote_Name__c = :currQ.Id];
                
                if(!QRsForDelete.isEmpty()){
					delete QRsForDelete;
                }
            }
        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Quote', 'QuoteTrigger', 'QuoteTriggerHandler.deleteQuoteRequestRecords()', 'High');
        }
    }    

}