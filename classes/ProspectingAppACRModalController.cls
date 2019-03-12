public with sharing class ProspectingAppACRModalController {
	@AuraEnabled
    public static List<String> getPicklistValues(String ObjectApi_name, String Field_name) {
    	return ProspectingAppUtilityClass.getPicklistValues(ObjectApi_name, Field_name);
    }
    
    @AuraEnabled
    public static void upsertAccountContactRelation(Id contactId, Id accountId, String role) {
        AccountContactRelation newACR = new AccountContactRelation();
        newACR.AccountId = accountId;
        newACR.ContactId = contactId;
        newACR.Roles = role;

        upsert newACR;
    }
}