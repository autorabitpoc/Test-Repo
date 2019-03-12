@isTest
private class RequestTypeTriggerHandlerTest {

	@isTest static void setCaseNITypeSelectionsTest(){
		Account acc = TestClassUtiltity.CreateAccountRecord('TestAccount');
		Id networkInformationRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.CaseRecordTypeNetworkInformation).getRecordTypeId();

		Case networkInformationCase = new Case(AccountId = acc.Id, Provider_Groups__c = 'Test');
		networkInformationCase.RecordTypeId = networkInformationRecordTypeId;
		insert networkInformationCase;

		Request_Type__c rt = new Request_Type__c(Case__c = networkInformationCase.Id);
		rt.Proposal_NI_Type__c = 'BCBSA';
		insert rt;

		networkInformationCase = [SELECT Id, NI_Type__c FROM Case WHERE Id =: networkInformationCase.Id];
		System.assert(networkInformationCase.NI_Type__c.contains('BCBSA'));
	}
	
}