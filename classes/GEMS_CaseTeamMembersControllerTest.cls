/**************************************************************************************************************************************************
  Apex Class Name     : GEMS_CaseTeamMembersControllerTest
  Function            : This class serves as Unit Test Class for GEMS_CaseTeamMembersController, GEMS_CaseTeamMembersHelper and GEMS_IndexedCTM
  Author              : Phani Kommareddy 

*  Ver     Date(MM/DD/YYYY)  Name                 Description
*  ---     ----------------  ---------------      ----------------------
*  1.0     05/30/2017        Phani Kommareddy     Original Version created for SFDC-1503 Prevent implementer change
*  1.1     06/05/2017        Phani Kommareddy     Test coverage for SFDC-3879 Updates on AS should update Pharmacy scode AS tasks uncompleted   
**************************************************************************************************************************************************/

@isTest
private class GEMS_CaseTeamMembersControllerTest{

    @testSetup
    static void GemsCTMSetup() {
        
        //users
        ID profileid = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        List<User> users = new List<user>();
        User user1 = GEMS_UtilityClassTest.CreateUserRecord(profileId, 'pk1@bcbstx.com', 'Kommareddy1', 'pk1@bcbstx.com');
        users.add(user1);
        User user2 = GEMS_UtilityClassTest.CreateUserRecord(profileId, 'pk2@bcbstx.com', 'Kommareddy2', 'pk2@bcbstx.com');
        users.add(user2);
        User user3 = GEMS_UtilityClassTest.CreateUserRecord(profileId, 'pk3@bcbstx.com', 'Kommareddy3', 'pk3@bcbstx.com');
        users.add(user3);
        User user4 = GEMS_UtilityClassTest.CreateUserRecord(profileId, 'pk4@bcbstx.com', 'Kommareddy4', 'pk4@bcbstx.com');
        users.add(user4);
        User user5 = GEMS_UtilityClassTest.CreateUserRecord(profileId, 'pk5@bcbstx.com', 'Kommareddy5', 'pk5@bcbstx.com');
        users.add(user5);
        User user6 = GEMS_UtilityClassTest.CreateUserRecord(profileId, 'uw@bcbstx.com', 'LastNameUW', 'uw@bcbstx.com');
        users.add(user6);
        User user7 = GEMS_UtilityClassTest.CreateUserRecord(profileId, 'duw@bcbstx.com', 'LastNameDUW', 'duw@bcbstx.com');
        users.add(user7);
        User user8 = GEMS_UtilityClassTest.CreateUserRecord(profileId, 'newuw@bcbstx.com', 'LastNameUWNew', 'newuw@bcbstx.com');
        users.add(user8);
        User user9 = GEMS_UtilityClassTest.CreateUserRecord(profileId, 'newduw@bcbstx.com', 'LastNameDUWNew', 'newduw@bcbstx.com');
        users.add(user9);
        insert users;
        
        
        
        //account
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        acc.OwnerId = user1.id;
        insert acc;
        
        //case
        Case caseObj = new Case();
        caseObj.HCSC_Division__c ='IL';
        caseObj.accountid= acc.id;
        caseObj.GEMS_Effective_Date__c = system.today();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        caseObj.GEMS_Case_Effective_Date__c = date.today();
        caseObj.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        caseObj.GEMS_Enter_number_of_categories__c = '2';
        caseObj.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        caseObj.Status = 'In Progress';
        caseObj.OwnerId = user1.id;
        insert caseObj;
        
       
        //caseteamrole
        CaseTeamRole ctrImpl = [SELECT ID, Name, AccessLevel from CaseTeamRole where Name = 'SBC Analyst' LIMIT 1];
        CaseTeamRole ctrAE = [SELECT ID, Name, AccessLevel from CaseTeamRole where Name = 'Account Executive' LIMIT 1];
        CaseTeamRole ctrAS = [SELECT ID, Name, AccessLevel from CaseTeamRole where Name = 'Account Specialist' LIMIT 1];
        CaseTeamRole ctrUW = [SELECT ID, Name, AccessLevel from CaseTeamRole where Name = 'Underwriter' LIMIT 1];
        CaseTeamRole ctrDUW = [SELECT ID, Name, AccessLevel from CaseTeamRole where Name = 'Dental Underwriter' LIMIT 1];
        
        
        
        //add caseteammembers to the case
        List<CaseTeamMember> ctmList = new List<CaseTeamMember>();
        CaseTeamMember ctmImpl = new CaseTeamMember();
        ctmImpl.MemberId = user1.Id;
        ctmImpl.ParentId = caseobj.Id;
        ctmImpl.TeamRoleId = ctrImpl.Id;
        ctmList.add(ctmImpl);
        
        CaseTeamMember ctmAE = new CaseTeamMember();
        ctmAE.MemberId = user2.Id;
        ctmAE.ParentId = caseobj.Id;
        ctmAE.TeamRoleId = ctrAE.Id;
        ctmList.add(ctmAE);
       
        CaseTeamMember ctmAS = new CaseTeamMember();
        ctmAS.MemberId = user5.Id;
        ctmAS.ParentId = caseobj.Id;
        ctmAS.TeamRoleId = ctrAS.Id;
        ctmList.add(ctmAS);
        
        
        CaseTeamMember ctmUW = new CaseTeamMember();
        ctmUW.MemberId = user6.Id;
        ctmUW.ParentId = caseobj.Id;
        ctmUW.TeamRoleId = ctrUW.Id;
        ctmList.add(ctmUW);
        
        
        CaseTeamMember ctmDUW = new CaseTeamMember();
        ctmDUW.MemberId = user7.Id;
        ctmDUW.ParentId = caseobj.Id;
        ctmDUW.TeamRoleId = ctrDUW.Id;
        ctmList.add(ctmDUW);
        
        insert ctmList;
        
        
       
        //create pharmacy coding case
        Case pc = new Case();
        pc.GEMS_Account_Submission_Info__c = caseobj.id;
        pc.Type = 'Pharmacy Coding';
        pc.HCSC_Division__c ='IL';
        pc.accountid= acc.id;
        pc.GEMS_Effective_Date__c = system.today();
        pc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        pc.GEMS_Case_Effective_Date__c = date.today();
        pc.GEMS_Enter_number_of_Benefit_Agreements__c = '2';
        pc.GEMS_Enter_number_of_categories__c = '2';
        pc.GEMS_Enter_the_number_of_Group_Sections__c = '2';
        
        pc.Status = 'In Progress';
        pc.OwnerId = user1.id;
        insert pc;
        
        
        //Create GEMS_Pharmacy_Scope_Code__c 
        GEMS_Pharmacy_Scope_Code__c gemsPhRec = new GEMS_Pharmacy_Scope_Code__c();
        gemsPhRec.Case__c = pc.id;
        //gemsPhRec.Case__c = caseRecord.Id;
        gemsPhRec.Name='Test';
        gemsPhRec.Temp__c=true;
        gemsPhRec.Type__c='Permanent';
        gemsPhRec.Mail__c='G=Flat/F=Flat/NF=Percent';
        gemsPhRec.Retail__c='No Retail Benefits';
        gemsPhRec.Copay_Type__c='Flat';
        gemsPhRec.Rider_Code__c='00';
        gemsPhRec.Scope_Status__c='No Scope Code Changes';
        //gemsPhRec.Related__c=gemsPhRec.Id;
        gemsPhRec.Peer_Review_Reject_Counter__c=12;
        gemsPhRec.Accums_Integration__c='Yes, Integrate Ded/OPX';
        gemsPhRec.Formulary_Type__c='Basic';
        gemsPhRec.Prime_Certify_Date__c=system.today();
        gemsPhRec.Prime_Plan_ID__c='123456';
        gemsPhRec.Report_Format_Code__c='P';
        gemsPhRec.Comments__c='Comments';
        gemsPhRec.Group_Pay_Code__c = 'Test';
        gemsPhRec.Related_Scope_Code__c = 'Real';
        insert gemsPhRec;
        
        
        //task
        Task task1 = new Task();
        task1.GEMS_Type__c = 'Pharmacy Scope Code Account Specialist';
        task1.Status =  'In Progress';
        task1.WhatId = gemsPhRec.id;
        task1.OwnerId = user1.Id;
        insert task1;
        
        
        
        
    }
    
    
    //core functionality test
    private static testmethod void  test1(){
        Test.startTest();
        List<User> users = [select id,name from user where username in ('pk1@bcbstx.com','pk2@bcbstx.com','pk3@bcbstx.com','pk4@bcbstx.com')];
        Case case1 = [select id from Case where ownerid  = :users.get(0).id LIMIT 1];
        ApexPages.currentpage().getParameters().put('id',case1.Id);
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(case1);
        GEMS_CaseTeamMembersController gemsCTM = new GEMS_CaseTeamMembersController(stdController);
        
        //add new row as account exective
        gemsCTM.addNewRowToCaseTeamList();
        
        //add member to the added row 
        gemsCTM.rowToUpdate = gemsCTM.indexedCTMList.size() -1 ;
        gemsCTM.updatedTeamMemberId = users.get(2).id;
        gemsCTM.updatedTeamMemberName = users.get(2).Name;
        gemsCTM.updateMemberNameId();
        
        //add role to the added row
        gemsCTM.updatedMemberRole = 'Account Specialist';
        gemsCTM.updateMemberRole();
        
        //remove row account specialist
        gemsCTM.rowToRemove = 1; 
        gemsCTM.removeRowFromCaseTeamList(); 
        
        //update row SBC Analyst team member
        gemsCTM.rowToUpdate = 0;
        gemsCTM.updatedTeamMemberId = users.get(3).id;
        gemsCTM.updatedTeamMemberName = users.get(3).Name;
        gemsCTM.updateMemberNameId();
        
        //persist the final members to database
        gemsCTM.saveCaseTeamList();         

        //SFDC-3879 test case - change on AS on CaseTeamMembers should reflect on the uncompleted tasks on pharmacy scope code
        List<Task> allTasksChanged = [Select id, ownerId from task where whatid in (select id FROM GEMS_Pharmacy_Scope_Code__c where case__r.GEMS_Account_Submission_Info__c = :case1.Id) AND GEMS_Type__C = 'Pharmacy Scope Code Account Specialist' and status != 'Completed'];
        for(Task taskChanged : allTasksChanged) {
            System.assertEquals(users.get(2).id, taskChanged.ownerId);
        }
        
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs){
            System.assertEquals('Case Team updated successfully', msg.getSummary());
            System.assertEquals(ApexPages.Severity.CONFIRM, msg.getSeverity());
        }
        
        //remove role
        CaseTeamMember ctm = [select id,TeamRole.name from caseteammember where TeamRole.Name != 'Implementer' and parentid = :case1.id limit 1];
        gemsCTM.roleName = ctm.TeamRole.name;
        gemsCTM.roleId = ctm.Id; 
        gemsCTM.RemoveRole();
        
        
        //search string test
        gemsCTM.searchString = 'Phani';
        gemsCTM.searchUsers();
        
        
        //search string negative test
        gemsCTM.searchString = 'P';
        gemsCTM.searchUsers();
        
        //misc code coverage
        System.debug(gemsCTM.offset); 
        gemsCTM.Redirect();
        gemsCTM.RedirectToCase();
        
        
        Test.stopTest();
    }
    
    
    
    //validation test case    
     private static testmethod void  test2(){
        Test.startTest();
        List<User> users = [select id,name from user where username in ('pk1@bcbstx.com')];
        Case case1 = [select id from Case where ownerid  = :users.get(0).id LIMIT 1];
        ApexPages.currentpage().getParameters().put('id',case1.Id);
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(case1);
        GEMS_CaseTeamMembersController gemsCTM = new GEMS_CaseTeamMembersController(stdController);
        
         //validation test coverage for empty role/members
        gemsCTM.addNewRowToCaseTeamList();
        gemsCTM.saveCaseTeamList();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs){
            System.assertEquals('Select Team Member and appropriate Member Role', msg.getSummary());
            System.assertEquals(ApexPages.Severity.WARNING, msg.getSeverity());
        }
        System.debug('list '+gemsCTM.indexedCTMList);
         Test.stopTest();
     }
    
    //validation test case
     public static testmethod void  test3(){
        Test.startTest();
        List<User> users = [select id,name from user where username in ('pk1@bcbstx.com','pk2@bcbstx.com')];
        Case case1 = [select id from Case where ownerid  = :users.get(0).id LIMIT 1];
        ApexPages.currentpage().getParameters().put('id',case1.Id);
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(case1);
        GEMS_CaseTeamMembersController gemsCTM = new GEMS_CaseTeamMembersController(stdController);
        
        gemsCTM.addNewRowToCaseTeamList();
        
        //add member to the added row 
        gemsCTM.rowToUpdate = gemsCTM.indexedCTMList.size() -1 ;
        gemsCTM.updatedTeamMemberId = users.get(1).id;
        gemsCTM.updatedTeamMemberName = users.get(1).Name;
        gemsCTM.updateMemberNameId();
        
        //add role to the added row
        gemsCTM.updatedMemberRole = 'Account Executive';
        gemsCTM.updateMemberRole();
        
        gemsCTM.saveCaseTeamList();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs){
            System.assertEquals('Team member cannot be assigned multiple roles', msg.getSummary());
            System.assertEquals(ApexPages.Severity.WARNING, msg.getSeverity());
        }
        System.debug('list '+gemsCTM.indexedCTMList);
        Test.stopTest();
       
     }
    
    //validation test case
     public static testmethod void  test4(){
        Test.startTest();
        List<User> users = [select id,name from user where username in ('pk1@bcbstx.com')];
        Case case1 = [select id from Case where ownerid  = :users.get(0).id LIMIT 1];
        ApexPages.currentpage().getParameters().put('id',case1.Id);
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(case1);
        GEMS_CaseTeamMembersController gemsCTM = new GEMS_CaseTeamMembersController(stdController);
         gemsCTM.saveCaseTeamList();
         List<Apexpages.Message>  msgs = ApexPages.getMessages();
        for(Apexpages.Message msg:msgs){
            System.assertEquals('Case Team updated successfully', msg.getSummary());
            System.assertEquals(ApexPages.Severity.INFO, msg.getSeverity());
        }
        Test.stopTest();
    }
     
  // SFDC-4225. Added to test duplicate UW validation
     private static testmethod void  testDuplicateUWRoleInsertion(){
         Test.startTest();
         List<User> users = [select id,name from user where username in ('newuw@bcbstx.com', 'pk1@bcbstx.com')];
         System.assert(!users.isEmpty());
         Case case1 = [select id from Case where ownerid  = :users.get(1).id LIMIT 1];
         System.assert(null != case1);         
         ApexPages.currentpage().getParameters().put('id',case1.Id);
         ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(case1);
         GEMS_CaseTeamMembersController gemsCTM = new GEMS_CaseTeamMembersController(stdController);
         
         gemsCTM.addNewRowToCaseTeamList();
         
         //add member to the added row 
         gemsCTM.rowToUpdate = gemsCTM.indexedCTMList.size() -1 ;
         gemsCTM.updatedTeamMemberId = users.get(0).id;
         gemsCTM.updatedTeamMemberName = users.get(0).Name;
         gemsCTM.updateMemberNameId();
         
         //add role to the added row
         gemsCTM.updatedMemberRole = 'Underwriter';
         gemsCTM.updateMemberRole();
         
         //persist the final members to database
         gemsCTM.saveCaseTeamList();         

         List<Apexpages.Message> msgs = ApexPages.getMessages();
         for(Apexpages.Message msg:msgs){
             System.assertEquals(System.Label.GEMS_Duplicate_UW_Error_Message, msg.getSummary());
             System.assertEquals(ApexPages.Severity.WARNING, msg.getSeverity());
         }
         
         Test.stopTest();
     }
     
     private static testmethod void  testDuplicateDUWRoleInsertion(){
         Test.startTest();
         List<User> users = [select id,name from user where username in ('newduw@bcbstx.com', 'pk1@bcbstx.com')];
         System.assert(!users.isEmpty());
         Case case1 = [select id from Case where ownerid  = :users.get(1).id LIMIT 1];
         System.assert(null != case1);         
         ApexPages.currentpage().getParameters().put('id',case1.Id);
         ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(case1);
         GEMS_CaseTeamMembersController gemsCTM = new GEMS_CaseTeamMembersController(stdController);
         
         gemsCTM.addNewRowToCaseTeamList();
         
         //add member to the added row 
         gemsCTM.rowToUpdate = gemsCTM.indexedCTMList.size() -1 ;
         gemsCTM.updatedTeamMemberId = users.get(0).id;
         gemsCTM.updatedTeamMemberName = users.get(0).Name;
         gemsCTM.updateMemberNameId();
         
         //add role to the added row
         gemsCTM.updatedMemberRole = 'Dental Underwriter';
         gemsCTM.updateMemberRole();
         
         //persist the final members to database
         gemsCTM.saveCaseTeamList();         

         List<Apexpages.Message> msgs = ApexPages.getMessages();
         for(Apexpages.Message msg:msgs){
             System.assertEquals(System.Label.GEMS_Duplicate_UW_Error_Message, msg.getSummary());
             System.assertEquals(ApexPages.Severity.WARNING, msg.getSeverity());
         }
         
         Test.stopTest();
     }
}