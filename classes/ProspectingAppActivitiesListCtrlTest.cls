@isTest
private class ProspectingAppActivitiesListCtrlTest {
    @testSetup 
    static void setupData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Note testNote = new Note();
        testNote.Body = 'Test Body';
        testNote.Title = 'ProspectingAppNewNote';
        testNote.ParentId = testAccount.Id;
        insert testNote;
        
        Task testTask = new Task();
        
        /* had to updated Field Security to allow System Admin to View in order to access */
        /* the Category__c and Sub_Category__c custom Activity Fields.  Without the       */
        /* change the Error 'INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST, bad value for       */
        /* restricted picklist field' was encountered.  Also had to update the  Field     */
        /* dependency for Sub_Category__c to allow for Category = "Other" to map to       */
        /* Sub Category = "Other".                                                        */
        
        testTask.Category__c = 'Other';
        testTask.Sub_Category__c = 'Other';
        
        testTask.Type = 'Account';       
        testTask.Priority = 'High';
        testTask.Status = 'Completed';
        testTask.Subject = 'ProspectingAppNewTask';
        testTask.OwnerId = UserInfo.getUserId();
        testTask.WhatId = testAccount.Id;
        insert testTask;
        
    }
    
    static testMethod void validateQueryAccountNotes() {
        Account testAccount = [SELECT Id FROM Account WHERE Name='Test Account'];
        
        List<Note> notes = ProspectingAppActivitiesListController.queryAccountNotes(testAccount);
        System.assert(notes.size()==1);
    }
    
    
    static testMethod void validateQueryAccounTasks() {
        Account testAccount = [SELECT Id FROM Account WHERE Name='Test Account'];
        
        List<Task> tasks = ProspectingAppActivitiesListController.queryAccountTasks(testAccount);
        System.assert(tasks.size()==1);
    }
    
}