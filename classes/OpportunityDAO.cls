/**************************************************************************************
  Apex Class Name     : OpportunityDAO
  Version             : 1.0
  Function            : This is a DAO class for the Opportunity Object
* Developer                        Date
* ----------------------------------------------------------------------------
* Nick Serafin/Slalom             5/23/2016
*************************************************************************************/

public with sharing class OpportunityDAO implements IOpportunityDAO {

  public interface IOpportunityDAO {
    List<Opportunity> getOpportunitiesForProduct360(Set<Id> accountIds);
    Opportunity getOpportunityById(Id opportunityId);
    void updateOpportunity(Opportunity opportunityObj);
    void updateOpportunities(List<Opportunity> opportunities);
    List<Opportunity> getOpportunitiesForCustomContractsCurrProds(Id acctId, Id productRecordTypeId);
    List<Opportunity> getOpportunitiesByParentAccount(Set<Id> parentIds);
    List<Opportunity> getOpportunitiesForCustomContractsActiveProds(Id acctId);
  }

  public Opportunity getOpportunityById(Id opportunityId) {
    return [SELECT Id, External_ID__c, Name,RecordTypeId, RecordType.Name, HCSC_Division__c, 
                    Expected_Health_Members__c, Expected_Health_Contracts__c, 
                      Expected_Dental_Members__c, Expected_Dental_Contracts__c,
                      AccountId 
            FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
  }

  public void updateOpportunity(Opportunity opportunityObj) {
    update opportunityObj;
  }

  public List<Opportunity> getOpportunitiesForProduct360(Set<Id> oppIds) {

    return [Select Id, StageName, Name, Expected_Health_Members__c, Expected_Health_Contracts__c, Expected_Dental_Members__c, Expected_Dental_Contracts__c, RecordType.Name, (Select Id, Product__r.Non_Medical_Compensation__c, Name, Product_Stage__c, Category__c, Projected_Members__c, Projected_Contracts__c, Product__r.Name, Status__c, Product_Type__c, Win_Probability__c, Funding_Type__c, Premium_Type__c from Opportunity_Products__r) From Opportunity Where Id in :oppIds];
  }

  public void updateOpportunities(List<Opportunity> opportunities) {
    update opportunities;
  }

  public List<Opportunity> getOpportunitiesForCustomContractsCurrProds(Id acctId, Id productRecordTypeId) {

    return [SELECT Id, (SELECT Id, Product__c, Effective_Date__c, Product__r.Simplified_Product__c,
            Projected_Members__c, Funding_Type__c, Status__c
            FROM Opportunity_Products__r WHERE Product__r.NotSimple__c = false AND Product__r.RecordTypeId = :productRecordTypeId)
            FROM Opportunity WHERE AccountId = :acctId AND StageName = :Label.WonP AND Requested_Effective_Date__c <= :System.Today() ORDER BY Id];
  }

  public List<Opportunity> getOpportunitiesByParentAccount(Set<Id> parentIds){
    return [SELECT Id, Name, Weekly_Activity_Modified_Date__c, AccountId FROM Opportunity where AccountId in :parentIds];
  }

  public List<Opportunity> getOpportunitiesForCustomContractsActiveProds(Id acctId){

    return [Select Id, (Select Id, Name, Product__c, Funding_Type__c, Product__r.Simplified_Product__c, 
            Projected_Members__c From Opportunity_Products__r)                    
            From Opportunity Where AccountId = :acctId And IsClosed = false
            Limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];
    }
}