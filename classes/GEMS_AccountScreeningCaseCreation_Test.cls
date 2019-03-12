/**************************************************************************************
  Apex Class Name     : GEMS_AccountScreeningCaseCreation_Test 
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_AccountScreeningCaseCreation
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------------                 
*   Siva                    06/22/2016                Original Version
*************************************************************************************/
@isTest
public class GEMS_AccountScreeningCaseCreation_Test {
    private static testmethod void AccountScreeningCaseCreation()
    {
      Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name); 
        
        List<Case> caseList = New List<Case>();
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        caseList.add(subRec);
        insert caseList; 
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        test.startTest();
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        System.assertEquals(subCaseRec.Id,caseTeamAccSpecMem.ParentId );
        
        GEMS_Attachment__c gemsAttach11 = new GEMS_Attachment__c();
        gemsAttach11.type__c='SIGNED BPA';
        gemsAttach11.Attachment__c = 'ts';
        gemsAttach11.case__c=subCaseRec.Id;
        insert gemsAttach11;
        
        Case strRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        strRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        strRec.accountId = acc.Id;
        strRec.Status = 'Design In Progress';
        insert strRec;

        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals('Design In Progress',strCaseRec.status);
        
       
        GEMS_AccountScreeningCaseCreation.screeningCasesCreation(caseList,True);
        
        test.stopTest();  
    }
    
    
    private static testmethod void AccountScreeningCaseCreation2()
    {
      Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name); 
        
        List<Case> caseList = New List<Case>();
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        subRec.GEMS_Submission_Type__c= 'New';
        subRec.GEMS_StdCust_Product__c= 'Custom Products only';
        caseList.add(subRec);
        insert caseList; 
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        test.startTest();
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        System.assertEquals(subCaseRec.Id,caseTeamAccSpecMem.ParentId );
        
        GEMS_Attachment__c gemsAttach11 = new GEMS_Attachment__c();
        gemsAttach11.type__c='SIGNED BPA';
        gemsAttach11.Attachment__c = 'ts';
        gemsAttach11.case__c=subCaseRec.Id;
        insert gemsAttach11;
        
        Case strRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        strRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        strRec.accountId = acc.Id;
        strRec.Status = 'Design In Progress';
        insert strRec;

        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals('Design In Progress',strCaseRec.status);
        
       
        GEMS_AccountScreeningCaseCreation.screeningCasesCreation(caseList,true);
        
        test.stopTest();  
    }
    
    private static testmethod void testCreateAccountMaintenanceDownstreamCases(){
    	Account accRec;
        accRec = new Account();
        accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec.Name = 'TestAccountForCaseTriggerHandler';
        accRec.Group_Number__c= 'B06093';
        accRec.external_id__c= 'B06093';
        accRec.BillingStreet ='Testing';
        accRec.BillingCity='TX';
        accRec.BillingState='CT';
        accRec.BillingPostalCode='534323';
        accRec.status__c = 'Active';
        accRec.AccountNumber = '012456';
        insert accRec;
        
        Entitlement en = new Entitlement();
        en.name='GEMS Process Entitlement';
        en.accountid = accRec.id;
        en.startdate = system.today();
        en.enddate = system.today();
        insert en;
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testUser1;
        
        AccountTeamMember accTeamMemberAccSpecialist = new AccountTeamMember ();
        accTeamMemberAccSpecialist.UserId =testUser1.id;
        accTeamMemberAccSpecialist.TeamMemberRole = 'Account Specialist';
        accTeamMemberAccSpecialist.AccountId =accRec.id;
        insert accTeamMemberAccSpecialist;
        
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
        case cs = new case();
        cs.accountid = accRec.Id;
        cs.recordtypeid = caseAccountSubmissionId;
        cs.status = 'New';
        cs.GEMS_Case_Effective_Date__c = system.today();
        insert cs;
        Set<ID> strucMainCaseIds = new Set<Id>(); 
        List<string> TypeofDownStCases=new List<string>(); 
        
        TypeofDownStCases.add('GEMS Account Setup');
        strucMainCaseIds.add(cs.id);
        GEMS_AccountScreeningCaseCreation.CreateAccountMaintenanceDownstreamCases(strucMainCaseIds,TypeofDownStCases,'BlueSTAR Entry Complete');

    }

}