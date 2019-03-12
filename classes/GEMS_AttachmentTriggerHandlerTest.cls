/**************************************************************************************
  Apex Class Name     : GEMS_AttachmentTriggerHandlerTest
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_AttachmentTriggerHandler
  Modification Log    :
* Developer                  Date                      Description
* ----------------------------------------------------------------------------------                 
* Offshore                   04/27/2016                Original Version
*************************************************************************************/ 
@isTest
public class GEMS_AttachmentTriggerHandlerTest
{   

    private static testmethod void GEMS_AttachmentTriggerHandler1()
    {
        Test.startTest();
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name); 
        
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        subRec.GEMS_All_required_documents_attached__c=true;
        insert subRec;
        
        Case medRec= GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
        medRec.GEMS_Account_Submission_Info__c  = subRec.Id;
        medRec.Status = 'In Progress';
        insert medRec;
        
        GEMS_Attachment__c attach=GEMS_UtilityClassTest.insertionAttach(subRec.Id);
        insert attach;
        System.assertEquals('ABS',attach.Type__c);

        list<GEMS_Attachment__c > attalist = new list<GEMS_Attachment__c>();
        GEMS_Attachment__c attachment =new GEMS_Attachment__c ();
        attachment.Case__c =subRec.id;
        attachment.Type__c ='BPS';     
        attalist.add(attachment);
        insert attalist;
        Test.stopTest();
    }
    
    private static testmethod void GEMS_AttachmentTriggerHandler2()
    {
        Test.startTest();
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name); 
        
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        subRec.GEMS_All_required_documents_attached__c=false;
        insert subRec;
        
        Case medRec= GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
        medRec.GEMS_Account_Submission_Info__c  = subRec.Id;
        medRec.Status = 'In Progress';
        insert medRec;

        list<GEMS_Attachment__c > attalist = new list<GEMS_Attachment__c>();
        GEMS_Attachment__c attachment =new GEMS_Attachment__c();
        attachment.Case__c =subRec.id;     
        attalist.add(attachment);
        insert attalist;
        Test.stopTest();
    }
    
    private static testmethod void statusInProgressautoUpdAccSubCaseBPA(){
        Test.startTest();
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];     
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.accountId = accRec.Id;
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c = true;
        subRec.GEMS_All_required_documents_attached__c=false;
        subRec.Milestone__c = '';
        insert subRec;
        
        Case elig = GEMS_UtilityClassTest.insertionCase('GEMS Eligibility');
        elig.GEMS_Account_Submission_Info__c = subRec.Id;
        elig.status = 'Completed';
        insert elig;
               
        Case req = GEMS_UtilityClassTest.insertionCase('GEMS Request Resource');
        req.GEMS_Account_Submission_Info__c = subRec.Id;
        req.status = 'Completed';
        insert req;
        
        Case get= GEMS_UtilityClassTest.insertionCase('GEMS GET');
        get.GEMS_Account_Submission_Info__c = subRec.Id;
        get.status = 'Completed';
        get.GEMS_Implementation_Is_Closed__c = true;
        get.GEMS_Verify_Benefit_Adhoc_Needed__c = 'No';
        get.GEMS_Client_Kickoff_Meeting_Comp_Date__c = System.Today(); 
        insert get;
        
        GEMS_Attachment__c attachment1 = new GEMS_Attachment__c();
        attachment1.Case__c = subRec.id;  
        attachment1.Type__c = 'BENEFIT MATRIX';   
        insert attachment1; 
        Test.stopTest();
    }
    
    private static testmethod void statusCompletedautoUpdAccSubCaseBPA(){
        Test.startTest();
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];     
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.accountId = accRec.Id;
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        subRec.GEMS_All_required_documents_attached__c=false;
        subRec.Milestone__c = 'Service Ready';
        insert subRec;
        
        Case elig = GEMS_UtilityClassTest.insertionCase('GEMS Eligibility');
        elig.GEMS_Account_Submission_Info__c = subRec.Id;
        elig.status = 'Completed';
        insert elig;
        
        Case req = GEMS_UtilityClassTest.insertionCase('GEMS Request Resource');
        req.GEMS_Account_Submission_Info__c = subRec.Id;
        req.status = 'Completed';
        insert req;
        
        Case get= GEMS_UtilityClassTest.insertionCase('GEMS GET');
        get.GEMS_Account_Submission_Info__c = subRec.Id;
        get.status = 'Completed';
        get.GEMS_Implementation_Is_Closed__c = true;
        get.GEMS_Verify_Benefit_Adhoc_Needed__c = 'No';
        get.GEMS_Client_Kickoff_Meeting_Comp_Date__c = System.Today(); 
        insert get;
        
        List<GEMS_Attachment__c> atts = new List<GEMS_Attachment__c>();
        GEMS_Attachment__c attachment1 = new GEMS_Attachment__c();
        attachment1.Case__c = subRec.id;  
        attachment1.Type__c = 'BPA - ASO SIGNED';   
        atts.add(attachment1);
        
        GEMS_Attachment__c attachment2 = new GEMS_Attachment__c();
        attachment2.Case__c = subRec.id;  
        attachment2.Type__c = 'BENEFIT MATRIX';   
        atts.add(attachment2);
        
        insert atts;
        Test.stopTest();
    }
    
    private static testmethod void noAttachmentautoUpdAccSubCaseBPA(){
        Test.startTest();
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;      
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];     
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.accountId = accRec.Id;
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        subRec.GEMS_All_required_documents_attached__c=false;
        subRec.Milestone__c = 'Service Ready';
        
        insert subRec;
        
        Case elig = GEMS_UtilityClassTest.insertionCase('GEMS Eligibility');
        elig.GEMS_Account_Submission_Info__c = subRec.Id;
        elig.status = 'Completed';
        insert elig;
               
        Case req = GEMS_UtilityClassTest.insertionCase('GEMS Request Resource');
        req.GEMS_Account_Submission_Info__c = subRec.Id;
        req.status = 'Completed';
        insert req;
        
        Case get= GEMS_UtilityClassTest.insertionCase('GEMS GET');
        get.GEMS_Account_Submission_Info__c = subRec.Id;
        get.status = 'In Progress';
        get.GEMS_Implementation_Is_Closed__c = true;
        get.GEMS_Verify_Benefit_Adhoc_Needed__c = 'No';
        get.GEMS_Client_Kickoff_Meeting_Comp_Date__c = System.Today(); 
        insert get;
        Test.stopTest();
    }
    
    private static testmethod void nonBPAAttachmentautoUpdAccSubCaseBPA(){
        Test.startTest();
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;      
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];     
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.accountId = accRec.Id;
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        subRec.GEMS_All_required_documents_attached__c=false;
        subRec.Milestone__c = 'Service Ready';
        
        insert subRec;
        
        Case elig = GEMS_UtilityClassTest.insertionCase('GEMS Eligibility');
        elig.GEMS_Account_Submission_Info__c = subRec.Id;
        elig.status = 'Completed';
        insert elig;
               
        Case req = GEMS_UtilityClassTest.insertionCase('GEMS Request Resource');
        req.GEMS_Account_Submission_Info__c = subRec.Id;
        req.status = 'Completed';
        insert req;
        
        Case get= GEMS_UtilityClassTest.insertionCase('GEMS GET');
        get.GEMS_Account_Submission_Info__c = subRec.Id;
        get.status = 'Completed';
        get.GEMS_Implementation_Is_Closed__c = true;
        get.GEMS_Verify_Benefit_Adhoc_Needed__c = 'No';
        get.GEMS_Client_Kickoff_Meeting_Comp_Date__c = System.Today(); 
        insert get;
        
        GEMS_Attachment__c attachment = new GEMS_Attachment__c();
        attachment.Case__c = subRec.id;  
        attachment.Type__c = 'BENEFIT MATRIX';   
        insert attachment;
        Test.stopTest();
    }
}