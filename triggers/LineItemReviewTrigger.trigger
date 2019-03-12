/**************************************************************************************
  Apex Trigger Name     : LineItemReviewTrigger
  Version               : 1.0
  Function              : This trigger on Line Item Review object is used to perform 
                          various operations on trigger events on Line Item Review.
  Modification Log      :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Ralph Tariga             06/20/2016                Original Version
*/

trigger LineItemReviewTrigger on Line_Item_Review__c (after update) {
	if (trigger.isAfter) {
  		if(trigger.isUpdate) {
  			LineItemReviewTriggerHandler.changePGParentCaseStatusIfAllLineItemsHaveDisposition(trigger.new);
  		}
    }
}