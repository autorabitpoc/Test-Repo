@isTest
private class GEMS_FWCaseTriggerHandlerTest
{
    static public List<Case> accSubCase;
    static public Account accRec;
    static public product2 prd;
    static public case cs2;
    static public List<case> accStructureCase;
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
        
        account accRec1 = new Account();
        accRec1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec1.Name = 'TestAccountForCaseTriggerHandler1';
        accRec1.Group_Number__c= 'B06092';
        accRec1.external_id__c= 'B06092';
        accRec1.BillingCity='TX';
        accRec1.BillingState='CT';
        accRec1.BillingPostalCode='534323';
        accRec1.status__c = 'Active';
        
        account accRec2 = new Account();
        accRec2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec2.Name = 'TestAccountForCaseTriggerHandler2';
        accRec2.Group_Number__c= 'B06091';
        accRec2.external_id__c= 'B06091';
        accRec2.BillingCity='TX';
        accRec2.BillingState='CT';
        accRec2.BillingPostalCode='535323';
        accRec2.status__c = 'Active';
        
        List<Account> acclist = new List<Account>();
        acclist.add(accRec);
        acclist.add(accRec1);
        acclist.add(accRec2);
        insert acclist;
        
        contact con = new contact();
        con.firstName='gems tesing';
        con.lastname='teting';
        con.Phone='(123) 456-7888'; 
        con.Email='testing@gems.com';
        
        con.accountid= acclist[0].id;
        con.Type__c = 'Billing' ;

        

        
         contact con1 = new contact();
        con1.firstName='gems tesing1';
        con1.lastname='teting1';
        con1.Email='testing1@gems.com';
        con1.MobilePhone='(122) 342-3232';
        con1.accountid= acclist[1].id;
        con1.Type__c = 'Billing' ;
        
        contact con2 = new contact();
        con2.firstName='gems tesing2';
        con2.lastname='teting2';
        //con1.Email='testing1@gems.com';
        con2.MobilePhone='(122) 582-3232';
        con2.accountid= acclist[2].id;
        con2.Type__c = 'Billing' ;
        
        List<contact> conlist = new List<Contact>();
        conlist.add(con);
        conlist.add(con1);
        conlist.add(con2);
        insert conlist;
        
        Entitlement en = new Entitlement();
        en.name='Testing';
        en.accountid = acclist[0].id;
        en.startdate = system.today();
        en.enddate = system.today();
        insert en;
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
        accountTeamRoleList.add('Sales Executive'); 
        accountTeamRoleList.add('Director Account Management'); 
        accountTeamRoleList.add('VP Account Management');
       

        List<AccountTeamMember> accTeamMemberList = new List<AccountTeamMember> ();
        for(Integer i=0; i<=9;i++)
        {
            AccountTeamMember accTeamMemberAccSpecialist = new AccountTeamMember ();
            accTeamMemberAccSpecialist.UserId =userList[i].id;
            accTeamMemberAccSpecialist.TeamMemberRole = accountTeamRoleList[i];
            accTeamMemberAccSpecialist.AccountId =acclist[0].id;
            accTeamMemberList.add(accTeamMemberAccSpecialist);

        }
         for(Integer i=0; i<=9;i++)
        {
            AccountTeamMember accTeamMemberAccSpecialist = new AccountTeamMember ();
            accTeamMemberAccSpecialist.UserId =userList[i].id;
            accTeamMemberAccSpecialist.TeamMemberRole = accountTeamRoleList[i];
            accTeamMemberAccSpecialist.AccountId =acclist[1].id;
            accTeamMemberList.add(accTeamMemberAccSpecialist);

        }
        
        for(Integer i=0; i<=9;i++)
        {
            AccountTeamMember accTeamMemberAccSpecialist = new AccountTeamMember ();
            accTeamMemberAccSpecialist.UserId =userList[i].id;
            accTeamMemberAccSpecialist.TeamMemberRole = accountTeamRoleList[i];
            accTeamMemberAccSpecialist.AccountId =acclist[2].id;
            accTeamMemberList.add(accTeamMemberAccSpecialist);

        }
        
        insert accTeamMemberList;

        
        
        List<Opportunity> optyList = new List<Opportunity>();
        Opportunity oppRec = new Opportunity();
        oppRec.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        oppRec.Name='CaseTriggerHandler';
        oppRec.accountId=acclist[0].Id;
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
        
        
        Opportunity oppRec1 = new Opportunity();
        oppRec1.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        oppRec1.Name='CaseTriggerHandler';
        oppRec1.accountId=acclist[1].Id;
        oppRec1.Type='Other';
        oppRec1.StageName=GEMS_UtilityClassTest.opportunityStatus();
        oppRec1.Date_Closed__c = system.today();
        oppRec1.Exchange_Offering_Type__c='No Private Exchange';
        oppRec1.CloseDate=Date.Today().addDays(8);
        oppRec1.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        oppRec1.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        oppRec1.Requested_Effective_Date__c=Date.Today().addDays(8);
        oppRec1.Expected_Health_Members__c=2;
        oppRec1.Account_Market_Segment__c='LG';
        oppRec1.HCSC_Division__c='IL';
        oppRec1.Region__c='N/A - IL';
        oppRec1.District__c='290';
        oppRec1.Clusters__c='020';
        oppRec1.Primary_Closed_Reason__c='Other';

        
        Opportunity oppRec2 = new Opportunity();
        oppRec2.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        oppRec2.Name='CaseTriggerHandler';
        oppRec2.accountId=acclist[2].Id;
        oppRec2.Type='Other';
        oppRec2.StageName=GEMS_UtilityClassTest.opportunityStatus();
        oppRec2.Date_Closed__c = system.today();
        oppRec2.Exchange_Offering_Type__c='No Private Exchange';
        oppRec2.CloseDate=Date.Today().addDays(8);
        oppRec2.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        oppRec2.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        oppRec2.Requested_Effective_Date__c=Date.Today().addDays(8);
        oppRec2.Expected_Health_Members__c=2;
        oppRec2.Account_Market_Segment__c='LG';
        oppRec2.HCSC_Division__c='IL';
        oppRec2.Region__c='N/A - IL';
        oppRec2.District__c='290';
        oppRec2.Clusters__c='020';
        oppRec2.Primary_Closed_Reason__c='Other';
        optyList.add(oppRec);
        optyList.add(oppRec1);
        optyList.add(oppRec2);
        
        insert optyList;
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        List<case> casesubList = new List<case>();
        for(integer i = 0;i <optyList.size();i++) {
            case cs = new case();
        cs.accountid = acclist[i].Id;
        cs.GEMS_Effective_Date__c = system.today();     
        cs.recordtypeid = caseAccountSubmissionId;
        cs.status = 'New';
        casesubList.add(cs);
        }
        insert casesubList;
        prd =GEMS_UtilityClassTest.insertionProduct(); 
        insert prd;
     
        
        //Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        System.assertEquals('GEMS Account Submission',accSubCase[0].RecordType.Name); 
        
        for(case cs:accSubCase) {
        cs.Status ='In Progress';
        cs.GEMS_Create_Account_Structure__c =true;
        cs.GEMS_Submission_Type__c = 'New Account';
        cs.GEMS_Submission_Sub_Type__c = 'Account Structure Change';
        cs.GEMS_Products__c ='Dental;PPO;RX';
        cs.Funding_Type_Multiselect__c = 'ASO'; 
        cs.GEMS_Line_of_Business__c='ENA';
        cs.GEMS_SBC_Required__c = 'Yes';        
        }
        update accSubCase;
        

    }
    

    

    private static testmethod void GEMS_CaseTriggerHandler1()
    {    
        Account acc = [select id,name from account WHERE name='TestAccountForCaseTriggerHandler'];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure'];
        
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase[0].id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase[0].id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase[0].id;
        insert bfAgrrement;
        Test.startTest(); 
        accStructureCase[0].status = 'Client Approval Received';
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';
        GEMS_Group_Section__c grp =  GEMS_UtilityClassTest.insertionGroupSection(acc.id,accStructureCase[0].id);
        grp.Case__c = accStructureCase[0].id;
        insert grp;
        update accStructureCase[0];        
        Test.stopTest();
    }
    
        private static testmethod void GEMS_CaseTriggerHandler2()
    {    
        Account acc = [select id,name from account WHERE name='TestAccountForCaseTriggerHandler1'];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where accountid=:acc.id];
        
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase[0].id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase[0].id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase[0].id;
        insert bfAgrrement;
        Test.startTest(); 
        accStructureCase[0].status = 'Client Approval Received';
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';
        GEMS_Group_Section__c grp =  GEMS_UtilityClassTest.insertionGroupSection(acc.id,accStructureCase[0].id);
        grp.Case__c = accStructureCase[0].id;
        insert grp;
        update accStructureCase[0];        
        Test.stopTest();
    }
    
    private static testmethod void GEMS_CaseTriggerHandler3()
    {    
        Account acc = [select id,name from account WHERE name='TestAccountForCaseTriggerHandler2'];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where accountid =:acc.id];
        
        Product2 prod = [select id,name from product2 limit 1];
        System.debug('==accStructureCase.id=='+accStructureCase[0].id);
        System.debug('==prd.id=='+prod.id);
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,accStructureCase[0].id,prod.id);
        bfAgrrement.AccountStructureCase__c = accStructureCase[0].id;
        insert bfAgrrement;
        Test.startTest(); 
        accStructureCase[0].status = 'Client Approval Received';
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06096';
        GEMS_Group_Section__c grp =  GEMS_UtilityClassTest.insertionGroupSection(acc.id,accStructureCase[0].id);
        grp.Case__c = accStructureCase[0].id;
        insert grp;
        update accStructureCase[0];        
        Test.stopTest();
    }
    
    
   
}