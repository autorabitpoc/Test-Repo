/**************************************************************************************
  Apex Class Name     : GEMS_HPS_MyCasesController_TEST
  Version             : 1.0
  Function            : This is a test class for GEMS_HPS_MyCasesController
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*  SIVA                    06/21/2016                
*************************************************************************************/
@isTest
public class GEMS_HPS_MyCasesController_TEST{

    static testMethod void myUnitTest() {
       try{
           Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
           User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
           insert testUser;
         system.runAs(testUser){
           //crate Account
          Account acc= GEMS_UtilityClassTest.insertionAccount();
          insert acc;
          
           Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
          System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
          
          Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
          
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        System.assertEquals(subRec.Id,caseTeamAccSpecMem.ParentId );
          
          //create the instance of constructor
          GEMS_HPS_MyCasesController tempController = new GEMS_HPS_MyCasesController();
          //assert the size of the case records queried
          system.assertEquals(1,tempController.myCasesList.size());
         }
       }
       catch(Exception e){
         throw e;
       } 
    }
}