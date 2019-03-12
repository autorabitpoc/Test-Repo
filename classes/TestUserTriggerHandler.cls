/*
    @Description : This is an test class for UserTriggerHandler
    @author      : Deloitte
    @date        : 10/16/2015
	@updated	 : 6/6/2016
*/
@isTest
public with sharing class TestUserTriggerHandler {

	static testMethod void updateContactTest() {
		Account acc = TestClassUtiltity.CreateAccountRecord('test');
		RecordType rt = [select Id from RecordType where SobjectType = 'Contact' and DeveloperName = :ConstantsController.ContactRecordType][0];
		Contact con = new Contact();
		con.LastName = 'Test';
		con.AccountId = acc.Id;
		con.External_ID__c = '124';
		con.RecordTypeId = rt.Id;
		insert con;
		Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
		User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
		testUser = [select EmployeeNumber from User where Id = :testUser.Id][0];
		testUser.EmployeeNumber = '124';
		update testUser;
		List<PermissionSet> superUserPermissionSet = [SELECT Id, Name, PermissionsModifyAllData FROM PermissionSet WHERE Name = :System.Label.Super_User_Permissions LIMIT 1];
		System.assertEquals(superUserPermissionSet.size(), 1);
		testUser.EmployeeNumber = '125';
		update testUser;

		testUser.EmployeeNumber = '124';
		update testUser;
	}

	static testMethod void assignPermissionSetsOnInsertTest() {
		String superUserLabel = System.Label.Super_User_Permissions;
		String strategicPlanLabel = System.Label.PermissionSetCanApproveStrategicPlans;
		List<PermissionSet> permSets = [SELECT Id FROM PermissionSet WHERE Name = :superUserLabel OR Name = :strategicPlanLabel];

		Profile anyProfile = [SELECT Id FROM Profile LIMIT 1];
		User newUser = new User(Alias = 'test', Email = 'TestUsername@uniqueexample.com', EmailEncodingKey = 'UTF-8', LastName = 'Test Lastname', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = anyProfile.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'TestUsername@uniqueexample.com');
		newUser.Is_Super_User__c = true;
		newUser.Can_Approve_Strategic_Plans__c = true;
		insert newUser;
		List<PermissionSetAssignment> psAsg = [SELECT Id, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = : newUser.Id];
		Map<Id, PermissionSetAssignment> psAsgMap = new Map<Id, PermissionSetAssignment>();
		for (PermissionSetAssignment psa : psAsg) {
			psAsgMap.put(psa.PermissionSetId, psa);
		}
		for (PermissionSet ps : permSets) {
			System.assert(psAsgMap.containsKey(ps.Id));
		}
	}

	static testMethod void assignPermissionSetsOnUpdateTest() {
		String superUserLabel = System.Label.Super_User_Permissions;
		String strategicPlanLabel = System.Label.PermissionSetCanApproveStrategicPlans;
		List<PermissionSet> permSets = [SELECT Id FROM PermissionSet WHERE Name = :superUserLabel OR Name = :strategicPlanLabel];

		Profile anyProfile = [SELECT Id FROM Profile LIMIT 1];
		User newUser = new User(Alias = 'test', Email = 'TestUsername@uniqueexample.com', EmailEncodingKey = 'UTF-8', LastName = 'Test Lastname', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = anyProfile.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'TestUsername@uniqueexample.com');
		newUser.Is_Super_User__c = false;
		newUser.Can_Approve_Strategic_Plans__c = false;
		insert newUser;

		List<PermissionSetAssignment> psAsgIns = [SELECT Id, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = : newUser.Id];
		Map<Id, PermissionSetAssignment> psAsgMapIns = new Map<Id, PermissionSetAssignment>();
		for (PermissionSetAssignment psa : psAsgIns) {
			psAsgMapIns.put(psa.PermissionSetId, psa);
		}
		for (PermissionSet ps : permSets) {
			System.assert(!psAsgMapIns.containsKey(ps.Id));
		}

		newUser.Is_Super_User__c = true;
		newUser.Can_Approve_Strategic_Plans__c = true;
		update newUser;

		List<PermissionSetAssignment> psAsgUpd = [SELECT Id, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = : newUser.Id];
		Map<Id, PermissionSetAssignment> psAsgMapUpd = new Map<Id, PermissionSetAssignment>();
		for (PermissionSetAssignment psa : psAsgUpd) {
			psAsgMapUpd.put(psa.PermissionSetId, psa);
		}
		for (PermissionSet ps : permSets) {
			System.assert(psAsgMapUpd.containsKey(ps.Id));
		}
	}

	static testMethod void unassignPermissionSetsOnUpdateTest() {
		String superUserLabel = System.Label.Super_User_Permissions;
		String strategicPlanLabel = System.Label.PermissionSetCanApproveStrategicPlans;
		List<PermissionSet> permSets = [SELECT Id FROM PermissionSet WHERE Name = :superUserLabel OR Name = :strategicPlanLabel];

		Profile anyProfile = [SELECT Id FROM Profile LIMIT 1];
		User newUser = new User(Alias = 'test', Email = 'TestUsername@uniqueexample.com', EmailEncodingKey = 'UTF-8', LastName = 'Test Lastname', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = anyProfile.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'TestUsername@uniqueexample.com');
		newUser.Is_Super_User__c = true;
		newUser.Can_Approve_Strategic_Plans__c = true;
		insert newUser;

		List<PermissionSetAssignment> psAsgIns = [SELECT Id, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = : newUser.Id];
		Map<Id, PermissionSetAssignment> psAsgMapIns = new Map<Id, PermissionSetAssignment>();
		for (PermissionSetAssignment psa : psAsgIns) {
			psAsgMapIns.put(psa.PermissionSetId, psa);
		}
		for (PermissionSet ps : permSets) {
			System.assert(psAsgMapIns.containsKey(ps.Id));
		}

		newUser.Is_Super_User__c = false;
		newUser.Can_Approve_Strategic_Plans__c = false;
		update newUser;

		List<PermissionSetAssignment> psAsgUpd = [SELECT Id, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = : newUser.Id];
		Map<Id, PermissionSetAssignment> psAsgMapUpd = new Map<Id, PermissionSetAssignment>();
		for (PermissionSetAssignment psa : psAsgUpd) {
			psAsgMapUpd.put(psa.PermissionSetId, psa);
		}
		for (PermissionSet ps : permSets) {
			System.assert(!psAsgMapUpd.containsKey(ps.Id));
		}
	}
}