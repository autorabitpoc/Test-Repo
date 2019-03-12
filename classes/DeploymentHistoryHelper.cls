public class DeploymentHistoryHelper{
    
	public static void createRecordEntry(String buildName){
		Deployment_History__c newRec = new Deployment_History__c();
		newRec.Build_Name__c = buildName;
		insert newRec;
	}
}