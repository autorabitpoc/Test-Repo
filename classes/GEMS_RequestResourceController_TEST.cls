/**************************************************************************************
  Apex Class Name     : GEMS_RequestResourceController_TEST 
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_RequestResourceController
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva               06/17/2016                Original Version
*************************************************************************************/
@isTest
public class GEMS_RequestResourceController_TEST {
    private static testmethod void GEMS_RequestResourceController_TEST1(){
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        test.startTest();
        Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'In Progress';
        subCaseRec.accountId = acc.Id;
        insert subCaseRec;
        
         Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         user usr=[select id from user where id = :userinfo.getUserId()];
        CaseTeamRole role = [SELECT Id ,Name FROM CaseTeamRole WHERE Name = 'Account Specialist' limit 1];
        CaseTeamMember CTM1 = New CaseTeamMember(ParentId = subCaseRec.Id, MemberId = usr.Id , TeamRoleId = role.Id);
        //insert CTM1;
        
        
         
        Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Request Resource');
        subStrRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        subStrRec.sub_category__c= 'Account Specialist';
        subStrRec.accountId = acc.Id;
        subStrRec.GEMS_Assign_Resource__c=usr.id;
        insert subStrRec;
        
        /*Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
        where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];*/
               ApexPages.currentpage().getParameters().put('id',subStrRec.id);
    //ApexPages.StandardController std = new ApexPages.standardController(strCaseRec);
    GEMS_RequestResourceController sbcSec = new GEMS_RequestResourceController ();
        GEMS_RequestResourceController.updateCaseTeam(subStrRec.id);
       test.stopTest();
    }
    
     private static testmethod void GEMS_RequestResourceController_TEST2(){
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        test.startTest();
        Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'In Progress';
        subCaseRec.accountId = acc.Id;
        insert subCaseRec;
        
         Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         user usr=[select id from user where id = :userinfo.getUserId()];
        CaseTeamRole role = [SELECT Id ,Name FROM CaseTeamRole WHERE Name = 'Account Specialist' limit 1];
        CaseTeamMember CTM1 = New CaseTeamMember(ParentId = subCaseRec.Id, MemberId = usr.Id , TeamRoleId = role.Id);
        insert CTM1;
        
        
         
        Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Request Resource');
        subStrRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        subStrRec.sub_category__c= 'Account Specialist';
        subStrRec.accountId = acc.Id;
        subStrRec.GEMS_Assign_Resource__c=usr.id;
        insert subStrRec;
        
        /*Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
        where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];*/
               ApexPages.currentpage().getParameters().put('id',subStrRec.id);
    //ApexPages.StandardController std = new ApexPages.standardController(strCaseRec);
    GEMS_RequestResourceController sbcSec = new GEMS_RequestResourceController ();
        GEMS_RequestResourceController.updateCaseTeam(subStrRec.id);
       test.stopTest();
    }
}