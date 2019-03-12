@isTest
private class ProspectingAppUploadAttachmentCtrlTest {
    static testMethod void validateFileUpload() {
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        
        String dummyBase64String1 = 'TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlzIHNpbmd1bGFyIHBhc3Npb24gZnJvbSBvdGhlciBhbmltYWxzLCB3aGljaCBpcyBhIGx1c3Qgb2YgdGhlIG1pbmQsIHRoF0aWdhY';
        String dummyBase64String2 = 'mxlIGdlbmVyYXRpb24gb2Yga25vd2xlZGdlLCBleGNlZWRzIHRoZSBzaG9ydCB2ZWhlbWVuY2Ugb2YgYW55IGNhcm5hbCBwbGVhc3VyZS4=YXQgYnkgYSBwZXJzZXZlcmFuY2Ugb2YgZGVsaWdodCBpbiB0aGUgY29udGludWVkIG';
    
        Id fileId = ProspectingAppUploadAttachmentController.saveTheChunk(testAccount.Id, 'Test Attachment', dummyBase64String1, 'text', '');
        System.assertNotEquals(null, fileId);
        
        Attachment att = [SELECT Id, BodyLength FROM Attachment WHERE Id=:fileId];        
        ProspectingAppUploadAttachmentController.saveTheChunk(testAccount.Id, 'Test Attachment', dummyBase64String2, 'text', fileId);
        Attachment updatedAtt = [SELECT Id, BodyLength FROM Attachment WHERE Id=:fileId]; 
        System.assert(updatedAtt.BodyLength > att.BodyLength);
    }
}