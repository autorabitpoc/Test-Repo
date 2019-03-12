/**************************************************************************************
  Apex Class Name     : GEMS_ScreeningCaseControllertest
  Version             : 1.0
  Function            : This class serves as Unit Test Class for GEMS_ScreeningCaseController
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva             08/03/2016                Original Version
*************************************************************************************/
@isTest
    private class GEMS_ScreeningCaseControllertest{  
   
   /* static public List<Case> accSubCase;
    static public Account accRec;
    static public product2 prd;
    static public case cs2;
    static public List<case> accStructureCase;
    @testSetup
    static void dataSetup() {

        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        List<User> userList = new List<User>();
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        userList.add(testUser1);
        insert userList;

        accRec = new Account();
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec.RecordTypeId = recTypeId;
        accRec.Name = 'TestAccountForCaseTriggerHandler';
        accRec.Group_Number__c= 'B06093';
        accRec.external_id__c= 'B06093';
        accRec.BillingStreet ='Testing';
        accRec.BillingCity='TX';
        accRec.BillingState='CT';
        accRec.BillingPostalCode='534323';
        accRec.status__c = 'Active';
        
        Account accRec1 = new Account();
        accRec1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec1.Name = 'TestAccountForCaseTriggerHandler1';
        accRec1.Group_Number__c= 'B060931';
        accRec1.external_id__c= 'B0609';
        accRec1.BillingStreet ='Testing';
        accRec1.BillingCity='TX';
        accRec1.BillingState='CT';
        accRec1.BillingPostalCode='534323';
        accRec1.status__c = 'Active';
        
        List<Account> acclist = new List<Account>();
        acclist.add(accRec);
        acclist.add(accRec1);
        insert acclist;
                                
        List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE recordtypeid=:recTypeId ];
        System.assertEquals('TestAccountForCaseTriggerHandler',accRecQuery[0].Name);
        
        List<String> accountTeamRoleList = new  List<String>();
               
        accountTeamRoleList.add('Account Specialist');
        List<AccountTeamMember> accTeamMemberList = new List<AccountTeamMember> ();
        AccountTeamMember accTeamMemberAccSpecialist = new AccountTeamMember ();
        accTeamMemberAccSpecialist.UserId =userList[0].id;
        accTeamMemberAccSpecialist.TeamMemberRole = accountTeamRoleList[0];
        accTeamMemberAccSpecialist.AccountId =acclist[0].id;
        accTeamMemberList.add(accTeamMemberAccSpecialist);
        
        AccountTeamMember accTeamMemberAccSpecialist1 = new AccountTeamMember ();
        accTeamMemberAccSpecialist1.UserId =userList[0].id;
        accTeamMemberAccSpecialist1.TeamMemberRole = accountTeamRoleList[0];
        accTeamMemberAccSpecialist1.AccountId =acclist[1].id;
        accTeamMemberList.add(accTeamMemberAccSpecialist1);
        
        insert accTeamMemberList;
        List<Opportunity> optyList = new List<Opportunity>();
        Opportunity oppRec = new Opportunity();
        oppRec.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        oppRec.Name='CaseTriggerHandler';
        oppRec.accountId=acclist[0].Id;
        oppRec.Type='Other';
        oppRec.StageName='In Progress';
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
        cs.accountid = accRecQuery[0].Id;
        cs.Opportunity_Name__c= oppRec.id;
        cs.recordtypeid = caseAccountSubmissionId;
        cs.status = 'New';
        caseList.add(cs);
        insert caseList;
        
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        System.assertEquals('GEMS Account Submission',accSubCase[0].RecordType.Name); 
        integer i=0;
        for(case accSubCase1:accSubCase ){
        accSubCase1.Status ='In Progress';
        accSubCase1.HCSC_Division__c ='TX';
        accSubCase1.GEMS_Create_Account_Structure__c =true;
        accSubCase1.GEMS_Submission_Type__c = 'New Account';
        accSubCase1.GEMS_Products__c ='Dental;PPO;RX';
        accSubCase1.Funding_Type_Multiselect__c = 'ASO'; 
        accSubCase1.GEMS_Line_of_Business__c='ENA';
        accSubCase1.GEMS_Effective_Date__c = system.today();
        accSubCase1.GEMS_Case_Effective_Date__c= system.today();
        accSubCase1.GEMS_SBC_Required__c = 'No';
       }
        update accSubCase;
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure'];
    } 
            
    private static testmethod void method1() 
    {
        Account acc = [select id,name from account limit 1];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        accSubCase = [SELECT Id, Subject, AccountId,GEMS_Submission_Type__c,HCSC_Division__c,GEMS_Products__c, RecordType.Name,Funding_Type_Multiselect__c from Case where recordtypeid = :caseAccountSubmissionId ];

        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure'];
        Product2 prod = [select id,name from product2 limit 1];
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

        GEMS_ScreeningCaseController.validatedocCheckToCreateScreening(accSubCase[0].id,true);
        Case accSubCase2 = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accSubCase2.GEMS_All_required_documents_attached__c=true;
        accSubCase2.GEMS_AEP_Account__c = true;
        accSubCase2.GEMS_Products__c='PPO';
        update accSubCase2;
        GEMS_ScreeningCaseController.validatedocCheckToCreateScreening(accSubCase2.id,true);
        Test.stopTest();
   }*/
}