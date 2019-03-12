/**************************************************************************************
  Apex Class Name     : GEMS_ScopeCodeDetailController_Test
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_ScopeCodeDetailController
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva             06/16/2016                Original Version
*************************************************************************************/
@isTest
public class GEMS_ScopeCodeDetailController_Test{

    private static testmethod void GEMS_ScopeCodeDetailController_Test1(){
        
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        
        test.startTest();
        Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'In Progress';
        subCaseRec.accountId = acc.Id;
        insert subCaseRec;
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        
        
        Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        subStrRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        subStrRec.accountId = acc.Id;
        insert subStrRec;
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
        where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        GEMS_Category__c gemsCatRec = GEMS_UtilityClassTest.insertionGemsCatg(acc.Id,strCaseRec.Id);
        insert gemsCatRec;
        
     GEMS_Pharmacy_Scope_Code__c pharm = new GEMS_Pharmacy_Scope_Code__c();
     pharm.Case__c=strCaseRec.id;
     pharm.name='test';
   //pharm.Peer_Reviewer__c=user.id;
     pharm.Copay_Type__c='Flat';
     pharm.Group_Pay_Code__c='ABCD';
     pharm.Mail__c='G=Flat/F=Flat/NF=Percent';
     pharm.Related_Scope_Code__c='ABCD';
     pharm.Retail__c='No Retail Benefits';
     pharm.Rider_Code__c='00';
     pharm.Scope_Status__c='No Scope Code Changes';
     pharm.Status__c='Started';
     pharm.Temp__c=False;
     pharm.Type__c='Permanent';
     pharm.Accums_Integration__c='Yes, Integrate Ded/OPX';
     pharm.Formulary_Type__c='Basic';
     pharm.Copay_Type__c ='Flat';
     insert pharm;
         


        
    ApexPages.currentpage().getParameters().put('id',strCaseRec.id);
    ApexPages.StandardController std = new ApexPages.standardController(pharm );
    GEMS_ScopeCodeDetailController bactrl= new GEMS_ScopeCodeDetailController(std);
    bactrl.ScopeCodeRecord=pharm;
    List<GEMS_Pharmacy_Scope_Code__c> pharmList =bactrl.RelatedScopeCodeRecord;
    //List<Case> casesss = bactrl.ListOfBACases;
    //ApexPages.currentpage().getParameters().put('id',strCaseRec.id);
   // ApexPages.StandardController stdNeg = new ApexPages.standardController(strCaseRec);
   // GEMS_ScopeCodeDetailController bactrlNeg= new GEMS_ScopeCodeDetailController(stdNeg);
    
    test.stopTest();
    }
    private static testmethod void GEMS_ScopeCodeDetailController_Test2(){
       
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
         test.startTest();
         Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'In Progress';
        subCaseRec.accountId = acc.Id;
        insert subCaseRec;
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        
        
        Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        subStrRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        subStrRec.accountId = acc.Id;
        insert subStrRec;
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
        where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        GEMS_Category__c gemsCatRec = GEMS_UtilityClassTest.insertionGemsCatg(acc.Id,strCaseRec.Id);
        insert gemsCatRec;
        
        
        
        
    GEMS_Pharmacy_Scope_Code__c pharm1 = new GEMS_Pharmacy_Scope_Code__c();
     pharm1.Case__c=strCaseRec.id;
     pharm1.name='test';
   //pharm1.Peer_Reviewer__c=user.id;
     pharm1.Copay_Type__c='Flat';
     pharm1.Group_Pay_Code__c='ABCD';
     pharm1.Mail__c='G=Flat/F=Flat/NF=Percent';
     pharm1.Related_Scope_Code__c='ABCD';
     pharm1.Retail__c='No Retail Benefits';
     pharm1.Rider_Code__c='00';
     pharm1.Scope_Status__c='No Scope Code Changes';
     pharm1.Status__c='Started';
     pharm1.Temp__c=False;
     pharm1.Type__c='Temp';
     pharm1.Accums_Integration__c='Yes, Integrate Ded/OPX';
     pharm1.Formulary_Type__c='Basic';
     pharm1.Copay_Type__c ='Flat';
     insert pharm1;
      
          ApexPages.currentpage().getParameters().put('id',strCaseRec.id);
    ApexPages.StandardController std = new ApexPages.standardController(pharm1 );
    GEMS_ScopeCodeDetailController bactrl= new GEMS_ScopeCodeDetailController(std);
    bactrl.ScopeCodeRecord=pharm1;
    List<GEMS_Pharmacy_Scope_Code__c> pharmList =bactrl.RelatedScopeCodeRecord;
         
         // ApexPages.currentpage().getParameters().put('id',strCaseRec.id);
   // ApexPages.StandardController stdNeg = new ApexPages.standardController(strCaseRec);
    //GEMS_ScopeCodeBACasesController bactrlNeg= new GEMS_ScopeCodeBACasesController(stdNeg);
    test.stopTest();
 }
    

}