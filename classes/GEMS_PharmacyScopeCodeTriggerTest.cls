/**************************************************************************************
  Apex Class Name     : GEMS_PharmacyScopeCodeTriggerTest
  Version             : 1.0
  Function            : This class is a test class for PharmacyScropeCodeTrigger
  Modification Log    :
* Developer           :    Date                   Description
* ----------------------------------------------------------------------------                 
* Balaram Naidu Chukka        11/09/2016                Original Version
*************************************************************************************/
@isTest
public class GEMS_PharmacyScopeCodeTriggerTest {
    
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
    public static testmethod void coverAfterInsertScenario() {
        Account acc = [select id,name from account limit 1];
        Product2 prod = [select id,name from product2 limit 1];
        Case structCase = [select id,casenumber,status from case where recordType.Name = 'GEMS Account Structure'];
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,structCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = structCase.id;
        insert bfAgrrement;
        User testUser2 = [select id, email from user where email = 'test2@user.com'];
        
        GEMS_Pharmacy_Scope_Code__c pharmacyScopeCode = new GEMS_Pharmacy_Scope_Code__c();
        pharmacyScopeCode.Case__c = structCase.Id;
        pharmacyScopeCode.Comments__c = 'TestComments';
        pharmacyScopeCode.Scope_Status__c = 'BET Submission Required';
        pharmacyScopeCode.Type__c = 'Percent';
        pharmacyScopeCode.Rider_Code__c = '08';
        pharmacyScopeCode.Retail__c = 'Percent';
        pharmacyScopeCode.Report_Format_Code__c = 'R';
        pharmacyScopeCode.Prime_Plan_ID__c = '1234560';
        pharmacyScopeCode.Prime_Certify_Date__c = System.today();
        pharmacyScopeCode.Copay_Type__c = 'Percent';
        pharmacyScopeCode.Accums_Integration__c = 'No';
        pharmacyScopeCode.Formulary_Type__c = 'Enhanced';
        pharmacyScopeCode.Name = '01';
        insert pharmacyScopeCode;

        Test.startTest();
        pharmacyScopeCode.Status__c = 'Peer Review Rejected';
        update pharmacyScopeCode;
        pharmacyScopeCode.Status__c = 'Peer Review Pending';
        update pharmacyScopeCode;
        pharmacyScopeCode.Status__c = 'Peer Review Rejected';
        pharmacyScopeCode.Scope_Status__c = 'No Scope Code Changes';
        update pharmacyScopeCode;
        pharmacyScopeCode.Status__c = 'Peer Review Pending';
        update pharmacyScopeCode;
        pharmacyScopeCode.Status__c = 'Peer Review Rejected';
        pharmacyScopeCode.Scope_Status__c = 'Scope Change Only - NoBETSub';
        pharmacyScopeCode.ownerId = testUser2.Id;
        update pharmacyScopeCode;
        pharmacyScopeCode.Status__c = 'Peer Review Approved';        
        update pharmacyScopeCode;
        Test.stopTest();
    }
    
    public static testmethod void coverAfterUpdateScenario() {
        Account acc = [select id,name from account limit 1];
        Product2 prod = [select id,name from product2 limit 1];
        Case structCase = [select id,casenumber,status from case where recordType.Name = 'GEMS Account Structure'];
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,structCase.id,prod.id);
        bfAgrrement.AccountStructureCase__c = structCase.id;
        insert bfAgrrement;
        User testUser2 = [select id, email from user where email = 'test2@user.com'];
        
        GEMS_Pharmacy_Scope_Code__c pharmacyScopeCode = new GEMS_Pharmacy_Scope_Code__c();
        pharmacyScopeCode.Case__c = structCase.Id;
        pharmacyScopeCode.Comments__c = 'TestComments';
        pharmacyScopeCode.Scope_Status__c = 'BET Submission Required';
        pharmacyScopeCode.Type__c = 'Percent';
        pharmacyScopeCode.Rider_Code__c = '08';
        pharmacyScopeCode.Retail__c = 'Percent';
        pharmacyScopeCode.Report_Format_Code__c = 'R';
        pharmacyScopeCode.Prime_Plan_ID__c = '1234560';
        pharmacyScopeCode.Prime_Certify_Date__c = System.today();
        pharmacyScopeCode.Copay_Type__c = 'Percent';
        pharmacyScopeCode.Accums_Integration__c = 'No';
        pharmacyScopeCode.Formulary_Type__c = 'Enhanced';
        pharmacyScopeCode.Name = '01';
        pharmacyScopeCode.status__c = 'New';
        insert pharmacyScopeCode;

        Test.startTest();
        pharmacyScopeCode.Rider_Code__c = '09';
        pharmacyScopeCode.status__c = 'In Progress';
        update pharmacyScopeCode;
        pharmacyScopeCode.status__c = 'Update BlueSTAR & AS400 Completed';
        pharmacyScopeCode.Scope_Status__c = 'No Scope Code Changes';
        update pharmacyScopeCode; 
        pharmacyScopeCode.Scope_Status__c = 'Scope Change Only - NoBETSub';
        update pharmacyScopeCode; 
        pharmacyScopeCode.Scope_Status__c = 'BET Submission Required';
        update pharmacyScopeCode; 
        pharmacyScopeCode.Scope_Status__c = 'No Scope Code Changes';
        update pharmacyScopeCode;  
        pharmacyScopeCode.Scope_Status__c = 'BET Submission Required';
        update pharmacyScopeCode;      
        Test.stopTest();
    }
}