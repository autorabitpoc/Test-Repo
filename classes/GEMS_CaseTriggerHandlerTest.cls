@isTest
private class GEMS_CaseTriggerHandlerTest
{
    static public List<Case> accSubCase;
    static public Account accRec;
    static public product2 prd;
    static public case cs2;
    static public case accStructureCase;


    @testSetup
    static void dataSetup() {

        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        List<User> userList = new List<User>();
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        User testUser2 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test2@user11.com', 'testUser2', 'test2@user.com');
        User testUser3 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test3@user11.com', 'testUser3', 'test3@user.com');
        User testUser4 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test4@user11.com', 'testUser4', 'test4@user.com');
        User testUser5 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test5@user11.com', 'testUse5', 'test5@user.com');
        User testUser6 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test6@user11.com', 'testUser6', 'test6@user.com');
        User testUser7 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test7@user11.com', 'testUser7', 'test7@user.com');
        User testUser8 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test8@user11.com', 'testUse8', 'test8@user.com');
        User testUser9 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test9@user11.com', 'testUser9', 'test9@user.com');
        User testUser10 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test10@user11.com', 'testUser10', 'test10@user.com');
        User testUser11 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test11@user11.com', 'testUser11', 'test11@user.com');
        User testUser12 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test12@user11.com', 'testUser12', 'test12@user.com');
        User testUser13 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test13@user11.com', 'testUser13', 'test13@user.com');
        User testUser14 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test14@user11.com', 'testUser14', 'test14@user.com');
        User testUser15 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test15@user11.com', 'testUser15', 'test15@user.com');
        User testUser16 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test16@user11.com', 'testUser16', 'test16@user.com');
        User testUser17 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test17@user11.com', 'testUser17', 'test17@user.com');
        User testUser18 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test18@user11.com', 'testUser18', 'test18@user.com');
        userList.add(testUser1);
        userList.add(testUser2);
        userList.add(testUser3);
        userList.add(testUser4);
        userList.add(testUser5);
        userList.add(testUser6);
        userList.add(testUser7);
        userList.add(testUser8);
        userList.add(testUser9);
        userList.add(testUser10);
        userList.add(testUser11);
        userList.add(testUser12);
        userList.add(testUser13);
        userList.add(testUser14);
        userList.add(testUser15);
        userList.add(testUser16);
        userList.add(testUser17);
        userList.add(testUser18);
        insert userList;
        accRec = new Account();
        accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec.Name = 'TestAccountForCaseTriggerHandler';
        accRec.Group_Number__c= 'B06093';
        accRec.external_id__c= 'B06093';
        accRec.BillingStreet ='Testing';
        accRec.BillingCity='TX';
        accRec.BillingState='CT';
        accRec.BillingPostalCode='534323';
        accRec.status__c = 'Active';
        accRec.AccountNumber = '012456';
        insert accRec;
        
        Entitlement en = new Entitlement();
        en.name='GEMS Process Entitlement';
        en.accountid = accRec.id;
        en.startdate = system.today();
        en.enddate = system.today();
        insert en;
        
        Entitlement en1 = new Entitlement();
        en1.name='GEMS Entitlement';
        en1.accountid = accRec.id;
        en1.startdate = system.today();
        en1.enddate = system.today();
        insert en1;
               
        List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE name='TestAccountForCaseTriggerHandler' LIMIT 1];
        System.assertEquals('TestAccountForCaseTriggerHandler',accRecQuery[0].Name);
        
        List<String> accountTeamRoleList = new  List<String>();
               
        accountTeamRoleList.add('Account Specialist');
        accountTeamRoleList.add('Benefit Coder');
        accountTeamRoleList.add('Accounts Receivable');
        accountTeamRoleList.add('Electronic Eligibility Specialist');
        accountTeamRoleList.add('Strategic Account Executive'); 
        accountTeamRoleList.add('Client Service Specialist'); 
        accountTeamRoleList.add('Client Implementation Consultant');
        accountTeamRoleList.add('Underwriter');
        accountTeamRoleList.add('Account Executive');
        accountTeamRoleList.add('Client Service Specialist.');
        accountTeamRoleList.add('Medical Underwriter');
        accountTeamRoleList.add('Marketing Service Rep');
        accountTeamRoleList.add('Implementation Manager');
        accountTeamRoleList.add('Membership Specialist');
        accountTeamRoleList.add('AEP Processor');

        List<AccountTeamMember> accTeamMemberList = new List<AccountTeamMember> ();
        for(Integer i=0; i<=13;i++) {
            AccountTeamMember accTeamMemberAccSpecialist = new AccountTeamMember ();
            accTeamMemberAccSpecialist.UserId =userList[i].id;
            accTeamMemberAccSpecialist.TeamMemberRole = accountTeamRoleList[i];
            accTeamMemberAccSpecialist.AccountId =accRec.id;
            accTeamMemberList.add(accTeamMemberAccSpecialist);
		}
        insert accTeamMemberList;
        System.assertEquals('Account Specialist',accTeamMemberList[0].TeamMemberRole);
        List<AccountTeamMember> accTeamMemberQuery=[SELECT Id, AccountId, TeamMemberRole from AccountTeamMember WHERE AccountId=:accRecQuery[0].id LIMIT 1];
        
        Opportunity oppRec = new Opportunity();
        oppRec.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        oppRec.Name='CaseTriggerHandler';
        oppRec.accountId=accRecQuery[0].Id;
        oppRec.Type='Other';
        oppRec.StageName=GEMS_UtilityClassTest.opportunityStatus();//'In Progress';
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
        insert oppRec;
        
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        case cs = new case();
        cs.accountid = accRecQuery[0].Id;
        cs.recordtypeid = caseAccountSubmissionId;
        cs.status = 'New';
        insert cs;
        
        prd =GEMS_UtilityClassTest.insertionProduct(); 
        insert prd;
     
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where AccountId=:accRecQuery[0].Id and recordtypeid = :caseAccountSubmissionId ];
        System.assertEquals('GEMS Account Submission',accSubCase[0].RecordType.Name); 
        
        accSubCase[0].Status ='In Progress';
        accSubCase[0].GEMS_Create_Account_Structure__c =true;
        accSubCase[0].GEMS_Submission_Type__c = 'New Account';
        accSubCase[0].GEMS_Submission_Sub_Type__c = 'Account Structure Change';
        accSubCase[0].GEMS_Products__c ='Dental;PPO;RX';
        accSubCase[0].Funding_Type_Multiselect__c = 'ASO'; 
        accSubCase[0].GEMS_Line_of_Business__c='ENA';
        accSubCase[0].GEMS_Effective_Date__c = system.today();
        accSubCase[0].GEMS_Case_Effective_Date__c= system.today();
        accSubCase[0].GEMS_SBC_Required__c = 'Yes';
        accSubCase[0].AccountId = accRec.Id;
        accSubCase[0].GEMS_Accum_Type__c='Manual and Electronic';
        update accSubCase[0];
       
        Gems_Attachment__c gemsattach = new Gems_Attachment__c();
        gemsattach.type__c = 'Benefit Adhoc Meeting Minutes';
        gemsattach.attachment__c = 'ts';
        gemsattach.case__c = accSubCase[0].id;
        insert gemsattach;
        
        caseteammember cs12 = gems_utilityclasstest.insertioncaseteam(accsubcase[0].id,'Additional Underwriter');
        cs12 .MemberID = userList[14].ID;
        caseteammember cs1 = gems_utilityclasstest.insertioncaseteam(accsubcase[0].id,'Dental Underwriter');
        cs1.MemberID = userList[15].ID;
        caseteammember cass3 = gems_utilityclasstest.insertioncaseteam(accsubcase[0].id,'Additional Medical Underwriter');
        cass3.MemberID = userList[17].ID;
        
        List<CaseTeamMember> caseteamlist = new List<caseTeamMember>();
        caseteamlist.add(cs12);
        caseteamlist.add(cs1);
        caseteamlist.add(cass3);
        insert caseteamlist;
    }
    
    

    private static testmethod void GEMS_CaseTriggerHandler1()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure'];
        
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        //Test.startTest(); 
        accStructureCase.status = 'Client Approval Received';
        accStructureCase.GEMS_Reserved_Group_Numbers__c = 'B06093';
        GEMS_Group_Section__c grp =  GEMS_UtilityClassTest.insertionGroupSection(acc.id,accStructureCase.id);
        grp.Case__c = accStructureCase.id;
        insert grp;
        update accStructureCase;        
        Test.stopTest();
    }
    
    
    private static testmethod void GEMS_CaseTriggerHandler2()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure'];
        
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        
        
        Case cas2 = new case();
        cas2.GEMS_account_submission_info__c = accSubCase[0].id;
        cas2.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
        cas2.status ='In progress';
         
        //Test.startTest(); 
        insert cas2;
        
        case cs1 = new case();
        cs1.parentid = cas2.id;
        cs1.GEMS_Benefit_Agreement__c = bfAgrrement.id;
        cs1.GEMS_account_submission_info__c = accStructureCase.id;
        cs1.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        cs1.Sub_Category__c = 'Account Setup Screening';
        cs1.status ='In progress';
        
        insert cs1;
        
        case cs2 = new case();
        cs2.parentid = cas2.id;
        cs2.GEMS_Benefit_Agreement__c = bfAgrrement.id;
        cs2.GEMS_account_submission_info__c = accStructureCase.id;
        cs2.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        cs2.Sub_Category__c = 'Account Setup Screening';
        cs2.status ='Approved';
        
        insert cs2;
        
        List<case> caselist = [select id,status from case where recordtype.name='GEMS BA Level Screening'];
       for(case cs:caselist){
       cs.status = 'Approved';
       }
       System.debug('+++getQueries()+'+Limits.getQueries());
       update caselist;
       Test.stopTest();
    }
    
        private static testmethod void GEMS_CaseTriggerHandler3()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure'];
        
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        
        Case cas2 = new case();
        cas2.GEMS_account_submission_info__c = accSubCase[0].id;
        cas2.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
        cas2.status ='In progress';
        
        //Test.startTest(); 
        insert cas2; 
        
        case cs1 = new case();
        cs1.parentid = cas2.id;
        cs1.GEMS_Benefit_Agreement__c = bfAgrrement.id;
        cs1.GEMS_account_submission_info__c = accStructureCase.id;
        cs1.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        cs1.Sub_Category__c = 'Medical Underwriting Screening';
        cs1.status ='In progress';
        
        insert cs1;
        List<case> caselist = [select id,status from case where recordtype.name='GEMS BA Level Screening'];
       for(case cs:caselist){
       cs.status = 'Approved';
       }
       System.debug('+++getQueries()+'+Limits.getQueries());
       update caselist;
       Test.stopTest();
    }
    
        
        private static testmethod void GEMS_CaseTriggerHandler4()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure'];
        
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        
        Case cas2 = new case();
        cas2.GEMS_account_submission_info__c = accSubCase[0].id;
        cas2.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
        cas2.status ='In progress';
         
        
        insert cas2;
        //Test.startTest(); 
        case cs1 = new case();
        cs1.parentid = cas2.id;
        cs1.GEMS_Benefit_Agreement__c = bfAgrrement.id;
        cs1.GEMS_account_submission_info__c = accSubCase[0].id;
        cs1.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        cs1.Sub_Category__c = 'Dental Benefit Coding Screening';
        cs1.status ='In progress';
        
        insert cs1;
        
        case csBCoding = new case();
        csBCoding.parentid = cas2.id;
        csBCoding.GEMS_Benefit_Agreement__c = bfAgrrement.id;
        csBCoding.GEMS_account_submission_info__c = accSubCase[0].id;
        csBCoding.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        csBCoding.Sub_Category__c = 'Benefit Coding Screening';
        csBCoding.status ='In progress';
        
        insert csBCoding;
        
        List<case> caselist = [select id,status from case where recordtype.name='GEMS BA Level Screening'];
       for(case cs:caselist){
       cs.status = 'Approved';
       }
       System.debug('+++getQueries()+'+Limits.getQueries());
       update caselist;
      
       Test.stopTest();
    }
    
            private static testmethod void GEMS_CaseTriggerHandler5()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure'];
        
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        
        Case cas2 = new case();
        cas2.GEMS_account_submission_info__c = accSubCase[0].id;
        cas2.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Screening').getRecordTypeId();
        cas2.status ='In progress';
         
        //Test.startTest(); 
        insert cas2;
        
        case cs1 = new case();
        cs1.parentid = cas2.id;
        cs1.GEMS_Benefit_Agreement__c = bfAgrrement.id;
        cs1.GEMS_account_submission_info__c = accStructureCase.id;
        cs1.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        cs1.Sub_Category__c = 'Pharmacy Coding Screening';
        cs1.status ='In progress';
        
        insert cs1;
        List<case> caselist = [select id,status from case where recordtype.name='GEMS BA Level Screening'];
       for(case cs:caselist){
       cs.status = 'Approved';
       }
       System.debug('+++getQueries()+'+Limits.getQueries());
       update caselist;
       
       Test.stopTest();
    }
    
    private static testmethod void GEMS_CaseTriggerHandler6()
    {    
        Test.startTest();
        Account acc = [select id,name,External_ID__c from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, GEMS_Effective_Date__c,GEMS_Case_Effective_Date__c,AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name,gems_account_submission_info__c from case where RecordType.Name ='GEMS Account Structure'];
        
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        
        Case cas2 = new case();
        cas2.accountid = acc.id;
        cas2.GEMS_Effective_Date__c = accSubCase[0].GEMS_Effective_Date__c;
        cas2.GEMS_Case_Effective_Date__c =accSubCase[0].GEMS_Case_Effective_Date__c;
        cas2.GEMS_account_submission_info__c = accSubCase[0].id;
        cas2.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        cas2.status ='In progress';
         
        //Test.startTest(); 
        insert cas2;
        
        case cs1 = new case();
        cs1.parentid = cas2.id;
        cs1.accountid = acc.id;
                cs1.GEMS_Effective_Date__c = accSubCase[0].GEMS_Effective_Date__c;
        cs1.GEMS_Case_Effective_Date__c =accSubCase[0].GEMS_Case_Effective_Date__c;
        cs1.GEMS_Benefit_Agreement__c = bfAgrrement.id;
        cs1.GEMS_account_submission_info__c = accSubCase[0].id;
        cs1.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
        cs1.Sub_Category__c = 'Pharmacy Coding Screening';
        cs1.status ='In progress';        
        insert cs1;
        
        List<case> caselist = [select id,status,GEMS_account_submission_info__c,GEMS_Benefit_Agreement__c from case where recordtype.name='GEMS BA Level Account Setup'];
       for(case cs:caselist){
       cs.status = 'Release Underwriting Complete';
       }
       System.debug('+++getQueries()+'+Limits.getQueries());
       update caselist;
       Test.stopTest();
    }
    

    
        private static testmethod void GEMS_CaseTriggerHandler7()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name,gems_account_submission_info__c from case where RecordType.Name ='GEMS Account Structure'];
        
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        
        Case cas2 = new case();
        cas2.GEMS_account_submission_info__c = accSubCase[0].id;
        cas2.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        cas2.status ='In progress';
         
        //Test.startTest(); 
        insert cas2;
        
        case cs1 = new case();
        cs1.parentid = cas2.id;
        cs1.GEMS_Benefit_Agreement__c = bfAgrrement.id;
        cs1.GEMS_account_submission_info__c = accStructureCase.GEMS_account_submission_info__c;
        cs1.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
        cs1.Sub_Category__c = 'Pharmacy Coding Screening';
        cs1.status ='In progress';        
        insert cs1;
        
        List<case> caselist = [select id,status from case where recordtype.name='GEMS BA Level Account Setup'];
       for(case cs:caselist){
       cs.status = 'Release Underwriting Complete';
       }
       System.debug('+++getQueries()+'+Limits.getQueries());
       update caselist;
       Test.stopTest();
    }
            //create member ship case
            private static testmethod void GEMS_CaseTriggerHandler8()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name,gems_account_submission_info__c from case where RecordType.Name ='GEMS Account Structure'];
        
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        
        Case cas2 = new case();
        cas2.GEMS_account_submission_info__c = accSubCase[0].id;
        cas2.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        cas2.status ='In progress';
         
        //Test.startTest(); 
        insert cas2;
        
        case cs1 = new case();
        cs1.parentid = cas2.id;
        cs1.GEMS_Benefit_Agreement__c = bfAgrrement.id;
        cs1.GEMS_account_submission_info__c = accStructureCase.GEMS_account_submission_info__c;
        cs1.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
        cs1.Sub_Category__c = 'Pharmacy Coding Screening';
        cs1.status ='In progress';        
        insert cs1;
        
        List<case> caselist = [select id,status from case where recordtype.name='GEMS Dental Underwriting'];
       for(case cs:caselist){
       cs.status = 'Approved';
       }
       System.debug('+++getQueries()+'+Limits.getQueries());
       update caselist;
       Test.stopTest();
    }
    
    
                //create fsu case
   private static testmethod void GEMS_CaseTriggerHandler11()
    {    
        Test.startTest(); 
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name,gems_account_submission_info__c from case where RecordType.Name ='GEMS Account Structure'];
        Id caseGEMSFSUClaimsRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS FSUClaims').getRecordTypeId();
        Id caseGEMSMedicalBenfCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        
        Case cas2 = new case();
        cas2.GEMS_account_submission_info__c = accSubCase[0].id;
        cas2.recordtypeid = caseGEMSMedicalBenfCodingRecordTypeId;
        cas2.status ='In progress';
         insert cas2;
        //Test.startTest(); 

       System.debug('+++getQueries()+'+Limits.getQueries());
       cas2.status ='Medical Benefits Production Ready';
       update cas2;
       Test.stopTest();
    }
    
                    //create fsu with case GEMS_Accum_Type__c=='Paper/Manual
   private static testmethod void GEMS_CaseTriggerHandler12()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name,gems_account_submission_info__c from case where RecordType.Name ='GEMS Account Structure'];
        Id caseGEMSFSUClaimsRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS FSUClaims').getRecordTypeId();
        Id caseGEMSMedicalBenfCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        //Test.startTest();
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1TR@user11.com', 'testUser1', 'test1@user.com');
        
        insert testUser1;
        AccountTeamMember accTeamMemberAccSpecialist = new AccountTeamMember ();
        accTeamMemberAccSpecialist.UserId =testUser1.id;
        accTeamMemberAccSpecialist.TeamMemberRole = 'Account Specialist';
        accTeamMemberAccSpecialist.AccountId =acc.id;
        //accTeamMemberList.add(accTeamMemberAccSpecialist);
        insert accTeamMemberAccSpecialist;
        
        Case cas2 = new case();
        cas2.GEMS_account_submission_info__c = accSubCase[0].id;
        cas2.recordtypeid = caseGEMSMedicalBenfCodingRecordTypeId;
        cas2.status ='In progress';
         insert cas2;
         
    accSubCase[0].GEMS_Accum_Type__c='Paper/Manual';
    update accSubCase;
       System.debug('+++getQueries()+'+Limits.getQueries());
       cas2.status ='Medical Benefits Production Ready';
       update cas2;
       Test.stopTest();
    }
    
                        //create fsu with case GEMS_Accum_Type__c==Electronic
   private static testmethod void GEMS_CaseTriggerHandler13()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name,gems_account_submission_info__c from case where RecordType.Name ='GEMS Account Structure'];
        Id caseGEMSFSUClaimsRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS FSUClaims').getRecordTypeId();
        Id caseGEMSMedicalBenfCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        
        Case cas2 = new case();
        cas2.GEMS_account_submission_info__c = accSubCase[0].id;
        cas2.recordtypeid = caseGEMSMedicalBenfCodingRecordTypeId;
        cas2.status ='In progress';
         insert cas2;
        //Test.startTest(); 
    accSubCase[0].GEMS_Accum_Type__c='Electronic';
    update accSubCase;
       System.debug('+++getQueries()+'+Limits.getQueries());
       cas2.status ='Medical Benefits Production Ready';
       update cas2;
       Test.stopTest();
    } 
   
                        //create fsu with case GEMS_Accum_Type__c=''
   private static testmethod void GEMS_CaseTriggerHandler14()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name,gems_account_submission_info__c from case where RecordType.Name ='GEMS Account Structure'];
        Id caseGEMSFSUClaimsRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS FSUClaims').getRecordTypeId();
        Id caseGEMSMedicalBenfCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        
        Case cas2 = new case();
        cas2.GEMS_account_submission_info__c = accSubCase[0].id;
        cas2.recordtypeid = caseGEMSMedicalBenfCodingRecordTypeId;
        cas2.status ='In progress';
         insert cas2;
        //Test.startTest(); 
    accSubCase[0].GEMS_Accum_Type__c='';
    update accSubCase;
       System.debug('+++getQueries()+'+Limits.getQueries());
       cas2.status ='Medical Benefits Production Ready';
       update cas2;
       Test.stopTest();
    } 

    private static testmethod void GEMS_CaseTriggerHandler15()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Id caseGEMSDentalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        
        case underwriterCase = new case();
        underwriterCase.recordtypeid = caseGEMSDentalRecordTypeId;
        underwriterCase.status = 'New';
        underwriterCase.gems_account_submission_info__c = accSubCase[0].id;
        insert underwriterCase;

         
        //Test.startTest(); 
         underwriterCase.status = 'Completed';
         update underwriterCase;
         
       
       Test.stopTest();
    } 
    
            private static testmethod void GEMS_CaseTriggerHandler16()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name,gems_account_submission_info__c from case where RecordType.Name ='GEMS Account Structure'];
        
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        
        Case cas2 = new case();
        cas2.GEMS_account_submission_info__c = accSubCase[0].id;
        cas2.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        cas2.status ='In progress';
         
        //Test.startTest(); 
        insert cas2;
        
        case cs1 = new case();
        cs1.parentid = cas2.id;
        cs1.GEMS_Benefit_Agreement__c = bfAgrrement.id;
        cs1.GEMS_account_submission_info__c = accStructureCase.GEMS_account_submission_info__c;
        cs1.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Account Setup').getRecordTypeId();
        cs1.Sub_Category__c = 'Pharmacy Coding Screening';
        cs1.status ='In progress';        
        insert cs1;
        
        List<case> caselist = [select id,status from case where recordtype.name='GEMS BA Level Account Setup'];
       for(case cs:caselist){
       cs.status = 'Release Underwriting Co';
       }
       System.debug('+++getQueries()+'+Limits.getQueries());
       update caselist;
       Test.stopTest();
    } 
        //This method to send notification when underwriter returns the case with reject reason
        private static testmethod void GEMS_CaseTriggerHandler17()
    {    
        Test.startTest(); 
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Id caseGEMSDentalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        
        case underwriterCase = new case();
        underwriterCase.recordtypeid = caseGEMSDentalRecordTypeId;
        underwriterCase.status = 'New';
        underwriterCase.gems_account_submission_info__c = accSubCase[0].id;
        insert underwriterCase;

         
        //Test.startTest(); 
         underwriterCase.status = 'Return';
         update underwriterCase;
       
       
       Test.stopTest();
    } 
    
            //This method to send notification when underwriter returns the case with reject reason and underwriterCase
        private static testmethod void GEMS_CaseTriggerHandler18()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Id caseGEMSDentalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        
        case underwriterCase = new case();
        underwriterCase.recordtypeid = caseGEMSDentalRecordTypeId;
        underwriterCase.status = 'New';
        underwriterCase.gems_account_submission_info__c = accSubCase[0].id;
        insert underwriterCase;

         
        //Test.startTest(); 
         underwriterCase.status = 'Return';
         underwriterCase.GEMS_Return_Reason__c = 'ASO Billing/BlueSTAR Issue (case sent to Accnt. Specialist)' ;
         update underwriterCase;
       
       
       Test.stopTest();
    } 
    
                //This method to check adhoc meeting minutes check when adhoc needed yes
        private static testmethod void GEMS_CaseTriggerHandler19()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Id caseGEMGetRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS GET').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        
        case getCase = new case();
        getCase.recordtypeid = caseGEMGetRecordTypeId;
        getCase.GEMS_Client_Kickoff_Meeting_Comp_Date__c = System.today();
        getCase.status = 'New';
        getCase.GEMS_Verify_Benefit_Adhoc_Needed__c ='No';
        getCase.GEMS_Implementation_Is_Closed__c = true;
        getCase.gems_account_submission_info__c = accSubCase[0].id;
        insert getCase;

         
        //Test.startTest(); 
        getCase.GEMS_Verify_Benefit_Adhoc_Needed__c = 'Yes';
        getCase.GEMS_Internal_Benefit_Meeting_Start_Date__c = System.today();
        getCase.GEMS_Internal_Benefit_Meeting_Comp_Date__c= System.today();
        getCase.GEMS_External_Benefit_Meeting_Comp_Date__c= System.today();
        getCase.GEMS_External_Benefit_Meeting_Start_Date__c= System.today();
         getCase.status = 'Completed';
         update getCase;
       
       
       Test.stopTest();
    } 
        //This method to update Parent case when all child process cases of all BA's approved
     private static testmethod void GEMS_CaseTriggerHandler20()  {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Id caseDentalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
        Id caseMedicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
        Id caseAdditionalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();
        Set<String> underwritingSet = new Set<String>{caseDentalId,caseMedicalId,caseAdditionalId};
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name,gems_account_submission_info__c from case where RecordType.Name ='GEMS Account Structure'];
        
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        
        Case cas2 = new case();
        cas2.GEMS_account_submission_info__c = accSubCase[0].id;
        cas2.ownerId = [select id,parentId,memberid,Teamrole.name from CaseTeammember where teamrole.name ='Account Specialist'].memberid;
        cas2.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        cas2.status ='In progress';
        cas2.GEMS_AEP_Account__c = false;
        //Test.startTest(); 
        insert cas2;

        
       List<case> caselist = [select id,status from case where recordtype.name='GEMS Account Setup'];
       for(case cs:caselist){
       cs.status ='Release Underwriting Complete';
       }
       System.debug('+++getQueries()+'+Limits.getQueries());
       update caselist;
       
       Id EntitlementIdT  = [SELECT Id,Name FROM Entitlement WHERE Name = 'GEMS Process Entitlement'].Id;
       MilestoneType mst = [SELECT id from MilestoneType where Name='GEMS Account Setup'];
       List<case> caseEntAslist = [select id,status from case where recordtype.name='GEMS Account Setup'];
       
       for(case cs: caseEntAslist){
       cs.entitlementId =EntitlementIdT;
       }
       update caseEntAslist;
       
       List<case> caseStatlist = [select id,status from case where recordtype.name='GEMS Account Setup'];
       for(case cs: caseStatlist){
       cs.GEMS_Effective_Date__c = System.today();
       cs.status = 'Release Underwriting Complete';
       }
       System.debug('+++getQueries()+'+Limits.getQueries());
       update caseStatlist;
       
       Test.stopTest();
    } 
    
    private static testmethod void GEMS_CaseTriggerHandlerUW()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name,gems_account_submission_info__c from case where RecordType.Name ='GEMS Account Structure'];
        User user8 = [select id, name from user where email = 'test18@user.com'];
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        
        accSubCase[0].GEMS_Submission_Sub_Type__c = null;
        accSubCase[0].ownerId = user8.Id;
        update accSubCase[0];
        
        Case casMBC = new case();
        casMBC.GEMS_account_submission_info__c = accSubCase[0].id;
        
        casMBC.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        //casMBC.status ='New';
        casMBC.status ='In progress';
        casMBC.GEMS_AEP_Account__c = false;
         
        insert casMBC;
        // casMBC.status ='In progress';
        // update casMBC;
        
        Case casMBCChild = new case();
        casMBCChild.GEMS_account_submission_info__c = accSubCase[0].id;
        
        casMBCChild.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();
        casMBCChild.status ='In progress';
        casMBCChild.GEMS_AEP_Account__c = false;
        casMBCChild.parentId = casMBC.Id;
        insert casMBCChild;
        //GEMS_MBCTestingCreate.NewMBCTest(casMBCChild.id,'DTU');
         
         GEMS_MBC_Testing__c NewMBCTestRec = new GEMS_MBC_Testing__c();
         NewMBCTestRec.MBC_BA_Level_Case_DTU__c = casMBCChild.id;  
         NewMBCTestRec.Status__c = 'In Progress';
         insert  NewMBCTestRec;
         NewMBCTestRec.Status__c = 'In Progress';
         update NewMBCTestRec;
        Profile mbcprofilerec = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        User mbctestuser = GEMS_UtilityClassTest.CreateUserRecord(mbcprofilerec.Id, 'mbctest@user11.com', 'mbctest', 'mbctest@user.com');
        insert mbctestuser;
        casMBCChild.OwnerId = mbctestuser.id; 
        casMBCChild.status = 'In Progress';//US 5230 changed the picklist value
        update casMBCChild;
        
        Case casUW = new case();
        casUW.GEMS_account_submission_info__c = accSubCase[0].id;
        
        casUW.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
        casUW.status ='In progress';
        casUW.GEMS_AEP_Account__c = false;
         
        insert casUW;
        Test.stopTest();
       } 
        private static testmethod void GEMS_CaseTriggerHandlerUW1()
    { 
    Test.startTest();
       List<case> underwriterCaseList = [select id,status from case where recordtype.name in ('GEMS Medical Underwriting','GEMS Dental Underwriting','GEMS Additional Underwriting') limit 1];
       if(!underwriterCaseList.isEmpty()) {
           for(Case uwCase : underwriterCaseList) {
               uwCase.status = 'Approved';
           }
           update underwriterCaseList;
       } 
       Test.stopTest();
       
    } 
    
   private static testmethod void GEMS_CaseTriggerHandler21()  { 
        
        //Test.startTest();
        Account acc = [select id,name from account limit 1];
         
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Id caseSBCId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();
        Id caseBASBCId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level SBC').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId limit 1];
        accStructureCase =[select id,RecordType.Name,gems_account_submission_info__c,status from case where RecordType.Name ='GEMS Account Structure' limit 1];     
        Product2 prod = [select id,name from product2 limit 1];
        //Test.stopTest();
        Test.startTest();
        System.debug('==accStructureCase.id=='+accStructureCase.id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase.id;
        insert bfAgrrement;
        GEMS_Group_Section__c grp =  GEMS_UtilityClassTest.insertionGroupSection(acc.id,accStructureCase.id);
        grp.Case__c = accStructureCase.id;
        
        insert grp;
        //Test.stopTest();
        

        
        accStructureCase.status = 'Client Approval Received';
        update accStructureCase;
        Case cas2 = new case();
        cas2.GEMS_account_submission_info__c = accSubCase[0].id;
        //cas2.ownerId = [select id,parentId,memberid,Teamrole.name from CaseTeammember where teamrole.name ='Account Specialist'].memberid;
        // cas2.recordtypeid = caseSBCId; // #FIX IT
        // cas2.status ='In progress';
        
        insert cas2;
        
        
        accStructureCase.status = 'In Progress';
        update accStructureCase;
        Case cas2Child = new case();
        cas2Child.GEMS_account_submission_info__c = accSubCase[0].id;
        //cas2.ownerId = [select id,parentId,memberid,Teamrole.name from CaseTeammember where teamrole.name ='Account Specialist'].memberid;
        cas2Child.recordtypeid = caseBASBCId;
        cas2Child.parentId = cas2.Id;
        cas2Child.status ='In progress';

        insert cas2Child;
        Test.stopTest();
        
    } 
  
    
    private static testmethod void childCaseStatusTOCancelledTest2(){
        Test.startTest();
        Profile profileRec = [SELECT Id FROM Profile where Name = 'GEMS Account Specialist' Limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        User u1 = [Select id, name, email from User where id=: UserInfo.getUserId()];
        User u2= GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test2TR@user12.com', 'testUser2', 'test2@user.com');
        insert u2;
        Map<id,id> c = new Map<id,id>();
        case csp1 = new case();
        csp1.recordtypeid = caseAccountSubmissionId;
        csp1.status = 'New';
        csp1.OwnerId = u1.Id;
        insert csp1;
        c.put(csp1.Id,csp1.OwnerId);
        
        

        case csc1 = new case();
 
        csc1.recordtypeid = caseAccountSubmissionId;
        csc1.status = 'In Progress';
        csc1.GEMS_Account_Submission_Info__c = csp1.Id;
        insert csc1;
        
        //Child case creation
         case csc2 = new case();
        //csc1.accountid = accRecQuery1[0].Id;
        csc2.recordtypeid = caseAccountSubmissionId;
        csc2.status = 'Closed';
        csc2.GEMS_Account_Submission_Info__c = csp1.Id;
        insert csc2;
        
        List<Task> taskList = new List<Task>();

        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'BlueSTAR Entry Complete';
        //taskElig.GEMS_start_date__c = System.now();
        taskElig.whatId = csc1.Id;
        //taskElig.ownerId = [select id,memberid from caseteammember where teamrole.name ='Electronic Eligibility Specialist'].memberid;
        //taskObj.status = 'In progress';
        taskElig.Priority = 'Normal';
        taskList.add(taskElig);
        
        insert taskList;
        
        
 
        system.runAs(u1){
        
        //System.assertEquals(1,c.size());
        
        csp1.Status = 'Cancelled';
            
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'GEMS_Main_Cancellation_Email_Template';
        validEmailTemplate.DeveloperName = 'GEMS_Main_Cancellation_Email_Template';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();

        insert validEmailTemplate;
            
            
        Contact cont = new Contact();
        cont.FirstName = 'No Reply';
        cont.LastName = 'GEMS';
        cont.email = 'no-reply@hcsc.com';
        insert cont;
         
        
            
        update csp1;
        System.assertNotEquals('Cancelled',csc1.status);
        System.assertNotEquals('Cancelled',csc2.status);
        Test.stopTest(); 
       }
   } 
   
    private static testmethod void childCaseStatusTOCancelledTest3(){
        Test.startTest();
        Profile profileRec = [SELECT Id FROM Profile where Name = 'GEMS Account Specialist' Limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseRxCodingId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        User u1 = [Select id, name, email from User where id=: UserInfo.getUserId()];
        User u2= GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test2TR@user12.com', 'testUser2', 'test2@user.com');
        insert u2;
        Map<id,id> c = new Map<id,id>();
        case csp1 = new case();
        csp1.recordtypeid = caseAccountSubmissionId;
        csp1.status = 'New';
        csp1.OwnerId = u1.Id;
        insert csp1;
        
        
        caseteammember cs12 = gems_utilityclasstest.insertioncaseteam(csp1.id,'Account Specialist');
        cs12.MemberID = u2.ID;       
        insert cs12;
        
        c.put(csp1.Id,csp1.OwnerId);

        case csc1 = new case();
 
        csc1.recordtypeid = caseRxCodingId;
        csc1.status = 'In Progress';
        csc1.GEMS_Account_Submission_Info__c = csp1.Id;
        insert csc1;
        
        //Child case creation
         case csc2 = new case();
        //csc1.accountid = accRecQuery1[0].Id;
        csc2.recordtypeid = caseAccountSubmissionId;
        csc2.status = 'In Progress';
        csc2.GEMS_Account_Submission_Info__c = csp1.Id;
        insert csc2;
        
        GEMS_Pharmacy_Scope_Code__c rxCode = new GEMS_Pharmacy_Scope_Code__c();
        rxCode.Status__c = 'In Progress';
        rxCode.Case__c = csc1.id;
        rxCode.Accums_Integration__c = 'No';
        rxCode.Copay_Type__c = 'Flat';
        rxCode.Formulary_Type__c = 'Basic';
        rxCode.Group_Pay_Code__c = '1234';
        rxCode.Prime_Plan_ID__c = '123456';
        rxCode.Name = '1234';
        rxCode.Scope_Status__c = 'No Scope Code Changes';
        
        insert rxCode;        

        List<Task> taskList = new List<Task>();

        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'BlueSTAR Entry Complete';
        //taskElig.GEMS_start_date__c = System.now();
        taskElig.whatId = rxCode.Id;
        //taskElig.ownerId = [select id,memberid from caseteammember where teamrole.name ='Electronic Eligibility Specialist'].memberid;
        //taskObj.status = 'In progress';
        taskElig.Priority = 'Normal';
        taskList.add(taskElig);
        
        insert taskList;

        system.runAs(u1){
        
        //System.assertEquals(1,c.size());
        
        csp1.Status = 'Cancelled';
            
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'GEMS_Main_Cancellation_Email_Template';
        validEmailTemplate.DeveloperName = 'GEMS_Main_Cancellation_Email_Template';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();

        insert validEmailTemplate;
            
            
        Contact cont = new Contact();
        cont.FirstName = 'No Reply';
        cont.LastName = 'GEMS';
        cont.email = 'no-reply@hcsc.com';
        insert cont;
            
        update csp1;
        System.assertNotEquals('Cancelled',csc1.status);
        System.assertNotEquals('Cancelled',csc2.status);
        Test.stopTest(); 
       }
   }     

  private static testmethod void cancelDownstreamAccountMaintenanceCases(){
        Test.startTest();
        Profile profileRec = [SELECT Id FROM Profile where Name = 'GEMS Account Specialist' Limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
        Id caseRxCodingId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        User u1 = [Select id, name, email from User where id=: UserInfo.getUserId()];
        User u2= GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test2TR@user12.com', 'testUser2', 'test2@user.com');
        insert u2;
        
    
        
        Map<id,id> c = new Map<id,id>();
        case csp1 = new case();
        csp1.recordtypeid = caseAccountSubmissionId;
        csp1.status = 'New';
        csp1.GEMS_Submission_Type__c = 'Renewal';
        csp1.GEMS_Submission_Sub_Type__c = 'New Account';
        csp1.GEMS_Case_Effective_Date__c = System.Today();
        csp1.OwnerId = u1.Id;
        insert csp1;
        c.put(csp1.Id,csp1.OwnerId);
        
        caseteammember cs12 = gems_utilityclasstest.insertioncaseteam(csp1.id,'Account Specialist');
        cs12.MemberID = u2.ID;       
        insert cs12;

        case csc1 = new case();
 
        csc1.recordtypeid = caseAccountSubmissionId;
        csc1.status = 'In Progress';
        csc1.GEMS_Account_Submission_Info__c = csp1.Id;
        csc1.GEMS_Case_Effective_Date__c = System.Today();
        insert csc1;
        
        case psc1 = new case();
 
        psc1.recordtypeid = caseRxCodingId;
        psc1.status = 'In Progress';
        psc1.GEMS_Account_Submission_Info__c = csp1.Id;
        insert psc1;
        
        //Child case creation
         case csc2 = new case();
        //csc1.accountid = accRecQuery1[0].Id;
        csc2.recordtypeid = caseAccountSubmissionId;
        csc2.status = 'Closed';
        csc2.GEMS_Account_Submission_Info__c = csp1.Id;
        csc2.GEMS_Case_Effective_Date__c = System.Today();
        insert csc2;
        
        
         GEMS_Pharmacy_Scope_Code__c rxCode = new GEMS_Pharmacy_Scope_Code__c();
        rxCode.Status__c = 'In Progress';
        rxCode.Case__c = psc1.id;
        rxCode.Accums_Integration__c = 'No';
        rxCode.Copay_Type__c = 'Flat';
        rxCode.Formulary_Type__c = 'Basic';
        rxCode.Group_Pay_Code__c = '1234';
        rxCode.Prime_Plan_ID__c = '123456';
        rxCode.Name = '1234';
        rxCode.Scope_Status__c = 'No Scope Code Changes';
        
        insert rxCode;       

        List<Task> taskList = new List<Task>();

        task taskElig = new task();
        taskElig.status = 'Not Started';
        taskElig.subject = 'BlueSTAR Entry Complete';
        //taskElig.GEMS_start_date__c = System.now();
        taskElig.whatId = psc1.Id;
        //taskElig.ownerId = [select id,memberid from caseteammember where teamrole.name ='Electronic Eligibility Specialist'].memberid;
        //taskObj.status = 'In progress';
        taskElig.Priority = 'Normal';
        taskList.add(taskElig);
        
        insert taskList; 
       
        system.runAs(u1){
            //System.assertEquals(1,c.size());
            csp1.Status = 'Cancelled';
            update csp1;
            Test.stopTest();
            System.assertNotEquals('Cancelled',csc1.status);
            System.assertNotEquals('Cancelled',csc2.status);
            
        }
  }    
  
  private static testmethod void testCreateAcctSetUpProcessCase()
  {    
      Test.startTest();
      Account acc = [select id,name from account limit 1];
      Id caseAccMainteRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();      
      Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
      Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
      accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name, recordtypeid, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c from Case where recordtypeid = :caseAccountSubmissionId ];
      accStructureCase =[select id,RecordType.Name, recordtypeid, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c from case where RecordType.Name ='GEMS Account Structure'];

      Product2 prod = [select id,name from product2 limit 1];
      System.debug('==accStructureCase.id=='+accStructureCase.id);
      System.debug('==prd.id=='+prod.id);
      GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase.id,prod.id);
      bfAgrrement.AccountStructureCase__c = accStructureCase.id;
      insert bfAgrrement;
      //Test.startTest(); 
      accStructureCase.status = 'Client Approval Received';
      accStructureCase.GEMS_Reserved_Group_Numbers__c = 'B06093';
      GEMS_Group_Section__c grp =  GEMS_UtilityClassTest.insertionGroupSection(acc.id,accStructureCase.id);
      grp.Case__c = accStructureCase.id;
      insert grp;
      // change type to the Account Structure maintenance submission and structure cases
      accSubCase[0].recordtypeid = caseAccMainteRecTypeId;
      accSubCase[0].GEMS_Submission_Type__c = 'Account Structure Maintenance';
      accSubCase[0].GEMS_Submission_Sub_Type__c = 'Add Characteristics';
      accStructureCase.GEMS_Submission_Type__c = 'Account Structure Maintenance';
      accStructureCase.GEMS_Submission_Sub_Type__c = 'Add Characteristics';
      update accStructureCase;        
      Test.stopTest();
  } 
    private static testmethod void GEMS_MBCOwnerChange()
    {    
        Test.startTest();
        Account acc = [select id,name from account limit 1];
       Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId limit 1];
        User user8 = [select id, name from user where email = 'test18@user.com' limit 1];
        Product2 prod = [select id,name from product2 limit 1];
               
        accSubCase[0].GEMS_Submission_Sub_Type__c = null;
        accSubCase[0].ownerId = user8.Id;
        update accSubCase[0];
        
        Case casMBCChild = new case();
        casMBCChild.GEMS_account_submission_info__c = accSubCase[0].id;
        
        casMBCChild.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();
        insert casMBCChild;
        
   User user7 = [select id, name from user where email = 'test17@user.com'];
        casMBCChild.OwnerId = user7.id;
    GEMS_MBC_Testing__c dTest = new GEMS_MBC_Testing__c();
    GEMS_MBC_Testing__c fTest = new GEMS_MBC_Testing__c();
    GEMS_MBC_Testing__c ftTest = new GEMS_MBC_Testing__c();
    GEMS_MBC_Testing__c sTest = new GEMS_MBC_Testing__c();
    GEMS_MBC_Testing__c cTest = new GEMS_MBC_Testing__c();
    cTest.MBC_BA_Level_Case_CDHP__c = casMBCChild.id;
    dTest.MBC_BA_Level_Case_DTU__c = casMBCChild.id;
    fTest.MBC_BA_Level_Case_FEAK__c = casMBCChild.id;
    ftTest.MBC_BA_Level_Case_FEAK_Testing__c = casMBCChild.id;
    sTest.MBC_BA_Level_Case_Shared_Accums__c = casMBCChild.id;
    sTest.Case_Owner_Email__c = Null;
    //Test.startTest();
    insert cTest;
    insert dTest;
    insert fTest;
    insert ftTest;
    insert sTest;
        update casMBCChild;
        Test.stopTest();
       }    

 
    private static testmethod void updateEligibilityCasesOwner(){
        Test.startTest();
        //Profile profileRec = [SELECT Id FROM Profile where Name = 'GEMS Account Specialist' Limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccMainteRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Eligibility').getRecordTypeId(); 
        Id idCardCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();            
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name, recordtypeid, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c from Case where recordtypeid = :caseAccountSubmissionId Limit 1];
        
        User u1 = [Select id, name, email from User where id=: UserInfo.getUserId()];
       
        case csp1 = new case();
        csp1.recordtypeid = caseAccountSubmissionId;
        csp1.status = 'New';
        csp1.GEMS_Submission_Type__c = 'Renewal';
        csp1.GEMS_Submission_Sub_Type__c = 'New Account';
        csp1.OwnerId = u1.Id;
        insert csp1;
        
        case cs1 = new case();
        cs1.recordtypeid = caseAccMainteRecTypeId;
        cs1.GEMS_Account_Submission_Info__c = csp1.id;
        cs1.status = 'In Progress';
        cs1.GEMS_Submitter__c = UserInfo.getUserId();
        cs1.ClosedDate = System.Today();
        insert cs1;
        
        case cs2 = new case();
        cs2.recordtypeid = idCardCaseRecordTypeId;
        cs2.GEMS_Account_Submission_Info__c = csp1.id;
        cs2.status = 'In Progress';
        cs2.GEMS_Submitter__c = UserInfo.getUserId();
        insert cs2;
        System.AssertEquals(cs1.GEMS_Account_Submission_Info__c,cs2.GEMS_Account_Submission_Info__c);
        System.AssertEquals(cs1.GEMS_Account_Submission_Info__c,cs2.GEMS_Account_Submission_Info__c);
        
        csp1.GEMS_Effective_date__c= system.today() +5;
        csp1.GEMS_Case_Effective_Date__c=system.today() +5;
        update csp1;
    Test.stopTest();
} 

private static testmethod void updateMUW(){
 Test.startTest();
        //Profile profileRec = [SELECT Id FROM Profile where Name = 'GEMS Account Specialist' Limit 1];
         Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
    
        User u1 = [Select id, name, email from User where id=: UserInfo.getUserId()];
        case csp1 = new case();
        csp1.recordtypeid = caseAccountSubmissionId;
        csp1.status = 'In Progress';
        csp1.GEMS_Submission_Type__c = 'New Account';
        //csp1.GEMS_Submission_Sub_Type__c = 'Changes to Rates Only with Dental, No Benefit Change';
        csp1.Type = 'Account Submission';
        csp1.GEMS_POR_BOB__c = 'No';
        csp1.GEMS_Are_commissions_changing__c = 'No';
        csp1.GEMS_Are_commissions_paid_for_account__c = 'No';
        csp1.OwnerId = u1.Id;
        insert csp1;
        
        csp1.GEMS_POR_BOB__c = 'POR';
        csp1.GEMS_Are_commissions_changing__c = 'Yes';
        csp1.GEMS_Are_commissions_paid_for_account__c = 'Yes';
        update csp1;
        system.debug('----csp1------'+csp1);
        case cs1 = new case();
        //cs1.recordtypeid = caseAccMainteRecTypeId;
        cs1.GEMS_Account_Submission_Info__c = csp1.id;
        cs1.status = 'In Progress';
        cs1.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        cs1.Type = 'Medical Underwriting';
        csp1.GEMS_AEP_Account__c = false;
        insert cs1; 
        system.debug('----cs1------'+cs1);

       
    Test.stopTest();
 }
    
  /*private static testmethod void incrementCaseNumber(){
  
  Test.startTest();
  Id sbcRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId(); 
  Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();    
   User u1 = [Select id, name, email from User where id=: UserInfo.getUserId()];   
      case cse = new case();
        cse.recordtypeid = caseAccountSubmissionId;
        cse.status = 'New';
        cse.GEMS_Submission_Type__c = 'Renewal';
        cse.GEMS_Submission_Sub_Type__c = 'New Account';
        cse.OwnerId = u1.Id;
        insert cse;
      
      case sbc1 = new case();
      sbc1.recordtypeid = sbcRecordTypeId;
      sbc1.GEMS_Account_Submission_Info__c = cse.id;
      insert sbc1;
      Test.StopTest();
  
  } */
 private static testmethod void parentReleaseToUnderwriterUpdation(){
 Test.startTest();
 Id accountSetupParentRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
 Id caseAccMainteRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
 Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
     User u1 = [Select id, name, email from User where id=: UserInfo.getUserId()];
        
        case cse = new case();
        cse.recordtypeid = caseAccountStructureId;
        cse.status = 'New';
        cse.GEMS_Submission_Type__c = 'Account Structure Maintenance';
        cse.OwnerId = u1.Id;
        cse.Type = 'Account Structure';
        insert cse;
        
        case cs1 = new case();
        cs1.recordtypeid = accountSetupParentRecordTypeId;
        cs1.status = 'New';
        insert cs1;
        cs1.status = 'Release Underwriting Complete';
        update cs1;
         Test.StopTest();
        } 
       
       private static testmethod void parentStatusChangeOnChildPharmacyCaseChange(){
       Test.startTest();
       Id pharmacyCodingCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();
        Id accountStructureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId(); 
        /*Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        case css = new case();
        css.recordtypeid = caseAccountSubmissionId;
        css.status = 'New'; 
        insert css; */
        
        case csp = new case();
        csp.recordtypeid = accountStructureRecordTypeId;
        csp.status = 'New'; 
        //csp.GEMS_Account_Submission_Info__c = css.id;
        insert csp;
        
        case cse = new case();
        cse.recordtypeid = pharmacyCodingCasesRecordTypeId;
        cse.status = 'New'; 
        cse.parentId = csp.id;
        insert cse;
        cse.status = 'Completed';
        update cse;
        Test.StopTest();
       }
    
       private static testmethod void updateUnderwriterFlagOnMedicalBenefitCoding(){
       Test.startTest();
        Id caseGEMSMedicalRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
            Id caseGEMSMedicalBenfCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
            Id caseGEMSDentalBenfCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
            Id caseGEMSAccountSubmissionRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
          
        case css = new case();
        css.recordtypeid = caseGEMSAccountSubmissionRecordTypeId;
        css.status = 'New';
        css.GEMS_XAccountHas_signed_2017BPA_attached__c = 'Yes'; 
        insert css;
        
        case csm = new case();
        csm.recordtypeid = caseGEMSMedicalBenfCodingRecordTypeId;
        csm.status = 'New'; 
        csm.GEMS_Account_Submission_Info__c = css.id;
        insert csm;
        
        case csp = new case();
        csp.recordtypeid = caseGEMSMedicalRecordTypeId ;
        csp.status = 'New'; 
        csp.GEMS_Account_Submission_Info__c = css.id;
        insert csp; 
         csp.status = 'Completed';
         update csp; 
        Test.StopTest();    
        }       
    
		private static testmethod void idcardMaintenanceTest(){
            Test.startTest();
     		List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE name='TestAccountForCaseTriggerHandler' LIMIT 1];
            System.assertEquals('TestAccountForCaseTriggerHandler',accRecQuery[0].Name);
            
            List<String> accountTeamRoleList = new  List<String>();
                   
            accountTeamRoleList.add('Account Specialist');
            accountTeamRoleList.add('Benefit Coder');
            accountTeamRoleList.add('Accounts Receivable');
            accountTeamRoleList.add('Electronic Eligibility Specialist');
            accountTeamRoleList.add('Strategic Account Executive'); 
            accountTeamRoleList.add('Client Service Specialist'); 
            accountTeamRoleList.add('Client Implementation Consultant');
            accountTeamRoleList.add('Underwriter');
            accountTeamRoleList.add('Account Executive');
            accountTeamRoleList.add('Client Service Specialist.');
            accountTeamRoleList.add('Medical Underwriter');
            accountTeamRoleList.add('Marketing Service Rep');
            accountTeamRoleList.add('Implementation Manager');
            accountTeamRoleList.add('Membership Specialist');
            accountTeamRoleList.add('AEP Processor');
    
            List<AccountTeamMember> accTeamMemberList = new List<AccountTeamMember> ();
            Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        	List<User> userList = new List<User>();
        	User testUser19 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test19@user11.com', 'testUser19', 'test19@user.com');
        	userList.add(testUser19);
        	insert userList;
            
            Account accRec = new Account();
            accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
            accRec.Name = 'Maintenance Test Account';
            accRec.Group_Number__c= 'B06092';
            accRec.external_id__c= 'B06092';
            accRec.BillingStreet ='Testing';
            accRec.BillingCity='TX';
            accRec.BillingState='CT';
            accRec.BillingPostalCode='534323';
            accRec.status__c = 'Active';
            accRec.AccountNumber = 'PK1234';
            insert accRec;
            
            
            
            AccountTeamMember accTeamMemberAccSpecialist = new AccountTeamMember ();
            accTeamMemberAccSpecialist.UserId =userList[0].id;
            accTeamMemberAccSpecialist.TeamMemberRole = accountTeamRoleList[0];
            accTeamMemberAccSpecialist.AccountId =accRec.id;
            accTeamMemberList.add(accTeamMemberAccSpecialist);
            insert accTeamMemberList;
            
            System.assertEquals('Account Specialist',accTeamMemberList[0].TeamMemberRole);
            List<AccountTeamMember> accTeamMemberQuery=[SELECT Id, AccountId, TeamMemberRole from AccountTeamMember WHERE AccountId=:accRecQuery[0].id LIMIT 1];
            
            Id accountMaintenanceId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
            case cs = new case();
            cs.accountid = accRecQuery[0].Id;
            cs.recordtypeid = accountMaintenanceId;
            cs.status = 'New';
            cs.GEMS_Submission_Type__c = 'ID Card Maintenance';
            cs.GEMS_Submission_Sub_Type__c = 'ID Card Changes, No Benefit Changes';
            insert cs;
            
            
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where AccountId=:accRecQuery[0].Id and recordtypeid = :accountMaintenanceId ];
        System.assertEquals('Account Maintenance',accSubCase[0].RecordType.Name); 
        
        accSubCase[0].Status ='In Progress';
        accSubCase[0].GEMS_Create_Account_Structure__c =true;
        accSubCase[0].GEMS_Submission_Type__c = 'ID Card Maintenance';
        accSubCase[0].GEMS_Submission_Sub_Type__c = 'ID Card Changes, No Benefit Changes';
        accSubCase[0].GEMS_Products__c ='Dental;PPO;RX';
        accSubCase[0].Funding_Type_Multiselect__c = 'ASO'; 
        accSubCase[0].GEMS_Line_of_Business__c='ENA';
        accSubCase[0].GEMS_Effective_Date__c = system.today();
        accSubCase[0].GEMS_Case_Effective_Date__c= system.today();
        accSubCase[0].GEMS_SBC_Required__c = 'Yes';
        accSubCase[0].AccountId = accRec.Id;
        accSubCase[0].GEMS_Accum_Type__c='Manual and Electronic';
        accSubCase[0].GEMS_ID_Cards_Format__c = 'Custom';
        update accSubCase[0];
       

            
            
        Gems_Attachment__c gemsattach = new Gems_Attachment__c();
        gemsattach.type__c = 'Benefit Adhoc Meeting Minutes';
        gemsattach.attachment__c = 'ts';
        gemsattach.case__c = accSubCase[0].id;
        insert gemsattach;
        
        Case idcardCase = new Case();
        idCardCase.GEMS_Account_Submission_Info__c = accSubCase[0].id;
        idCardCase.GEMS_Submission_Type__c = 'ID Card Maintenance';
        idCardCase.GEMS_Submission_Sub_Type__c = 'ID Card Changes, No Benefit Changes';
        idCardCase.GEMS_ID_Cards_Format__c = 'Custom';
        idCardCase.Status = 'In Progress';
        idCardCase.RecordTypeId = SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        idCardCase.GEMS_Line_of_Business__c='ENA';
        idCardCase.GEMS_Effective_Date__c = system.today();
        idCardCase.GEMS_Case_Effective_Date__c= system.today();
        insert idCardCase;
            
        idCardCase.status = 'Completed';
        update idCardCase;
        Test.StopTest();    
        }
    
}