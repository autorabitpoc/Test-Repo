/**************************************************************************************
  Apex Class Name     : GEMS_TriggerClass_TEST
  Version             : 1.0
  Function            : This class serves as Unit Test Class for Apex Renewal Triggers 
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva             05/02/2016                Original Version
*************************************************************************************/
@isTest
    private class GEMS_TriggerClass_TEST{  
    
    static public List<Case> accSubCase;
    static public Account accRec;
    static public product2 prd;
    static public case cs2;
    static public List<case> accStructureCase;
    @testSetup
    static void dataSetup() 
    {
    
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
    cs.accountid = accRecQuery[0].Id;
    cs.Opportunity_Name__c= oppRec.id;
    cs.recordtypeid = caseAccountSubmissionId;
    cs.status = 'New';
    
    case cs1 = new case();
        cs1.accountid = accRecQuery[1].Id;
        cs1.Opportunity_Name__c= oppRec.id;
        cs1.recordtypeid = caseAccountSubmissionId;
        cs1.status = 'New';
    case cs3 = new case();
        cs3.accountid = accRecQuery[1].Id;
        cs3.Opportunity_Name__c= oppRec.id;
        cs3.recordtypeid = caseAccountSubmissionId;
        cs3.status = 'New';
    
    
    caseList.add(cs);
    caseList.add(cs1);
    caseList.add(cs3);
    insert caseList;
    
    accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
    System.assertEquals('GEMS Account Submission',accSubCase[0].RecordType.Name); 
    System.assertEquals('GEMS Account Submission',accSubCase[1].RecordType.Name); 
    integer i=0;
    for(case accSubCase1:accSubCase ){
    accSubCase1.Status ='In Progress';
    accSubCase1.GEMS_Create_Account_Structure__c =true;
    accSubCase1.GEMS_Submission_Type__c = 'Renewal';
    accSubCase1.GEMS_Submission_Sub_Type__c = 'Account Structure Change';
    accSubCase1.GEMS_Products__c ='Dental;PPO;RX';
    accSubCase1.Funding_Type_Multiselect__c = 'ASO'; 
    accSubCase1.GEMS_Line_of_Business__c='ENA';
    accSubCase1.GEMS_Effective_Date__c = system.today();
    accSubCase1.GEMS_Case_Effective_Date__c= system.today();
    accSubCase1.GEMS_SBC_Required__c = 'Yes';
    
    }
    accSubCase[0].GEMS_Submission_Type__c = 'Renewal'; 
    accSubCase[0].HCSC_Division__c = 'TX';
    accSubCase[1].HCSC_Division__c = 'IL';
    accSubCase[2].HCSC_Division__c = 'KP';
    update accSubCase;
    accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure'];
    
    } 
    
    private static testmethod void method1() {
    Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
    List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE recordtypeid=:recTypeId ];
    Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
    
    product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
    accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
    accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
    accStructureCase[0].GEMS_Submission_Type__c = 'Renewal';
    test.starttest();
    update accStructureCase[0];
    
    GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
    benefit.IsNew__c=true;
    benefit.Schedule__c= 'Tes';
    insert benefit;
    benefit.IsCancelled__c=true;
    benefit.IsNew__c=false;
    
    
    GEMS_Characteristic__c gemsCaract = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
    gemsCaract.Usage__c='Billing/Mailing';
    gemsCaract.isNew__c = true;
    insert gemsCaract ;
    gemsCaract.Mailing__c=true;
    update gemsCaract;
   
    GEMS_Address__c address = New GEMS_Address__c();
    address.Account__c = accRecQuery[0].Id;
    address.Address_Sequence__c ='2345-1201-1234';
    address.Usage__c='Billing';
    insert address;
    
    GEMS_Address__c address1 = New GEMS_Address__c();
    address1.Account__c = accRecQuery[0].Id;
    address1.Address_Sequence__c ='0012-1023-1254';
    address1.Usage__c='Mailing';
    //address.Billing_Usage__c=true;
    insert address1;   
    
    GEMS_Characteristic_Value__c charval = GEMS_UtilityClassTest.insertionCharacValue(gemsCaract.id,accStructureCase[0].id);
    insert charval;
    
    GEMS_Category__c gemscat1 = GEMS_UtilityClassTest.insertiongemscat1(accRecQuery[0].Id,accStructureCase[0].id);
    gemscat1.Usage_Billing__c = true;
    insert gemscat1;
    gemscat1.IsCancelled__c=true;
    gemscat1.IsNew__c=false;
    gemscat1.Usage_Reporting__c=true;
    gemscat1.Usage_Mailing__c=true;
    gemscat1.Mailing_Address__c =address1.id;
    
    
    GEMS_BA_Category_Assignment__c catass = GEMS_UtilityClassTest.insertionBACategory(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemscat1.Id);
    insert catass;
    GEMS_BA_Category_Assignment__c catquery =[Select id,Benefit_Agreement__c,Category__c from GEMS_BA_Category_Assignment__c where Case__c=:accStructureCase[0].id ];
    System.assertEquals(benefit.id,catquery.Benefit_Agreement__c);
    GEMS_Cat_Char_Value_Association__c charass = GEMS_UtilityClassTest.insertionAssociate(accStructureCase[0].id,accRecQuery[0].Id,charval.id,gemscat1.Id);
    insert charass;
    
    GEMS_Group_Section__c gemsGroupObj = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
    insert gemsGroupObj;
    
    GEMS_Category_Assignment__c gemsCatAsgmnt = GEMS_UtilityClassTest.insertionCategoryAssign(accRecQuery[0].Id,accStructureCase[0].id,gemsCat1.Id,gemsGroupObj.Id);
    insert gemsCatAsgmnt;
    
    GEMS_BA_Assignment__c gemsbaass = GEMS_UtilityClassTest.insertionBaAssign(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemsGroupObj.Id);
    insert gemsbaass;
    
    GEMS_Billing_Profile__c billpro = new GEMS_Billing_Profile__c();
    billpro.Account__c=accRecQuery[0].Id;
    billpro.Case__c=accStructureCase[0].id;
    billpro.Billing_Address__c=address.id;
    billpro.IsNew__c=true;
    billpro.IsUpdated__c=true;
    insert billpro;
    billpro.IsUpdated__c=false;
    update billpro; 
    
    GEMS_BP_Category_Association__c bpcat =New GEMS_BP_Category_Association__c();
    bpcat.Billing_Profile__c=billpro.id;
    bpcat.Case__c=accStructureCase[0].id;
    bpcat.Category__c=gemscat1.id;
    bpcat.IsNew__c=true; 
    insert bpcat;
     GEMS_BP_Category_Association__c bpquery =[Select id,Category__c from GEMS_BP_Category_Association__c where Case__c=:accStructureCase[0].id ];
    System.assertEquals(gemscat1.id,bpquery.Category__c );

    GEMS_BP_BA_Association__c bpbaass = new GEMS_BP_BA_Association__c();
    bpbaass.Benefit_Agreement__c =benefit.id;
    bpbaass.Billing_Profile__c= billpro.id;
    bpbaass.Case__c=accStructureCase[0].id;
    bpbaass.IsNew__c=true; 
    insert bpbaass;
    update benefit;
    update gemscat1;
    test.stoptest();
    }
    
    private static testmethod void method2() {
    Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
    List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE recordtypeid=:recTypeId ];
    Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
    
    product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
    accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
    accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
    accStructureCase[0].GEMS_Submission_Type__c = 'Renewal';
    test.starttest();
    update accStructureCase[0];
    
    GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
    benefit.IsNew__c=true;
    benefit.Schedule__c= 'Tes';
    insert benefit;
    
    GEMS_Characteristic__c gemsCaract = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
    gemsCaract.Usage__c='Billing/Mailing';
   // gemsCaract.isNew__c = false;
    insert gemsCaract ;
    gemsCaract.Mailing__c=true;
    update gemsCaract;
   
    GEMS_Address__c address = New GEMS_Address__c();
    address.Account__c = accRecQuery[0].Id;
    address.Address_Sequence__c =null;
    address.Usage__c='Billing';
    insert address;
    
    GEMS_Address__c address1 = New GEMS_Address__c();
    address1.Account__c = accRecQuery[0].Id;
    address1.Address_Sequence__c =null;
    address1.Usage__c='Mailing';
    //address.Billing_Usage__c=true;
    insert address1;   
    
    GEMS_Characteristic_Value__c charval = GEMS_UtilityClassTest.insertionCharacValue(gemsCaract.id,accStructureCase[0].id);
    insert charval;
    
    GEMS_Category__c gemscat1 = GEMS_UtilityClassTest.insertiongemscat1(accRecQuery[0].Id,accStructureCase[0].id);
    gemscat1.Usage_Billing__c = true;
    insert gemscat1;
    gemscat1.IsCancelled__c=true;
    gemscat1.IsNew__c=false;
    gemscat1.Usage_Reporting__c=true;
    gemscat1.Usage_Mailing__c=true;
    gemscat1.Mailing_Address__c =address1.id;
  
    GEMS_Group_Section__c gemsGroupObj = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
    insert gemsGroupObj;
     GEMS_Category_Assignment__c gemsCatAsgmnt = GEMS_UtilityClassTest.insertionCategoryAssign(accRecQuery[0].Id,accStructureCase[0].id,gemsCat1.Id,gemsGroupObj.Id);
    insert gemsCatAsgmnt;
    
    GEMS_BA_Category_Assignment__c catass = GEMS_UtilityClassTest.insertionBACategory(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemscat1.Id);
    insert catass;
    GEMS_BA_Category_Assignment__c catquery =[Select id,Benefit_Agreement__c,Category__c from GEMS_BA_Category_Assignment__c where Case__c=:accStructureCase[0].id ];
    System.assertEquals(benefit.id,catquery.Benefit_Agreement__c);
      
    delete catass;
    update gemscat1;
    test.stoptest();
    }
    
  private static testmethod void method4() {
    Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
    List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE recordtypeid=:recTypeId ];
    Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
    
    product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
    accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
    accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
    accStructureCase[0].GEMS_Submission_Type__c = 'Renewal';
    test.starttest();
    update accStructureCase[0];
    
    GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
    benefit.IsNew__c=true;
    benefit.Schedule__c= 'Tes';
    insert benefit;
    
    GEMS_Characteristic__c gemsCaract = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
    gemsCaract.Usage__c='Billing/Mailing';
    insert gemsCaract ;
    
   
    GEMS_Address__c address = New GEMS_Address__c();
    address.Account__c = accRecQuery[0].Id;
    address.Address_Sequence__c =null;
    address.Usage__c='Billing';
    insert address;
    
    GEMS_Address__c address1 = New GEMS_Address__c();
    address1.Account__c = accRecQuery[0].Id;
    address1.Address_Sequence__c =null;
    address1.Usage__c='Mailing';
    insert address1;   
    
    GEMS_Characteristic_Value__c charval = GEMS_UtilityClassTest.insertionCharacValue(gemsCaract.id,accStructureCase[0].id);
    insert charval;
    
    GEMS_Category__c gemscat1 = GEMS_UtilityClassTest.insertiongemscat1(accRecQuery[0].Id,accStructureCase[0].id);
    gemscat1.Usage_Billing__c = true;
    insert gemscat1;
    gemscat1.IsCancelled__c=true;
    gemscat1.IsNew__c=false;
    gemscat1.Usage_Reporting__c=true;
    gemscat1.Usage_Mailing__c=true;
    gemscat1.Mailing_Address__c =address1.id;
  
    GEMS_Group_Section__c gemsGroupObj = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
    insert gemsGroupObj;
    GEMS_Category_Assignment__c gemsCatAsgmnt = GEMS_UtilityClassTest.insertionCategoryAssign(accRecQuery[0].Id,accStructureCase[0].id,gemsCat1.Id,gemsGroupObj.Id);
    insert gemsCatAsgmnt;
    
    GEMS_BA_Category_Assignment__c catass = GEMS_UtilityClassTest.insertionBACategory(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemscat1.Id);
    insert catass;
    GEMS_BA_Category_Assignment__c catquery =[Select id,Benefit_Agreement__c,Category__c from GEMS_BA_Category_Assignment__c where Case__c=:accStructureCase[0].id ];
    System.assertEquals(benefit.id,catquery.Benefit_Agreement__c);
    
    GEMS_Billing_Profile__c billpro = new GEMS_Billing_Profile__c();
    billpro.Account__c=accRecQuery[0].Id;
    billpro.Case__c=accStructureCase[0].id;
    billpro.Billing_Address__c=address.id;
    billpro.IsNew__c=true;
    billpro.IsUpdated__c=true;
    insert billpro;
    
    GEMS_BP_Category_Association__c bpcat =New GEMS_BP_Category_Association__c();
    bpcat.Billing_Profile__c=billpro.id;
    bpcat.Case__c=accStructureCase[0].id;
    bpcat.Category__c=gemscat1.id;
    bpcat.IsNew__c=true; 
    insert bpcat;
    GEMS_BP_Category_Association__c bpquery =[Select id,Category__c from GEMS_BP_Category_Association__c where Case__c=:accStructureCase[0].id ];
    System.assertEquals(gemscat1.id,bpquery.Category__c ); 
    
    update gemscat1;
    test.stoptest();
    }
}