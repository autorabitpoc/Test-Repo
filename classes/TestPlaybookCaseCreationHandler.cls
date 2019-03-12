@isTest
private class TestPlaybookCaseCreationHandler {


   /* static testMethod void myUnitTest() {

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
         User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
         system.runAs(testUser){
            //crate Account
            List<Account> accList = new List<Account>();
            Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
            testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
            testAccount.status__c = 'Sold';
            testAccount.Fax = '1234567';
            update testAccount;
            
            Account acc = TestClassUtiltity.CreateAccountRecord('Test');
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
            acc.status__c = 'Sold';
            acc.Fax = '123456';
            update acc;
            
            Contact TestCon = TestClassUtiltity.CreateContactRecord(testAccount.id, 'TestFirstName', 'TestLastname', null);
            testCon.RecordTypeId =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal Contact').getRecordTypeId(); 
            update testCon;
            
            TestClassUtiltity.createPlaybookSettingsFields();
            

            
            list<Playbook__c> playBooks = TestClassUtiltity.createPlayBookRecords();
            insert playBooks;
            
            list<Stage__c> stages = TestClassUtiltity.createStageRecords(playBooks[0].Id);
            insert stages;
            
            list<Substage__c> substages = TestClassUtiltity.createSubStageRecords(stages[0].Id);
            insert substages;
            
            list<Task__c> tasks = TestClassUtiltity.createTaskSubStageRecords(substages[0].Id);
            tasks[0].Case_Record_Type__c = 'Custom Benefit/Service';
            tasks[1].Case_Record_Type__c = 'Proposal';
            insert tasks;
            
            list<Task__c> tasks2 = TestClassUtiltity.createTaskSubStageRecords(substages[0].Id);
            tasks2[0].Case_Record_Type__c = 'Cede';
            tasks2[1].Case_Record_Type__c = 'Custom Benefit/Service';
            insert tasks2;
            
            //create Opportunity records
            list<Opportunity> opportunities = new list<Opportunity> ();
            opportunities.add(new Opportunity(AccountId = testAccount.Id, Name = 'oppName 1', StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1)));
            opportunities.add(new Opportunity(AccountId = testAccount.Id, Name = 'testopp 2', StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1)));
            //list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
            opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
            opportunities[0].StageName = 'Won';
            opportunities[0].Exchange_Offering_Type__c = 'All On Private Exchange';
            opportunities[0].Primary_Closed_Reason__c = 'Savings';
            
            opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
            opportunities[1].StageName = 'Prospective';
            opportunities[1].Exchange_Offering_Type__c = 'All On Private Exchange';
            insert opportunities;
            
            List<Producer_Association_For_Opportunity__c> pAOList = TestClassUtiltity.createProducerAssociationForOpportunity(acc.Id,opportunities[0].Id);
            insert pAOList;
            List<Producer_Association_For_Opportunity__c> pAOList2 = TestClassUtiltity.createProducerAssociationForOpportunity(acc.Id,opportunities[1].Id);
            insert pAOList2;
            
            list<Case> cases = TestClassUtiltity.createCaseRecords(testAccount.Id);
            cases[0].Opportunity_Name__c = opportunities[1].Id;
             cases[0].PPO__c = 'PPO';
            insert cases;
            
            //create Opportunity Team Members
            list<OpportunityTeamMember> oppTeamMembers = TestClassUtiltity.createOppTeamMember(opportunities[1].Id,testUser.Id);
            oppTeamMembers[0].TeamMemberRole = 'Accountant';
            insert oppTeamMembers;
            
            //create Opportunity Team NON SF Members
            list<Opportunity_Team_Non_SF__c> oppTeamMembersNonSF = TestClassUtiltity.createOppTeamNonSF(opportunities[1].Id,TestCon.Id);
            insert oppTeamMembersNonSF;
            
            list<Stage_Mapping__c> stageMapping = TestClassUtiltity.createStageMappings(stages[0].Id,playBooks[0].Id,opportunities[1].Id);
            insert stageMapping;
            
            list<Substage_Mapping1__c> substageMapping = TestClassUtiltity.createSubStageMappings(stageMapping[0].Id,substages[0].Id);
            insert substageMapping;
            
            list<Task_Mapping__c> taskMappings = TestClassUtiltity.createTaskMappings(substageMapping[0].Id,tasks[0].Id);
            taskMappings[0].Task__c = tasks[1].Id;
            insert taskMappings;
            
            list<Task_Mapping__c> taskMappings2 = TestClassUtiltity.createTaskMappings(substageMapping[0].Id,tasks2[0].Id);
            taskMappings2[0].Task__c = tasks2[1].Id;
            insert taskMappings2;
            
            list<Id> taskMappingIds = new list<Id>();
            for(Task_Mapping__c tm: taskMappings)
                taskMappingIds.add(tm.Id);
                
            for(Task_Mapping__c tm: taskMappings2)
                taskMappingIds.add(tm.Id);
                
                Test.startTest();

                PlaybookCaseCreationHandler.createCases(opportunities[0].Id,taskMappingIds);
                list<Case> tempcases = [select Id from Case ];
                system.assertequals(5,tempcases.size());
                PlaybookCaseCreationHandler.createCases(opportunities[1].Id,taskMappingIds);
                Test.stopTest();

         }

    }
    
    static testMethod void myUnitTest1() {
    

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
         User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
         User testUser1 = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev1@user.com', 'testUser1', 'test1@user.com');
         User testUser2 = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev2@user.com', 'testUser2', 'test2@user.com');
         User testUser3 = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev3@user.com', 'testUser3', 'test3@user.com');
         
         system.runAs(testUser){
            //crate Account
            Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
            testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
            testAccount.status__c = 'Sold';
            testAccount.Fax = '1234567';
            testAccount.Ceded_From_ICL__c = 'LA';
            testAccount.Ceded_To_ACL__c = 'AL';
            testAccount.Effective_Date__c = date.today();
            testAccount.Cede_End_Date__c = date.today();
            testAccount.Funding_Type__c = 'ACAP';
            testAccount.Active_Health_Subscribers__c = 20 ;
                             
            update testAccount;
            Contact TestCon = TestClassUtiltity.CreateContactRecord(testAccount.id, 'TestFirstName', 'TestLastname', null);
            testCon.RecordTypeId =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal Contact').getRecordTypeId(); 
            update testCon;
            Contact testCon1 = TestClassUtiltity.CreateContactRecord(testAccount.id, 'First', 'Last32223', null);
            testCon1.RecordTypeId =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal Contact').getRecordTypeId(); 
            update testCon1;
            

            
            TestClassUtiltity.createPlaybookSettingsFields();
            
            list<Playbook__c> playBooks = TestClassUtiltity.createPlayBookRecords();
            insert playBooks;
            
            list<Stage__c> stages = TestClassUtiltity.createStageRecords(playBooks[1].Id);
            insert stages;
            
            list<Substage__c> substages = TestClassUtiltity.createSubStageRecords(stages[0].Id);
            insert substages;
            
            list<Task__c> tasks = TestClassUtiltity.createTaskSubStageRecords(substages[0].Id);
            tasks[0].Case_Record_Type__c = 'Performance Guarantee';
            tasks[1].Case_Record_Type__c = 'Underwriting';
            insert tasks;
            
            list<Task__c> tasks2 = TestClassUtiltity.createTaskSubStageRecords(substages[0].Id);
            tasks2[0].Case_Record_Type__c = 'Underwriting';
            tasks2[1].Case_Record_Type__c = 'Performance Guarantee';
            insert tasks2;
            
            list<Task__c> tasks3 = TestClassUtiltity.createTaskSubStageRecords(substages[1].Id);
            tasks3[0].Case_Record_Type__c = 'Cede';
            tasks3[1].Case_Record_Type__c = 'Underwriting';
            insert tasks3;
            
            
            //create Opportunity records
             list<Opportunity> opportunities = new list<Opportunity> ();
            opportunities.add(new Opportunity(AccountId = testAccount.Id, Name = 'oppName 1', StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1)));
            opportunities.add(new Opportunity(AccountId = testAccount.Id, Name = 'testopp 2', StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1)));
            //list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
            opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
            opportunities[0].StageName = 'Lost';
            opportunities[0].Exchange_Offering_Type__c = 'All On Private Exchange';
            opportunities[0].Primary_Closed_Reason__c = 'Savings';
            
            opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
            opportunities[1].StageName = 'Prospective';
            opportunities[1].Exchange_Offering_Type__c = 'All On Private Exchange';
            insert opportunities;
             
            List<Product2> products = TestClassUtiltity.createProducts();
            insert products;
            List<Opportunity_Product__c> opptyprods = TestClassUtiltity.createOpptyProducts(opportunities[0].Id,products[0].Id);
            opptyprods[0].Funding_Type__c = 'ACAP';
            opptyprods[0].Premium_Type__c = 'PP';
            opptyprods[1].Funding_Type__c = 'ASO';
            opptyprods[1].Premium_Type__c = 'RP';
            insert opptyprods;
            
            
            list<Case> cases = TestClassUtiltity.createCaseRecords(testAccount.Id);
            cases[0].Opportunity_Name__c = opportunities[0].Id;
            cases[0].RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Network Information').getRecordTypeId();
             cases[0].PPO__c = 'PPO';
            insert cases;
            list<Case> cases1 = TestClassUtiltity.createCaseRecords(testAccount.Id);
            cases1[0].Opportunity_Name__c = opportunities[0].Id;
            cases1[0].RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
             cases1[0].PPO__c = 'PPO';
            insert cases1;
            
            //List<CaseTeamRole> csTeamRoles = TestClassUtiltity.CreateCaseTeamRole();
            //insert csTeamRoles;
            
            
            
            
            // create Opportunity Contact Roles
            list<OpportunityContactRole> oppConRoleList = new list<OpportunityContactRole>();
            OpportunityContactRole oppConRole1 = new OpportunityContactRole(ContactId = testCon.Id, OpportunityId = opportunities[1].Id, Role = 'Producer' );
            oppConRoleList.add(oppConRole1);
            OpportunityContactRole oppConRole2 = new OpportunityContactRole(ContactId = testCon1.Id, OpportunityId = opportunities[1].Id, Role = 'Consultant' );
            oppConRoleList.add(oppConRole2);
            OpportunityContactRole oppConRole3 = new OpportunityContactRole(ContactId = testCon.Id, OpportunityId = opportunities[0].Id, Role = 'Producer' );
            oppConRoleList.add(oppConRole3);
            OpportunityContactRole oppConRole4 = new OpportunityContactRole(ContactId = testCon1.Id, OpportunityId = opportunities[0].Id, Role = 'Consultant' );
            oppConRoleList.add(oppConRole4);
            insert oppConRoleList;
            
            
            
            //create Opportunity Team Members
            list<OpportunityTeamMember> oppTeamMembers11 = TestClassUtiltity.createOppTeamMember(opportunities[1].Id,testUser.Id);
            list<OpportunityTeamMember> oppTeamMembers12 = TestClassUtiltity.createOppTeamMember(opportunities[1].Id,testUser1.Id);
            list<OpportunityTeamMember> oppTeamMembers13 = TestClassUtiltity.createOppTeamMember(opportunities[1].Id,testUser2.Id);
            list<OpportunityTeamMember> oppTeamMembers14 = TestClassUtiltity.createOppTeamMember(opportunities[1].Id,testUser3.Id);
            list<OpportunityTeamMember> oppTeamMembersList1 = new list<OpportunityTeamMember>();
            oppTeamMembers11[0].TeamMemberRole = 'Accountant';
            oppTeamMembers12[0].TeamMemberRole = 'Sales Executive';
            oppTeamMembers13[0].TeamMemberRole = 'Account Executive';
            oppTeamMembers14[0].TeamMemberRole = 'Underwriter';
            oppTeamMembersList1.add(oppTeamMembers11[0]);
            oppTeamMembersList1.add(oppTeamMembers12[0]);
            oppTeamMembersList1.add(oppTeamMembers13[0]);
            oppTeamMembersList1.add(oppTeamMembers14[0]);
            insert oppTeamMembersList1;
            
            list<OpportunityTeamMember> oppTeamMembers = TestClassUtiltity.createOppTeamMember(opportunities[0].Id,testUser.Id);
            list<OpportunityTeamMember> oppTeamMembers1 = TestClassUtiltity.createOppTeamMember(opportunities[0].Id,testUser1.Id);
            list<OpportunityTeamMember> oppTeamMembers2 = TestClassUtiltity.createOppTeamMember(opportunities[0].Id,testUser2.Id);
            list<OpportunityTeamMember> oppTeamMembers3 = TestClassUtiltity.createOppTeamMember(opportunities[0].Id,testUser3.Id);
            list<OpportunityTeamMember> oppTeamMembersList = new list<OpportunityTeamMember>();
            oppTeamMembers[0].TeamMemberRole = 'Accountant';
            oppTeamMembers1[0].TeamMemberRole = 'Sales Executive';
            oppTeamMembers2[0].TeamMemberRole = 'Account Executive';
            oppTeamMembers2[0].TeamMemberRole = 'Underwriter';
            oppTeamMembersList.add(oppTeamMembers[0]);
            oppTeamMembersList.add(oppTeamMembers1[0]);
            oppTeamMembersList.add(oppTeamMembers2[0]);
            oppTeamMembersList.add(oppTeamMembers3[0]);
            insert oppTeamMembersList;
            
            
            
            //create Opportunity Team NON SF Members
            list<Opportunity_Team_Non_SF__c> oppTeamMembersNonSF = TestClassUtiltity.createOppTeamNonSF(opportunities[0].Id,TestCon.Id);
            insert oppTeamMembersNonSF;
            
           
            list<Stage_Mapping__c> stageMapping = TestClassUtiltity.createStageMappings(stages[0].Id,playBooks[1].Id,opportunities[0].Id);
            insert stageMapping;
            
            list<Substage_Mapping1__c> substageMapping = TestClassUtiltity.createSubStageMappings(stageMapping[0].Id,substages[0].Id);
            insert substageMapping;
            
            list<Task_Mapping__c> taskMappings = TestClassUtiltity.createTaskMappings(substageMapping[0].Id,tasks[0].Id);
            taskMappings[0].Task__c = tasks[1].Id;
            insert taskMappings;
            
            for(Task_Mapping__c tm: taskMappings)
                tm.Completed__c = true;
            update taskMappings;
            
            list<Task_Mapping__c> taskMappings2 = TestClassUtiltity.createTaskMappings(substageMapping[0].Id,tasks2[0].Id);
            taskMappings2[0].Task__c = tasks2[1].Id;
            insert taskMappings2;
            
            for(Task_Mapping__c tm: taskMappings2)
                tm.Completed__c = true;
            update taskMappings2;
            
            list<Id> taskMappingIds = new list<Id>();
            for(Task_Mapping__c tm: taskMappings)
                taskMappingIds.add(tm.Id);
            
            for(Task_Mapping__c tm: taskMappings2)
                taskMappingIds.add(tm.Id);
                
            Test.startTest();


            PlaybookCaseCreationHandler.createCases(opportunities[0].Id,taskMappingIds);
             list<Case> tempcases = [select Id from Case];
            system.assertequals(6,tempcases.size());
            PlaybookCaseCreationHandler.createCases(opportunities[1].Id,taskMappingIds);
            test.stopTest();
         }
    }


*/




















}