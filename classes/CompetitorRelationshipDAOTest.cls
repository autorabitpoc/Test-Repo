@isTest(SeeAllData = false)
public class CompetitorRelationshipDAOTest { 

	@isTest
	static void competitorRelationshipDAOTest() {
		Test.StartTest();
		Id competitorAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get( 'Vendor' ).getRecordTypeId();
		Id groupAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get( 'Group Account' ).getRecordTypeId();

		CompetitorRelationshipDAO.ICompetitorRelationshipDAO competitorRelationshipDAOInstance = new CompetitorRelationshipDAO();
		
		Account compAcnt = TestClassUtiltity.CreateAccountWithRecType('TestAccount', competitorAccRecType );
		Account groupAcnt = TestClassUtiltity.CreateAccountWithRecType('TestAccount2', groupAccRecType );
		Competitor_Relationship__c compRelationship = new Competitor_Relationship__c(Status__c = 'Active', 	Total_Contracts__c = 50, Total_Members__c = 50);
		compRelationship.Competitor_Account__c = compAcnt.Id;
		compRelationship.Group_Account__c = groupAcnt.Id;
		insert compRelationship;

		Map<Id, Account> groupAccounts = new Map<Id, Account>();
		groupAccounts.put(groupAcnt.Id, groupAcnt);
		
		List<Competitor_Relationship__c> compRelationships = competitorRelationshipDAOInstance.getActiveCompetitorRelationships(groupAccounts);

		System.assertEquals(compRelationships.size(), 1);

		Test.StopTest();
	}
}