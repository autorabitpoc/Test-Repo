@isTest
private class ProspectingAppNewContactModalCtrlTest {
    static testMethod void validateSaveNewContact() {
        Contact newCon = new Contact(LastName='Test');
        ProspectingAppNewContactModalController.saveNewContact(newCon);
        System.assertNotEquals(null, newCon.Id);
    }
    
    static testMethod void validatequerySobjectRecordtypes() {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Contact; 
        Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();

        List<RecordType> contactRecordTypes = ProspectingAppNewContactModalController.querySobjectRecordtypes('Contact');
        
        for(RecordType contactRT : contactRecordTypes) {
            System.assert(rtMapById.containsKey(contactRT.Id));
        }
    }
}