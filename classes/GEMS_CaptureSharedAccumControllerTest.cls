/**************************************************************************************
  Apex Class Name     : GEMS_CaptureSharedAccumControllerTest
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_CaptureSharedAccumsController
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Siva                  06/16/2016                Original Version
* Gokul Bharati         03/02/2018                SFDC-8322 GEMS: Shared Accums - Ability to Clone Existing Shared Accums Form
*************************************************************************************/
@isTest
private class GEMS_CaptureSharedAccumControllerTest{
    private static testmethod void GEMS_CaptureSharedAccumsController(){

        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);  

        
        Test.startTest();
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
        //Ranjit    SFDC-2074 Create Account Structure case 
        Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        subStrRec.GEMS_Account_Submission_Info__c  = subRec.Id;
        substrRec.Status = 'Design In Progress';
        subStrRec.accountId = acc.Id;
        insert subStrRec;
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        insert product2Rec;
        
        Product2 product2RecQuery=[SELECT Id, Name, isActive from Product2 where Name='BCS Stop Loss'];
        System.assertEquals('BCS Stop Loss',product2RecQuery.Name);
          
        GEMS_Benefit_Agreement__c benefit = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,subRec.id,product2Rec.id); 
        benefit.AccountStructureCase__c = subStrRec.Id; 
        insert benefit ;
        
            
        GEMS_Shared_Accums__c sharedAccums =new GEMS_Shared_Accums__c();
        sharedAccums.GEMS_Case__c=subRec.id;
        sharedAccums.Benefit_Agreement__c=benefit.id;                        
        sharedAccums.Accum_Period__c='Calendar Year';    
        sharedAccums.Shared_Accums_Effective_Date__c=Date.today();
        sharedAccums.HCSC_responsible_for_Vendor_Eligibility__c='Yes';
        boolean s = false;   
        boolean s2 = true;   
        //Ranjit    Test Deductible=true scenario to show error message                       
        sharedAccums.Deductible__c= true;
        sharedAccums.Aggregate_or_Embedded_Deductible__c='Aggregate';
        Decimal d1 = 5000;
        Decimal d2 = 7000;
        Decimal d3 = 9000;
        sharedAccums.Individual_Deductible_Amount__c=d1;
        //sharedAccums.Deductible_Middle_Tier_s_if_Applicable__c=d2;  
        //Ranjit    SFDC-2074 Family_Deductible_Amount__c= null to show error message                       
        sharedAccums.Family_Deductible_Amount__c=null;    
        sharedAccums.Does_Deductible_apply_to_Out_of_Pocket__c='';
        sharedAccums.Does_Copay_apply_to_Out_of_Pocket__c='';
        sharedAccums.Out_of_Pocket__c=s2;
        sharedAccums.Aggregate_or_Embedded_Out_of_Pocket__c='';
        sharedAccums.Individual_Out_of_Pocket_Amount__c=Null;
        //sharedAccums.Out_of_Pocket_Middle_Tier_if_Applicable__c=d1;                       
        sharedAccums.Family_Out_of_Pocket_Amount__c=null;            
          //Ranjit  SFDC-2074 Lifetime_Maximum__c= null to show error message      
        sharedAccums.Lifetime_Maximum__c=true;            
        sharedAccums.Amount__c=null;
        sharedAccums.Accums_Shared_With__c='';
        sharedAccums.Accums_Feeding_feaking__c='';
        sharedAccums.Shared_Accum_ID__c='';
        sharedAccums.Shared_Accum_with_Vendor_Using__c='';
        insert sharedAccums;      
       
             
              
        Test.stopTest(); 
        
        PageReference pageRef = Page.GEMSCaptureSharedAccums;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here
        ApexPages.currentpage().getParameters().put('accountId', acc.id);         
        ApexPages.currentpage().getParameters().put('caseid', subRec.id);
        
        ApexPages.currentpage().getParameters().put('Id', sharedAccums.Id);
        
        ApexPages.currentpage().getParameters().put('accumRecId',sharedAccums.Id); 
        ApexPages.currentpage().getParameters().put('accumRecId',''); 
        ApexPages.StandardController stdController2 = new ApexPages.StandardController(subRec);
        GEMS_CaptureSharedAccumsController accums=new GEMS_CaptureSharedAccumsController(stdController2);       
        accums.Save1();
        accums.back();
        accums.checked();
        
       
        pageRef = Page.GEMSCaptureSharedAccums;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here
        ApexPages.currentpage().getParameters().put('accountId', acc.id);         
        ApexPages.currentpage().getParameters().put('caseid', null);
        ApexPages.currentpage().getParameters().put('Id', sharedAccums.Id);        
        ApexPages.currentpage().getParameters().put('accumRecId',sharedAccums.Id); 
        ApexPages.currentpage().getParameters().put('accumRecId',''); 
        stdController2 = new ApexPages.StandardController(subRec);
        accums=new GEMS_CaptureSharedAccumsController(stdController2);
        accums.Save1();
        accums.back();
        accums.checked();
        
        
            
    }
    
     private static testmethod void GEMS_CaptureSharedAccumsController2(){

        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);  

        
        Test.startTest();
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
         
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        insert product2Rec;
        
        Product2 product2RecQuery=[SELECT Id, Name, isActive from Product2 where Name='BCS Stop Loss'];
        System.assertEquals('BCS Stop Loss',product2RecQuery.Name);
          
        GEMS_Benefit_Agreement__c benefit = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,subRec.id,product2Rec.id);  
        insert benefit ;   
            
        GEMS_Shared_Accums__c sharedAccums =new GEMS_Shared_Accums__c();
        sharedAccums.GEMS_Case__c=subRec.id;
        boolean s = true;   
        boolean s2 = true;   
        sharedAccums.Deductible__c= s;
        Decimal d1 = 5000;
        Decimal d2 = 7000;
        Decimal d3 = 9000;                       
        sharedAccums.Family_Deductible_Amount__c=d1;    
        sharedAccums.Does_Deductible_apply_to_Out_of_Pocket__c='Yes';
        sharedAccums.Does_Copay_apply_to_Out_of_Pocket__c='Yes';
        sharedAccums.Out_of_Pocket__c=s2;
        sharedAccums.Aggregate_or_Embedded_Out_of_Pocket__c='Aggregate';
        sharedAccums.Individual_Out_of_Pocket_Amount__c=d3;                      
        sharedAccums.Family_Out_of_Pocket_Amount__c=d1;            
        sharedAccums.Lifetime_Maximum__c=s;            
        sharedAccums.Amount__c=900000;
        sharedAccums.Accums_Shared_With__c='Pharmacy Only';
        sharedAccums.Accums_Feeding_feaking__c='In Network Updates/Feeds Out of Network';
        sharedAccums.Shared_Accum_ID__c='ABS';
        sharedAccums.Shared_Accum_with_Vendor_Using__c='SSN';
        insert sharedAccums;  
        Test.stopTest();     
        
        PageReference pageRef = Page.GEMSCaptureSharedAccums;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here
        ApexPages.currentpage().getParameters().put('accountId', acc.id);         
        ApexPages.currentpage().getParameters().put('caseid', subRec.id);        
        ApexPages.currentpage().getParameters().put('Id', sharedAccums.Id);        
        ApexPages.currentpage().getParameters().put('accumRecId',sharedAccums.Id); 
        ApexPages.currentpage().getParameters().put('accumRecId',''); 
        ApexPages.StandardController stdController2 = new ApexPages.StandardController(subRec);
        GEMS_CaptureSharedAccumsController accums=new GEMS_CaptureSharedAccumsController(stdController2);
        accums.Save1();
        accums.back();
        accums.checked();
        accums.cloneRecord();     
    }
        private static testmethod void validateFormFailed(){
        
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);  

        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;

        Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        subStrRec.GEMS_Account_Submission_Info__c  = subRec.Id;
        substrRec.Status = 'Design In Progress';
        subStrRec.accountId = acc.Id;
        insert subStrRec;
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        insert product2Rec;
        
        Product2 product2RecQuery=[SELECT Id, Name, isActive from Product2 where Name='BCS Stop Loss'];
        System.assertEquals('BCS Stop Loss',product2RecQuery.Name);
          
        GEMS_Benefit_Agreement__c benefit = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,subRec.id,product2Rec.id); 
        benefit.AccountStructureCase__c = subStrRec.Id; 
        insert benefit ;

        Test.startTest();
        PageReference pageRef = Page.GEMSCaptureSharedAccums;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here        
        ApexPages.currentpage().getParameters().put('caseid', subRec.id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(subRec);
        GEMS_CaptureSharedAccumsController accums=new GEMS_CaptureSharedAccumsController(stdController);        
        GEMS_Shared_Accums__c sharedAccums = new GEMS_Shared_Accums__c();      
        accums.sharedAccumRecord = sharedAccums;
        accums.Save1();
        Test.stopTest();
        } 
        
        private static testmethod void validateFormSuccess(){
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);  

        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;

        Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        subStrRec.GEMS_Account_Submission_Info__c  = subRec.Id;
        substrRec.Status = 'Design In Progress';
        subStrRec.accountId = acc.Id;
        insert subStrRec;
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        insert product2Rec;
        
        Product2 product2RecQuery=[SELECT Id, Name, isActive from Product2 where Name='BCS Stop Loss'];
        System.assertEquals('BCS Stop Loss',product2RecQuery.Name);
          
        GEMS_Benefit_Agreement__c benefit1 = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,subStrRec.Id,product2Rec.id); 
        benefit1.IsCancelled__c = false;
        insert benefit1 ;
        
        GEMS_Benefit_Agreement__c benefit2 = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,subStrRec.Id,product2Rec.id); 
        benefit2.IsCancelled__c = false;
        insert benefit2 ;
        
        GEMS_Group_Section__c groupSection = GEMS_UtilityClassTest.insertionGroup(acc.id,subRec.id); 
        insert groupSection ;
        
        GEMS_Category__c insertionGemsCatg = GEMS_UtilityClassTest.insertionGemsCatg(acc.id,subRec.id);
        insert insertionGemsCatg ;
               
        GEMS_Category_Assignment__c insertionCategoryAssign = GEMS_UtilityClassTest.insertionCategoryAssign(acc.id,subRec.id,insertionGemsCatg.Id,groupSection.Id);
        insert insertionCategoryAssign;
        
        GEMS_BA_Assignment__c insertionBaAssign1 = GEMS_UtilityClassTest.insertionBaAssign(acc.id,subStrRec.id,benefit1.Id,groupSection.Id);        
        insertionBaAssign1.Case__c = subStrRec.Id;
        insert insertionBaAssign1;
        
        GEMS_BA_Assignment__c insertionBaAssign2 = GEMS_UtilityClassTest.insertionBaAssign(acc.id,subStrRec.id,benefit1.Id,groupSection.Id);        
        insertionBaAssign2.Case__c = subStrRec.Id;
        insert insertionBaAssign2;
        
        Test.startTest();
        PageReference pageRef = Page.GEMSCaptureSharedAccums;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here        
        ApexPages.currentpage().getParameters().put('caseid', subRec.id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(subRec);
        GEMS_CaptureSharedAccumsController accums = new GEMS_CaptureSharedAccumsController(stdController); 
        accums.setbacasenum.add('1234');       
        GEMS_Shared_Accums__c sharedAccums = new GEMS_Shared_Accums__c();
        sharedAccums.Accum_Period__c = 'Calendar Year';
        sharedAccums.Number_of_Accum_Tiers__c = 'One Tier = One Rate Applies to all Family Structures';
        sharedAccums.Shared_Accums_Effective_Date__c = System.Today();
        sharedAccums.HCSC_responsible_for_Vendor_Eligibility__c = 'Yes';
        sharedAccums.Accums_Shared_With__c='Pharmacy Only'; 
        sharedAccums.Shared_Accum_ID__c='ABS';
        sharedAccums.Shared_Accum_with_Vendor_Using__c='SSN';     
        accums.sharedAccumRecord = sharedAccums;
        accums.Save1();
        Test.stopTest();	        	
        }	
  }