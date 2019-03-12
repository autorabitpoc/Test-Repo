@isTest
private class ProspectingAppTaskDetailsCtrlTest {
    @testSetup 
    static void setupTask() {
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
    
	static testMethod void validateGetPicklistValues() {
        List<String> taskStatusList = ProspectingAppTaskDetailsController.getPicklistValues('Task', 'Status');
        
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
    
    static testMethod void validateUpdateTask() {
        Task testTask = [SELECT Id, Status FROM Task WHERE Subject='ProspectingAppNewTask'];
        String origStatus = testTask.Status;
        
        testTask.Status = 'In Progress';
        ProspectingAppTaskDetailsController.updateTask(testTask);
        
        testTask = [SELECT Id, Status FROM Task WHERE Subject='ProspectingAppNewTask'];
        System.assertNotEquals(origStatus, testTask.Status);
    }
}