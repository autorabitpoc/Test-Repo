/**************************************************************************************
  Apex Class Name     : GEMS_GetPageController_TEST 
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_GetPageController
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva               06/17/2016                Original Version
*************************************************************************************/
@isTest
public class GEMS_GetPageController_TEST {
    private static testmethod void GEMS_GetPageController_TEST1(){
         
        
      
        
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        
        test.startTest();
        Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'In Progress';
        subCaseRec.accountId = acc.Id;
        insert subCaseRec;
        
        ApexPages.currentpage().getParameters().put('id',subCaseRec.id);
    ApexPages.StandardController std = new ApexPages.standardController(subCaseRec);
    GEMS_GetPageController sbcSec = new GEMS_GetPageController (std);
        PageReference pageRef = Page.GEMSGetPage;
             Test.setCurrentPage(pageRef);
      sbcSec.save();
    
    test.stopTest();
        
    }
    
     private static testmethod void GEMS_GetPageController_TEST2(){
        
        
        
        
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        
       test.startTest();
        
        Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'In Progress';
        subCaseRec.accountId = acc.Id;
        subCaseRec.GEMS_SBC_Required__c ='Yes';
        insert subCaseRec;
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        subStrRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        subStrRec.accountId = acc.Id;
        insert subStrRec;
        
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
        where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        
       
        
        
            
        ApexPages.currentpage().getParameters().put('id',strCaseRec.id);
    ApexPages.StandardController std = new ApexPages.standardController(strCaseRec);
    GEMS_GetPageController sbcSec = new GEMS_GetPageController (std);
          sbcSec.save();
        PageReference pageRef = Page.GEMSGetPage;
             Test.setCurrentPage(pageRef);
      test.stopTest();
    }

}