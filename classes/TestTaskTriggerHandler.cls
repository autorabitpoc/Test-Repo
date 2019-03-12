/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class TestTaskTriggerHandler {

    static testMethod void myUnitTestMethod() {
         try{
             Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
             User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
             //system.runAs(testUser){
                //create Account
                Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                testAccount.status__c = 'Sold';
                testAccount.Fax = '1234567';
                update testAccount;
                
                //create Case
                list<Case> cases = TestClassUtiltity.createCaseRecords(testAccount.Id);
                cases[0].RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(ConstantsController.UnderwritingCaseRecordType).getRecordTypeId();
                cases[0].Proposed_Employee__c  = 10;
                
                cases.addAll(TestClassUtiltity.createCaseRecords(testAccount.Id));
                cases[1].RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(ConstantsController.UnderwritingCaseRecordType).getRecordTypeId();
                cases[1].Proposed_Employee__c  = 10;
                insert cases;
                
                
                list<Task> tasks = TestClassUtiltity.createTasks(cases[0].Id);
                tasks[0].status='In progress';
                tasks[0].Type = ConstantsController.TaskTypeForUpdatingCaseStatus;
                tasks[1].status='Completed';
                tasks[1].WhatId=cases[1].Id;
                tasks[1].Type = ConstantsController.TaskTypeForUpdatingCaseStatus;
                insert tasks;
                test.StartTest(); 
                /*tasks[0].status='Completed'; 
                update tasks;*/
                
                Case c = [select Status from Case where Id =:cases[0].Id][0];
                Map<ID,Schema.RecordTypeInfo> recordType_Map = Task.sObjectType.getDescribe().getRecordTypeInfosById();
                if(!recordType_Map.get(tasks[0].recordTypeID).getName().containsIgnoreCase('GEMS')) {
                    system.assertEquals(c.status,'In Progress');
                }
                test.StopTest(); 
                TaskTriggerHandler Classvar = new TaskTriggerHandler();
         }catch(Exception e){
            
         }
    }
   
	static testMethod void insertParentCaseCSSFields() {
		
		try{
			//create profile custom setting list             
            List<Task_Closed_Mail_User_Profiles__c> pProfiles = new List<Task_Closed_Mail_User_Profiles__c>();
			Task_Closed_Mail_User_Profiles__c pProfiles1 = new Task_Closed_Mail_User_Profiles__c();            
			pProfiles1.Name = 'System Administrator';       
			pProfiles.add(pProfiles1);
			insert pProfiles;
            
			//create test user            
			Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User newUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');

            //find case/account record type ids
            Id caseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CaseRecordTypeLGNAGeneralCase).getRecordTypeId();
            Id groupAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Account_Group_Account_Record_Type).getRecordTypeId();
			Id taskRecTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(Label.TaskRecordTypeCSSTaskRecordType).getRecordTypeId();

			system.runAs(newUser){
                
            	//create Account
            	Account testAcnt = TestClassUtiltity.createAccountWithRecType('Test Account 01', groupAccountRecordTypeId);
            	testAcnt.Description = 'Test Description 1';
				testAcnt.HCSC_Division__c = 'IL';
				testAcnt.Region__c = 'IL';
				testAcnt.District__c = '038';
				testAcnt.Cluster__c = '007';
				update testAcnt;
                
                //create case
            	Case newCase = new Case();
            	newCase.RecordTypeId = caseRecTypeId;
            	newCase.AccountId = testAcnt.Id;
            	newCase.Status = 'New';
                newCase.Subject = 'test 01';
                newCase.Description = 'Test';
                newCase.Type = 'Other';
                newCase.Priority = 'Medium';
                newCase.Complexity__c = 'Level 1';
                newCase.OwnerId = newUser.id;
				insert newCase;
               
                test.StartTest();
                //create task 
				List<task> tasks = new List<task> ();
				tasks.add(new task(WhatID = newCase.id, ActivityDate = system.today().addDays(- 1), subject = 'Test 01', 
                                   description = 'Test description', category__c = 'Audits', Sub_Category__c = 'Group',
                                   priority__c = 'Medium', ownerid = newUser.id, status = 'In progress', recordtypeid = taskRecTypeId));

			    insert tasks;
				test.StopTest();
                
                //assertion test
				List<Case> cs = [select id, Open_CSS_Task__c, Open_CSS_Task_Count__c from Case where Id =:newCase.Id];
				System.assertEquals(true, cs[0].Open_CSS_Task__c);
			}
 
		}catch(Exception e){
         	system.debug('Exception Message - Insert Test Task Method = ' +e);   
        }
	}
  
   static testMethod void updateParentCaseCSSFields() {

		try{
		 //create test user            
			Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User newUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
            
            //find case/account record type ids
            Id caseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CaseRecordTypeLGNAGeneralCase).getRecordTypeId();
            Id groupAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Account_Group_Account_Record_Type).getRecordTypeId();
			Id taskRecTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(Label.TaskRecordTypeCSSTaskRecordType).getRecordTypeId();

			system.runAs(newUser){
            	//create Account
            	Account testAcnt = TestClassUtiltity.createAccountWithRecType('Test Account 01', groupAccountRecordTypeId);
            	testAcnt.Description = 'Test Description 1';
				testAcnt.HCSC_Division__c = 'IL';
				testAcnt.Region__c = 'IL';
				testAcnt.District__c = '038';
				testAcnt.Cluster__c = '007';
				update testAcnt;
                
				Case newCase2 = new Case();
            	newCase2.RecordTypeId = caseRecTypeId;
            	newCase2.AccountId = testAcnt.Id;
            	newCase2.Status = 'New';
                newCase2.Subject = 'test 02';
                newCase2.Description = 'Test';
                newCase2.Type = ConstantsController.UnderwritingCaseRecordType;
                newCase2.Priority = 'Medium';
                newCase2.Complexity__c = 'Level 1';
               
                newCase2.OwnerId = newUser.id;
				insert newCase2;

                //create task 
				List<task> tasks = new List<task> ();
				tasks.add(new task(WhatID = newCase2.id, ActivityDate = system.today().addDays(- 1), subject = 'Test 01', 
                                   description = 'Test description', category__c = 'Audits', Sub_Category__c = 'Group',
                                   priority__c = 'Medium', ownerid = newUser.id, status = 'New', recordtypeid = taskRecTypeId));
                insert tasks;
                
				test.StartTest(); 

               	tasks[0].status = 'Completed';
               	update tasks;
                delete tasks;
			    test.StopTest();

               //assertion test
			   List<Case> cs = [select id, Open_CSS_Task__c, Open_CSS_Task_Count__c from Case where Id =:newCase2.Id];
			   System.assertEquals(false, cs[0].Open_CSS_Task__c);
			}
 
		}catch(Exception e){
         	system.debug('Exception Message - Update Test Task Method = ' +e);   
        }
	}

}