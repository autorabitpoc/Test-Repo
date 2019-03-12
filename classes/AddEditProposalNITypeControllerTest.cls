@isTest
private class AddEditProposalNITypeControllerTest {

	@isTest
	static void testAddDeleteSave() {
		Test.startTest();
		PageReference pageRef = Page.AddEditProposalNIType;
		Test.setCurrentPage(pageRef);
		Case case1 = new Case();
		case1.Subject = 'Test Case';
		insert case1;
		Request_Type__c rtc = new Request_Type__c();
        rtc.Proposal_NI_Type__c = 'Service Area';
        rtc.number_of_requests__c = 11;
        rtc.Case__c = case1.id;
        insert rtc;
		AddEditProposalNITypeController ctrl = new AddEditProposalNITypeController(new ApexPages.StandardController(case1));
		ApexPages.currentPage().getParameters().put('cases', 'case1');
		pageref.getParameters().put('id', case1.Id);

		Id caseID = ApexPages.currentPage().getParameters().get('id');
		ApexPages.currentPage().getParameters().put('rowIndex', '0');

		Integer wrapperSize = ctrl.proposalNIWrappers.size();
		wrapperSize = ctrl.proposalNIWrappers.size();
		ctrl.save();
		List<Request_Type__c> rtList = [SELECT id  FROM Request_Type__c WHERE Case__c = : caseID];

		//system.assertEquals(rtList.size(), 1);
		Test.stopTest();
	}
}