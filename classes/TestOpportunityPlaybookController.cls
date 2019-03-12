/*****************************************************************************
Apex Class Name     : OpportunityPlaybookControllerTest 
Version             : 1.0
Function            : This is a test class for OpportunityPlaybookController
Modification Log    :
Developer           Date          	Description        
Mark Naumann		11/17/2017		SFDC-5796 Increaed coverage from 61% to 77%
*******************************************************************************/
@isTest
private class TestOpportunityPlaybookController {

      static testMethod void myUnitTest() {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
            system.runAs(testUser) {
                  //crate Account
                  List<Account> accList = new List<Account>();
                  Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                  testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                  
                  testAccount.Description = 'ABC123';
                  testAccount.Ceded_From_ICL__c = 'OK';
                  testAccount.Ceded_To_ACL__c = 'TX';
                                
                  testAccount.status__c = 'Sold';
                  testAccount.Fax = '1234567';
                  testAccount.ShippingStreet = 'test';
                  testAccount.ShippingCity = 'Florida';
                  testAccount.ShippingState = 'IL';
                  testAccount.ShippingPostalCode = '12345';
                  update testAccount;

                  Dental_UW_Fields_PrePopulated__c temp = new Dental_UW_Fields_PrePopulated__c();
                  temp.Case_FIeld_API_Name__c = 'Status';
                  temp.Name = 'default';
                  insert temp;

                  Account acc = TestClassUtiltity.CreateAccountRecord('Test');
                  acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
                  acc.status__c = 'Sold';
                  acc.Fax = '123456';
                  update acc;

                  Contact TestCon = TestClassUtiltity.CreateContactRecord(testAccount.id, 'TestFirstName', 'TestLastname', null);
                  testCon.RecordTypeId =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal Contact').getRecordTypeId();
                  update testCon;
                  Contact TestCon1 = TestClassUtiltity.CreateContactRecord(testAccount.id, 'FName23', 'name', null);
                  Contact TestCon2 = TestClassUtiltity.CreateContactRecord(testAccount.id, 'TestFirst', 'Testname76', null);

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

                  list<Task__c> tasks3 = TestClassUtiltity.createTaskSubStageRecords(substages[0].Id);
                  tasks3[0].Case_Record_Type__c = 'Underwriting';
                  tasks3[1].Case_Record_Type__c = 'Dental Underwriting';
                  insert tasks3;

                  //create Opportunity records
                  list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
                  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                  opportunities[0].StageName = 'RFI Received';
                  opportunities[0].Probability = 10;


                  opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
                  opportunities[1].StageName = 'RFI Delivered';
                  opportunities[1].Probability = 20;

                  insert opportunities;

                  list<OpportunityContactRole> oppConRoleList = new list<OpportunityContactRole>();
                  OpportunityContactRole oppConRole1 = new OpportunityContactRole(ContactId = testCon.Id, OpportunityId = opportunities[1].Id, Role = 'Producer' );
                  oppConRoleList.add(oppConRole1);
                  OpportunityContactRole oppConRole2 = new OpportunityContactRole(ContactId = TestCon1.Id, OpportunityId = opportunities[1].Id, Role = 'Consultant' );
                  oppConRoleList.add(oppConRole2);
                  OpportunityContactRole oppConRole3 = new OpportunityContactRole(ContactId = TestCon2.Id, OpportunityId = opportunities[1].Id, Role = 'Decision Maker' );
                  oppConRoleList.add(oppConRole3);
                  insert oppConRoleList;

                  list<Case> cases = TestClassUtiltity.createCaseRecords(testAccount.Id);
                  cases[0].Opportunity_Name__c = opportunities[1].Id;
                  //insert cases;

                  list<Stage_Mapping__c> stageMapping = TestClassUtiltity.createStageMappings(stages[0].Id, playBooks[0].Id, opportunities[1].Id);
                  insert stageMapping;

                  list<Substage_Mapping1__c> substageMapping = TestClassUtiltity.createSubStageMappings(stageMapping[0].Id, substages[0].Id);
                  insert substageMapping;

                  list<Task__c> tasks1 = TestClassUtiltity.createTaskSubStageRecords(substages[0].Id);
                  tasks[0].Case_Record_Type__c = 'Custom Benefit/Service';
                  tasks[1].Case_Record_Type__c = 'Proposal';
                  insert tasks1;
                
                  list<Task_Mapping__c> taskMappings = TestClassUtiltity.createTaskMappings(substageMapping[0].Id, tasks[0].Id);
                  taskMappings[0].Task__c = tasks[1].Id;
                  taskMappings[1].Completed__c = true;
                  insert taskMappings;

                  list<Task_Mapping__c> taskMappings3 = TestClassUtiltity.createTaskMappings(substageMapping[0].Id, tasks3[0].Id);
                  taskMappings3[0].Task__c = tasks3[1].Id;
                  taskMappings3[1].Completed__c = true;
                  insert taskMappings3;

                  test.startTest();
                  ApexPAges.StandardController sc2 = new ApexPages.StandardController(opportunities[1]);
                  ApexPages.currentPage().getParameters().put( 'subStageId' , substageMapping[0].Id );
                  ApexPages.currentPage().getParameters().put( 'status' , 'done' );
                  OpportunityPlaybookController myCntrl = new OpportunityPlaybookController(sc2);
                  mycntrl.updateSubStageStatus();
                  mycntrl.startSubStage();
                  ApexPages.currentPage().getParameters().put( 'subStageId' , substageMapping[0].Id );
                  ApexPages.currentPage().getParameters().put( 'status' , 'undone' );
                  mycntrl.updateSubStageStatus();
                  mycntrl.startSubStage();
                  ApexPages.currentPage().getParameters().put( 'subStageIdForTasks' , substageMapping[0].Id );
                  mycntrl.updateTaskStatus();
                  system.assertEquals(mycntrl.mapTasksBySubstage.size(), 4);
                  test.stopTest();
            }
      }
 
           static testMethod void myUnitTest4() {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
            system.runAs(testUser) {
                  //create Account
                  List<Account> accList = new List<Account>();
                  Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                  testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                  testAccount.status__c = 'Sold';
                  testAccount.Fax = '1234567';
                  testAccount.ShippingStreet = 'test';
                  testAccount.ShippingCity = 'Florida';
                  testAccount.ShippingState = 'FL';
                  testAccount.ShippingPostalCode = '12345';
                  update testAccount;

                  Dental_UW_Fields_PrePopulated__c temp = new Dental_UW_Fields_PrePopulated__c();
                  temp.Case_FIeld_API_Name__c = 'Status';
                  temp.Name = 'default';
                  insert temp;

                  Account acc = TestClassUtiltity.CreateAccountRecord('Test');
                  acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
                  acc.status__c = 'Sold';
                  acc.Fax = '123456';
                  update acc;

                  Contact TestCon = TestClassUtiltity.CreateContactRecord(testAccount.id, 'TestFirstName', 'TestLastname', null);
                  testCon.RecordTypeId =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal Contact').getRecordTypeId();
                  update testCon;
                  Contact TestCon1 = TestClassUtiltity.CreateContactRecord(testAccount.id, 'FName23', 'name', null);
                  Contact TestCon2 = TestClassUtiltity.CreateContactRecord(testAccount.id, 'TestFirst', 'Testname76', null);

                  TestClassUtiltity.createPlaybookSettingsFields();

                  list<Playbook__c> playBooks = TestClassUtiltity.createPlayBookRecords();
                  insert playBooks;

                  list<Stage__c> stages = TestClassUtiltity.createStageRecords(playBooks[0].Id);
                  insert stages;

                  list<Substage__c> substages = TestClassUtiltity.createSubStageRecords(stages[0].Id);
                  insert substages;

                  list<Task__c> tasks2 = TestClassUtiltity.createTaskSubStageRecords(substages[0].Id);
                  tasks2[0].Case_Record_Type__c = 'Performance Guarantee_ForExceptions';
                  tasks2[1].Case_Record_Type__c = 'Cede_ForExceptions';
                  insert tasks2;

                  //create Opportunity records
                  list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
                  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                  opportunities[0].StageName = 'RFI Received';
                  opportunities[0].Probability = 10;


                  opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
                  opportunities[1].StageName = 'RFI Received';
                  opportunities[1].Probability = 20;
                  insert opportunities;

                  list<OpportunityContactRole> oppConRoleList = new list<OpportunityContactRole>();
                  OpportunityContactRole oppConRole1 = new OpportunityContactRole(ContactId = testCon.Id, OpportunityId = opportunities[1].Id, Role = 'Producer' );
                  oppConRoleList.add(oppConRole1);
                  OpportunityContactRole oppConRole2 = new OpportunityContactRole(ContactId = TestCon1.Id, OpportunityId = opportunities[1].Id, Role = 'Consultant' );
                  oppConRoleList.add(oppConRole2);
                  OpportunityContactRole oppConRole3 = new OpportunityContactRole(ContactId = TestCon2.Id, OpportunityId = opportunities[1].Id, Role = 'Decision Maker' );
                  oppConRoleList.add(oppConRole3);
                  insert oppConRoleList;

                  List<Producer_Association_For_Opportunity__c> pAOList = TestClassUtiltity.createProducerAssociationForOpportunity(acc.Id, opportunities[0].Id);
                  insert pAOList;
                  List<Producer_Association_For_Opportunity__c> pAOList2 = TestClassUtiltity.createProducerAssociationForOpportunity(acc.Id, opportunities[1].Id);
                  insert pAOList2;

                  list<Case> cases = TestClassUtiltity.createCaseRecords(testAccount.Id);
                  cases[0].Opportunity_Name__c = opportunities[1].Id;
                                
                         
                  //create Opportunity Team Members
                  list<OpportunityTeamMember> oppTeamMembers = TestClassUtiltity.createOppTeamMember(opportunities[1].Id, testUser.Id);
                 oppTeamMembers[0].TeamMemberRole = 'Accountant';
                  
                
                 
                  //create Opportunity Team NON SF Members
                  list<Opportunity_Team_Non_SF__c> oppTeamMembersNonSF = TestClassUtiltity.createOppTeamNonSF(opportunities[1].Id, TestCon.Id);
                  insert oppTeamMembersNonSF;
                              
                  list<Stage_Mapping__c> stageMapping = TestClassUtiltity.createStageMappings(stages[0].Id, playBooks[0].Id, opportunities[1].Id);
                  insert stageMapping;

                  list<Substage_Mapping1__c> substageMapping = TestClassUtiltity.createSubStageMappings(stageMapping[0].Id, substages[0].Id);
   
                  substageMapping[0].Started__c = false; 
                  substageMapping[1].Start_DateTime__c = system.today();
                              
                  insert substageMapping;

                  list<Task_Mapping__c> taskMappings2 = TestClassUtiltity.createTaskMappings(substageMapping[0].Id, tasks2[0].Id);
                  taskMappings2[0].Task__c = tasks2[1].Id;
                  taskMappings2[1].Completed__c = true;
					                
                  insert taskMappings2;

                  test.startTest();
                  ApexPAges.StandardController sc2 = new ApexPages.StandardController(opportunities[1]);
                  ApexPages.currentPage().getParameters().put( 'subStageId' , substageMapping[0].Id );
                  ApexPages.currentPage().getParameters().put( 'status' , 'done' );  
                  OpportunityPlaybookController myCntrl = new OpportunityPlaybookController(sc2);
                  mycntrl.updateSubStageStatus();
                  mycntrl.startSubStage();
                  ApexPages.currentPage().getParameters().put( 'subStageId' , substageMapping[1].Id );
                  ApexPages.currentPage().getParameters().put( 'status' , 'done' );  
                  mycntrl.updateSubStageStatus();
                  mycntrl.startSubStage();
                  ApexPages.currentPage().getParameters().put( 'subStageIdForTasks' , substageMapping[0].Id );
                  mycntrl.updateTaskStatus();
                  system.assertEquals(mycntrl.mapTasksBySubstage.size(), 4);
                  test.stopTest();
            }
      }    
      static testMethod void myUnitTest3() {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
            system.runAs(testUser) {
                  //create Account
                  List<Account> accList = new List<Account>();
                  Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                  testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                  testAccount.status__c = 'Sold';
                  testAccount.Fax = '1234567';
                  testAccount.ShippingStreet = 'test';
                  testAccount.ShippingCity = 'Florida';
                  testAccount.ShippingState = 'FL';
                  testAccount.ShippingPostalCode = '12345';
                  update testAccount;

                  Dental_UW_Fields_PrePopulated__c temp = new Dental_UW_Fields_PrePopulated__c();
                  temp.Case_FIeld_API_Name__c = 'Status';
                  temp.Name = 'default';
                  insert temp;

                  Account acc = TestClassUtiltity.CreateAccountRecord('Test');
                  acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
                  acc.status__c = 'Sold';
                  acc.Fax = '123456';
                  update acc;

                  Contact TestCon = TestClassUtiltity.CreateContactRecord(testAccount.id, 'TestFirstName', 'TestLastname', null);
                  testCon.RecordTypeId =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal Contact').getRecordTypeId();
                  update testCon;
                  Contact TestCon1 = TestClassUtiltity.CreateContactRecord(testAccount.id, 'FName23', 'name', null);
                  Contact TestCon2 = TestClassUtiltity.CreateContactRecord(testAccount.id, 'TestFirst', 'Testname76', null);

                  TestClassUtiltity.createPlaybookSettingsFields();

                  list<Playbook__c> playBooks = TestClassUtiltity.createPlayBookRecords();
                  insert playBooks;

                  list<Stage__c> stages = TestClassUtiltity.createStageRecords(playBooks[0].Id);
                  insert stages;

                  list<Substage__c> substages = TestClassUtiltity.createSubStageRecords(stages[0].Id);
                  insert substages;

                  list<Task__c> tasks2 = TestClassUtiltity.createTaskSubStageRecords(substages[0].Id);
                  tasks2[0].Case_Record_Type__c = 'Performance Guarantee_ForExceptions';
                  tasks2[1].Case_Record_Type__c = 'Cede_ForExceptions';
                  insert tasks2;

                  //create Opportunity records
                  list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
                  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                  opportunities[0].StageName = 'RFI Received';
                  opportunities[0].Probability = 10;


                  opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
                  opportunities[1].StageName = 'RFI Received';
                  opportunities[1].Probability = 20;
                  insert opportunities;

                  list<OpportunityContactRole> oppConRoleList = new list<OpportunityContactRole>();
                  OpportunityContactRole oppConRole1 = new OpportunityContactRole(ContactId = testCon.Id, OpportunityId = opportunities[1].Id, Role = 'Producer' );
                  oppConRoleList.add(oppConRole1);
                  OpportunityContactRole oppConRole2 = new OpportunityContactRole(ContactId = TestCon1.Id, OpportunityId = opportunities[1].Id, Role = 'Consultant' );
                  oppConRoleList.add(oppConRole2);
                  OpportunityContactRole oppConRole3 = new OpportunityContactRole(ContactId = TestCon2.Id, OpportunityId = opportunities[1].Id, Role = 'Decision Maker' );
                  oppConRoleList.add(oppConRole3);
                  insert oppConRoleList;

                  List<Producer_Association_For_Opportunity__c> pAOList = TestClassUtiltity.createProducerAssociationForOpportunity(acc.Id, opportunities[0].Id);
                  insert pAOList;
                  List<Producer_Association_For_Opportunity__c> pAOList2 = TestClassUtiltity.createProducerAssociationForOpportunity(acc.Id, opportunities[1].Id);
                  insert pAOList2;

                  list<Case> cases = TestClassUtiltity.createCaseRecords(testAccount.Id);
                  cases[0].Opportunity_Name__c = opportunities[1].Id;
                                
                         
                  //create Opportunity Team Members
                  list<OpportunityTeamMember> oppTeamMembers = TestClassUtiltity.createOppTeamMember(opportunities[1].Id, testUser.Id);
                 oppTeamMembers[0].TeamMemberRole = 'Accountant';
                  
                
                 
                  //create Opportunity Team NON SF Members
                  list<Opportunity_Team_Non_SF__c> oppTeamMembersNonSF = TestClassUtiltity.createOppTeamNonSF(opportunities[1].Id, TestCon.Id);
                  insert oppTeamMembersNonSF;
                              
                  list<Stage_Mapping__c> stageMapping = TestClassUtiltity.createStageMappings(stages[0].Id, playBooks[0].Id, opportunities[1].Id);
                  insert stageMapping;

                  list<Substage_Mapping1__c> substageMapping = TestClassUtiltity.createSubStageMappings(stageMapping[0].Id, substages[0].Id);
                  insert substageMapping;

                  list<Task_Mapping__c> taskMappings2 = TestClassUtiltity.createTaskMappings(substageMapping[0].Id, tasks2[0].Id);
                  taskMappings2[0].Task__c = tasks2[1].Id;
                  taskMappings2[1].Completed__c = true;
                  insert taskMappings2;

                  test.startTest();
                  ApexPAges.StandardController sc2 = new ApexPages.StandardController(opportunities[1]);
                  ApexPages.currentPage().getParameters().put( 'subStageId' , substageMapping[0].Id );
                  ApexPages.currentPage().getParameters().put( 'status' , 'undone' ); // exception done to undone
                  OpportunityPlaybookController myCntrl = new OpportunityPlaybookController(sc2);
                  mycntrl.updateSubStageStatus();
                  mycntrl.startSubStage();
                  ApexPages.currentPage().getParameters().put( 'subStageId' , substageMapping[0].Id );
                  ApexPages.currentPage().getParameters().put( 'status' , 'undone' ); // exception  
                  mycntrl.updateSubStageStatus();
                  mycntrl.startSubStage();
                  ApexPages.currentPage().getParameters().put( 'subStageIdForTasks' , substageMapping[0].Id );
                  mycntrl.updateTaskStatus();
                  system.assertEquals(mycntrl.mapTasksBySubstage.size(), 4);
                  test.stopTest();
            }
      }   

     static testMethod void myUnitTest2() {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
            system.runAs(testUser) {
                  //crate Account
                  List<Account> accList = new List<Account>();
                  Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                  testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                  testAccount.status__c = 'Sold';
                  testAccount.Fax = '1234567';
                  testAccount.ShippingStreet = 'test';
                  testAccount.ShippingCity = 'Florida';
                  testAccount.ShippingState = 'IL';
                  testAccount.ShippingPostalCode = '12345';
                  update testAccount;

                  Dental_UW_Fields_PrePopulated__c temp = new Dental_UW_Fields_PrePopulated__c();
                  temp.Case_FIeld_API_Name__c = 'Status';
                  temp.Name = 'default';
                  insert temp;

                  Account acc = TestClassUtiltity.CreateAccountRecord('Test');
                  acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
                  acc.status__c = 'Sold';
                  acc.Fax = '123456';
                  update acc;

                  Contact TestCon = TestClassUtiltity.CreateContactRecord(testAccount.id, 'TestFirstName', 'TestLastname', null);
                  testCon.RecordTypeId =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal Contact').getRecordTypeId();
                  update testCon;
                  Contact TestCon1 = TestClassUtiltity.CreateContactRecord(testAccount.id, 'FName23', 'name', null);
                  Contact TestCon2 = TestClassUtiltity.CreateContactRecord(testAccount.id, 'TestFirst', 'Testname76', null);

                  TestClassUtiltity.createPlaybookSettingsFields();

                  list<Playbook__c> playBooks = TestClassUtiltity.createPlayBookRecords();
                  insert playBooks;

                  list<Stage__c> stages = TestClassUtiltity.createStageRecords(playBooks[0].Id);
                  insert stages;

                  list<Substage__c> substages = TestClassUtiltity.createSubStageRecords(stages[0].Id);
                  insert substages;

                  list<Task__c> tasks2 = TestClassUtiltity.createTaskSubStageRecords(substages[0].Id);
                  tasks2[0].Case_Record_Type__c = 'Performance Guarantee';
                  tasks2[1].Case_Record_Type__c = 'Cede';
                  insert tasks2;

                  //create Opportunity records
                  list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
                  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                  opportunities[0].StageName = 'RFI Received';
                  opportunities[0].Probability = 10;


                  opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
                  opportunities[1].StageName = 'RFI Delivered';
                  opportunities[1].Probability = 10;
                  insert opportunities;

                  list<OpportunityContactRole> oppConRoleList = new list<OpportunityContactRole>();
                  OpportunityContactRole oppConRole1 = new OpportunityContactRole(ContactId = testCon.Id, OpportunityId = opportunities[1].Id, Role = 'Producer' );
                  oppConRoleList.add(oppConRole1);
                  OpportunityContactRole oppConRole2 = new OpportunityContactRole(ContactId = TestCon1.Id, OpportunityId = opportunities[1].Id, Role = 'Consultant' );
                  oppConRoleList.add(oppConRole2);
                  OpportunityContactRole oppConRole3 = new OpportunityContactRole(ContactId = TestCon2.Id, OpportunityId = opportunities[1].Id, Role = 'Decision Maker' );
                  oppConRoleList.add(oppConRole3);
                  insert oppConRoleList;

                  List<Producer_Association_For_Opportunity__c> pAOList = TestClassUtiltity.createProducerAssociationForOpportunity(acc.Id, opportunities[0].Id);
                  insert pAOList;
                  List<Producer_Association_For_Opportunity__c> pAOList2 = TestClassUtiltity.createProducerAssociationForOpportunity(acc.Id, opportunities[1].Id);
                  insert pAOList2;

                  list<Case> cases = TestClassUtiltity.createCaseRecords(testAccount.Id);
                  cases[0].Opportunity_Name__c = opportunities[1].Id;
                  //insert cases;

                  //create Opportunity Team Members
                  list<OpportunityTeamMember> oppTeamMembers = TestClassUtiltity.createOppTeamMember(opportunities[1].Id, testUser.Id);
                  oppTeamMembers[0].TeamMemberRole = 'Accountant';
                  insert oppTeamMembers;

                  //create Opportunity Team NON SF Members
                  list<Opportunity_Team_Non_SF__c> oppTeamMembersNonSF = TestClassUtiltity.createOppTeamNonSF(opportunities[1].Id, TestCon.Id);
                  insert oppTeamMembersNonSF;

                  list<Stage_Mapping__c> stageMapping = TestClassUtiltity.createStageMappings(stages[0].Id, playBooks[0].Id, opportunities[1].Id);
                  insert stageMapping;

                  list<Substage_Mapping1__c> substageMapping = TestClassUtiltity.createSubStageMappings(stageMapping[0].Id, substages[0].Id);
                  insert substageMapping;

                  list<Task_Mapping__c> taskMappings2 = TestClassUtiltity.createTaskMappings(substageMapping[0].Id, tasks2[0].Id);
                  taskMappings2[0].Task__c = tasks2[1].Id;
                  taskMappings2[1].Completed__c = true;
                  insert taskMappings2;

                  test.startTest();
                  ApexPAges.StandardController sc2 = new ApexPages.StandardController(opportunities[1]);
                  ApexPages.currentPage().getParameters().put( 'subStageId' , substageMapping[0].Id );
                  ApexPages.currentPage().getParameters().put( 'status' , 'done'  );
                  OpportunityPlaybookController myCntrl = new OpportunityPlaybookController(sc2);
                  mycntrl.updateSubStageStatus();
                  mycntrl.startSubStage();
                  ApexPages.currentPage().getParameters().put( 'subStageId' , substageMapping[0].Id );
                  ApexPages.currentPage().getParameters().put( 'status' , 'done'  );
                  mycntrl.updateSubStageStatus();
                  mycntrl.startSubStage();
                  ApexPages.currentPage().getParameters().put( 'subStageIdForTasks' , substageMapping[0].Id );
                  mycntrl.updateTaskStatus();
                  system.assertEquals(mycntrl.mapTasksBySubstage.size(), 4);
                  test.stopTest();
            }
      }
  static testMethod void myUnitTest1() {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
            system.runAs(testUser) {
                  //crate Account
                  Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                  testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                  testAccount.status__c = 'Sold';
                  testAccount.Fax = '1234567';
                  update testAccount;
                  Contact TestCon = TestClassUtiltity.CreateContactRecord(testAccount.id, 'TestFirstName', 'TestLastname', null);
                  testCon.RecordTypeId =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal Contact').getRecordTypeId();
                  update testCon;

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
                  // insert tasks;

                  list<Task__c> tasks2 = TestClassUtiltity.createTaskSubStageRecords(substages[0].Id);
                  tasks2[0].Case_Record_Type__c = 'Dental Underwriting';
                  tasks2[1].Case_Record_Type__c = 'Cede';
                  //insert tasks2;
                  tasks.addAll(tasks2);
                  insert tasks;

                  //create Opportunity records
                  list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
                  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                  opportunities[0].StageName = 'RFI Received';
                  opportunities[0].Probability = 10;

                  opportunities[0].Primary_Closed_Reason__c = 'Organizational Changes';

                  opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
                  opportunities[1].StageName = 'RFI Delivered';
                  opportunities[1].Probability = 20;

                  insert opportunities;

                  list<Case> cases = TestClassUtiltity.createCaseRecords(testAccount.Id);
                  cases[0].Opportunity_Name__c = opportunities[0].Id;
                  cases[0].RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Network Information').getRecordTypeId();
                  cases[0].Provider_Groups__c = 'Dental Providers';
                  insert cases;
                  /*
                  list<Case> cases1 = TestClassUtiltity.createCaseRecords(testAccount.Id);
                  cases1[0].Opportunity_Name__c = opportunities[0].Id;
                  cases1[0].RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
                  cases1[0].PPO__c = 'PPO';
                  //insert cases1;*/
                  Dental_UW_Fields_PrePopulated__c temp = new Dental_UW_Fields_PrePopulated__c();
                  temp.Case_FIeld_API_Name__c = 'Status';
                  temp.Name = 'default';
                  insert temp;
                  //List<CaseTeamRole> csTeamRoles = TestClassUtiltity.CreateCaseTeamRole();
                  //insert csTeamRoles;

                  //create Opportunity Team Members
                  /*list<OpportunityTeamMember> oppTeamMembers = TestClassUtiltity.createOppTeamMember(opportunities[0].Id, testUser.Id);
                  oppTeamMembers[0].TeamMemberRole = 'Accountant';
                  insert oppTeamMembers;

                  //create Opportunity Team NON SF Members
                  list<Opportunity_Team_Non_SF__c> oppTeamMembersNonSF = TestClassUtiltity.createOppTeamNonSF(opportunities[0].Id, TestCon.Id);
                  insert oppTeamMembersNonSF;

                  List<Product2> products = TestClassUtiltity.createProducts();
                  insert products;
                  List<Opportunity_Product__c> opptyprods = TestClassUtiltity.createOpptyProducts(opportunities[0].Id, products[0].Id);
                  opptyprods[0].Funding_Type__c = 'ACAP';
                  opptyprods[0].Premium_Type__c = 'PP';
                  opptyprods[1].Funding_Type__c = 'ASO';
                  opptyprods[1].Premium_Type__c = 'RP';
                  opptyprods[0].Product_Type__c = 'Renewal';
                  opptyprods[1].Product_Type__c = 'New Sale';
                  insert opptyprods;
                  */
                  list<Stage_Mapping__c> stageMapping = TestClassUtiltity.createStageMappings(stages[0].Id, playBooks[1].Id, opportunities[0].Id);
                  insert stageMapping;

                  list<Substage_Mapping1__c> substageMapping = TestClassUtiltity.createSubStageMappings(stageMapping[0].Id, substages[0].Id);
                  insert substageMapping;

                  list<Task_Mapping__c> taskMappings = TestClassUtiltity.createTaskMappings(substageMapping[0].Id, tasks[0].Id);
                  taskMappings[0].Task__c = tasks[1].Id;
                  insert taskMappings;

                  list<Task_Mapping__c> taskMappings2 = TestClassUtiltity.createTaskMappings(substageMapping[0].Id, tasks[0].Id);
                  taskMappings2[0].Task__c = tasks2[1].Id;
                  insert taskMappings2;

                  test.startTest();
                  ApexPAges.StandardController sc2 = new ApexPages.StandardController(opportunities[0]);
                  ApexPages.currentPage().getParameters().put( 'subStageId' , substageMapping[0].Id );
                  ApexPages.currentPage().getParameters().put( 'status' , 'done' );
                  OpportunityPlaybookController myCntrl = new OpportunityPlaybookController(sc2);
                  mycntrl.updateSubStageStatus();
                  mycntrl.startSubStage();

                  ApexPages.currentPage().getParameters().put( 'subStageIdForTasks' , substageMapping[0].Id );
                  mycntrl.updateTaskStatus();

                  mycntrl.editPlaybook();
                  mycntrl.goToPlaybook();
                  system.assertEquals(mycntrl.showEdit, false);
                  mycntrl.selectedPlaybook = playBooks[0].Id;
                  mycntrl.savePlaybookSelection();
                  mycntrl.createDentalUnderwriting(cases[0], cases[0]);
                  test.stopTest();
            }
      }
}