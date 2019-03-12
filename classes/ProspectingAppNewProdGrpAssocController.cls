public with sharing class ProspectingAppNewProdGrpAssocController {
	@AuraEnabled
    public static void saveProdGroupAssoc(Producer_Group_Association__c newProdGrpAssoc) {
        upsert newProdGrpAssoc;
    }
}