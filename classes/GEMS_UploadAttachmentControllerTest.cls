/**************************************************************************************
Apex Class Name     : GEMS_UploadAttachmentControllerTest
Version             : 1.0
Function            : This class serves as Unit Test Class for GEMS_UploadAttachmentController
Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva               04/14/2016                Original Version
*************************************************************************************/
@isTest 
public class GEMS_UploadAttachmentControllerTest
{
    private static testmethod void GEMS_UploadAttachmentController1()
    {
        
        Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
        
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
        Opportunity oppty= GEMS_UtilityClassTest.insertionOpp1(acc.Id);
        oppty.StageName=GEMS_UtilityClassTest.opportunityStatus();
        insert oppty;
        System.assertEquals('BenefitAgreementControllerTest',oppty.name);
        
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;
        System.assertEquals('HSA',productRec1.Product_Category__c);
        
        Opportunity_Product__c oppProd1=GEMS_UtilityClassTest.insertionOppProd1(productRec1.Id,oppty.Id);
        oppProd1.Incumbent__c = testCompetitorAccount.Id;
        insert oppProd1;
        System.assertEquals('In Progress',oppProd1.Status__c);
        
        Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        caseObj.accountId = acc.id;
        caseObj.GEMS_Submission_Type__c ='Renewal';
        insert caseobj;
        Case caseRec = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        caseRec.accountId = acc.id;
        caseRec.GEMS_Submission_Type__c ='Renewal';
        insert caseRec;
        
        GEMS_Attachment__c attach=GEMS_UtilityClassTest.insertionAttach(caseRec.Id);
        insert attach;
        System.assertEquals('ABS',attach.Type__c);
        
        
        test.starttest();
        ApexPages.currentpage().getParameters().put('id',caseobj.id);
        ApexPages.StandardController std = new ApexPages.standardController(caseobj);
        GEMS_UploadAttachmentController attctrl = new GEMS_UploadAttachmentController(std);
        attctrl.filename='test';
        attctrl.fileBody=Blob.valueOf('Unit Test Attachment Body');
        attctrl.saveCustomAttachment();
        attctrl.getLevelOptions();
        attctrl.getTypeOptions();
        attctrl.processUpload();
        attctrl.back();
        attctrl.getPageNumber();
        attctrl.getTotalPages();
        GEMS_UploadAttachmentController.WrapperClass wrapCls = new GEMS_UploadAttachmentController.WrapperClass(attach);
        wrapCls.checked=true;
        attctrl.allBool=true;
        attctrl.selectAll();
        attctrl.allBool=false;
        attctrl.selectAll();
        attctrl.del();
        attctrl.test();
        
        GEMS_UploadAttachmentController attctrl1 = new GEMS_UploadAttachmentController(std);
        attctrl1.saveCustomAttachment();
        attctrl1.saveStandardAttachment(attach.id);        
        attctrl1.getLevelOptions();
        attctrl1.getTypeOptions();
        attctrl1.filename='test';
        attctrl1.fileBody=Blob.valueOf('');
        attctrl1.processUpload();
        attctrl1.back();
        attctrl1.getPageNumber();
        attctrl1.getTotalPages();
        GEMS_UploadAttachmentController.WrapperClass wrapCls1 = new GEMS_UploadAttachmentController.WrapperClass(attach);
        wrapCls1.checked=true;
        attctrl1.allBool=true;
        attctrl1.selectAll();
        attctrl1.allBool=false;
        attctrl1.selectAll();
        attctrl1.del();
        attctrl1.test();
        
        test.stoptest();
    }
    
    private static testmethod void GEMS_UploadAttachmentController2()
    {
        
        Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
        
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
        Opportunity oppty= GEMS_UtilityClassTest.insertionOpp1(acc.Id);
        oppty.StageName=GEMS_UtilityClassTest.opportunityStatus();//'In Progress';
        insert oppty;
        System.assertEquals('BenefitAgreementControllerTest',oppty.name);
        
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;
        System.assertEquals('HSA',productRec1.Product_Category__c);
        
        Opportunity_Product__c oppProd1=GEMS_UtilityClassTest.insertionOppProd1(productRec1.Id,oppty.Id);
        oppProd1.Incumbent__c = testCompetitorAccount.Id;
        insert oppProd1;
        System.assertEquals('In Progress',oppProd1.Status__c);
        
        Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        caseObj.accountId = acc.id;
        caseObj.GEMS_Submission_Type__c ='Renewal';
        insert caseobj;
        
        GEMS_Attachment__c attach=GEMS_UtilityClassTest.insertionAttach(caseobj.Id);
        insert attach;
        System.assertEquals('ABS',attach.Type__c);
        
        test.starttest();
        ApexPages.currentpage().getParameters().put('id',caseobj.id);
        ApexPages.StandardController std = new ApexPages.standardController(caseobj);
        GEMS_UploadAttachmentController attctrl = new GEMS_UploadAttachmentController(std);
        attctrl.filename= null;
        attctrl.filebody=null;
        attctrl.processUpload();
        test.stoptest();
    }
    
    private static testmethod void GEMS_UploadAttachmentController3()
    {
        
        Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
        
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
        Opportunity oppty= GEMS_UtilityClassTest.insertionOpp1(acc.Id);
        oppty.StageName=GEMS_UtilityClassTest.opportunityStatus();//'In Progress';
        insert oppty;
        System.assertEquals('BenefitAgreementControllerTest',oppty.name);
        
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;
        System.assertEquals('HSA',productRec1.Product_Category__c);
        
        Opportunity_Product__c oppProd1=GEMS_UtilityClassTest.insertionOppProd1(productRec1.Id,oppty.Id);
        oppProd1.Incumbent__c = testCompetitorAccount.Id;
        insert oppProd1;
        System.assertEquals('In Progress',oppProd1.Status__c);
        
        Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        caseObj.accountId = acc.id;
        caseObj.GEMS_Submission_Type__c ='Renewal';
        insert caseobj;
        
        GEMS_Attachment__c attach=GEMS_UtilityClassTest.insertionAttach(caseobj.Id);
        insert attach;
        System.assertEquals('ABS',attach.Type__c);
        test.starttest();
        ApexPages.currentpage().getParameters().put('id',caseobj.id);
        ApexPages.StandardController std = new ApexPages.standardController(caseobj);
        GEMS_UploadAttachmentController attctrl = new GEMS_UploadAttachmentController(std);
        attctrl.filename='test';
        attctrl.fileBody=Blob.valueOf('Unit Test Attachment Body');
        attctrl.selectedType='TypeTest';
        attctrl.description='Test';
        attctrl.selectedLevel='TestLevel';
        attctrl.bainfo='Info';
        attctrl.processUpload();
        test.stoptest();
    }
    
    private static testmethod void GEMS_UploadAttachmentController4()
    {
        
        Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);
        
        Account acc = GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        System.assertEquals('BenefitAgreementControllerTest',acc.Name);
        
        Opportunity oppty= GEMS_UtilityClassTest.insertionOpp1(acc.Id);
        oppty.StageName=GEMS_UtilityClassTest.opportunityStatus();//'In Progress';
        insert oppty;
        System.assertEquals('BenefitAgreementControllerTest',oppty.name);
        
        product2 productRec1=GEMS_UtilityClassTest.insertionProduct1();
        insert productRec1;
        System.assertEquals('HSA',productRec1.Product_Category__c);
        
        Opportunity_Product__c oppProd1=GEMS_UtilityClassTest.insertionOppProd1(productRec1.Id,oppty.Id);
        oppProd1.Incumbent__c = testCompetitorAccount.Id;
        insert oppProd1;
        System.assertEquals('In Progress',oppProd1.Status__c);
        
        Case caseobj = GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        caseObj.accountId = acc.id;
        caseObj.GEMS_Submission_Type__c ='Renewal';
        insert caseobj;
        
        GEMS_Attachment__c attach=GEMS_UtilityClassTest.insertionAttach(caseobj.Id);
        insert attach;
        System.assertEquals('ABS',attach.Type__c);
        test.starttest();
        ApexPages.currentpage().getParameters().put('id',caseobj.id);
        ApexPages.StandardController std = new ApexPages.standardController(caseobj);
        GEMS_UploadAttachmentController attctrl = new GEMS_UploadAttachmentController(std);
        attctrl.filename='test';
        attctrl.fileBody=null;
        attctrl.selectedType='--None--';
        attctrl.description='Test';
        attctrl.selectedLevel='TestLevel';
        attctrl.bainfo='Info';
        attctrl.processUpload();
        test.stoptest();
    }
}