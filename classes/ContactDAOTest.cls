/**************************************************************************************
  Apex Class Name     : ContactDAOTest
  Version             : 1.0
  Function            : This is a test class for ContactDAO.
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------
* Alec Klein				6/8/2016
*************************************************************************************/
@isTest(SeeAllData = false)
public class ContactDAOTest {
	@isTest static void getContactsWithAssociatedUsersTest() {
		Set<String> associatedUsers = new Set<String>();
		Map<String, User> employeeUsers = new Map<String, User>();
		RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' LIMIT 1];
		Profile p = [SELECT Id FROM Profile LIMIT 1];
		User u = new User(Alias = 'test', Email = 'uniqueUsername@testemail.com', EmailEncodingKey = 'UTF-8', LastName = 'Last Name', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'uniqueUsername@testemail.com');
		u.EmployeeNumber = 'TestEmployeeNumber';
		insert u;
		associatedUsers.add(u.Id);

		Account a = TestClassUtiltity.CreateAccountRecord('Test Account');
		Contact newContact = new Contact(AccountId = a.Id, Fax = '1234567', Phone = '(000) 000-0000-000', FirstName = 'FirstName', LastName = 'LastName');
		newContact.Associated_User__c = u.Id;
		newContact.RecordTypeId = rt.Id;
		insert newContact;

		ContactDAO.IContactDAO contactDAOInstance = new ContactDAO();
		List<Contact> associatedContacts = contactDAOInstance.getContactsWithAssociatedUsers(associatedUsers, employeeUsers, rt.Id);
		System.assert(associatedContacts.size() > 0);
	}

	@isTest static void updateContactsTest() {
		Account a = TestClassUtiltity.CreateAccountRecord('Test Account');
		Contact newContact = new Contact(AccountId = a.Id, Phone = '(000) 000-0000-000', Fax = '1234567', FirstName = 'FirstName', LastName = 'LastName');
		insert newContact;
		Contact updateContact = [SELECT Id, Firstname FROM Contact WHERE Id = : newContact.Id];
		updateContact.Firstname = 'Updated';
		ContactDAO.IContactDAO contactDAOInstance = new ContactDAO();
		contactDAOInstance.updateContacts(new List<Contact> {updateContact});
		Contact finalContact = [SELECT Id, Firstname FROM Contact WHERE Id = : newContact.Id];
		System.assertEquals(finalContact.Firstname, 'Updated');
	}

	@isTest
	static void contactDAOComplexityScoreTest() {
		Test.startTest();

		Id groupContactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get( Label.Group_Contact ).getRecordTypeId();
		Id groupAccRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId();
		ContactDAO.IContactDAO contactDAOInstance = new ContactDAO();

		Account testAcnt = TestClassUtiltity.createAccountWithRecType('TestAccount', groupAccRecId);
		Map<Id, Account> accountMap = new Map<Id, Account>();
        accountMap.put(testAcnt.id, testAcnt);

		Contact testContact = new Contact(accountId = testAcnt.id, Phone = '(000) 000-0000-000', LastName = 'Smith', Type__c = 'Primary' );
		insert testContact;

		List<Contact> primaryContacts = contactDAOInstance.getPrimaryGroupContacts( accountMap, groupContactRecordType );
		System.assert(!primaryContacts.isEmpty());

		Test.stopTest();
	}
	@isTest
	static void getContactsByIDTest() {
		List<Id> ids = new List<Id>();

		Account a = TestClassUtiltity.CreateAccountRecord('Test Account');
		Contact newContact = new Contact(AccountId = a.Id, Fax = '1234567', FirstName = 'FirstName', LastName = 'LastName');
		
		insert newContact;

		ids.add(newContact.Id);

		ContactDAO.IContactDAO contactDAOInstance = new ContactDAO();
		List<Contact> contacts = contactDAOInstance.getContactsById(ids);

		System.assertEquals(contacts[0].id,newContact.Id);

	}
}