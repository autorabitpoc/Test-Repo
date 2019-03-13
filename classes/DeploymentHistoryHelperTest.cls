@IsTest
public class DeploymentHistoryHelperTest{
    
	@IsTest
	static void testCreateRecordEntry(){
		System.debug('Enter test method');
		Test.startTest();
		DeploymentHistoryHelper.createRecordEntry('dummyRec');
		Test.stopTest();
		System.assertEquals(97, [SELECT COUNT() FROM Deployment_History__c WHERE Build_Name__c = 'dummyRec']);
	}
}