/**************************************************************************************
//Apex Class Name     : GEMS_CharValTriggerHandler_Test
//Version             : 1.0
//Modification Log    :
//Developer                   Date                   Description
//----------------------------------------------------------------------------------                 
//5/10/2018   Gokul Bharati   SFDC-4912 GEMS: BlueSTAR - Transfer Updated Characteristic Value Descriptions from GEMS to B* 
*************************************************************************************/ 
@isTest(seeAllData=false)
private class GEMS_CharValTriggerHandler_Test{
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
        
        //create characterstics 1      
        GEMS_Characteristic__c charac1 = GEMS_UtilityClassTest.insertionCharacteristic(acc.Id,strRec.id);
        charac1.isNew__c = false;
        insert charac1;
        
        //create characterstics value 1 
        GEMS_Characteristic_Value__c  charval1 = GEMS_UtilityClassTest.insertionCharacValue(charac1.Id,strRec.id);
        charval1.isNew__c = false;
        insert charval1;
               
    }
    
    public static testmethod void UpdateCharValueDesciption(){
        GEMS_Characteristic_Value__c  charac = [select id,Name from GEMS_Characteristic_Value__c where isNew__c = false];
        Test.startTest();
        charac.Name = 'Test Update';
        update charac;
        Test.stopTest(); 
    
    }
}