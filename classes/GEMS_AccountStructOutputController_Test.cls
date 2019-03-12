@isTest
public class GEMS_AccountStructOutputController_Test {


        private static testmethod void GEMSAccountStructureController_TEST1(){
        
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
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;
        System.assertEquals('HSA',productRec1.Product_Category__c);
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals('Design In Progress',strCaseRec.status);
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(acc.Id,strRec.id,productRec1.Id);
                    benefit.IsNew__c=true;
                    benefit.Schedule__c= null;
                    insert benefit;
         GEMS_Group_Section__c gemsGroupObj = GEMS_UtilityClassTest.insertionGroup(acc.Id,strRec.id);
        insert gemsGroupObj;
        test.startTest();
        PageReference pageRef = Page.GEMSGenerateAccountStructure;
        Test.setCurrentPage(pageRef);
        apexpages.currentpage().getparameters().put('caseid',strRec.id);
        List<Case> ssss = new List<Case>();
        ssss.add(strRec);
        ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(SSSS);
        GEMS_AccountStructureOutputController accStrController = new GEMS_AccountStructureOutputController(stdController);
        //accStrController.saveGroupNos();
        //accStrController.saveAccountStructure();
        List<String> stringsList = new List<String>();
        for(Integer i=1; i<4 ; i++)
        {
            stringsList.add('test'+i);
        }
        
        List<Integer> intsList = new List<Integer>();
        for(Integer i=1; i<4 ; i++)
        {
            intsList.add(i);
        }
        
        accStrController.CharColumnCount = 2;
        accStrController.LoopCharVals = intsList;
        accStrController.noOfBAs = 2;
        accStrController.basperpage = 10;
        accStrController.disableNext = true;
        accStrController.disablePrev = false;
        accStrController.limitSize = 2;
        //accSetUpHelper.limitSize = 2;
        accStrController.offsetSize = 2;
        //accSetupHelper.offsetSize = 2;
        accStrController.getcharValforColumn();
        accStrController.GenerateDocument();
        accStrController.DownloadPDF();
        accStrController.gotoCase();
        accStrController.getNext();
        accStrController.getPrevious();
        
        //accStrController.init();
       /* accStrController.opp=opptyRec;
        accStrController.bas=benfAggList;
        accStrController.cats=gemsCatList;
        accStrController.oppPro=oppProdList;*/
        test.stopTest();
    }
    

}