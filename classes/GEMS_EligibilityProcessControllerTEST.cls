/**************************************************************************************
  Apex Class Name     : GEMS_EligibilityProcessControllerTEST
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_EligibilityProcessController
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Rajesh                 11/24/2016                Original Version
*************************************************************************************/
@isTest
public class GEMS_EligibilityProcessControllerTEST{
    private static testmethod void GEMS_EligibilityProcessControllerTEST1()
    {
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name); 
        
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
        ApexPages.currentPage().getParameters().put('caseId',subRec.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(subRec);
        GEMS_EligibilityProcessController eligibility = new GEMS_EligibilityProcessController(sc);
        eligibility.save();
        eligibility.checkCurrentUserisACDHPQueMember();
        eligibility.isCDHPGroupMember =false;
        
        PageReference pageRef = Page.GEMSEligibilityProcessPage;
        Test.setCurrentPage(pageRef);
    }
    }