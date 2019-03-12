/**************************************************************************************
  Apex Class Name     : GEMS_ScreeningCaseCtrlBatch_test
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_ScreeningCaseControllerBatch
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------------                 
*   Siva Thimmannagari      07/21/2016               Original Version
*   Shankar                 09/22/2017               Code coverage improvements
*************************************************************************************/ 
@isTest
private class GEMS_ScreeningCaseCtrlBatch_test{  
    
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
        
        product2 productRec2=GEMS_UtilityClassTest.insertionProduct8();
        insert productRec2;
        System.assertEquals('Dental',productRec2.Product_Category__c);
        
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        List<case> caseList = new List<case>();
        case cs = new case();
        cs.accountid = accRecQuery[0].Id;
        cs.Opportunity_Name__c= oppRec.id;
        cs.recordtypeid = caseAccountSubmissionId;
        cs.GEMS_Are_commissions_paid_for_account__c = 'No';
        cs.status = 'New';
        
        case cs1 = new case();
        cs1.accountid = accRecQuery[1].Id;
        cs1.Opportunity_Name__c= oppRec.id;
        cs1.recordtypeid = caseAccountSubmissionId;
        cs1.GEMS_Are_commissions_paid_for_account__c = 'No';
        cs1.status = 'New';
        case cs3 = new case();
        cs3.accountid = accRecQuery[1].Id;
        cs3.Opportunity_Name__c= oppRec.id;
        cs3.recordtypeid = caseAccountSubmissionId;
        cs3.GEMS_Are_commissions_paid_for_account__c = 'No';
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
            accSubCase1.GEMS_Are_commissions_changing__c = 'No';
            
        }
        accSubCase[0].GEMS_Submission_Type__c = 'Renewal';        
        accSubCase[0].GEMS_StdCust_Product__c = 'Custom Products only';
        accSubCase[0].GEMS_Submission_Type__c='Off Cycle';
        accSubCase[0].GEMS_Submission_Sub_Type__c='Funding Change';
        accSubCase[0].GEMS_Is_Eligibility_Required__c = 'Yes';
        accSubCase[0].GEMS_All_required_documents_attached__c= true;
        accSubCase[0].GEMS_Rx_Vendor__c = 'ABC';
        accSubCase[0].GEMS_Products__c='Dental';
        accSubCase[0].GEMS_Line_of_Business__c='ENA';
        accSubCase[0].GEMS_Effective_Date__c = System.today();
        accSubCase[0].HCSC_Division__c = 'TX';
        accSubCase[1].HCSC_Division__c = 'TX';
        accSubCase[2].HCSC_Division__c = 'TX';
        accSubCase[0].GEMS_AEP_Account__c= False;
        accSubCase[0].GEMS_OE_Eligibility_Method__c='Paper/XLS';
        
        update accSubCase;
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure'];
        
    } 
    
    private static testmethod void method1() {
        test.startTest();
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
        benefit.Schedule__c= null;
        insert benefit;
        GEMS_Group_Section__c grpSec = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        insert grpSec;
        accStructureCase[0].status = 'Client Approval Received';

       
        update accStructureCase[0];  
        
        GEMS_Attachment__c gemsAttach11 = new GEMS_Attachment__c();
        gemsAttach11.type__c='BPA';
        gemsAttach11.Attachment__c = 'ts';
        gemsAttach11.case__c=accSubCase[0].Id;
        insert gemsAttach11;
        GEMS_ScreeningCaseControllerBatch casebatch = new GEMS_ScreeningCaseControllerBatch();
        GEMS_ScreeningCaseControllerBatch.validatedocCheckToCreateScreening(accSubCase[0].id,true,true);
        GEMS_ScreeningCaseControllerBatch.checkRequiredDocuments(accSubCase);
        test.stoptest();
    }
    
    private static testmethod void method2() {
        test.startTest();
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accSubCase[0].GEMS_StdCust_Product__c = 'Custom Products only';
        accSubCase[0].GEMS_All_required_documents_attached__c= true;
        
        update accSubCase[0];
        GEMS_Attachment__c gemsAttach11 = new GEMS_Attachment__c();
        gemsAttach11.type__c='BPA';
        gemsAttach11.Attachment__c = 'ts';
        gemsAttach11.case__c=accSubCase[0].Id;
        insert gemsAttach11;
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';
        update accStructureCase[0]; 
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        benefit.IsNew__c=true;
        benefit.Schedule__c= null;
        insert benefit;
        GEMS_Group_Section__c grpSec = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        insert grpSec;
        accStructureCase[0].status = 'Client Approval Received';
          
        
        
        update accStructureCase[0];
        GEMS_ScreeningCaseControllerBatch casebatch = new GEMS_ScreeningCaseControllerBatch();
        GEMS_ScreeningCaseControllerBatch.validatedocCheckToCreateScreening(accSubCase[0].id,true,true);
        test.stoptest();
    }  
    
    private static testmethod void method3() {
    test.startTest();
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accSubCase[0].GEMS_StdCust_Product__c = 'Standard Products only';
        accSubCase[0].GEMS_All_required_documents_attached__c= true;
        accSubCase[0].GEMS_SBC_Required__c= 'Yes';
        update accSubCase[0];
        GEMS_Attachment__c gemsAttach11 = new GEMS_Attachment__c();
        gemsAttach11.type__c='BPA';
        gemsAttach11.Attachment__c = 'ts';
        gemsAttach11.case__c=accSubCase[0].Id;
        insert gemsAttach11;
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';
        update accStructureCase[0]; 
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        benefit.IsNew__c=true;
        benefit.Schedule__c= null;
        insert benefit;
        GEMS_Group_Section__c grpSec = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        insert grpSec;
        accStructureCase[0].status = 'Client Approval Received';
          
        
        
        
        update accStructureCase[0];
        GEMS_ScreeningCaseControllerBatch casebatch = new GEMS_ScreeningCaseControllerBatch();
        GEMS_ScreeningCaseControllerBatch.validatedocCheckToCreateScreening(accSubCase[0].id,true,true);
        test.stoptest();
    } 
    
    private static testmethod void method4() {
        test.startTest();
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accSubCase[0].GEMS_StdCust_Product__c = 'Standard and Custom Products';
        accSubCase[0].GEMS_All_required_documents_attached__c= true;
        accSubCase[0].GEMS_SBC_Required__c= 'Yes';
        
        update accSubCase[0];
        GEMS_Attachment__c gemsAttach11 = new GEMS_Attachment__c();
        gemsAttach11.type__c='BPA';
        gemsAttach11.Attachment__c = 'ts';
        gemsAttach11.case__c=accSubCase[0].Id;
        insert gemsAttach11;
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';
        update accStructureCase[0]; 
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        benefit.IsNew__c=true;
        benefit.Schedule__c= null;
        insert benefit;
        GEMS_Group_Section__c grpSec = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        insert grpSec;
        accStructureCase[0].status = 'Client Approval Received';
        update accStructureCase[0]; 
        GEMS_ScreeningCaseControllerBatch casebatch = new GEMS_ScreeningCaseControllerBatch();
        GEMS_ScreeningCaseControllerBatch.validatedocCheckToCreateScreening(accSubCase[0].id,true,true);
        
        test.stoptest();
    } 
    
    private static testmethod void method5() {
        test.startTest();
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId LIMIT 1];
        
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId LIMIT 1];
        accSubCase[0].GEMS_StdCust_Product__c = 'Custom Products only';
        accSubCase[0].GEMS_All_required_documents_attached__c= true;
        accSubCase[0].GEMS_SBC_Required__c= 'Yes';
        accSubCase[0].GEMS_AEP_Account__c = true;
        update accSubCase[0];
        
        GEMS_Attachment__c gemsAttach11 = new GEMS_Attachment__c();
        gemsAttach11.type__c='BPA';
        gemsAttach11.Attachment__c = 'ts';
        gemsAttach11.case__c=accSubCase[0].Id;
        insert gemsAttach11;
        
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX' LIMIT 1];
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';
                
        update accStructureCase[0]; 
        List<GEMS_Benefit_Agreement__c> baList = new List<GEMS_Benefit_Agreement__c>();
        GEMS_Benefit_Agreement__c benefit1=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        benefit1.IsNew__c=true;
        benefit1.Schedule__c= null;
        
        GEMS_Benefit_Agreement__c benefit2=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit3=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit4=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit5=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit6=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit7=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit8=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit9=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit10=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit11=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit12=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit13=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit14=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit15=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit16=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit17=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit18=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit19=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit20=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        baList.add(benefit1);
        baList.add(benefit2);
        baList.add(benefit3);
        baList.add(benefit4);
        baList.add(benefit5);
        baList.add(benefit6);
        baList.add(benefit7);
        baList.add(benefit8);
        baList.add(benefit9);
        baList.add(benefit10);
        baList.add(benefit11);
        baList.add(benefit12);
        baList.add(benefit13);
        baList.add(benefit14);
        baList.add(benefit15);
        baList.add(benefit16);
        baList.add(benefit17);
        baList.add(benefit18);
        baList.add(benefit19);
        baList.add(benefit20);
        insert baList;
        
        GEMS_Group_Section__c grpSec = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        insert grpSec;
        accStructureCase[0].status = 'Client Approval Received';
        
      
        
        update accStructureCase[0];  
        GEMS_ScreeningCaseControllerBatch casebatch = new GEMS_ScreeningCaseControllerBatch();
        GEMS_ScreeningCaseControllerBatch.validatedocCheckToCreateScreening(accSubCase[0].id,false,true);
        test.stoptest();
    } 
    
    private static testmethod void method6() {
        test.startTest();
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accSubCase[0].GEMS_StdCust_Product__c = 'Standard Products only';
        accSubCase[0].GEMS_All_required_documents_attached__c= true;
        accSubCase[0].GEMS_SBC_Required__c= 'Yes';
        update accSubCase[0];
        GEMS_Attachment__c gemsAttach11 = new GEMS_Attachment__c();
        gemsAttach11.type__c='BPA';
        gemsAttach11.Attachment__c = 'ts';
        gemsAttach11.case__c=accSubCase[0].Id;
        insert gemsAttach11;
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';
        accStructureCase[0].GEMS_Account_Submission_Info__c  = accSubCase[0].Id;
        accStructureCase[0].Parent= accSubCase[0];
        update accStructureCase[0]; 
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        benefit.IsNew__c=true;
        benefit.Schedule__c= null;
        insert benefit;
        GEMS_Group_Section__c grpSec = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        insert grpSec;
        accStructureCase[0].status = 'Client Approval Received';
          
        
        
        update accStructureCase[0];
        GEMS_ScreeningCaseControllerBatch casebatch = new GEMS_ScreeningCaseControllerBatch();
        GEMS_ScreeningCaseControllerBatch.validatedocCheckToCreateScreening(accSubCase[0].id,false,true);
        test.stoptest();
    } 
    private static testmethod void method7() {
        test.startTest();
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId ];
        
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        product2 productRec1 =[select id,name from product2 where Product_Category__c='HSA'LIMIT 1];
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        accSubCase[0].GEMS_StdCust_Product__c = 'Custom Products only';
        accSubCase[0].GEMS_All_required_documents_attached__c= true;
        accSubCase[0].GEMS_Rx_Vendor__c = 'ABC';
        update accSubCase[0];
        
        GEMS_Attachment__c gemsAttach11 = new GEMS_Attachment__c();
        gemsAttach11.type__c='BPA';
        gemsAttach11.Attachment__c = 'ts';
        gemsAttach11.case__c=accSubCase[0].Id;
        insert gemsAttach11;
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX'];
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';
        update accStructureCase[0]; 
        List<GEMS_Benefit_Agreement__c> baList = new List<GEMS_Benefit_Agreement__c>();
        GEMS_Benefit_Agreement__c benefit1=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        benefit1.IsNew__c=true;
        benefit1.Schedule__c= null;
        GEMS_Benefit_Agreement__c benefit2=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit3=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit4=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit5=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit6=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit7=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit8=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit9=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit10=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit11=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit12=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit13=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit14=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit15=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit16=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit17=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit18=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit19=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        GEMS_Benefit_Agreement__c benefit20=GEMS_UtilityClassTest.insertionBenefit(accRecQuery[0].Id,accStructureCase[0].id,productRec1.Id);
        baList.add(benefit1);
        baList.add(benefit2);
        baList.add(benefit3);
        baList.add(benefit4);
        baList.add(benefit5);
        baList.add(benefit6);
        baList.add(benefit7);
        baList.add(benefit8);
        baList.add(benefit9);
        baList.add(benefit10);
        baList.add(benefit11);
        baList.add(benefit12);
        baList.add(benefit13);
        baList.add(benefit14);
        baList.add(benefit15);
        baList.add(benefit16);
        baList.add(benefit17);
        baList.add(benefit18);
        baList.add(benefit19);
        baList.add(benefit20);
        insert baList;
        GEMS_Group_Section__c grpSec = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        insert grpSec;
        accStructureCase[0].status = 'Client Approval Received';
        accStructureCase[0].parentId = accSubCase[0].Id;
        accStructureCase[0].GEMS_AEP_Account__c = true;
         
        
        
        update accStructureCase[0]; 
        GEMS_ScreeningCaseControllerBatch casebatch = new GEMS_ScreeningCaseControllerBatch();
        GEMS_ScreeningCaseControllerBatch.validatedocCheckToCreateScreening(accSubCase[0].id,true,true);
        test.stoptest();
    }
    
    private static testmethod void testChildCaseCreationForBAWithoutProductType() {
        test.startTest();

        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Id baScrTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId];
        System.assert(!accRecQuery.isEmpty());
        
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name, GEMS_Is_Eligibility_Required__c,GEMS_AEP_Account__c, GEMS_BCC_Products__c, GEMS_Rx_Vendor__c, GEMS_Submission_Type__c, GEMS_Products__c from Case where  recordtypeid = :caseAccountSubmissionId LIMIT 1];
        System.assert(!accSubCase.isEmpty());
        
        accSubCase[0].GEMS_StdCust_Product__c = 'Custom Products only';
        accSubCase[0].GEMS_All_required_documents_attached__c= true;
        accSubCase[0].GEMS_Rx_Vendor__c = 'ABC';
        accSubCase[0].GEMS_Submission_Type__c='Renewal';
        accSubCase[0].GEMS_Submission_Sub_Type__c='Account Structure Change';
        
        accSubCase[0].GEMS_Products__c='Dental';
        accSubCase[0].GEMS_Line_of_Business__c='ENA';
        accSubCase[0].GEMS_Effective_Date__c = System.today();
        update accSubCase[0];
        
        GEMS_Attachment__c gemsAttach11 = new GEMS_Attachment__c();
        gemsAttach11.type__c='BPA';
        gemsAttach11.Attachment__c = 'ts';
        gemsAttach11.case__c=accSubCase[0].Id;
        insert gemsAttach11;

        accStructureCase =[select id,RecordType.Name,GEMS_Submission_Sub_Type__c from case where RecordType.Name ='GEMS Account Structure' and hcsc_division__c ='TX' and GEMS_Account_Submission_Info__c=:accSubCase[0].Id];
        System.assert(!accStructureCase.isEmpty());
        
        product2 prod =[select id,name,Product_Category__c from product2 where Product_Category__c='Dental'LIMIT 1];
        System.assertEquals('Dental',prod.Product_Category__c);
        
        Plan__c pl = new Plan__c();
        pl.Product__c = prod.id;
        pl.External_Id__c = 'plan999';
        pl.Plan_Type__c = 'PDent';
        insert pl;
        
        
        GEMS_Benefit_Agreement__c b= new GEMS_Benefit_Agreement__c();
        b.Name='1234';
        b.Account__c = accRecQuery[0].id;
        b.AccountStructureCase__c=accStructureCase[0].id;        
        b.Product__c = null;
        b.IsNew__c=true;
        b.Schedule__c= 'tes';
        b.Plan__c = pl.id;
        b.BA_Fund_Type__c='ACAP'; 
        b.Has_Group_Sections__c = true; 
        b.IsNew__c=true;
        insert b;
        
        GEMS_Benefit_Agreement__c bb = [Select Plan__r.Product__r.Product_Category__c, Id from GEMS_Benefit_Agreement__c where Id=:b.id];
        System.assert('Dental'==bb.Plan__r.Product__r.Product_Category__c);
        
        GEMS_Group_Section__c grpSec = GEMS_UtilityClassTest.insertionGroup(accRecQuery[0].Id,accStructureCase[0].id);
        insert grpSec;
        
        accStructureCase[0].GEMS_Reserved_Group_Numbers__c = 'B06093';
        accStructureCase[0].status = 'Client Approval Received';
        accStructureCase[0].GEMS_Effective_Date__c = System.today();
        accStructureCase[0].parentId = accSubCase[0].Id;
        update accStructureCase[0]; 
        List<Case> submissionCases = new List<Case>();
        submissionCases.add(accSubCase[0]);
        List<Case> accStructCases = new List<Case>();
        accStructCases.add(accStructureCase[0]);
        
       // GEMS_ScreeningCaseControllerBatch.createScreeningCases(submissionCases,accStructCases[0], accStructCases);
        //List<Case> children = [Select Id from Case where  GEMS_Benefit_Agreement__c = :b.Id and RecordType.Id=:baScrTypeId];
 
        test.stoptest();
        
        //System.assert(!children.isEmpty());      
        
    }
    
    private static testmethod void testCheckRequiredDocuments() {
         test.startTest();

        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Id baScrTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Screening').getRecordTypeId();
        List<Account> accRecQuery=[SELECT ID, name,external_id__c FROM Account WHERE recordtypeid=:recTypeId];
        System.assert(!accRecQuery.isEmpty());
        
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Case accSubCase = new Case();
        accSubCase.RecordTypeId=caseAccountSubmissionId;
        accSubCase.GEMS_Submission_Type__c = 'Renewal';        
        accSubCase.GEMS_StdCust_Product__c = 'Custom Products only';
        accSubCase.GEMS_Submission_Type__c='Off Cycle';
        accSubCase.GEMS_Submission_Sub_Type__c='Funding Change';
        accSubCase.GEMS_Is_Eligibility_Required__c = 'Yes';
        accSubCase.GEMS_All_required_documents_attached__c= true;
        accSubCase.GEMS_Rx_Vendor__c = 'ABC';
        accSubCase.GEMS_Products__c='Dental';
        accSubCase.GEMS_Line_of_Business__c='ENA';
        accSubCase.GEMS_Effective_Date__c = System.today();
        accSubCase.HCSC_Division__c = 'TX';       
        accSubCase.GEMS_Products__c='Dental;BCC';
        accSubCase.GEMS_Line_of_Business__c='ENA';
        accSubCase.GEMS_Effective_Date__c = System.today(); 
        accSubCase.Funding_Type_Multiselect__c='ASO';
        insert accSubCase;
        
        GEMS_Attachment__c gemsAttach11 = new GEMS_Attachment__c();
        gemsAttach11.type__c='BPA';
        gemsAttach11.Attachment__c = 'ts';
        gemsAttach11.case__c=accSubCase.Id;
        insert gemsAttach11;
        
        List<Case> subCases = new List<Case>();
        subCases.add(accSubCase);
        
        String missedDocs = GEMS_ScreeningCaseControllerBatch.checkRequiredDocuments(subCases);
        System.assert(missedDocs!='');
        Test.stopTest();
    }
}