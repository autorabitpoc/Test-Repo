@isTest
private class ProspectingAppNoteDetailsCtrlTest {
	@testSetup static void setupNote() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Note testNote = new Note();
        testNote.Body = 'Test Body';
        testNote.Title = 'ProspectingAppNewNote';
        testNote.ParentId = testAccount.Id;
        
        insert testNote;
    }
    
    static testMethod void validateUpdateNote() {
        Note testNote = [SELECT Id, Body, Title, ParentId FROM Note WHERE Title='ProspectingAppNewNote'];       
        System.assertEquals('Test Body', testNote.Body);
        testNote.Body = 'Test Body Modified';        
        ProspectingAppNoteDetailsController.updateNote(testNote);
        testNote = [SELECT Id, Body, Title, ParentId FROM Note WHERE Title='ProspectingAppNewNote'];
        System.assertEquals('Test Body Modified', testNote.Body);      
    }
}