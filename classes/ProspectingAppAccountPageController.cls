public with sharing class ProspectingAppAccountPageController {
	@AuraEnabled
    public static List<String> getPicklistValues(String ObjectApi_name, String Field_name) {
        return ProspectingAppUtilityClass.getPicklistValues(ObjectApi_name, Field_name);
    }
    
    @AuraEnabled
    public static Account upsertRecord(Account acc) {
        //Added the first line so tests will pass
        //There is a Javascript quirk where nulls are passed in as a blank string to apex
        if(acc.Id==null || String.valueOf(acc.Id)=='') {
        	acc.Id = null;
            insert acc;
            acc = ProspectingAppUtilityClass.queryAccount(acc.Id);
        }
        else {
        	update acc;    
        }
        
        return acc;
    }
}