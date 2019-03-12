/**************************************************************************************
  Apex Class Name     : ContactListCreationControllerTest
  Version             : 1.0
  Function            : This is a test class for the ContactListCreationController class
* Developer                        Date                  
* ----------------------------------------------------------------------------                 
* Nick Serafin/Slalom             5/11/2016
*************************************************************************************/
@isTest
private class ContactListCreationControllerTest {

	@isTest static void selectedContactsTest() {

		Account TestAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');

		Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
		User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');

		List<AccountTeamMember> accTeamMember = TestClassUtiltity.createAccTeamMember(TestAcnt.Id, testUser.Id);
		insert accTeamMember;

		Contact newContact = new Contact(AccountId = TestAcnt.Id, Fax = '1234567', FirstName = 'Test', LastName = 'Test');
		newContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal Contact').getRecordTypeId();
		insert newContact;

		Account_Team_Non_SF__c accTeamMemberNonSF = new Account_Team_Non_SF__c(Account_Name__c = TestAcnt.Id, Team_Member_Name__c = newContact.Id, Member_Role__c = 'Account Executive');
		insert accTeamMemberNonSF;

		APXTConga4__Conga_Template__c template = new APXTConga4__Conga_Template__c(APXTConga4__Name__c = 'ContactList');
		insert template;

		APXTConga4__Conga_Merge_Query__c query = new APXTConga4__Conga_Merge_Query__c(APXTConga4__Name__c = 'AccountTeam');
		insert query;

		APXTConga4__Conga_Merge_Query__c query2 = new APXTConga4__Conga_Merge_Query__c(APXTConga4__Name__c = 'AccountTeamNonSF');
		insert query2;

		PageReference pageRef = new PageReference('/apex/ContactListCreation');
		pageRef.getParameters().put('Id', TestAcnt.Id);
		Test.setCurrentPage(pageRef);

		Test.startTest();

		ApexPages.StandardController sc2 = new ApexPages.StandardController(TestAcnt);
		ContactListCreationController contactController = new ContactListCreationController(sc2);
		System.assertEquals(contactController.listOfAccountTeamMembers.size(), 1);
		System.assertEquals(contactController.listOfAccountTeamNonSFMembers.size(), 1);

		contactController.listOfAccountTeamMembers.get(0).isSelected = true;
		contactController.listOfAccountTeamNonSFMembers.get(0).isSelected = true;
		contactController.sendContactsToConga();
		System.assertEquals(contactController.accountTeamMemberIds.size(), 1);
		System.assertEquals(contactController.accountTeamNonSFMemberIds.size(), 1);

		contactController.listOfAccountTeamMembers.get(0).isSelected = true;
		contactController.listOfAccountTeamNonSFMembers.get(0).isSelected = false;
		contactController.sendContactsToConga();
		System.assertEquals(contactController.accountTeamMemberIds.size(), 1);
		System.assertEquals(contactController.accountTeamNonSFMemberIds.size(), 0);

		contactController.listOfAccountTeamMembers.get(0).isSelected = false;
		contactController.listOfAccountTeamNonSFMembers.get(0).isSelected = true;
		contactController.sendContactsToConga();
		System.assertEquals(contactController.accountTeamMemberIds.size(), 0);
		System.assertEquals(contactController.accountTeamNonSFMemberIds.size(), 1);

		contactController.listOfAccountTeamMembers.get(0).isSelected = false;
		contactController.listOfAccountTeamNonSFMembers.get(0).isSelected = false;
		contactController.sendContactsToConga();
		System.assertEquals(contactController.accountTeamMemberIds.size(), 0);
		System.assertEquals(contactController.accountTeamNonSFMemberIds.size(), 0);

		contactController.backToAccount();

		Test.stopTest();
	}
}