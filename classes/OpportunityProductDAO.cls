/**************************************************************************************
  Apex Class Name     : OpportunityProductDAO
  Version             : 1.0
  Function            : This is a DAO class for the Opportunity_Product__c Object
* Developer                        Date
* ----------------------------------------------------------------------------
* Nick Serafin/Slalom             5/23/2016
*************************************************************************************/

public with sharing class OpportunityProductDAO implements IOpportunityProductDAO {

  public interface IOpportunityProductDAO {
    List<Opportunity_Product__c> getLostProducts(List<String> lostProductIds);
    List<Opportunity_Product__c> getSelectedProducts(List<String> selectedProductIds);
    List<Opportunity_Product__c> getRatingProducts(Id opportunityId);
    void updateOpportunityProducts(List<Opportunity_Product__c> opProducts);
    Opportunity_Product__c getOpportunityProductById(Id opportunityProductId);
    void deleteOpportunityProduct(Opportunity_Product__c opportunityProduct);
    void upsertOpportunityProducts(List<Opportunity_Product__c> opportunityProducts);
    List<AggregateResult> getAggregateOpportunityProductByIds(List<Id> ids);
  }

  public List<Opportunity_Product__c> getLostProducts(List<String> lostProductIds) {
    return [SELECT Id, Name, Product__r.Non_Medical_Compensation__c, Product__r.Name, Product_Type__c, Funding_Type__c,
            Premium_Type__c, Projected_Contracts__c, Projected_Members__c, Win_Probability__c, Status__c,
            Product_Stage__c FROM Opportunity_Product__c WHERE Id IN :lostProductIds AND Product__r.Non_Medical_Compensation__c = True];
  }

  public List<Opportunity_Product__c> getSelectedProducts(List<String> selectedProductIds) {
    return [SELECT Id, Opportunity_Name__c, Projected_Members__c, Projected_Contracts__c,
            Category__c, Status__c, Product_Type__c FROM Opportunity_Product__c WHERE Id IN :selectedProductIds];
  }

  public List<Opportunity_Product__c> getRatingProducts(Id opportunityId){
        return [SELECT Id, Product__c, Product__r.Name FROM Opportunity_Product__c WHERE Opportunity_Name__c = :opportunityId];
  }

  public void updateOpportunityProducts(List<Opportunity_Product__c> opProducts) {
    update opProducts;
  }

  public Opportunity_Product__c getOpportunityProductById(Id opportunityProductId) {
    return [Select Id from Opportunity_Product__c where Id = :opportunityProductId limit 1];
  }

  public void deleteOpportunityProduct(Opportunity_Product__c opportunityProduct) {
    delete opportunityProduct;
  }

  public void upsertOpportunityProducts(List<Opportunity_Product__c> opportunityProducts) {
    upsert opportunityProducts;
  }

  public List<AggregateResult> getAggregateOpportunityProductByIds(List<Id> ids){
    return [SELECT SUM(Projected_Members__c) noOfProjectedMembers, Opportunity_Name__c opportunityName 
                  FROM Opportunity_Product__c WHERE Product__c != null AND Opportunity_Name__c IN:ids
                            GROUP BY Opportunity_Name__c LIMIT :Limits.getLimitQueryRows() - Limits.getQueryRows()];
  }
}