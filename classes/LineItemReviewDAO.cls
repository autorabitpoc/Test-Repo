/**************************************************************************************
  Apex Class Name     : LineItemReviewDAO
  Version             : 1.0
  Function            : This is a Line Item Review DAO class for accessing the Line  
                        Item Review object.
  Modification Log    :
* Developer                 Date
* ----------------------------------------------------------------------------
* Ralph Tariga              6/21/2016
*************************************************************************************/
public with sharing class LineItemReviewDAO implements ILineItemReviewDAO {

    public interface ILineItemReviewDAO {
		void insertLineItemReviews(List<Line_Item_Review__c> lineItemReviews);
		void deleteLineItemReviews(List<Line_Item_Review__c> lineItemReviews);
		List<Line_Item_Review__c> getLineItemReviewsUsingCases(Set<Id> caseIds);
	}
	public void insertLineItemReviews(List<Line_Item_Review__c> lineItemReviews){
		insert lineItemReviews;
	}
	public void deleteLineItemReviews(List<Line_Item_Review__c> lineItemReviews){
		delete lineItemReviews;
	}
	public List<Line_Item_Review__c> getLineItemReviewsUsingCases(Set<Id> caseIds){
		return [SELECT Id, OwnerId, Owner.Name, Related_Case__c FROM Line_Item_Review__c WHERE Related_Case__c IN :caseIds];
	}
}