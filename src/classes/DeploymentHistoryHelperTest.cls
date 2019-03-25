@IsTest
public class DeploymentHistoryHelperTest{
    
	@IsTest
	static void testCreateRecordEntry(){
		System.debug('Enter testt method');
		Test.startTest();
		DeploymentHistoryHelper.createRecordEntry('dummyRec');
		Test.stopTest();
		System.assertEquals(1, [SELECT COUNT() FROM Deployment_History__c WHERE Build_Name__c = 'dummyRec']);
	}
}
