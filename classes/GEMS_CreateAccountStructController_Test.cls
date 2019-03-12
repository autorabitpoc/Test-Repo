@isTest
public class GEMS_CreateAccountStructController_Test {

    public static testmethod void testMethodForAll() {
        
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
        test.starttest();
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        System.assertEquals(subCaseRec.Id,caseTeamAccSpecMem.ParentId );
        
        Case strRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        strRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        strRec.accountId = acc.Id;
        strRec.GEMS_Group_Numbers__c ='1234';
        strRec.Status = 'Design In Progress';
        insert strRec;

        /*
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals('Design In Progress',strCaseRec.status);
        test.startTest();
        GEMS_Group_Section__c grpSec = GEMS_UtilityClassTest.insertionGroup(acc.Id,strCaseRec.Id);
        insert grpSec ;
        
        strCaseRec.GEMS_Reserved_Group_Numbers__c = '1234';
        strCaseRec.Status = 'Client Approval Received';
        update strCaseRec;
        
        Case strRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        strRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        strRec.accountId = acc.Id;
        strRec.GEMS_Reserved_Group_Numbers__c = '1234';
        strRec.Status = 'Client Approval Received';
        insert strRec;
        
        GEMS_Group_Section__c grpSec = GEMS_UtilityClassTest.insertionGroup(acc.Id,strRec.Id);
        insert grpSec;
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals('Client Approval Received',strCaseRec.status);  */
        
        List<String> stringsList = new List<String>();
        for(Integer i=1; i<4 ; i++)
        {
            stringsList.add('test'+i);
        }
        
        ApexPages.currentPage().getParameters().put('caseId',subCaseRec.Id);
        ApexPages.StandardSetController controller = new ApexPages.StandardSetController(caseList);
        GEMS_CreateAccountStructureController accStructController = new GEMS_CreateAccountStructureController(controller);
        accStructController.ListGroupNosTrial=stringsList;
        //accStructController.ValidateAccountStructure();
        accStructController.saveGroupNos();
        accStructController.saveAccountStructure();
        accStructController.GenerateDocument();
        accStructController.DownloadPDF();
        accStructController.gotoCase();
        test.stopTest(); 
    }    
    
 }