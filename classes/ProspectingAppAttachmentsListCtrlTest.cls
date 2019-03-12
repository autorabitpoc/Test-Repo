@isTest
private class ProspectingAppAttachmentsListCtrlTest {
	@testSetup
    static void setupData() {
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        List<Attachment> atts = new List<Attachment>();
        
        Attachment testAttachment = new Attachment();
        testAttachment.Body = Blob.valueOf('Body of a png file');
        testAttachment.Name = 'logo.png';
        testAttachment.ContentType = 'image/png';
        testAttachment.parentId = acc.id;
        atts.add(testAttachment);
        
        Attachment testAttachment2 = new Attachment();
        testAttachment2.Body = Blob.valueOf('Body of a png file');
        testAttachment2.Name = 'logo.png';
        testAttachment2.ContentType = 'image/png';
        testAttachment2.parentId = acc.id;
        atts.add(testAttachment2);
        
        insert atts;
    }
    
    static testMethod void validateQueryAccountAttachments() {
        Account acc = [SELECT Id FROM Account WHERE Name='Test Account'];
        
        List<Attachment> atts = ProspectingAppAttachmentsListController.queryAccountAttachments(acc);
        System.assert(atts.size()==2);
    }
}