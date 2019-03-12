/**************************************************************************************
  Apex Class Name     : GEMS_RequestAccountSpecialistCtrl_TEST
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_RequestAccountSpecialistController
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva             06/16/2016                Original Version
*************************************************************************************/
@isTest
public class GEMS_RequestAccountSpecialistCtrl_TEST{
    private static testmethod void GEMS_RequestAccountSpecialistController_TEST1()
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
        
        GEMS_RequestAccountSpecialistController reqacc =new GEMS_RequestAccountSpecialistController();
        GEMS_RequestAccountSpecialistController.createAccSpecialistCase(subRec.id,'Account Specialist');
     }
   }