@isTest
private class ProspectingAppNewCompVendModalCtrlTest {
    static testMethod void validateSaveCompVendRelationship() {
        Competitor_Relationship__c compVendRel = new Competitor_Relationship__c();
        compVendRel.Total_Members__c = 123;
        
        ProspectingAppNewCompVendModalController.saveCompVendRelationship(compVendRel);
        System.assertNotEquals(null, compVendRel.Id);
    }
    
    static testMethod void validateGetPicklistValues() {
        List<String> compVendStatusList = ProspectingAppNewCompVendModalController.getPicklistValues('Competitor_Relationship__c', 'Status__c');
        
        Set<String> compVendStatusSet = new Set<String>();
        Schema.DescribeFieldResult fieldResult = Competitor_Relationship__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple)
        {
            compVendStatusSet.add(f.getValue());
        } 
        
        for(String status : compVendStatusList) {
            System.assertEquals(true, compVendStatusSet.contains(status));
        }
    }
}