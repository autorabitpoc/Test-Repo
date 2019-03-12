/*****************************************************************************************************************************
Apex Class Name       : GEMSAccountStructureOperation_Test
Version               : 1.0
Function              : This class serves as unit test class for GEMSAccountStructureOperationController
Modification Log      : 
------------------------------------------------------------------------------------------------------------------------------
Developer           Date                   Description
------------------------------------------------------------------------------------------------------------------------------
// 4/23/2018        Gokul               SFDC-8523 GEMS: BlueSTAR - Add existing Category to an existing BA
// 4/23/2018        Phani               SFDC-4903 GEMS: BlueSTAR - Un-assigning & re-assigning (moving) Group Sections
****************************************************************************************************************************/
@isTest(seeAllData=false)
private class GEMSAccountStructureOperation_Test{
    
    //Create test data
    @testSetUp
    public static void setUpData(){
        
        //Create Account 
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name); 
        
        //Create Account Submission Case
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        //Create a Case Team member
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        System.assertEquals(subCaseRec.Id,caseTeamAccSpecMem.ParentId);
        
        //Create a GEMS Attachment
        GEMS_Attachment__c gemsAttach11 = new GEMS_Attachment__c();
        gemsAttach11.type__c='SIGNED BPA';
        gemsAttach11.Attachment__c = 'ts';
        gemsAttach11.case__c=subCaseRec.Id;
        insert gemsAttach11;
        
        //Create GEMS Account Structure
        Case strRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        strRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        strRec.accountId = acc.Id;
        strRec.Status = 'Design In Progress';
        insert strRec;
        
        //insert product for BEnefit Agreement 
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;
        System.assertEquals('HSA',productRec1.Product_Category__c);
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals('Design In Progress',strCaseRec.status);
        
        //Create a existing Benefit Agreement 1
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(acc.Id,strRec.id,productRec1.Id);
        benefit.Name = '1234';
        benefit.IsNew__c=false;
        benefit.Schedule__c= null;
        insert benefit;
        
        //Create a existing Benefit Agreement 2
        GEMS_Benefit_Agreement__c benefit2=GEMS_UtilityClassTest.insertionBenefit(acc.Id,strRec.id,productRec1.Id);
        benefit2.Name = '5678';
        benefit2.IsNew__c=true;
        benefit2.Schedule__c= null;
        insert benefit2;
        
        //Create a existing Benefit Agreement 3
        GEMS_Benefit_Agreement__c ba3 = new GEMS_Benefit_Agreement__c();
        ba3.Name = '3456';
        ba3.IsNew__c=false;
        ba3.BA_Fund_Type__c = 'PREM';
        ba3.Account__c = acc.Id;
        ba3.AccountStructureCase__c=strRec.id;        
        ba3.Product__c=productRec1.Id; 
        Plan__c plan1 = GEMS_UtilityClassTest.insertionPlan(productRec1.Id);
        insert plan1;
        ba3.Plan__c = plan1.Id;
        insert ba3;
        
        
        
        
        
        //Create a existing Benefit Agreement 4
        GEMS_Benefit_Agreement__c ba4 = new GEMS_Benefit_Agreement__c();
        ba4.Name = '3457';
        ba4.IsNew__c=false;
        ba4.BA_Fund_Type__c = 'PREM';
        ba4.Account__c = acc.Id;
        ba4.AccountStructureCase__c=strRec.id;        
        ba4.Product__c=productRec1.Id; 
        Plan__c plan2 = GEMS_UtilityClassTest.insertionPlan(productRec1.Id);
        insert plan2;
        ba4.Plan__c = plan2.Id;
        insert ba4;        
        
        //Create a existing GEMS Category 1
        GEMS_Category__c gemscat1 = GEMS_UtilityClassTest.insertiongemscat1(acc.Id,strRec.id);//Category - 1234
        gemscat1.Usage_Product__c =true;
        gemscat1.Usage_Billing__c=true;
        gemscat1.Usage_Reporting__c=true;
        gemscat1.Usage_Mailing__c=true;
        gemscat1.Members_Derivation_Type__c='CT';
        gemscat1.isNew__c = false;
        insert gemscat1;
        
        //Create a existing GEMS Category 2       
        GEMS_Category__c gemscat2 = GEMS_UtilityClassTest.insertiongemscat2(acc.Id,strRec.id);//Category - 5678
        gemscat2.Usage_Product__c =true;
        gemscat2.Usage_Billing__c=true;
        gemscat2.Usage_Reporting__c=true;
        gemscat2.Usage_Mailing__c=true;
        gemscat2.Members_Derivation_Type__c='CT';
        gemscat2.isNew__c = true;
        insert gemscat2;
        
        
        //Create a existing GEMS Category 3
        GEMS_Category__c cat3 = new GEMS_Category__c();//Category - 3456
        cat3.Account__c=acc.Id;
        cat3.Case__c=strRec.id;
        cat3.Usage_Product__c =false;
        cat3.Usage_Billing__c=true;
        cat3.Usage_Reporting__c=false;
        cat3.Usage_Mailing__c=false;
        cat3.Members_Derivation_Type__c='CT';
        cat3.isNew__c = false;
        cat3.Name = '3456';
        insert cat3;
        
        
        //Create a existing GEMS Category 4  
        GEMS_Category__c cat4 = new GEMS_Category__c();//Category - 3457
        cat4.Account__c=acc.Id;
        cat4.Case__c=strRec.id;
        cat4.Usage_Product__c =false;
        cat4.Usage_Billing__c=true;
        cat4.Usage_Reporting__c=false;
        cat4.Usage_Mailing__c=false;
        cat4.Members_Derivation_Type__c='CT';
        cat4.isNew__c = false;
        cat4.Name = '3457';
        insert cat4;
        
        
        
        //Create a existing groupsection3
        GEMS_Group_Section__c gs3 = new GEMS_Group_Section__c();
        gs3.Section_Eff_Date__c = system.today();
        gs3.case__c = strRec.id;
        gs3.account__c = acc.Id;
        gs3.Group_No__c='3456';
        gs3.Section_No__c ='3456';
        gs3.IsNew__c = false;
        insert gs3;
        
        
        //Create a existing groupsection4
        GEMS_Group_Section__c gs4 = new GEMS_Group_Section__c();
        gs4.Section_Eff_Date__c = system.today();
        gs4.case__c = strRec.id;
        gs4.account__c = acc.Id;
        gs4.Group_No__c='3457';
        gs4.Section_No__c ='3457';
        gs4.IsNew__c = false;
        insert gs4;
        
        
        //create a billing profile
        GEMS_Billing_Profile__c bp1 = new GEMS_Billing_Profile__c();
        bp1.Effective_Date__c = system.today();
        bp1.case__c = strRec.id;
        bp1.account__c = acc.Id;
        bp1.Name='TeSt02';
        insert bp1;
        
        //create bpba association        
        GEMS_BP_BA_Association__c bpba = new GEMS_BP_BA_Association__c();
        bpba.Billing_Profile__c = bp1.id;
        bpba.Benefit_Agreement__c = ba3.id;
        bpba.Case__c = strRec.id;
        insert bpba;
        
        
        //create catbp association
        GEMS_BP_Category_Association__c bpcat = new GEMS_BP_Category_Association__c();
        bpcat.Billing_Profile__c = bp1.id;
        bpcat.Category__c = cat3.id;
        bpcat.Case__c = strRec.id;
        insert bpcat;
        
        //create bacat association
        GEMS_BA_Category_Assignment__c bacat = new GEMS_BA_Category_Assignment__c();
        bacat.Account__c = acc.Id;
        bacat.Case__c = strRec.id;
        bacat.Benefit_Agreement__c = ba3.id;
        bacat.Category__c =  cat3.id;
        insert bacat;
        
        //create bags association
        GEMS_BA_Assignment__c bags = new GEMS_BA_Assignment__c();
        bags.Account__c = acc.Id;
        bags.Case__c = strRec.id;
        bags.Benefit_Agreement__c = ba3.id;
        bags.Group_Section__c = gs3.id;
        insert bags;
        
        //create catgs association
        GEMS_Category_Assignment__c catgs = new GEMS_Category_Assignment__c();
        catgs.Account__c =  acc.Id;
        catgs.Case__c = strRec.id;
        catgs.Category__c = cat3.id;
        catgs.Group_Section__c = gs3.id;
        insert catgs;
        
    }
    
    public static testmethod void LoadwithNoAccountStructureCaseId(){             
        Test.startTest();
        PageReference pageRef = Page.GEMSAccountStructureOperation;
        Test.setCurrentPage(pageRef);
        Apexpages.Currentpage().getparameters().put('caseid','');
        GEMS_AccountStructureOperationController accOperationCtrl = new GEMS_AccountStructureOperationController();
        accOperationCtrl.getoperations();       
        accOperationCtrl.SearchBA();
        accOperationCtrl.SearchCAT();
        Test.stopTest();
    }
    
    public static testmethod void RequiredBACATParameterNotEnter(){                
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId LIMIT 1];
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                     where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =:subCaseRec.Id LIMIT 1];        
        Test.startTest();
        PageReference pageRef = Page.GEMSAccountStructureOperation;
        Test.setCurrentPage(pageRef);
        Apexpages.Currentpage().getparameters().put('caseid',strRec.id);
        GEMS_AccountStructureOperationController accOperationCtrl = new GEMS_AccountStructureOperationController();
        accOperationCtrl.getoperations();     
        accOperationCtrl.SearchBA();
        accOperationCtrl.SearchCAT();
        Test.stopTest();        
    }
    
    public static testmethod void AddExistingBACATAssociation(){
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId LIMIT 1];
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                     where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =:subCaseRec.Id LIMIT 1];        
        Test.startTest();
        PageReference pageRef = Page.GEMSAccountStructureOperation;
        Test.setCurrentPage(pageRef);
        Apexpages.Currentpage().getparameters().put('caseid',strRec.id);
        GEMS_AccountStructureOperationController accOperationCtrl = new GEMS_AccountStructureOperationController();
        accOperationCtrl.getoperations();       
        accOperationCtrl.enterBA = '1234';
        accOperationCtrl.enterCAT = '1234';
        accOperationCtrl.SearchBA();
        accOperationCtrl.SearchCAT();
        accOperationCtrl.AddRow();
        accOperationCtrl.Add();
        Test.stopTest();        
    }
    
    public static testmethod void RemoveExistingBACATAssociation(){
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId LIMIT 1];
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                     where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =:subCaseRec.Id LIMIT 1];        
        Test.startTest();
        PageReference pageRef = Page.GEMSAccountStructureOperation;
        Test.setCurrentPage(pageRef);
        Apexpages.Currentpage().getparameters().put('caseid',strRec.id);
        GEMS_AccountStructureOperationController accOperationCtrl = new GEMS_AccountStructureOperationController();
        accOperationCtrl.getoperations();        
        accOperationCtrl.enterBA = '1234';
        accOperationCtrl.enterCAT = '1234';
        accOperationCtrl.SearchBA();
        accOperationCtrl.SearchCAT();
        accOperationCtrl.AddRow();
        accOperationCtrl.Add();
        accOperationCtrl.RemoveRow();
        accOperationCtrl.RemoveAddRow();
        accOperationCtrl.Remove();
        accOperationCtrl.AddRemoveReset();
        accOperationCtrl.GoBackToAccountStructureCase();
        Test.stopTest();        
    }
    
    public static testmethod void AddAssociationNewBACAT(){
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId LIMIT 1];
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                     where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =:subCaseRec.Id LIMIT 1];        
        Test.startTest();
        PageReference pageRef = Page.GEMSAccountStructureOperation;
        Test.setCurrentPage(pageRef);
        Apexpages.Currentpage().getparameters().put('caseid',strRec.id);
        GEMS_AccountStructureOperationController accOperationCtrl = new GEMS_AccountStructureOperationController();
        accOperationCtrl.getoperations(); 
        accOperationCtrl.enterBA = '5678';
        accOperationCtrl.enterCAT = '5678';
        accOperationCtrl.SearchBA();
        accOperationCtrl.SearchCAT();    
        Test.stopTest();        
    }
    
    public static testmethod void NoBACatRecordExist(){
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId LIMIT 1];
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                     where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =:subCaseRec.Id LIMIT 1];        
        Test.startTest();
        PageReference pageRef = Page.GEMSAccountStructureOperation;
        Test.setCurrentPage(pageRef);
        Apexpages.Currentpage().getparameters().put('caseid',strRec.id);
        GEMS_AccountStructureOperationController accOperationCtrl = new GEMS_AccountStructureOperationController();
        accOperationCtrl.getoperations(); 
        accOperationCtrl.enterBA = '3333';
        accOperationCtrl.enterCAT = '3333';
        accOperationCtrl.SearchBA();
        accOperationCtrl.SearchCAT();  
        accOperationCtrl.ReloadPage();
        Test.stopTest();        
    }
    
    public static testmethod void moveGS() {
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId LIMIT 1];
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                     where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =:subCaseRec.Id LIMIT 1];        
        Test.startTest();
        PageReference pageRef = Page.GEMSAccountStructureOperation;
        Test.setCurrentPage(pageRef);
        Apexpages.Currentpage().getparameters().put('caseid',strRec.id);
        GEMS_AccountStructureOperationController accOperationCtrl = new GEMS_AccountStructureOperationController();
        accOperationCtrl.getoperations(); 
        accOperationCtrl.getGroups();
        accOperationCtrl.selectedGN = '3456';
        accOperationCtrl.enterSN = '3456';
        accOperationCtrl.SearchGS();
        accOperationCtrl.enterTargetBA = '3457';
        accOperationCtrl.SearchTargetBA();
        accOperationCtrl.move();
        //assert ba-cat is new
        GEMS_BA_Category_Assignment__c baCatNew = [select id,IsNew__c from GEMS_BA_Category_Assignment__c where Benefit_Agreement__r.name = '3457' and Category__r.name = '3456'];
        System.assertEquals(true, baCatNew.IsNew__c);
        //assert gs is updated
        GEMS_Group_Section__c gsUpdated = [select id,IsUpdated__c from GEMS_Group_Section__c where Group_No__c = '3456' and Section_No__c = '3456'];
        System.assertEquals(true, gsUpdated.IsUpdated__c);
        accOperationCtrl.MoveReset();
        Test.stopTest();      
    }
    
}