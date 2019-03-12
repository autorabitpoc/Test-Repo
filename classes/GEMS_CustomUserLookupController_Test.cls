@isTest
public class GEMS_CustomUserLookupController_Test {
    public static testmethod void testForAll() {
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = TestClassUtiltity.CreateUserRecord(profileRec.Id, 'test@user11.com', 'testUser', 'test@user.com');
        
        case case_parent = new Case();
        case_parent.GEMS_Peer_Review__c = testUser.Id;
        case_parent.status = 'New';
        case_parent.GEMS_Case_Effective_Date__c = system.today();
        case_parent.GEMS_Effective_Date__c = system.today();
        case_parent.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();        
        insert case_parent;
        
        case case_child = new Case();
        //case_child.GEMS_Peer_Review__c = testUser.Id;
        case_child.status = 'New';
        case_child.GEMS_Case_Effective_Date__c = system.today();
        case_child.GEMS_Effective_Date__c = system.today();
        case_child.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        case_child.parentId = case_parent.Id;
        insert case_child;
        
        System.currentPageReference().getParameters().put('id',case_parent.Id);
        GEMS_CustomUserLookupController customLookupController = new GEMS_CustomUserLookupController();        
        customLookupController.updateCase();
        customLookupController.getTextBox();
        customLookupController.getFormTag();
        customLookupController.getResults();
        customLookupController.searchString = 'test';
        customLookupController.Search();        
        //runSearch('');
        
    }
}