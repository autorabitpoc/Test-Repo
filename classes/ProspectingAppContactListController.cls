public with sharing class ProspectingAppContactListController {
	@AuraEnabled
    public static Contact queryContactAccountsInfo(Id contactId) {
    	return ProspectingAppUtilityClass.queryContactRelatedAccountsInfo(contactId);
    } 
    
    @AuraEnabled
    public static List<Contact> getAccountContacts(Account curAccount) {
        return ProspectingAppUtilityClass.getAccountContacts(curAccount);
    }
    
    //<!-- SFDC-4497 - 06/2017 - SHUYLER - Begin -->
    @AuraEnabled
    public static Contact queryContactDetailsInfo(Id contactId){
        return ProspectingAppUtilityClass.queryContactInfo(contactId);
    }
    //<!-- SFDC-4497 - 06/2017 - SHUYLER - End   -->
}