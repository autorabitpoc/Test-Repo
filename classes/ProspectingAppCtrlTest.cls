@isTest
private class ProspectingAppCtrlTest {
    static testMethod void validateQueryRecord() {
        Account compAcc = new Account();
        compAcc.Name = 'Test Competitor Account';
        compAcc.RecordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName='Vendor' AND SobjectType='Account'].Id;
        insert compAcc;
        
        Account prodAcc = new Account();
        prodAcc.Name = 'Test Producer Account';
        prodAcc.RecordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName='Producer_Account' AND SobjectType='Account'].Id;
        insert prodAcc;
        
        Account testAcc = new Account();
        testAcc.Name = 'Test Account';
        testAcc.Total_Num_of_Potential_Subscribers__c = 100;
        testAcc.Status__c = 'Active';
        testAcc.RecordTypeId = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName='Group_Account' AND SobjectType='Account'].Id;
        insert testAcc;
        
        List<Attachment> atts = new List<Attachment>();
        Attachment att1 = new Attachment();
        att1.Body = Blob.valueOf('Body of a png file');
        att1.Name='logo.png';
        att1.ContentType = 'image/png';
        att1.parentId = testAcc.Id;
        att1.CreatedDate = System.today();
        atts.add(att1);
        Attachment att2 = new Attachment();
        att2.Body = Blob.valueOf('Body of a png file');
        att2.Name='logo2.png';
        att2.ContentType = 'image/png';
        att2.parentId = testAcc.Id;
        att2.CreatedDate = System.today()-1;
        atts.add(att2);
        insert atts;
        
        List<Contact> cons = new List<Contact>();
        Contact con1 = new Contact();
        con1.LastName = 'Almond';
        con1.AccountId = testAcc.Id;
        cons.add(con1);
        Contact con2 = new Contact();
        con2.LastName = 'Bratwurst';
        con2.AccountId = testAcc.Id;
        cons.add(con2);
        insert cons;
        
        List<Note> notes = new List<Note>();
        Note note1 = new Note();
        note1.Title = 'Test Title 1';
        note1.CreatedDate = System.today();
        note1.ParentId = testAcc.Id;
        notes.add(note1);
        Note note2 = new Note();
        note2.Title = 'Test Title 2';
        note2.CreatedDate = System.today()-1;
        note2.ParentId = testAcc.Id;
        notes.add(note2);
        insert notes;
        
        List<Task> tasks = new List<Task>();
        Task task1 = new Task();
        
        /* had to updated Field Security to allow System Admin to View in order to access */
        /* the Category__c and Sub_Category__c custom Activity Fields.  Without the       */
        /* change the Error 'INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST, bad value for       */
        /* restricted picklist field' was encountered.  Also had to update the  Field     */
        /* dependency for Sub_Category__c to allow for Category = "Other" to map to       */
        /* Sub Category = "Other".                                                        */
        
        task1.Category__c = 'Other';
        task1.Sub_Category__c = 'Other';
        
        task1.Subject = 'Subject 1';
        task1.CreatedDate = System.today();
        task1.WhatId = testAcc.Id;
        tasks.add(task1);
        Task task2 = new Task();
        
        task2.Category__c = 'Other';
        task2.Sub_Category__c = 'Other';
        
        task2.Subject = 'Subject 2';
        task2.CreatedDate = System.today()-1;
        task2.WhatId = testAcc.Id;
        tasks.add(task2);
        insert tasks;
        
        List<Competitor_Relationship__c> compRels = new List<Competitor_Relationship__c>();
        Competitor_Relationship__c compRel1 = new Competitor_Relationship__c();
        compRel1.Competitor_Account__c = compAcc.Id;
        compRel1.Group_Account__c = testAcc.Id;
        compRel1.Total_Members__c = 100;
        compRels.add(compRel1);
        Competitor_Relationship__c compRel2 = new Competitor_Relationship__c();
        compRel2.Competitor_Account__c = compAcc.Id;
        compRel2.Group_Account__c = testAcc.Id;
        compRel2.Total_Members__c = 100;
        compRels.add(compRel2);
        insert compRels;
        
        List<Producer_Group_Association__c> prodGroups = new List<Producer_Group_Association__c>();
        Producer_Group_Association__c prodGroup1 = new Producer_Group_Association__c();
        prodGroup1.Producer_Account__c = prodAcc.Id;
        prodGroup1.Group_Account__c = testAcc.Id;
        prodGroups.add(prodGroup1);
        Producer_Group_Association__c prodGroup2 = new Producer_Group_Association__c();
        prodGroup2.Producer_Account__c = prodAcc.Id;
        prodGroup2.Group_Account__c = testAcc.Id;
        prodGroups.add(prodGroup2);
        insert prodGroups;
        
        Account queriedAcc = (Account)ProspectingAppController.queryRecord('Account', testAcc.Id);
        System.assertEquals(testAcc.Id, queriedAcc.Id);
        
        queriedAcc = (Account)ProspectingAppController.queryRecord('Case', testAcc.Id);
        System.assertEquals(null, queriedAcc);
    }
    
    static testMethod void validateIsLightningProfile() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
        system.runAs(testUser) {
            
        }
        
        
        
    }
}