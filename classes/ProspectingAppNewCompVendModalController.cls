public with sharing class ProspectingAppNewCompVendModalController {
    @AuraEnabled
    public static List<String> getPicklistValues(String ObjectApi_name, String Field_name) {
    	return ProspectingAppUtilityClass.getPicklistValues(ObjectApi_name, Field_name);    
    }
    
    @AuraEnabled
    public static void saveCompVendRelationship(Competitor_Relationship__c compVendRel) {
        upsert compVendRel;
    }
}