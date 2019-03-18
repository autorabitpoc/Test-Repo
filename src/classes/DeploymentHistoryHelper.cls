public class DeploymentHistoryHelper{
    
	public static void createRecordEntry(String buildName){
		System.debug('Enter DeploymentHistoryHelper');
		Deployment_History__c newRec = new Deployment_History__c();
		newRec.Build_Name__c = buildName;
		insert newRec;
		System.debug('newRec inserted = ' + newRec);
	}
}