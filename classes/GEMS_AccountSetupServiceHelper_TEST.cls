/**************************************************************************************
  Apex Class Name     : GEMS_AccountSetupServiceHelper_TEST
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_AccountSetupServiceHelper
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------------                 
*   Siva Thimmannagari                   07/21/2016                Original Version
*   Shankar       						 07/17/2017 			   SFDC-5071 - Changes to validate if associated BA Product 
																   (plan) has a product code 1.3 
*   Shankar		 						 05/07/2017			       SFDC 4890, 4893. Changes in logic to set changeReasonCode for 
																   BA, Cat & GS
*   Shankar		 						 08/07/2017			       SFDC 4894, 5025. Changes in logic to set changeReasonCode for 
																   BA, Cat & BP
*************************************************************************************/ 
@isTest
    private class GEMS_AccountSetupServiceHelper_TEST{  
    
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
        accRec.Effective_Date__c = system.today().addDays(8);
        
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
        accRec1.Effective_Date__c = system.today().addDays(8);
        
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
        oppRec.HCSC_Division__c='TX';
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
        Test.startTest();
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
        accSubCase[1].HCSC_Division__c = 'TX';
        accSubCase[2].HCSC_Division__c = 'TX';
        
        update accSubCase;
        Test.stopTest();
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure'];

    } 
            
    private static testmethod void method1() 
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
    Test.startTest();
        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';
        update accStructureCase[0]; 
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        benefit.IsNew__c=true;
        benefit.Schedule__c= null;
        insert benefit;

        GEMS_Characteristic__c gemsCaract = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
        gemsCaract.Usage__c='Billing/Product/Reporting';
        insert gemsCaract ;
        GEMS_Characteristic_Value__c charval = GEMS_UtilityClassTest.insertionCharacValue(gemsCaract.id,accStructureCase[0].id);
        insert charval;
        GEMS_Category__c gemscat1 = GEMS_UtilityClassTest.insertiongemscat1(accRecQuery[0].Id,accStructureCase[0].id);
        gemscat1.Usage_Product__c =true;
        gemscat1.Usage_Billing__c=true;
        gemscat1.Usage_Reporting__c=true;
        gemscat1.Usage_Mailing__c=true;
        insert gemscat1;
        GEMS_BA_Category_Assignment__c catass = GEMS_UtilityClassTest.insertionBACategory(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemscat1.Id);
        insert catass;
        GEMS_Cat_Char_Value_Association__c charass = GEMS_UtilityClassTest.insertionAssociate(accStructureCase[0].id,accRecQuery[0].Id,charval.id,gemscat1.Id);
        insert charass;
        GEMS_Group_Section__c gemsGroupObj = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        insert gemsGroupObj;
        GEMS_Category_Assignment__c gemsCatAsgmnt = GEMS_UtilityClassTest.insertionCategoryAssign(accRecQuery[0].Id,accStructureCase[0].id,gemsCat1.Id,gemsGroupObj.Id);
        insert gemsCatAsgmnt;
        accStructureCase[0].status = 'Client Approval Received';
        update accStructureCase[0];  
        List<id> idList = new List<Id>();
        idList.add(accStructureCase[0].id );
        
        Test.setMock(HttpCalloutMock.class, new GEMS_MockHttpResponseGenerator()); 
        GEMS_AccountSetupServiceHelper.sendAccountStructure( idList );
        GEMS_AccountSetupServiceHelper.validateAccountStructure(accStructureCase[0].id);
        test.stoptest();
    }
   
    private static testmethod void method2() 
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE recordtypeid=:recTypeId ];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        accStructureCase[0].GEMS_Submission_Type__c = 'Renewal';
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';

        update accStructureCase[0];
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        benefit.IsNew__c=true;
        //benefit.Schedule__c= 'Tes';
        insert benefit;

        GEMS_Characteristic__c gemsCaract = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
        gemsCaract.Usage__c='Billing/Mailing';
        insert gemsCaract ;
        GEMS_Address__c address = New GEMS_Address__c();
        address.Account__c = accRecQuery[0].Id;
        address.Address_Sequence__c ='2345-1201-1234';
        address.Contact_Phone__c='1458522';
        address.Usage__c='Billing';
        insert address;
        GEMS_Address__c address1 = New GEMS_Address__c();
        address1.Account__c = accRecQuery[0].Id;
        address1.Address_Sequence__c ='0012-1023-1254';
        address1.Usage__c='Mailing';
        address.Contact_Phone__c='1458522';
        //address.Billing_Usage__c=true;
        insert address1;   
        GEMS_Characteristic_Value__c charval = GEMS_UtilityClassTest.insertionCharacValue(gemsCaract.id,accStructureCase[0].id);
        insert charval;
        GEMS_Category__c gemscat1 = GEMS_UtilityClassTest.insertiongemscat1(accRecQuery[0].Id,accStructureCase[0].id);
        gemscat1.Usage_Product__c =true;
        gemscat1.Usage_Billing__c=true;
        gemscat1.Usage_Reporting__c=true;
        gemscat1.Usage_Mailing__c=true;
        gemscat1.Mailing_Address__c =address1.id;
        insert gemscat1;
        GEMS_BA_Category_Assignment__c catass = GEMS_UtilityClassTest.insertionBACategory(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemscat1.Id);
        insert catass;
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

        GEMS_BP_Category_Association__c bpcat =New GEMS_BP_Category_Association__c();
        bpcat.Billing_Profile__c=billpro.id;
        bpcat.Case__c=accStructureCase[0].id;
        bpcat.Category__c=gemscat1.id;
        bpcat.IsNew__c=true; 
        insert bpcat;

        GEMS_BP_BA_Association__c bpbaass = new GEMS_BP_BA_Association__c();
        bpbaass.Billing_Profile__c=billpro.id;
        bpbaass.Benefit_Agreement__c=benefit.id;
        bpbaass.Case__c=accStructureCase[0].id;
        bpbaass.IsNew__c=true;
        insert bpbaass;
        accStructureCase[0].status = 'Client Approval Received';
        test.startTest();
        update accStructureCase[0];
        //GEMS_BA_Assignment__c gemsbaass = GEMS_UtilityClassTest.insertionBaAssign(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemsGroupObj.Id);
        //insert gemsbaass;

        //System.assertEquals('ABS',gemsCaract.Usage__c );
        List<id> idList = new List<Id>();
        idList.add(accStructureCase[0].id );
        //idList.add(accStructureCase[1].id);
        
        Test.setMock(HttpCalloutMock.class, new GEMS_MockHttpResponseGenerator()); 
        GEMS_AccountSetupServiceHelper.sendAccountStructure( idList );
        test.stoptest();
    }

    private static testmethod void method3() 
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE recordtypeid=:recTypeId ];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        accStructureCase[0].GEMS_Submission_Type__c = 'New Account';
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';
        update accStructureCase[0];
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        benefit.IsNew__c=true;
        benefit.Schedule__c= 'Tes';
        insert benefit;
        GEMS_Benefit_Agreement__c benefit1=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        benefit1.IsNew__c=true;
        benefit1.Schedule__c= 'Tes';
        insert benefit1;
        GEMS_Address__c address = New GEMS_Address__c();
        address.Account__c = accRecQuery[0].Id;
        address.Address_Sequence__c ='IL1-1234-1234';
        address.Usage__c='Primary;Mailing';
        insert address;       
        GEMS_Characteristic__c gemsCaract = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
        gemsCaract.Usage__c='Billing/Reporting';
        insert gemsCaract ;
        GEMS_Characteristic__c gemsCaract2 = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
        gemsCaract2.Usage__c='Billing/Product';
        insert gemsCaract2;


        GEMS_Characteristic_Value__c charval = GEMS_UtilityClassTest.insertionCharacValue(gemsCaract.id,accStructureCase[0].id);
        insert charval;
        GEMS_Category__c gemscat1 = GEMS_UtilityClassTest.insertiongemscat1(accRecQuery[0].Id,accStructureCase[0].id);
        gemscat1.Usage_Product__c =true;
        gemscat1.Usage_Billing__c=true;
        gemscat1.Usage_Reporting__c=true;
        gemscat1.Usage_Mailing__c=true;
        gemscat1.Mailing_Address__c =address.id;
        insert gemscat1;
        GEMS_BA_Category_Assignment__c catass = GEMS_UtilityClassTest.insertionBACategory(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemscat1.Id);
        insert catass;
        GEMS_Cat_Char_Value_Association__c charass = GEMS_UtilityClassTest.insertionAssociate(accStructureCase[0].id,accRecQuery[0].Id,charval.id,gemscat1.Id);
        insert charass;
        GEMS_Group_Section__c gemsGroupObj = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        insert gemsGroupObj;
        GEMS_Category_Assignment__c gemsCatAsgmnt = GEMS_UtilityClassTest.insertionCategoryAssign(accRecQuery[0].Id,accStructureCase[0].id,gemsCat1.Id,gemsGroupObj.Id);
        insert gemsCatAsgmnt;
        GEMS_Corp_Characteristic_Code__c corpchar = new GEMS_Corp_Characteristic_Code__c();
        corpchar.CORP_Characteristic_Code__c='Test';
        insert corpchar;
        GEMS_Characteristic__c gemsCaract1 = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
        gemsCaract1.Usage__c='Billing/Product/Reporting';
        gemsCaract1.Corp_Characteristic_Code__c=corpchar.id;
        insert gemsCaract1 ;
        accStructureCase[0].status = 'Client Approval Received';
        test.startTest();
        update accStructureCase[0]; 
        //System.assertEquals('ABS',gemsCaract.Usage__c );
        List<id> idList = new List<Id>();
        idList.add(accStructureCase[0].id );
        //idList.add(accStructureCase[1].id);
        
        Test.setMock(HttpCalloutMock.class, new GEMS_MockHttpResponseGenerator()); 
        GEMS_AccountSetupServiceHelper.sendAccountStructure( idList );
        test.stoptest();
    }
            
 /* private static testmethod void method4() 
    {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE recordtypeid=:recTypeId ];
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';
        update accStructureCase[0]; 
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        benefit.IsNew__c=true;
        benefit.Schedule__c= 'Tes';
        insert benefit;
        /* GEMS_Address__c address = New GEMS_Address__c();
        address.Account__c = accRecQuery[0].Id;
        address.Address_Sequence__c ='IL1-1234-1234';
        address.Usage__c='Primary';
        //address.Billing_Usage__c=true;
        address.IsNew__c=TRUE;
        insert address;  --->commented
        GEMS_Address__c address1 = New GEMS_Address__c();
        address1.Account__c = accRecQuery[0].Id;
        address1.Address_Sequence__c ='IL1-1234-1234';
        address1.Usage__c='Billing';
        address1.IsNew__c=TRUE;
        //address.Billing_Usage__c=true;
        insert address1;    
        GEMS_Characteristic__c gemsCaract = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
        gemsCaract.Usage__c='Billing/Reporting';
        insert gemsCaract ;
        GEMS_Characteristic_Value__c charval = GEMS_UtilityClassTest.insertionCharacValue(gemsCaract.id,accStructureCase[0].id);
        insert charval;
        GEMS_Category__c gemscat1 = GEMS_UtilityClassTest.insertiongemscat1(accRecQuery[0].Id,accStructureCase[0].id);
        gemscat1.Usage_Product__c =true;
        gemscat1.Usage_Billing__c=true;
        gemscat1.Usage_Reporting__c=true;
        gemscat1.Usage_Mailing__c=true;
        insert gemscat1;
        GEMS_BA_Category_Assignment__c catass = GEMS_UtilityClassTest.insertionBACategory(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemscat1.Id);
        insert catass;
        GEMS_Cat_Char_Value_Association__c charass = GEMS_UtilityClassTest.insertionAssociate(accStructureCase[0].id,accRecQuery[0].Id,charval.id,gemscat1.Id);
        insert charass; 
        List<GEMS_Group_Section__c> grplst =New List<GEMS_Group_Section__c>();
        GEMS_Group_Section__c gemsGroupObj = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        gemsGroupObj.IsNew__c = true;
        gemsGroupObj.IsCancelled__c = false;
        GEMS_Group_Section__c gemsGroupObj2 = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        gemsGroupObj2.IsNew__c = true;
        gemsGroupObj2.IsCancelled__c = false;
        GEMS_Group_Section__c gemsGroupObj3 = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        gemsGroupObj3.IsNew__c = true;
        gemsGroupObj3.IsCancelled__c = false;
        GEMS_Group_Section__c gemsGroupObj4 = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        gemsGroupObj4.IsNew__c = true;
        gemsGroupObj4.IsCancelled__c = false;
        grplst.add(gemsGroupObj);
        grplst.add(gemsGroupObj2);
        grplst.add(gemsGroupObj3);
        grplst.add(gemsGroupObj4);
        insert grplst;
        GEMS_Category_Assignment__c gemsCatAsgmnt = GEMS_UtilityClassTest.insertionCategoryAssign(accRecQuery[0].Id,accStructureCase[0].id,gemsCat1.Id,grplst[0].Id);
        insert gemsCatAsgmnt;
        GEMS_BA_Assignment__c gemsbaass = GEMS_UtilityClassTest.insertionBaAssign(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemsGroupObj.Id);
        insert gemsbaass;
        accStructureCase[0].GEMS_Submission_Type__c = 'New Account';
        accStructureCase[0].status = 'Client Approval Received';

        update accStructureCase[0];
        GEMS_Billing_Profile__c billpro = new GEMS_Billing_Profile__c();
        billpro.Account__c=accRecQuery[0].Id;
        billpro.Case__c=accStructureCase[0].id;
        billpro.Billing_Address__c=address1.id;
        billpro.IsNew__c=true;
        billpro.IsUpdated__c=true;
        insert billpro;
        GEMS_BP_Category_Association__c bpcat =New GEMS_BP_Category_Association__c();
        bpcat.Billing_Profile__c=billpro.id;
        bpcat.Case__c=accStructureCase[0].id;
        bpcat.Category__c=gemscat1.id;
        bpcat.IsNew__c=true; 
        insert bpcat;
        //System.assertEquals('ABS',gemsCaract.Usage__c );
        List<id> idList = new List<Id>();
        idList.add(accStructureCase[0].id );
        //idList.add(accStructureCase[1].id);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new GEMS_MockHttpResponseGenerator()); 
        GEMS_AccountSetupServiceHelper.sendAccountStructure( idList );
        test.stoptest();
    } */
            
    private static testmethod void testForNewBANewCatExistingGS() {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';
        update accStructureCase[0];

        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        benefit.IsNew__c=true;
        benefit.Schedule__c= 'Tes';
        benefit.Billing_Assoc__c='Test';
        benefit.BA_Description__c='Test1';
        benefit.BA_Fund_Type__c ='PREM';
        benefit.IsCancelled__c = false;
        insert benefit;

        GEMS_Address__c address = New GEMS_Address__c();
        address.Account__c = accRecQuery[0].Id;
        address.Address_Sequence__c ='TX1-123-40';
        address.Usage__c='Primary;Billing';
        address.Contact_Phone__c='1455548921';
        address.Contact_Email__c='test@kk.com';
        address.IsNew__c=TRUE;
        
        insert address;   
         
        GEMS_Characteristic__c gemsCaract = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
        gemsCaract.Usage__c='Billing/Reporting';
        insert gemsCaract ;

        GEMS_Characteristic__c gemsCaract1 = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
        gemsCaract1.Usage__c='Billing/Product';
        insert gemsCaract1 ;
        GEMS_Characteristic_Value__c charval = GEMS_UtilityClassTest.insertionCharacValue(gemsCaract.id,accStructureCase[0].id);
        insert charval;

        GEMS_Category__c gemscat1 = GEMS_UtilityClassTest.insertiongemscat1(accRecQuery[0].Id,accStructureCase[0].id);
        gemscat1.Usage_Product__c =true;
        gemscat1.Usage_Billing__c=true;
        gemscat1.Usage_Reporting__c=true;
        gemscat1.Usage_Mailing__c=true;
        gemscat1.IsNew__c=true;
        gemscat1.IsUpdated__c=true;
        insert gemscat1;

        GEMS_BA_Category_Assignment__c catass = GEMS_UtilityClassTest.insertionBACategory(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemscat1.Id);
        insert catass;
        GEMS_Cat_Char_Value_Association__c charass = GEMS_UtilityClassTest.insertionAssociate(accStructureCase[0].id,accRecQuery[0].Id,charval.id,gemscat1.Id);
        insert charass; 

        List<GEMS_Group_Section__c> grplst =New List<GEMS_Group_Section__c>();
        GEMS_Group_Section__c gemsGroupObj = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        gemsGroupObj.IsNew__c = false;
        gemsGroupObj.IsCancelled__c = false;        
        grplst.add(gemsGroupObj);
        insert grplst;

        GEMS_Category_Assignment__c gemsCatAsgmnt = GEMS_UtilityClassTest.insertionCategoryAssign(accRecQuery[0].Id,accStructureCase[0].id,gemsCat1.Id,grplst[0].Id);
        insert gemsCatAsgmnt;
        
        GEMS_BA_Assignment__c gemsbaass = GEMS_UtilityClassTest.insertionBaAssign(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemsGroupObj.Id);
        insert gemsbaass;
        
        accStructureCase[0].status = 'Client Approval Received';
        test.startTest();
        update accStructureCase[0];

        List<id> idList = new List<Id>();
        idList.add(accStructureCase[0].id );
        //idList.add(accStructureCase[1].id);
        
        GEMS_Billing_Profile__c billpro = new GEMS_Billing_Profile__c();
        billpro.Account__c=accRecQuery[0].Id;
        billpro.Case__c=accStructureCase[0].id;
        billpro.Billing_Address__c=address.id;
        billpro.IsNew__c=true;
        billpro.IsUpdated__c=true;
        billpro.IsDescUpdate__c = true;
        insert billpro;
        
        GEMS_BP_Category_Association__c bpcat = new GEMS_BP_Category_Association__c();
        bpcat.Billing_Profile__c=billpro.id;
        bpcat.Case__c=accStructureCase[0].id;
        bpcat.Category__c=gemscat1.id;
        bpcat.IsNew__c=true; 
        insert bpcat;
        
		GEMS_BP_BA_Association__c bpBa = new GEMS_BP_BA_Association__c();
        bpBa.Billing_Profile__c=billpro.id;
        bpBa.Case__c=accStructureCase[0].id;
        bpBa.Benefit_Agreement__c =benefit.id;
        bpBa.IsNew__c=true; 
        insert bpBa;
        
        GEMS_AccountSetupServiceHelper.sendAccountStructure( idList );
        GEMS_AccountSetupServiceHelper.validateAccountStructure(accStructureCase[0].id);
        test.stoptest();
    }    
        
        private static testmethod void testForNewBAExistingCatExistingGS() {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';
        update accStructureCase[0];

        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        benefit.IsNew__c=true;
        benefit.Schedule__c= 'Tes';
        benefit.Billing_Assoc__c='Test';
        benefit.BA_Description__c='Test1';
        benefit.BA_Fund_Type__c ='PREM';
        benefit.IsCancelled__c = false;
        insert benefit;

        GEMS_Address__c address = New GEMS_Address__c();
        address.Account__c = accRecQuery[0].Id;
        address.Address_Sequence__c ='TX1-123-40';
        address.Usage__c='Primary;Billing';
        address.Contact_Phone__c='1455548921';
        address.Contact_Email__c='test@kk.com';
        address.IsNew__c=TRUE;
        
        insert address;   
         
        GEMS_Characteristic__c gemsCaract = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
        gemsCaract.Usage__c='Billing/Reporting';
        insert gemsCaract ;

        GEMS_Characteristic__c gemsCaract1 = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
        gemsCaract1.Usage__c='Billing/Product';
        insert gemsCaract1 ;
        GEMS_Characteristic_Value__c charval = GEMS_UtilityClassTest.insertionCharacValue(gemsCaract.id,accStructureCase[0].id);
        insert charval;

        GEMS_Category__c gemscat1 = GEMS_UtilityClassTest.insertiongemscat1(accRecQuery[0].Id,accStructureCase[0].id);
        gemscat1.Usage_Product__c =true;
        gemscat1.Usage_Billing__c=true;
        gemscat1.Usage_Reporting__c=true;
        gemscat1.Usage_Mailing__c=true;
        gemscat1.IsNew__c=false;
        gemscat1.IsUpdated__c=true;
        insert gemscat1;

        GEMS_BA_Category_Assignment__c catass = GEMS_UtilityClassTest.insertionBACategory(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemscat1.Id);
        insert catass;
        GEMS_Cat_Char_Value_Association__c charass = GEMS_UtilityClassTest.insertionAssociate(accStructureCase[0].id,accRecQuery[0].Id,charval.id,gemscat1.Id);
        insert charass; 

        List<GEMS_Group_Section__c> grplst =New List<GEMS_Group_Section__c>();
        GEMS_Group_Section__c gemsGroupObj = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        gemsGroupObj.IsNew__c = false;
        gemsGroupObj.IsCancelled__c = false;        
        grplst.add(gemsGroupObj);
        insert grplst;

        GEMS_Category_Assignment__c gemsCatAsgmnt = GEMS_UtilityClassTest.insertionCategoryAssign(accRecQuery[0].Id,accStructureCase[0].id,gemsCat1.Id,grplst[0].Id);
        insert gemsCatAsgmnt;
        
        GEMS_BA_Assignment__c gemsbaass = GEMS_UtilityClassTest.insertionBaAssign(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemsGroupObj.Id);
        insert gemsbaass;
        
        accStructureCase[0].status = 'Client Approval Received';
        test.startTest();
        update accStructureCase[0];

        List<id> idList = new List<Id>();
        idList.add(accStructureCase[0].id );
        //idList.add(accStructureCase[1].id);
        
        GEMS_Billing_Profile__c billpro = new GEMS_Billing_Profile__c();
        billpro.Account__c=accRecQuery[0].Id;
        billpro.Case__c=accStructureCase[0].id;
        billpro.Billing_Address__c=address.id;
        billpro.IsNew__c=true;
        billpro.IsUpdated__c=true;
        billpro.IsDescUpdate__c = true;
        insert billpro;
        
        GEMS_BP_Category_Association__c bpcat = new GEMS_BP_Category_Association__c();
        bpcat.Billing_Profile__c=billpro.id;
        bpcat.Case__c=accStructureCase[0].id;
        bpcat.Category__c=gemscat1.id;
        bpcat.IsNew__c=true; 
        insert bpcat;
        
		GEMS_BP_BA_Association__c bpBa = new GEMS_BP_BA_Association__c();
        bpBa.Billing_Profile__c=billpro.id;
        bpBa.Case__c=accStructureCase[0].id;
        bpBa.Benefit_Agreement__c =benefit.id;
        bpBa.IsNew__c=true; 
        insert bpBa;
        
        GEMS_AccountSetupServiceHelper.sendAccountStructure( idList );
        GEMS_AccountSetupServiceHelper.validateAccountStructure(accStructureCase[0].id);
        test.stoptest();
    } 
        private static testmethod void testForNewBANewCatNewGS() {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
    
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();

        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';
        update accStructureCase[0];

        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        benefit.IsNew__c=true;
        benefit.Schedule__c= 'Tes';
        benefit.Billing_Assoc__c='Test';
        benefit.BA_Description__c='Test1';
        benefit.BA_Fund_Type__c ='PREM';
        benefit.IsCancelled__c = false;
        insert benefit;

        GEMS_Address__c address = New GEMS_Address__c();
        address.Account__c = accRecQuery[0].Id;
        address.Address_Sequence__c ='TX1-123-40';
        address.Usage__c='Primary;Billing';
        address.Contact_Phone__c='1455548921';
        address.Contact_Email__c='test@kk.com';
        address.IsNew__c=TRUE;
        
        insert address;   
         
        GEMS_Characteristic__c gemsCaract = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
        gemsCaract.Usage__c='Billing/Reporting';
        insert gemsCaract ;

        GEMS_Characteristic__c gemsCaract1 = GEMS_UtilityClassTest.insertionCharacteristic(accRecQuery[0].Id,accStructureCase[0].id);
        gemsCaract1.Usage__c='Billing/Product';
        insert gemsCaract1 ;
        GEMS_Characteristic_Value__c charval = GEMS_UtilityClassTest.insertionCharacValue(gemsCaract.id,accStructureCase[0].id);
        insert charval;

        GEMS_Category__c gemscat1 = GEMS_UtilityClassTest.insertiongemscat1(accRecQuery[0].Id,accStructureCase[0].id);
        gemscat1.Usage_Product__c =true;
        gemscat1.Usage_Billing__c=true;
        gemscat1.Usage_Reporting__c=true;
        gemscat1.Usage_Mailing__c=true;
        gemscat1.IsNew__c=true;
        gemscat1.IsUpdated__c=true;
        insert gemscat1;

        GEMS_BA_Category_Assignment__c catass = GEMS_UtilityClassTest.insertionBACategory(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemscat1.Id);
        insert catass;
        GEMS_Cat_Char_Value_Association__c charass = GEMS_UtilityClassTest.insertionAssociate(accStructureCase[0].id,accRecQuery[0].Id,charval.id,gemscat1.Id);
        insert charass; 

        List<GEMS_Group_Section__c> grplst =New List<GEMS_Group_Section__c>();
        GEMS_Group_Section__c gemsGroupObj = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        gemsGroupObj.IsNew__c = true;
        gemsGroupObj.IsCancelled__c = false;        
        grplst.add(gemsGroupObj);
        insert grplst;

        GEMS_Category_Assignment__c gemsCatAsgmnt = GEMS_UtilityClassTest.insertionCategoryAssign(accRecQuery[0].Id,accStructureCase[0].id,gemsCat1.Id,grplst[0].Id);
        insert gemsCatAsgmnt;
        
        GEMS_BA_Assignment__c gemsbaass = GEMS_UtilityClassTest.insertionBaAssign(accRecQuery[0].Id,accStructureCase[0].id,benefit.id,gemsGroupObj.Id);
        insert gemsbaass;
        
        accStructureCase[0].status = 'Client Approval Received';
        test.startTest();
        update accStructureCase[0];

        List<id> idList = new List<Id>();
        idList.add(accStructureCase[0].id );
        //idList.add(accStructureCase[1].id);
        
        GEMS_Billing_Profile__c billpro = new GEMS_Billing_Profile__c();
        billpro.Account__c=accRecQuery[0].Id;
        billpro.Case__c=accStructureCase[0].id;
        billpro.Billing_Address__c=address.id;
        billpro.IsNew__c=true;
        billpro.IsUpdated__c=true;
        billpro.IsDescUpdate__c = true;
        insert billpro;
        
        GEMS_BP_Category_Association__c bpcat = new GEMS_BP_Category_Association__c();
        bpcat.Billing_Profile__c=billpro.id;
        bpcat.Case__c=accStructureCase[0].id;
        bpcat.Category__c=gemscat1.id;
        bpcat.IsNew__c=true; 
        insert bpcat;
        
		GEMS_BP_BA_Association__c bpBa = new GEMS_BP_BA_Association__c();
        bpBa.Billing_Profile__c=billpro.id;
        bpBa.Case__c=accStructureCase[0].id;
        bpBa.Benefit_Agreement__c =benefit.id;
        bpBa.IsNew__c=true; 
        insert bpBa;
        
        GEMS_AccountSetupServiceHelper.sendAccountStructure( idList );
        GEMS_AccountSetupServiceHelper.validateAccountStructure(accStructureCase[0].id);
        test.stoptest();
    }  
}