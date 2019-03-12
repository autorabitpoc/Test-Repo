/**************************************************************************************
Apex Class Name       : GEMSAccountStructureController_TEST
Version               : 1.0
Function              : This class serves as Unit Test Class for GEMSAccountStructureController. 
Modification Log      : 
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
    Siva            7/19/2016               Original Version
    Luke Chen       5/18/2017               test new method saveDraftAccountStructure()
    Ketki J         7/11/2017               test new method duplicate group section check SFDC-5085
    Luke Chen       5/17/2018				SFDC-8446 test new method populateGroupNo()
*************************************************************************************/
@isTest
public class GEMSAccountStructureController_TEST{
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
        benefit.Name = '005';
        benefit.IsNew__c=true;
        benefit.Schedule__c= null;
        insert benefit;
        
        
        GEMS_Benefit_Agreement__c benefit2=GEMS_UtilityClassTest.insertionBenefit(acc.Id,strRec.id,productRec1.Id);
        benefit2.Name = '006';
        benefit2.IsNew__c=true;
        benefit2.Schedule__c= null;
        insert benefit2;
        
        GEMS_Characteristic__c gemsCaract = GEMS_UtilityClassTest.insertionCharacteristic(acc.Id,strRec.id);
        gemsCaract.Usage__c='Billing/Product/Reporting';
        insert gemsCaract ;

        
        GEMS_Characteristic_Value__c charval = GEMS_UtilityClassTest.insertionCharacValue(gemsCaract.id,strRec.id);
        insert charval;

        GEMS_Category__c gemscat1 = GEMS_UtilityClassTest.insertiongemscat1(acc.Id,strRec.id);
        gemscat1.Usage_Product__c =true;
        gemscat1.Usage_Billing__c=true;
        gemscat1.Usage_Reporting__c=true;
        gemscat1.Usage_Mailing__c=true;
        gemscat1.Members_Derivation_Type__c='CT';
        insert gemscat1;

        GEMS_BA_Category_Assignment__c catass = GEMS_UtilityClassTest.insertionBACategory(acc.Id,strRec.id,benefit.id,gemscat1.Id);
        insert catass;
        

        GEMS_Cat_Char_Value_Association__c charass = GEMS_UtilityClassTest.insertionAssociate(strRec.id,acc.Id,charval.id,gemscat1.Id);
        insert charass;

        //GEMS_Group_Section__c gemsGroupObj = GEMS_UtilityClassTest.insertionGroup(acc.Id,strRec.id);
        //insert gemsGroupObj;
        
        GEMS_Group_Section__c gemsGroupObj = new GEMS_Group_Section__c();
        gemsGroupObj.Section_Eff_Date__c = system.today();
        gemsGroupObj.Case__c = strRec.id;
        gemsGroupObj.Account__c = acc.Id ;
        gemsGroupObj.Section_No__c ='2001';
        gemsGroupObj.Section_Description__c ='Test';
        gemsGroupObj.Group_No__c = 'TeSt02';
        insert gemsGroupObj;

        GEMS_Category_Assignment__c gemsCatAsgmnt = GEMS_UtilityClassTest.insertionCategoryAssign(acc.Id,strRec.id,gemsCat1.Id,gemsGroupObj.Id);
        insert gemsCatAsgmnt;


        GEMS_BA_Assignment__c gemsbaass = GEMS_UtilityClassTest.insertionBaAssign(acc.Id,strRec.id,benefit.id,gemsGroupObj.Id);
        insert gemsbaass;
        
        
        
         GEMS_Category__c gemscat2 = GEMS_UtilityClassTest.insertiongemscat2(acc.Id,strRec.id);
        gemscat2.Usage_Product__c =true;
        gemscat2.Usage_Billing__c=true;
        gemscat2.Usage_Reporting__c=true;
        gemscat2.Usage_Mailing__c=true;
        gemscat2.Members_Derivation_Type__c='CT';
        insert gemscat2;

        GEMS_BA_Category_Assignment__c catass2 = GEMS_UtilityClassTest.insertionBACategory(acc.Id,strRec.id,benefit2.id,gemscat2.Id);
        insert catass2;
        

        GEMS_Cat_Char_Value_Association__c charas2 = GEMS_UtilityClassTest.insertionAssociate(strRec.id,acc.Id,charval.id,gemscat2.Id);
        insert charas2;

        GEMS_Group_Section__c gemsGroupObj2 = new GEMS_Group_Section__c();
        gemsGroupObj2.Section_Eff_Date__c = system.today();
        gemsGroupObj2.Case__c = strRec.id;
        gemsGroupObj2.Account__c = acc.Id ;
        gemsGroupObj2.Section_No__c ='2001';
        gemsGroupObj2.Section_Description__c ='Test';
        gemsGroupObj2.Group_No__c = 'TeSt02';
        insert gemsGroupObj2;
        


        GEMS_Category_Assignment__c gemsCatAsgmnt2 = GEMS_UtilityClassTest.insertionCategoryAssign(acc.Id,strRec.id,gemscat2.Id,gemsGroupObj2.Id);
        insert gemsCatAsgmnt2;


        GEMS_BA_Assignment__c gemsbaass2 = GEMS_UtilityClassTest.insertionBaAssign(acc.Id,strRec.id,benefit2.id,gemsGroupObj2.Id);
        insert gemsbaass2;
        
        
        list<GEMS_Category_Assignment__c> cats = new list<GEMS_Category_Assignment__c>();
        //cats.add(gemsCatAsgmnt1);
        cats.add(gemsCatAsgmnt);
        cats.add(gemsCatAsgmnt2);
         
        set<Id> catIds = new set<Id>();
        catIds.add(cats[0].id);

        
        test.startTest();
        PageReference pageRef = Page.GEMSCreateAS;
        Test.setCurrentPage(pageRef);
        apexpages.currentpage().getparameters().put('caseid',strRec.id);
        List<Case> ssss = new List<Case>();
        ssss.add(strRec);
        ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(SSSS);
        GEMSAccountStructureController accStrController = new GEMSAccountStructureController(stdController);
        GEMS_AccountSetup.Category category = new GEMS_AccountSetup.Category();
        category.cat = gemsCatAsgmnt.Category__r; 
        //category.gs.groupNumber ='1234';
        //category.gs.sectionNumber ='1234';
        // SFDC-8446 start
        GEMS_AccountSetup uiFormData = accStrController.accStr;
        uiFormData.benefitAgreements.get(0).groupNumber = '5001';
        accStrController.populateGroupNo();
        // SFDC-8446 end
        accStrController.saveDraftAccountStructure();
        accStrController.saveAccountStructure();
        accStrController.GenerateDocument();
        accStrController.DownloadPDF();
        accStrController.gotoCase();
        accStrController.getNext();
        accStrController.getPrevious();
        accStrController.init();
      

        test.stopTest();
    }  
    
    private static testmethod void GEMSAccountStructureController_TEST2(){
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
        PageReference pageRef = Page.GEMSCreateAS;
        Test.setCurrentPage(pageRef);
        apexpages.currentpage().getparameters().put('caseid',strRec.id);
        List<Case> ssss = new List<Case>();
        ssss.add(strRec);
        ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(SSSS);
        GEMSAccountStructureController accStrController = new GEMSAccountStructureController(stdController);
        // SFDC-8446 start
        GEMS_AccountSetup uiFormData = accStrController.accStr;
        uiFormData.benefitAgreements.get(0).groupNumber = '5001';
        accStrController.populateGroupNo();
        // SFDC-8446 end
        accStrController.saveDraftAccountStructure();
        accStrController.saveAccountStructure();
        accStrController.GenerateDocument();
        accStrController.DownloadPDF();
        accStrController.gotoCase();
        accStrController.getNext();
        accStrController.getPrevious();
        accStrController.init();

        test.stopTest();
    }  
}