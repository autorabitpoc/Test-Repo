@isTest
private class GEMS_CaseTriggerHandlerExtendedTest
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
        insert userList;
        accRec = new Account();
        accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec.Name = 'TestAccountForCaseTriggerHandler';
        accRec.Group_Number__c= 'B06093';
        accRec.external_id__c= 'B06093';
        accRec.status__c = 'Active';
        insert accRec;
        
        Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
        
        Entitlement en = new Entitlement();
        en.name='Testing';
        en.accountid = accRec.id;
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
        accountTeamRoleList.add('Underwriter');
        accountTeamRoleList.add('Account Executive');
        accountTeamRoleList.add('Client Service Specialist.');
        
        
        List<AccountTeamMember> accTeamMemberList = new List<AccountTeamMember> ();
        for(Integer i=0; i<=12;i++)
        {
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
        insert oppRec;
        
        List<Product2> prdlist = new List<product2>();
        prd =GEMS_UtilityClassTest.insertionProduct(); 
        //insert prd;
        product2 prd1 = GEMS_UtilityClassTest.insertionProduct1();
        //prd1.Product_Category__c ='Dental';
        prdlist.add(prd);
        prdlist.add(prd1);
        insert prdlist;
        
        Opportunity_Product__c   optyPrd = GEMS_UtilityClassTest.insertionOppProd(prd.id, oppRec.id);
        optyPrd .Funding_Type__c ='EPO';
        optyPrd.Incumbent__c = testCompetitorAccount.Id;
        Opportunity_Product__c   optyPrd1 = GEMS_UtilityClassTest.insertionOppProd8(prd.id, oppRec.id);
        optyPrd1.Funding_Type__c ='EPO';
        optyPrd1.Incumbent__c = testCompetitorAccount.Id;
        Opportunity_Product__c   optyPrd2 = GEMS_UtilityClassTest.insertionOppProd8(prd.id, oppRec.id);        
        optyPrd2.Funding_Type__c ='PREM';
        optyPrd2.Incumbent__c = testCompetitorAccount.Id;
        Opportunity_Product__c   optyPrd3 = GEMS_UtilityClassTest.insertionOppProd8(prdlist[1].id, oppRec.id);        
        optyPrd3.Funding_Type__c ='Dental';
        optyPrd3.Incumbent__c = testCompetitorAccount.Id;
        
        List<Opportunity_Product__c> optyProdList = new List<Opportunity_Product__c>();
        optyProdList.add(optyPrd);
        optyProdList.add(optyPrd1);
        optyProdList.add(optyPrd2);
        optyProdList.add(optyPrd3);
        insert optyProdList;
        
        //oppRec.StageName='In Progress';
        
        //update oppRec;
        
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        case cs = new case();
        cs.Opportunity_Name__c = oppRec.id;
        cs.GEMS_Effective_Date__c = System.today();
        cs.accountid = accRecQuery[0].Id;
        cs.recordtypeid = caseAccountSubmissionId;
        cs.status = 'New';
        insert cs;
        
        
    }
    
    
    
    private static testmethod void GEMS_CaseTriggerHandler1()
    {    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Test.startTest();
        List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE name='TestAccountForCaseTriggerHandler' LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where AccountId=:accRecQuery[0].Id and recordtypeid = :caseAccountSubmissionId ];
        System.assertEquals('GEMS Account Submission',accSubCase[0].RecordType.Name);         
        accSubCase[0].Status ='In Progress';
        accSubCase[0].GEMS_Create_Account_Structure__c =true;
        accSubCase[0].GEMS_Submission_Type__c = 'New Account';
        accSubCase[0].GEMS_Submission_Sub_Type__c = 'Account Structure Change';
        accSubCase[0].GEMS_Products__c ='Dental;PPO;RX';
        accSubCase[0].Funding_Type_Multiselect__c = 'ASO'; 
        accSubCase[0].GEMS_Line_of_Business__c='ENA';
        accSubCase[0].GEMS_SBC_Required__c = 'Yes';
        update accSubCase;       
        Test.stopTest();
    }
    
    private static testmethod void GEMS_CaseTriggerHandler2()
    {    /*
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

Test.startTest(); 
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
Test.stopTest();*/
    }
    
    
    
}