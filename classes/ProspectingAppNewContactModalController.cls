public with sharing class ProspectingAppNewContactModalController {
	@AuraEnabled
    public static void saveNewContact(Contact newCon) {
        upsert newCon;
    }
    
    @AuraEnabled
    public static List<RecordType> querySobjectRecordtypes(String sobjectName) {
        return ProspectingAppUtilityClass.querySobjectRecordtypes(sobjectName);
    }
}