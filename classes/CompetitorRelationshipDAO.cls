public class CompetitorRelationshipDAO implements ICompetitorRelationshipDAO
{
    public interface ICompetitorRelationshipDAO{
		 List<Competitor_Relationship__c> getActiveCompetitorRelationships(Map<Id, Account> groupAccounts);
    }

    public List<Competitor_Relationship__c> getActiveCompetitorRelationships(Map<Id, Account> groupAccounts){
        return [SELECT Group_Account__c, Status__c FROM Competitor_Relationship__c 
							WHERE Group_Account__c IN :groupAccounts.keySet() AND Status__c = :Label.Active];
    }
}