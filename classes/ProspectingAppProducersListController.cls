public with sharing class ProspectingAppProducersListController {
	@AuraEnabled
    public static List<Producer_Group_Association__c> queryAccountProdGroupAssocList(Account curAccount) {
        return ProspectingAppUtilityClass.queryAccountProdGroupAssocList(curAccount);
    }
}