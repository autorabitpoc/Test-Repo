/**************************************************************************************
  Apex Class Name     : GEMS_AccountSubmissionCompleteValid_TEST
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_AccountSubmissionCompleteValidation 
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva             06/16/2016                Original Version
*************************************************************************************/
@isTest
public class GEMS_AccountSubmissionCompleteValid_TEST{
    private static testmethod void GEMS_AccountSubmissionCompleteValidation_TEST1()
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
        strRec.GEMS_Reserved_Group_Numbers__c = '1234';
        insert strRec;
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals('Design In Progress',strCaseRec.status);
        //test.startTest();
        GEMS_Group_Section__c grpSec = GEMS_UtilityClassTest.insertionGroup(acc.Id,strCaseRec.Id);
        insert grpSec ;
        strCaseRec.Status = 'Client Approval Received';
        update strCaseRec;
        
        Case idRec= GEMS_UtilityClassTest.insertionCase('GEMS ID Card');
        idRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        //idRec.accountId = acc.Id;
        idRec.GEMS_ID_Cards_Format__c='Custom';
        idRec.GEMS_ID_Card_Approved_Date__c=date.today();
        idRec.GEMS_ID_card_mailed_date__c=date.today();
        idRec.Status = 'Completed';
        insert idRec;
        test.startTest();
        Id accidRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Case idCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:accidRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        
        System.assertEquals(subCaseRec.Id,idCaseRec.GEMS_Account_Submission_Info__c );
        
        Case sbcRec= GEMS_UtilityClassTest.insertionCase('GEMS SBC');
        sbcRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        sbcRec.Status = 'Completed';
        insert sbcRec;
        Id sbcRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();
        Case sbcCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:sbcRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
          
        System.assertEquals(subCaseRec.Id,sbcCaseRec.GEMS_Account_Submission_Info__c );
        
        Case medRec= GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
        medRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        medRec.Status = 'Medical Benefits Production Ready';
        insert medRec;
        Id medicalRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Case medicalCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:medicalRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
                       
        System.assertEquals(subCaseRec.Id,medicalCaseRec.GEMS_Account_Submission_Info__c);

      
        Case pharmacyRec= GEMS_UtilityClassTest.insertionCase('GEMS Pharmacy Coding');
        pharmacyRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        pharmacyRec.Status =  'AS400 & BlueStar Update Completed'; 
        insert pharmacyRec;
        Id pharmacyRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        Case pharmacyCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:pharmacyRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
         System.assertEquals(subCaseRec.Id,pharmacyCaseRec.GEMS_Account_Submission_Info__c);
        
        Case dentalRec= GEMS_UtilityClassTest.insertionCase('GEMS Dental Benefit Coding');
        dentalRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        dentalRec.Status = 'Completed'; 
        insert dentalRec;
        Id dentalRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
        Case dentalCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:dentalRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
         
        System.assertEquals(subCaseRec.Id,pharmacyCaseRec.GEMS_Account_Submission_Info__c);
        Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        insert product2Rec;
        
        Product2 product2RecQuery=[SELECT Id, Name, isActive from Product2 where Name='BCS Stop Loss'];
        System.assertEquals('BCS Stop Loss',product2RecQuery.Name);
        GEMS_Benefit_Agreement__c benefit = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,subCaseRec.id,product2Rec.id);    
        insert benefit ; 
        GEMS_Shared_Accums__c sharedAccums =new GEMS_Shared_Accums__c();
        sharedAccums.GEMS_Case__c=subCaseRec.id;
        sharedAccums.Benefit_Agreement__c=benefit.id;                        
        sharedAccums.Accum_Period__c='Calendar Year';    
        sharedAccums.Shared_Accums_Effective_Date__c=Date.today();
        sharedAccums.HCSC_responsible_for_Vendor_Eligibility__c='Yes';
        boolean s = false;   
        boolean s2 = true;   
        sharedAccums.Deductible__c= s;
        sharedAccums.Aggregate_or_Embedded_Deductible__c='Aggregate';
        Decimal d1 = 5000;
        Decimal d2 = 7000;
        Decimal d3 = 9000;
        sharedAccums.Individual_Deductible_Amount__c=d1;
        sharedAccums.Family_Deductible_Amount__c=Null;    
        sharedAccums.Does_Deductible_apply_to_Out_of_Pocket__c='';
        sharedAccums.Does_Copay_apply_to_Out_of_Pocket__c='';
        sharedAccums.Out_of_Pocket__c=s2;
        sharedAccums.Aggregate_or_Embedded_Out_of_Pocket__c='';
        sharedAccums.Individual_Out_of_Pocket_Amount__c=Null;
        sharedAccums.Family_Out_of_Pocket_Amount__c=null;            
        sharedAccums.Lifetime_Maximum__c=s;            
        sharedAccums.Amount__c=null;
        sharedAccums.Accums_Shared_With__c='';
        sharedAccums.Accums_Feeding_feaking__c='';
        sharedAccums.Shared_Accum_ID__c='';
        sharedAccums.Shared_Accum_with_Vendor_Using__c='';
        insert sharedAccums;
       
        
        GEMS_AccountSubmissionCompleteValidation completeVal = New GEMS_AccountSubmissionCompleteValidation();
        GEMS_AccountSubmissionCompleteValidation.validateChildCasesStatus(subCaseRec.Id);
        
        test.stopTest(); 
    }
    
    
    private static testmethod void GEMS_AccountSubmissionCompleteValidation_TEST2()
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
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        System.assertEquals(subCaseRec.Id,caseTeamAccSpecMem.ParentId );
        
        GEMS_Attachment__c gemsAttach11 = new GEMS_Attachment__c();
        gemsAttach11.type__c='BPA';
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
        test.startTest();

        GEMS_AccountSubmissionCompleteValidation completeVal = New GEMS_AccountSubmissionCompleteValidation();
        GEMS_AccountSubmissionCompleteValidation.validateChildCasesStatus(subCaseRec.Id);
        
        test.stopTest(); 
    }
   
    private static testmethod void GEMS_AccountSubmissionCompleteValidation_TEST4()
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
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        System.assertEquals(subCaseRec.Id,caseTeamAccSpecMem.ParentId );
        
        GEMS_Attachment__c gemsAttach11 = new GEMS_Attachment__c();
        gemsAttach11.type__c='BPA';
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
        test.startTest();
    
        Case idRec= GEMS_UtilityClassTest.insertionCase('GEMS ID Card');
        idRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        //idRec.accountId = acc.Id;
        idRec.Status = 'In Progress';
        insert idRec;
        Id accidRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Case idCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:accidRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
          
        System.assertEquals(subCaseRec.Id,idCaseRec.GEMS_Account_Submission_Info__c );
        
        
        Case sbcRec= GEMS_UtilityClassTest.insertionCase('GEMS SBC');
        sbcRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        sbcRec.Status = 'In Progress';
        insert sbcRec;
        
        Id sbcRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();
        Case sbcCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:sbcRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
          
        System.assertEquals(subCaseRec.Id,sbcCaseRec.GEMS_Account_Submission_Info__c );
        
        GEMS_AccountSubmissionCompleteValidation completeVal = New GEMS_AccountSubmissionCompleteValidation();
        GEMS_AccountSubmissionCompleteValidation.validateChildCasesStatus(subCaseRec.Id);
        
        test.stopTest(); 
    }
   
   private static testmethod void GEMS_AccountSubmissionCompleteValidation_TEST3()
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
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        System.assertEquals(subCaseRec.Id,caseTeamAccSpecMem.ParentId );
        
        GEMS_Attachment__c gemsAttach11 = new GEMS_Attachment__c();
        gemsAttach11.type__c='BPA';
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
        test.startTest();

        Case idRec= GEMS_UtilityClassTest.insertionCase('GEMS ID Card');
        idRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        idRec.Status = 'Completed';
        insert idRec;
        Id accidRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Case idCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:accidRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
          
        System.assertEquals(subCaseRec.Id,idCaseRec.GEMS_Account_Submission_Info__c );
        
        Case sbcRec= GEMS_UtilityClassTest.insertionCase('GEMS SBC');
        sbcRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        sbcRec.Status = 'Completed';
        insert sbcRec;
        Id sbcRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();
        Case sbcCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:sbcRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
          
        System.assertEquals(subCaseRec.Id,sbcCaseRec.GEMS_Account_Submission_Info__c );
        
        Case medRec= GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
        medRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        medRec.Status = 'Medical Benefits Production Ready';
        insert medRec;
        Id medicalRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Case medicalCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:medicalRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
                       
        System.assertEquals(subCaseRec.Id,medicalCaseRec.GEMS_Account_Submission_Info__c);

      
        Case pharmacyRec= GEMS_UtilityClassTest.insertionCase('GEMS Pharmacy Coding');
        pharmacyRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        pharmacyRec.Status =  'AS400 & BlueStar Update Completed'; 
        insert pharmacyRec;
        Id pharmacyRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        Case pharmacyCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:pharmacyRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals(subCaseRec.Id,pharmacyCaseRec.GEMS_Account_Submission_Info__c);
        
        Case dentalRec= GEMS_UtilityClassTest.insertionCase('GEMS Dental Benefit Coding');
        dentalRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        dentalRec.Status = 'Completed'; 
        insert dentalRec;
        Id dentalRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
        Case dentalCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:dentalRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
                         
         
        System.assertEquals(subCaseRec.Id,pharmacyCaseRec.GEMS_Account_Submission_Info__c);
             
        GEMS_AccountSubmissionCompleteValidation completeVal = New GEMS_AccountSubmissionCompleteValidation();
        GEMS_AccountSubmissionCompleteValidation.validateChildCasesStatus(subCaseRec.Id);
        
        test.stopTest(); 
    } 
    
    private static testmethod void GEMS_AccountSubmissionCompleteValidation_TEST5()
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
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        System.assertEquals(subCaseRec.Id,caseTeamAccSpecMem.ParentId );
        
        Case strRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        strRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        strRec.accountId = acc.Id;
        strRec.Status = 'Design In Progress';
        strRec.GEMS_Reserved_Group_Numbers__c = '1234';
        insert strRec;
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals('Design In Progress',strCaseRec.status);
        //test.startTest();
        GEMS_Group_Section__c grpSec = GEMS_UtilityClassTest.insertionGroup(acc.Id,strCaseRec.Id);
        insert grpSec ;
        
        strCaseRec.Status = 'Client Approval Received';
        update strCaseRec;
        
        Case idRec= GEMS_UtilityClassTest.insertionCase('GEMS ID Card');
        idRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        idRec.Status = 'Completed';
        insert idRec;
        test.startTest();
        Id accidRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Case idCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:accidRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
          
        System.assertEquals(subCaseRec.Id,idCaseRec.GEMS_Account_Submission_Info__c );
        
        Case sbcRec= GEMS_UtilityClassTest.insertionCase('GEMS SBC');
        sbcRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        sbcRec.Status = 'Completed';
        insert sbcRec;
        Id sbcRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();
        Case sbcCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:sbcRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id limit 1 ];
          
        System.assertEquals(subCaseRec.Id,sbcCaseRec.GEMS_Account_Submission_Info__c );
        
        Case medRec= GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
        medRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        medRec.Status = 'Medical Benefits Production Ready';
        insert medRec;
        
        Id medicalRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Case medicalCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:medicalRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
                       
        System.assertEquals(subCaseRec.Id,medicalCaseRec.GEMS_Account_Submission_Info__c);

        Case pharmacyRec= GEMS_UtilityClassTest.insertionCase('GEMS Pharmacy Coding');
        pharmacyRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        pharmacyRec.Status =  'AS400 & BlueStar Update Completed'; 
        insert pharmacyRec;
        Id pharmacyRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        Case pharmacyCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:pharmacyRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals(subCaseRec.Id,pharmacyCaseRec.GEMS_Account_Submission_Info__c);
        
        Case dentalRec= GEMS_UtilityClassTest.insertionCase('GEMS Dental Benefit Coding');
        dentalRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        dentalRec.Status = 'Completed'; 
        insert dentalRec;
        
        Id dentalRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
        Case dentalCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:dentalRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
                         
         
        System.assertEquals(subCaseRec.Id,pharmacyCaseRec.GEMS_Account_Submission_Info__c);
      
        List<Case> cslst =new List<Case>();
        Case accsetRec= GEMS_UtilityClassTest.insertionCase('GEMS FSUClaims');
        accsetRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec.accountId = acc.Id;
        accsetRec.Status = 'Completed'; 
        cslst.add(accsetRec);
        Case accsetRec1= GEMS_UtilityClassTest.insertionCase('GEMS GET');
        accsetRec1.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec1.accountId = acc.Id;
        accsetRec1.Status = 'In Progress';
        cslst.add(accsetRec1); 
        
        Case accsetRec2= GEMS_UtilityClassTest.insertionCase('GEMS Manual Eligibility');
        accsetRec2.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec2.accountId = acc.Id;
        accsetRec2.Status = 'Completed'; 
        insert accsetRec2;
        Case accsetRec3= GEMS_UtilityClassTest.insertionCase('GEMS Eligibility');
        accsetRec3.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec3.accountId = acc.Id;
        accsetRec3.Status = 'Completed';
        cslst.add(accsetRec3);
        insert cslst;
       
        GEMS_AccountSubmissionCompleteValidation completeVal = New GEMS_AccountSubmissionCompleteValidation();
        GEMS_AccountSubmissionCompleteValidation.validateChildCasesStatus(subCaseRec.Id);
        
        test.stopTest(); 
    }
    
    private static testmethod void GEMS_AccountSubmissionCompleteValidation_TEST6()
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
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        System.assertEquals(subCaseRec.Id,caseTeamAccSpecMem.ParentId );
        
        Case strRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        strRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        strRec.accountId = acc.Id;
        strRec.Status = 'Design In Progress';
        strRec.GEMS_Reserved_Group_Numbers__c = '1234';
        insert strRec;

        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals('Design In Progress',strCaseRec.status);
        //test.startTest();
         GEMS_Group_Section__c grpSec = GEMS_UtilityClassTest.insertionGroup(acc.Id,strCaseRec.Id);
        insert grpSec ;
        
        strCaseRec.Status = 'Client Approval Received';
        update strCaseRec;
        
        Case idRec= GEMS_UtilityClassTest.insertionCase('GEMS ID Card');
        idRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        idRec.Status = 'Completed';
        insert idRec;
        test.startTest();
        Id accidRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Case idCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:accidRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
          
        System.assertEquals(subCaseRec.Id,idCaseRec.GEMS_Account_Submission_Info__c );
        
        Case sbcRec= GEMS_UtilityClassTest.insertionCase('GEMS SBC');
        sbcRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        sbcRec.Status = 'Completed';
        insert sbcRec;
        Id sbcRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();
        Case sbcCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:sbcRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
          
        System.assertEquals(subCaseRec.Id,sbcCaseRec.GEMS_Account_Submission_Info__c );
        
        Case medRec= GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
        medRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        medRec.Status = 'Medical Benefits Production Ready';
        insert medRec;
        
        Id medicalRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Case medicalCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:medicalRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
                       
        System.assertEquals(subCaseRec.Id,medicalCaseRec.GEMS_Account_Submission_Info__c);

        Case pharmacyRec= GEMS_UtilityClassTest.insertionCase('GEMS Pharmacy Coding');
        pharmacyRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        pharmacyRec.Status =  'AS400 & BlueStar Update Completed'; 
        insert pharmacyRec;
        Id pharmacyRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        Case pharmacyCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:pharmacyRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals(subCaseRec.Id,pharmacyCaseRec.GEMS_Account_Submission_Info__c);
        
        Case dentalRec= GEMS_UtilityClassTest.insertionCase('GEMS Dental Benefit Coding');
        dentalRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        dentalRec.Status = 'Completed'; 
        insert dentalRec;
        
        Id dentalRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
        Case dentalCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:dentalRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
                         
         
        System.assertEquals(subCaseRec.Id,pharmacyCaseRec.GEMS_Account_Submission_Info__c);
        List<Case> cslst =new List<Case>();
        Case accsetRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Setup');
        accsetRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec.accountId = acc.Id;
        accsetRec.Status = 'Release Underwriting Complete'; 
        cslst.add(accsetRec);
        Case accsetRec1= GEMS_UtilityClassTest.insertionCase('GEMS Dental Underwriting');
        accsetRec1.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec1.accountId = acc.Id;
        accsetRec1.Status = 'Approved';
        cslst.add(accsetRec1); 
        
        Case accsetRec2= GEMS_UtilityClassTest.insertionCase('GEMS Additional Underwriting');
        accsetRec2.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec2.accountId = acc.Id;
        accsetRec2.Status = 'Approved'; 
        insert accsetRec2;
        Case accsetRec3= GEMS_UtilityClassTest.insertionCase('GEMS Medical Underwriting');
        accsetRec3.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec3.GEMS_UW_Acct_Sub_Spec_flag__c =true;
        accsetRec3.accountId = acc.Id;
        accsetRec3.Status = 'Approved';
        cslst.add(accsetRec3);
        Case accsetRec4= GEMS_UtilityClassTest.insertionCase('GEMS Membership');
        accsetRec4.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec4.accountId = acc.Id;
        accsetRec4.Status = 'Approved';
        cslst.add(accsetRec4);
        insert cslst;
       
        
        GEMS_AccountSubmissionCompleteValidation completeVal = New GEMS_AccountSubmissionCompleteValidation();
        GEMS_AccountSubmissionCompleteValidation.validateChildCasesStatus(subCaseRec.Id);
        
        test.stopTest(); 
    }
    
    private static testmethod void GEMS_AccountSubmissionCompleteValidation_TEST7(){
    
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
        
        Case strRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        strRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        strRec.accountId = acc.Id;
        strRec.Status = 'Design In Progress';
        strRec.GEMS_Reserved_Group_Numbers__c = '1234';
        insert strRec;
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals('Design In Progress',strCaseRec.status);
        //test.startTest();
        GEMS_Group_Section__c grpSec = GEMS_UtilityClassTest.insertionGroup(acc.Id,strCaseRec.Id);
        insert grpSec ;
        
        strCaseRec.Status = 'Client Approval Received';
        update strCaseRec;
        List<Case> cslst =new List<Case>();
        Case idRec= GEMS_UtilityClassTest.insertionCase('GEMS ID Card');
        idRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        idRec.Status = 'Completed';
        cslst.add(idRec);
        
        Case sbcRec= GEMS_UtilityClassTest.insertionCase('GEMS SBC');
        sbcRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        sbcRec.Status = 'Completed';
        cslst.add(sbcRec);
               
        Case medRec= GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
        medRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        medRec.Status = 'Medical Benefits Production Ready';
        cslst.add(medRec);
        
        Case pharmacyRec= GEMS_UtilityClassTest.insertionCase('GEMS Pharmacy Coding');
        pharmacyRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        pharmacyRec.Status =  'AS400 & BlueStar Update Completed'; 
        cslst.add(pharmacyRec);     
        
        Case dentalRec= GEMS_UtilityClassTest.insertionCase('GEMS Dental Benefit Coding');
        dentalRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        dentalRec.Status = 'Completed'; 
        cslst.add(dentalRec);       
        
        Case accsetRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Setup');
        accsetRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec.accountId = acc.Id;
        accsetRec.Status = 'In Progress'; 
        cslst.add(accsetRec);
        Case accsetRec1= GEMS_UtilityClassTest.insertionCase('GEMS Dental Underwriting');
        accsetRec1.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec1.accountId = acc.Id;
        accsetRec1.Status = 'In Progress';
        cslst.add(accsetRec1); 
        
        Case accsetRec2= GEMS_UtilityClassTest.insertionCase('GEMS Additional Underwriting');
        accsetRec2.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec2.accountId = acc.Id;
        accsetRec2.Status = 'In Progress'; 
        insert accsetRec2;
        Case accsetRec3= GEMS_UtilityClassTest.insertionCase('GEMS Medical Underwriting');
        accsetRec3.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec3.GEMS_UW_Acct_Sub_Spec_flag__c =true;
        accsetRec3.accountId = acc.Id;
        accsetRec3.Status = 'In Progress';
        cslst.add(accsetRec3);
        Case accsetRec4= GEMS_UtilityClassTest.insertionCase('GEMS Membership');
        accsetRec4.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec4.accountId = acc.Id;
        accsetRec4.Status = 'In Progress';
        cslst.add(accsetRec4);
        test.startTest();
        Case accsetRec5= GEMS_UtilityClassTest.insertionCase('GEMS FSUClaims');
        accsetRec5.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec5.accountId = acc.Id;
        accsetRec5.Status = 'In Progress'; 
        cslst.add(accsetRec5);
        Case accsetRec6= GEMS_UtilityClassTest.insertionCase('GEMS GET');
        accsetRec6.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec6.accountId = acc.Id;
        accsetRec6.Status = 'In Progress';
        cslst.add(accsetRec6); 
        
        Case accsetRec7= GEMS_UtilityClassTest.insertionCase('GEMS Manual Eligibility');
        accsetRec7.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec7.accountId = acc.Id;
        accsetRec7.Status = 'In Progress'; 
        insert accsetRec7;
        Case accsetRec8= GEMS_UtilityClassTest.insertionCase('GEMS Eligibility');
        accsetRec8.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec8.accountId = acc.Id;
        accsetRec8.Status = 'In Progress';
        cslst.add(accsetRec8);
        Case accsetRec9= GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
        accsetRec9.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec9.accountId = acc.Id;
        accsetRec9.Status = 'In Progress';
        cslst.add(accsetRec9); 
        
        Case accsetRec10= GEMS_UtilityClassTest.insertionCase('GEMS Pharmacy Coding');
        accsetRec10.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec10.accountId = acc.Id;
        accsetRec10.Status = 'In Progress'; 
        insert accsetRec10;
        Case accsetRec11= GEMS_UtilityClassTest.insertionCase('GEMS Dental Benefit Coding');
        accsetRec11.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec11.accountId = acc.Id;
        accsetRec11.Status = 'In Progress';
        cslst.add(accsetRec11);
        insert cslst;
       
        GEMS_AccountSubmissionCompleteValidation completeVal = New GEMS_AccountSubmissionCompleteValidation();
        GEMS_AccountSubmissionCompleteValidation.validateChildCasesStatus(subCaseRec.Id);
        
        test.stopTest(); 
    }
    
    private static testmethod void GEMS_AccountSubmissionCompleteValidation_TEST8(){
    
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
        
        Case accsetRec3= GEMS_UtilityClassTest.insertionCase('GEMS Medical Underwriting');
        accsetRec3.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec3.GEMS_UW_Acct_Sub_Spec_flag__c =true;
        accsetRec3.accountId = acc.Id;
        accsetRec3.Status = 'Approved';
        insert accsetRec3;
        
        Id uwCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
        Case uwCaseRec = [Select id, recordtype.id from case where recordtypeid=:uwCaserecordTypeId];
        uwCaseRec.Status = 'In Progress';
        update uwCaseRec;
     }   
     
      private static testmethod void GEMS_AccountSubmissionCompleteValidation_TEST9(){
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testuser;
        
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
        
        Case accsetRec3= GEMS_UtilityClassTest.insertionCase('GEMS Medical Underwriting');
        accsetRec3.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        accsetRec3.GEMS_UW_Acct_Sub_Spec_flag__c =false;
        accsetRec3.accountId = acc.Id;
        accsetRec3.Status = 'Approved';
        accsetRec3.GEMS_Returned_user_id__c= testuser.Id;
        accsetRec3.GEMS_Return_Reason__c = 'ASO Billing/BlueSTAR Issue (case sent to Accnt. Specialist)';
        insert accsetRec3;
        
        Id uwCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
        Case uwCaseRec = [Select id, recordtype.id from case where recordtypeid=:uwCaserecordTypeId];
        uwCaseRec.Status = 'In Progress';
        update uwCaseRec;
     }   
}