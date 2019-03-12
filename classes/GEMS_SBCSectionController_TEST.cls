/**************************************************************************************
  Apex Class Name     : GEMS_SBCSectionController_TEST 
  Version             : 1.0
  Function            : This class serves as Unit Test Class for GEMS_SBCSectionController
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva               06/14/2016                Original Version
*************************************************************************************/
@isTest
public class GEMS_SBCSectionController_TEST {
    private static testmethod void GEMS_SBCSectionController_TEST1()
    {
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        test.startTest();

        Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'In Progress';
        subCaseRec.accountId = acc.Id;
        subCaseRec.GEMS_SBC_Required__c ='Yes';
        subCaseRec.GEMS_Grandfathered_benefits__c=true; 
        insert subCaseRec;

        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;

        GEMS_SBC_Request_Form__c sbcreq = new GEMS_SBC_Request_Form__c();
        sbcreq.Case__c = subCaseRec.id;
        sbcreq.GEMS_Current_No_of_Members__c=10;
        sbcreq.GEMS_Affected_Benefit_Agreements__c=13;
        sbcreq.GEMS_Number_of_SBCs_Being_Requested__c=12;
        sbcreq.GEMS_Number_of_BAs__c=12;
        sbcreq.GEMS_Current_No_of_Subscribers__c=10;
        sbcreq.GEMS_Grandfathered_benefit_s__c='Yes';
        sbcreq.GEMS_Rush__c = 'Yes';
        insert sbcreq;

        ApexPages.currentpage().getParameters().put('id',subCaseRec.id);
        ApexPages.currentpage().getParameters().put('ssspage','AccSub');
        ApexPages.StandardController std = new ApexPages.standardController(subCaseRec);
        GEMS_SBCSectionController sbcSec = new GEMS_SBCSectionController (std);
        PageReference pageRef = Page.GEMSSBCDetailpage;
        Test.setCurrentPage(pageRef);
        sbcSec.saveSBCCaseDetails();
        sbcSec.back();
        test.stopTest();
    }
    
    private static testmethod void GEMS_SBCSectionController_TEST2()
    {
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
        ApexPages.currentpage().getParameters().put('ssspage','AccSub');
        ApexPages.StandardController std = new ApexPages.standardController(strCaseRec);
        GEMS_SBCSectionController sbcSec = new GEMS_SBCSectionController (std);
        PageReference pageRef = Page.GEMSSBCDetailpage;
        Test.setCurrentPage(pageRef);
        test.stopTest();
    }

    private static testmethod void GEMS_SBCSectionController_TEST3()
    {
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
        ApexPages.currentpage().getParameters().put('ssspage','');
        ApexPages.StandardController std = new ApexPages.standardController(strCaseRec);
        GEMS_SBCSectionController sbcSec = new GEMS_SBCSectionController (std);
        PageReference pageRef = Page.GEMSSBCDetailpage;
        Test.setCurrentPage(pageRef);
        test.stopTest();
    }
    
    private static testmethod void GEMS_SBCSectionController_TEST4()
    {
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        acc.District__c='001';
        acc.Cluster__c='002';
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        test.startTest();

        Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'In Progress';
        subCaseRec.accountId = acc.Id;
        subCaseRec.GEMS_SBC_Required__c ='Yes';
        subCaseRec.GEMS_Grandfathered_benefits__c=false; 
        insert subCaseRec;

        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;

        GEMS_SBC_Request_Form__c sbcreq = new GEMS_SBC_Request_Form__c();
        sbcreq.Case__c = subCaseRec.id;
        sbcreq.GEMS_Did_HCSC_Create_the_SBC_Last_Year__c='Yes';
        sbcreq.GEMS_Carved_Out_Benefits_From_Vendors__c='Yes';
        sbcreq.GEMS_Minimum_Value_Standard_MV__c='Yes';
        sbcreq.GEMS_Sbc_District__c='001';
        sbcreq.GEMS_Cluster__c='002';
        sbcreq.GEMS_Rush__c = 'Yes';
        sbcreq.GEMS_Reason_for_Rush__c='Test';
        sbcreq.GEMS_Minimum_Essential_Coverage_MEC__c='Yes';
        insert sbcreq;
        GEMS_SBC_Request_Form__c  sbcrequestform =[select id,GEMS_Grandfathered_benefit_s__c,Case__c from GEMS_SBC_Request_Form__c where Case__c=:subCaseRec.id ]; 
        sbcrequestform.GEMS_Grandfathered_benefit_s__c =null;
        update sbcrequestform; 
        system.debug('+++sbcrequestform'+sbcrequestform); 
        ApexPages.currentpage().getParameters().put('id',subCaseRec.id);
        ApexPages.currentpage().getParameters().put('ssspage','AccSub');
        ApexPages.StandardController std = new ApexPages.standardController(subCaseRec);
        GEMS_SBCSectionController sbcSec = new GEMS_SBCSectionController (std);
        PageReference pageRef = Page.GEMSSBCDetailpage;
        Test.setCurrentPage(pageRef);
        sbcSec.saveSBCCaseDetails();
        sbcSec.back();
        test.stopTest();
    }
    
    private static testmethod void GEMS_SBCSectionController_TEST5()
    {
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        acc.District__c='001';
        acc.Cluster__c='002';
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        test.startTest();
       
        Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'In Progress';
        subCaseRec.accountId = acc.Id;
        subCaseRec.GEMS_SBC_Required__c ='Yes';
        subCaseRec.GEMS_Grandfathered_benefits__c=true; 
        insert subCaseRec;
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;

        GEMS_SBC_Request_Form__c sbcreq = new GEMS_SBC_Request_Form__c();
        sbcreq.Case__c = subCaseRec.id;
        sbcreq.GEMS_Current_No_of_Members__c=10;
        sbcreq.GEMS_Affected_Benefit_Agreements__c=13;
        sbcreq.GEMS_Number_of_SBCs_Being_Requested__c=12;
        sbcreq.GEMS_Did_HCSC_Create_the_SBC_Last_Year__c='Yes';
        sbcreq.GEMS_Carved_Out_Benefits_From_Vendors__c='Yes';
        sbcreq.GEMS_Current_No_of_Subscribers__c=10;
        sbcreq.GEMS_Grandfathered_benefit_s__c='Yes';
        sbcreq.GEMS_Minimum_Value_Standard_MV__c='Yes';
        sbcreq.GEMS_Sbc_District__c='001';
        sbcreq.GEMS_Cluster__c='002';
        sbcreq.GEMS_Rush__c = 'Yes';
        sbcreq.GEMS_Reason_for_Rush__c='Test';
        sbcreq.GEMS_Minimum_Essential_Coverage_MEC__c='Yes';
        sbcreq.GEMS_Number_of_BAs__c=10;
        insert sbcreq;

        ApexPages.currentpage().getParameters().put('id',subCaseRec.id);
        ApexPages.currentpage().getParameters().put('ssspage','AccSub');
        ApexPages.StandardController std = new ApexPages.standardController(subCaseRec);
        GEMS_SBCSectionController sbcSec = new GEMS_SBCSectionController (std);
        PageReference pageRef = Page.GEMSSBCDetailpage;
        Test.setCurrentPage(pageRef);
        sbcSec.saveSBCCaseDetails();
        sbcSec.back();
        test.stopTest();
    }
        
    private static testmethod void GEMS_SBCSectionController_TEST6()
    {
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        acc.District__c='001';
        acc.Cluster__c='002';
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        test.startTest();

        Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'In Progress';
        subCaseRec.accountId = acc.Id;
        subCaseRec.GEMS_SBC_Required__c ='Yes';
        subCaseRec.GEMS_Grandfathered_benefits__c=true; 
        insert subCaseRec;

        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        GEMS_SBC_Request_Form__c sbcreq = new GEMS_SBC_Request_Form__c();
        sbcreq.Case__c = subCaseRec.id;
        sbcreq.GEMS_Current_No_of_Members__c=10;
        sbcreq.GEMS_Affected_Benefit_Agreements__c=13;
        sbcreq.GEMS_Number_of_SBCs_Being_Requested__c=12;
        sbcreq.GEMS_Did_HCSC_Create_the_SBC_Last_Year__c='Yes';
        sbcreq.GEMS_Carved_Out_Benefits_From_Vendors__c='Yes';
        sbcreq.GEMS_Current_No_of_Subscribers__c=10;
        sbcreq.GEMS_Grandfathered_benefit_s__c='Yes';
        sbcreq.GEMS_Minimum_Value_Standard_MV__c='Yes';
        sbcreq.GEMS_Sbc_District__c='001';
        sbcreq.GEMS_Cluster__c='002';
        sbcreq.GEMS_Rush__c = 'Yes';
        sbcreq.GEMS_Reason_for_Rush__c='Test';
        sbcreq.GEMS_Minimum_Essential_Coverage_MEC__c='Yes';
        sbcreq.GEMS_Number_of_BAs__c=10;
        sbcreq.GEMS_Print_Mail__c='Yes';
        insert sbcreq;

        ApexPages.currentpage().getParameters().put('id',subCaseRec.id);
        ApexPages.currentpage().getParameters().put('ssspage','AccSub');
        ApexPages.StandardController std = new ApexPages.standardController(subCaseRec);
        GEMS_SBCSectionController sbcSec = new GEMS_SBCSectionController (std);
        PageReference pageRef = Page.GEMSSBCDetailpage;
        Test.setCurrentPage(pageRef);
        sbcSec.saveSBCCaseDetails();
        sbcSec.back();
        test.stopTest();
    }
}