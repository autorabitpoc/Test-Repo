/**************************************************************************************
  Apex Class Name     : GEMS_MembershipController_TEST
  Version             : 1.0
  Function            : This class serves as Unit Test Class for  GEMS_MembershipController
  Modification Log    :
* Developer           :    Date                   Description
* ----------------------------------------------------------------------------                 
* Siva Thimmannagari     06/16/2016                Original Version
*************************************************************************************/

@isTest
public class GEMS_MembershipController_TEST
{
 private static testmethod void GEMS_MembershipController_TEST1()
    {
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        
        
       test.startTest();
       
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        System.assertEquals(subCaseRec.Id,caseTeamAccSpecMem.ParentId );
        
        
       Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
       insert testuser;
        
        List<Task> taskList = new List<Task>();
        
         task taskObj = new task();
        taskObj.status = 'In Progress';
        taskObj.subject = 'Load and Test Benefit Accums';
        taskObj.GEMS_start_date__c = System.now();
        taskObj.whatId = subRec.Id;
        taskObj.ownerId = testUser.Id;
        taskObj.status = 'Completed';
        taskObj.Priority = 'Normal';
        taskList.add(taskObj);
        
        task taskRel = new task();
        taskRel.status = 'In Progress';
        taskRel.subject = 'Release Claims Hold';
        taskRel.GEMS_start_date__c = System.now();
        taskRel.whatId = subRec.Id;
        taskRel.ownerId = testUser.Id;
        taskObj.status = 'Completed';
        taskRel.Priority = 'Normal';
        taskList.add(taskRel);
        
        task taskElig = new task();
        taskElig.status = 'In Progress';
        taskElig.subject = 'Confirm Accums Tested';
        taskElig.GEMS_start_date__c = System.now();
        taskElig.whatId = subRec.Id;
        taskElig.ownerId = testUser.Id;
        taskElig.status = 'Completed';
        taskRel.Priority = 'Normal';
        taskList.add(taskElig);
        
        
        insert taskList;
        
        
        ApexPages.currentpage().getParameters().put('id',subRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(subRec);
        GEMS_MembershipController membership = new GEMS_MembershipController(std);
        PageReference pageRef = Page.GEMSMembershipTask;
        Test.setCurrentPage(pageRef);
        membership.changeTaskStatus();
         
     test.stopTest();
    
    }
    
    private static testmethod void GEMS_MembershipController_TEST2()
    {
            
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'Completed';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        test.startTest();

        ApexPages.currentpage().getParameters().put('id',subRec.id);
        ApexPages.StandardController std1 = new ApexPages.standardController(subRec);
        GEMS_MembershipController membership = new GEMS_MembershipController(std1);
        PageReference pageRef = Page.GEMSMembershipTask;
        Test.setCurrentPage(pageRef);
        membership.changeTaskStatus();
         
     test.stopTest();
    
    }
}