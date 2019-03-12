/********************************************************************************************************
Name        : GEMS_ContractAdminReqHelperTest
Description : New button for Contract Admin Request from the Submission Case screen.
Version History:
Date        Developer               Description
08/21/2017  Bharath, Shankar        SFDC-5647
6/10/2018   Gokul Bharati           SFDC-9541 GEMS: Add Contract Admin Request to Cosmetic and Account Eligibility Maintenance Cases (SBC/BB
*******************************************************************************************************/
@isTest
public class GEMS_ContractAdminReqHelperTest {

    @testSetup  
    public static void setupTestData() {        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
        Opportunity oppty1= GEMS_UtilityClassTest.insertionOpp1(acc.Id);
        oppty1.Name = 'WithOut CAR';
        oppty1.StageName=GEMS_UtilityClassTest.opportunityStatus();
        oppty1.Recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        oppty1.Date_Closed__c = system.today();
        oppty1.Primary_Closed_Reason__c='Other';
        insert oppty1;
        
        Opportunity oppty2= GEMS_UtilityClassTest.insertionOpp1(acc.Id);
        oppty2.Name = 'With CAR';
        oppty2.StageName=GEMS_UtilityClassTest.opportunityStatus();
        oppty2.Recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        oppty2.Date_Closed__c = system.today();
        oppty2.Primary_Closed_Reason__c='Other';
        insert oppty2;
        
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;     
        
        Opportunity_Product__c insertionOppProd1=GEMS_UtilityClassTest.insertionOppProd1(productRec1.Id,oppty1.Id);
        Opportunity_Product__c insertionOppProd2=GEMS_UtilityClassTest.insertionOppProd1(productRec1.Id,oppty2.Id);
        
        List<Case> insertCases = new List<Case>();       
        
        Case accSub = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        accSub.accountId = acc.Id;
        accSub.Funding_Type_Multiselect__c = 'ASO;Premium';
        accSub.Opportunity_Name__c = oppty1.id;
        insertCases.add(accSub);
        
        Case accSubCase = GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        accSubCase.accountId = acc.Id;
        accSubCase.Funding_Type_Multiselect__c = 'ASO;Premium';
        accSubCase.Opportunity_Name__c = oppty2.id;
        insertCases.add(accSubCase);
        
        Case accMain1 = GEMS_UtilityClassTest.insertionCaseMaintenance('Account Maintenance');
        accMain1.accountId = acc.Id;
        accMain1.GEMS_Submission_Type__c='Cosmetic Account Maintenance';
        accMain1.GEMS_Submission_Sub_Type__c='Account Name; Address; Contact Information; Contact Usage; Updates to OE Date; Updating AEP checkbox';
        insertCases.add(accMain1); 
        
        Case accMain2 = GEMS_UtilityClassTest.insertionCaseMaintenance('Account Maintenance');
        accMain2.accountId = acc.Id;
        accMain2.GEMS_Submission_Type__c='Account Structure Maintenance';
        accMain2.GEMS_Submission_Sub_Type__c='Account Name; Address; Contact Information; Contact Usage; Updates to OE Date; Updating AEP checkbox';
        insertCases.add(accMain2);
        
        if(!insertCases.isEmpty())
        insert insertCases;
        
        GEMS_Contract_Admin_Request__c req = new GEMS_Contract_Admin_Request__c();   
        req.Opportunity_Link__c = oppty2.id; 
        req.Category__c = 'Contract Admin';
        req.Status__c = 'New';
        req.Hidden_HCSC_Division__c = accSubCase.Account.HCSC_Division__c;
        req.District__c = accSubCase.Account.District__c;
        req.Cluster__c = accSubCase.Account.Cluster__c;
        req.Market_Segment__c = accSubCase.Account.Market_Segment__c;
        req.Region__c = accSubCase.Account.Region__c;
        req.Line_of_Business__c = accSubCase.Account.Line_of_Business__c;
        req.Open_Enrollment_Start_Date__c = accSubCase.Account.Open_Enrollment_Date__c;
        req.Effective_Date__c = accSubCase.GEMS_Effective_Date__c;
        insert req;
    }
    
    @isTest
    public  static void  testReqFromSubCase() {
        Case c = [Select Id from Case where Opportunity_Name__c != NULL LIMIT 1];
        Opportunity op = [Select Id from Opportunity LIMIT 1];
        String result = GEMS_ContractAdminReqHelper.addNewRecord(c.Id);
        Account acc = [Select Id, Name from Account LIMIT 1];
        String hypText = '<a href="' + acc.Id + '" target="_self">BenefitAgreementControllerTest</a>';
        GEMS_Contract_Admin_Request__c req = [Select Account_Name__c from GEMS_Contract_Admin_Request__c LIMIT 1];
        System.assert(req.Account_Name__c.contains(acc.Name));
    }   
    
    @isTest
    public  static void  testReqFromCosmeticMainCase() {
        Case c = [Select Id from Case where Opportunity_Name__c = NULL and GEMS_Submission_Type__c = 'Cosmetic Account Maintenance' LIMIT 1];
        Account acc = [Select Id, Name from Account LIMIT 1];
        String result = GEMS_ContractAdminReqHelper.addNewRecord(c.Id);
        GEMS_Contract_Admin_Request__c req = [Select Account_Name__c from GEMS_Contract_Admin_Request__c where Opportunity_Link__c = NULL  LIMIT 1];
        System.assert(req.Account_Name__c.contains(acc.Name));
    }
    
    @isTest
    public  static void  testReqFromAcctStructMainCase() {
        Case c = [Select Id from Case where Opportunity_Name__c = NULL and GEMS_Submission_Type__c = 'Account Structure Maintenance' LIMIT 1];
        Account acc = [Select Id, Name from Account LIMIT 1];
        String result = GEMS_ContractAdminReqHelper.addNewRecord(c.Id);
        System.assert(result .contains('Applies only to Cosmetic and Account Eligibilty Maintenance types'));
    }
    
    @isTest
    public  static void  testReqFromSubCaseWithCAR() {
        Case c = [Select Id from Case where Opportunity_Name__c != NULL and Opportunity_Name__r.Name = 'With CAR' LIMIT 1];
        Account acc = [Select Id, Name from Account LIMIT 1];
        String result = GEMS_ContractAdminReqHelper.addNewRecord(c.Id);
        GEMS_Contract_Admin_Request__c req = [Select Account_Name__c from GEMS_Contract_Admin_Request__c LIMIT 1];
        System.assert(req.Account_Name__c.contains(acc.Name));
    }
}