@isTest
private class ProspectingAppNewNotesTasksCtrlTest {   
    @testSetup static void setupNote() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Note testNote = new Note();
        testNote.Body = 'Test Body';
        testNote.Title = 'ProspectingAppNewNote';
        testNote.ParentId = testAccount.Id;
        
        insert testNote;
    }
    
    @testSetup static void setupTask() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Task testTask = new Task();
        
        /* had to updated Field Security to allow System Admin to View in order to access */
        /* the Category__c and Sub_Category__c custom Activity Fields.  Without the       */
        /* change the Error 'INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST, bad value for       */
        /* restricted picklist field' was encountered.  Also had to update the  Field     */
        /* dependency for Sub_Category__c to allow for Category = "Other" to map to       */
        /* Sub Category = "Other".                                                        */
        testTask.Category__c = 'Other';
        testTask.Sub_Category__c = 'Other';
        
        
        testTask.Priority = 'High';
        testTask.Status = 'Completed';
        testTask.Subject = 'ProspectingAppNewTask';
        testTask.WhatId = testAccount.Id;
        
        insert testTask;
    }
    
    static testMethod void validateSaveNote() {
        Note testNote = [SELECT Id, Body, Title, ParentId FROM Note WHERE Title='ProspectingAppNewNote'];       
        System.assertEquals('Test Body', testNote.Body);
        testNote.Body = 'Test Body Modified';        
        ProspectingAppNewNotesTasksController.saveNote(testNote);
        testNote = [SELECT Id, Body, Title, ParentId FROM Note WHERE Title='ProspectingAppNewNote'];
        System.assertEquals('Test Body Modified', testNote.Body);      
    }
    
    static testMethod void validateSaveTask() {
        Task testTask = [SELECT Id, Priority, Status, Subject, WhatId FROM Task WHERE Subject='ProspectingAppNewTask'];       
        System.assertEquals('Completed', testTask.Status);
        testTask.Status = 'In Progress';        
        ProspectingAppNewNotesTasksController.saveTask(testTask);
        testTask = [SELECT Id, Priority, Status, Subject, WhatId FROM Task WHERE Subject='ProspectingAppNewTask'];
        System.assertEquals('In Progress', testTask.Status);      
    }
    
    static testMethod void validateGetPicklistValues() {
        List<String> taskStatusList = ProspectingAppNewNotesTasksController.getPicklistValues('Task', 'Status');
        
        Set<String> taskStatusSet = new Set<String>();
        Schema.DescribeFieldResult fieldResult = Task.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple)
        {
            taskStatusSet.add(f.getValue());
        } 
        
        for(String status : taskStatusList) {
            System.assertEquals(true, taskStatusSet.contains(status));
        }
    }
}