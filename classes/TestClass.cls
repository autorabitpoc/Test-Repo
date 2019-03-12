public class TestClass {
    @AuraEnabled
    public static Opportunity TestClass(String oppId){
       
       List<opportunity> lstopp = [SELECT Id,AccountId,name,Rating_Status__c,sgrAccountHoldReason__c,SGR_Workflow_Activity__c,Has_Notes__c,RecordType.Name,HCSC_Division__c,Account_Market_Segment__c,External_Id__c,Current_Tier_Billing__c,SGR_Opportunity_Auto_Number__c,Renewal_Date__c,Batch_Id__c,Funding_Type__c FROM opportunity where id =:oppId];
       return lstopp[0];

}
}