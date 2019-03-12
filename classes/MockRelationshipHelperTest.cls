@IsTest
private class MockRelationshipHelperTest {

	@IsTest
	private static void testWithDb()
	{
		// Create records
		Account acct = new Account( 
			Name = 'Master #1');
		insert acct;
		List<Contact> contacts = new List<Contact> {
			new Contact ( 
				FirstName = 'Child', 
				LastName = '#1', 
				AccountId = acct.Id),
			new Contact ( 
				FirstName = 'Child', 
				LastName = '#2', 
				AccountId = acct.Id) };
		insert contacts;

		// Query records
		List<Account> accounts = 
			[select Id, Name, 
				(select Id, FirstName, LastName, AccountId from Contacts) from Account];

		// Assert result set
		assertRecords(acct.Id, contacts[0].Id, contacts[1].Id, accounts);
	}

	@IsTest
	private static void testWithoutDb()
	{
		// Create records
		Account acct = new Account( 
			Id = MockRelationshipHelper.Id.generate(Account.SObjectType), 
			Name = 'Master #1');
		List<Contact> contacts = new List<Contact> {
			new Contact ( 
				Id = MockRelationshipHelper.Id.generate(Contact.SObjectType), 
				FirstName = 'Child', 
				LastName = '#1', 
				AccountId = acct.Id),
			new Contact ( 
				Id = MockRelationshipHelper.Id.generate(Contact.SObjectType), 
				FirstName = 'Child', 
				LastName = '#2', 
				AccountId = acct.Id) };

		// Mock query records
		List<Account> accounts = (List<Account>) 
			MockRelationshipHelper.makeRelationship(
				List<Account>.class,
				new List<Account> { acct }, 
				Contact.AccountId,
				new List<List<Contact>> { contacts });			

		// Assert result set
		assertRecords(acct.Id, contacts[0].Id, contacts[1].Id, accounts);
	}

	private static void assertRecords(Id parentId, Id childId1, Id childId2, List<Account> masters)
	{
		System.assertEquals(Account.SObjectType, masters.getSObjectType());
		System.assertEquals(Account.SObjectType, masters[0].getSObjectType());
		System.assertEquals(1, masters.size());
		System.assertEquals(parentId, masters[0].Id);
		System.assertEquals('Master #1', masters[0].Name);
		System.assertEquals(2, masters[0].Contacts.size());
		System.assertEquals(childId1, masters[0].Contacts[0].Id);
		System.assertEquals(parentId, masters[0].Contacts[0].AccountId);
		System.assertEquals('Child', masters[0].Contacts[0].FirstName);
		System.assertEquals('#1', masters[0].Contacts[0].LastName);
		System.assertEquals(childId2, masters[0].Contacts[1].Id);
		System.assertEquals(parentId, masters[0].Contacts[1].AccountId);
		System.assertEquals('Child', masters[0].Contacts[1].FirstName);		
		System.assertEquals('#2', masters[0].Contacts[1].LastName);
	}
}