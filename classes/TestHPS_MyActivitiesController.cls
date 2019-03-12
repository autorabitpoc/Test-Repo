/**************************************************************************************
  Apex Class Name     : TestHPS_MyActivitiesController
  Version             : 1.0
  Function            : This is a test class for HPS_MyActivitiesController .
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*  
*************************************************************************************/
    

@isTest
public class TestHPS_MyActivitiesController {

        @testSetup
        static void dataSetupForPharmacyCode() {
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        List<User> userList = new List<User>();
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        userList.add(testUser1);
        insert userList;
        
        Product2 prd =GEMS_UtilityClassTest.insertionProduct(); 
        insert prd;
        User testUser2 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test2@user11.com', 'testUser2', 'test2@user.com');
        insert testUser2;
        
        Account accRec = new Account();
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec.RecordTypeId = recTypeId;
        
        accRec.Name = 'TestAccountForCaseTriggerHandler';
        accRec.Group_Number__c= 'B0609';
        accRec.external_id__c= 'B0609';
        accRec.BillingStreet ='Testing';
        accRec.BillingCity='TX';
        accRec.BillingState='CT';
        accRec.BillingPostalCode='534323';
        accRec.status__c = 'Active';
        insert accRec;
        
        List<String> accountTeamRoleList = new List<String>();
        accountTeamRoleList.add('Account Specialist');
        List<AccountTeamMember> accTeamMemberList = new List<AccountTeamMember> ();
        AccountTeamMember accTeamMemberAccSpecialist = new AccountTeamMember ();
        accTeamMemberAccSpecialist.UserId =userList[0].id;
        accTeamMemberAccSpecialist.TeamMemberRole = accountTeamRoleList[0];
        accTeamMemberAccSpecialist.AccountId =accRec.id;
        accTeamMemberList.add(accTeamMemberAccSpecialist);
        
        AccountTeamMember accTeamMemberAccSpecialist1 = new AccountTeamMember ();
        accTeamMemberAccSpecialist1.UserId =userList[0].id;
        accTeamMemberAccSpecialist1.TeamMemberRole = accountTeamRoleList[0];
        accTeamMemberAccSpecialist1.AccountId =accRec.id;
        accTeamMemberList.add(accTeamMemberAccSpecialist1);
        
        insert accTeamMemberList;
        
        List<Opportunity> optyList = new List<Opportunity>();
        Opportunity oppRec = new Opportunity();
        oppRec.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        oppRec.Name='CaseTriggerHandler';
        oppRec.accountId=accRec.Id;
        oppRec.Type='Other';
        oppRec.StageName=GEMS_UtilityClassTest.opportunityStatus();
        oppRec.Date_Closed__c = system.today();
        oppRec.Exchange_Offering_Type__c='No Private Exchange';
        oppRec.CloseDate=Date.Today().addDays(8);
        oppRec.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        oppRec.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        oppRec.Requested_Effective_Date__c=Date.Today().addDays(8);
        oppRec.Expected_Health_Members__c=2;
        oppRec.Account_Market_Segment__c='LG';
        oppRec.HCSC_Division__c='IL';
        oppRec.Region__c='N/A - IL';
        oppRec.District__c='290';
        oppRec.Clusters__c='020';
        oppRec.Primary_Closed_Reason__c='Other';
        optyList.add(oppRec);
        insert optyList;
        
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;
        System.assertEquals('HSA',productRec1.Product_Category__c);
        
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        List<case> caseList = new List<case>();
        case cs = new case();
        cs.accountid = accRec.Id;
        cs.Opportunity_Name__c= oppRec.id;
        cs.recordtypeid = caseAccountSubmissionId;
        cs.status = 'New';
        caseList.add(cs);
        insert caseList;
        
        cs.Status ='In Progress';
        cs.GEMS_Create_Account_Structure__c =true;
        cs.GEMS_Submission_Type__c = 'new account';
        //accSubCase1.GEMS_Submission_Sub_Type__c = 'Account Structure Change';
        cs.GEMS_Products__c ='Dental;PPO;RX';
        cs.Funding_Type_Multiselect__c = 'Premium'; 
        cs.GEMS_Line_of_Business__c='ENA';
        cs.GEMS_Effective_Date__c = system.today();
        cs.GEMS_Case_Effective_Date__c= system.today();
        cs.GEMS_SBC_Required__c = 'Yes';
        //caseList.add(cs);
        update cs;
        
        
        
    }

    static testMethod void CaseTasksEvents_Test() {
        try{
             test.StartTest(); 
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
             testUser.Is_Super_User__c = true;
             update testUser;
             testUser.Is_Super_User__c = false;
            system.runAs(testUser){
                //crate Account
                Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                testAccount.status__c = 'Sold';
                testAccount.Fax = '1234567';
                update testAccount;
                
                //create case
                 List<Case> cases =  TestClassUtiltity.createCaseRecords(testAccount.id);
                 insert cases;
                 
                //create tasks
                list<Task> tasks = TestClassUtiltity.createTasks(testAccount.Id);
                tasks[0].status='In progress';
                tasks[0].whatID = cases[0].Id;
                insert tasks; 
              
                //create Activities
                //list<Event> events = TestClassUtiltity.createEvents(testAccount.Id);
                Event events = new Event(WhatId = testAccount.Id, Subject = 'Test Event 1', StartDateTime = system.now().addMonths(1), EndDateTime = system.now().addMonths(1).addHours(1));
                insert events;
               
                //Initializing the Constructor
                HPS_MyActivitiesController tempController = new HPS_MyActivitiesController();
                double d = tempController.offset;
                //assert the size of the Task list
                System.assertEquals(tempController.TaskExtensionList.size(),1);
               
                test.StopTest(); 
            }
        }catch(Exception e){
            
        }
    }
    
    
    private static testmethod void GemsPharmacyCdTask_Test()
    {
         test.startTest();     
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
        testUser.Is_Super_User__c = true;
        update testUser;
             
        system.runAs(testUser){
         
        Account acc = [select id,name from account limit 1];
        Product2 prod = [select id,name from product2 limit 1];
        Case structCase = [select id,casenumber,status from case where recordType.Name = 'GEMS Account Structure'];
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,structCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = structCase.id;
        insert bfAgrrement;
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = structCase.Id;
        gemsPhRec.Name='1000';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='BET Submission Required';
        gemsPhRec.Peer_Review_Reject_Counter__c=0;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = '1000';
        gemsPhRec.Status__c='Pharmacy Scope Coding Completed';
        gemsPhRec.ownerId = testuser.Id;
        insert gemsPhRec;
        
       
        GEMS_Pharmacy_Scope_Code__c gemsRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsRec.Case__c = structCase.Id;
        gemsRec.Name='2000';
        gemsRec.Type__c='Temp';
        gemsRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsRec.Retail__c='No Retail Benefits';
        gemsRec.Status__c='Prime Build Started';
        gemsRec.Copay_Type__c='Flat';
        gemsRec.Rider_Code__c='00';
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Scope_Status__c='BET Submission Required';
        gemsRec.Related__c=gemsPhRec.Id;
        gemsRec.Peer_Review_Reject_Counter__c=12;
        gemsRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsRec.Formulary_Type__c='Basic';
        gemsRec.Prime_Certify_Date__c=null;
        gemsRec.Prime_Plan_ID__c='';
        gemsRec.Report_Format_Code__c='P';
        gemsRec.Comments__c='Comments';
        gemsRec.Group_Pay_Code__c = 'Test';
        gemsRec.Related_Scope_Code__c = 'Real';
        gemsRec.ownerId = testuser.Id;
        insert gemsRec;
        
        List<Task> taskList = new List<Task>();
        
        task taskObj1 = new task();
        taskObj1.status = 'In Progress';
        taskObj1.subject = 'Prime Build';
        taskObj1.GEMS_start_date__c = System.now();
        taskObj1.GEMS_end_date__c = System.now();
        taskObj1.whatId = gemsPhRec.Id;
        taskObj1.ownerId = testuser.Id; 
        taskObj1.Priority = 'Normal';
        taskList.add(taskObj1);
        insert taskList;
             
       
        
         //Initializing the Constructor
         HPS_MyActivitiesController tempController = new HPS_MyActivitiesController();
        //assert the size of the Task list
         System.assertEquals(tempController.TaskExtensionList.size()>0,true);
              
        test.StopTest();
       
        }
    }
    
}