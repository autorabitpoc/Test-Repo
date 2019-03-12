/**************************************************************************************
  Apex Class Name     : GEMS_ProspectiveIDCardBACntlr_TEST
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_GEMSProspectiveIDCardBACntlr
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva             06/16/2016                Original Version
*************************************************************************************/
@isTest
public class GEMS_ProspectiveIDCardBACntlr_TEST{
/*
    private static testmethod void GEMS_GEMSProspectiveIDCardBACntlr_TEST1(){
    
         Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        product2Rec.Product_Category__c='EPO;PPO;Dental';
        insert product2Rec;
        
        Product2 product2RecQuery=[SELECT Id, Name, isActive, Product_Category__c from Product2 where Name='BCS Stop Loss'];
        System.assertEquals('BCS Stop Loss',product2RecQuery.Name);
        System.assertEquals('EPO;PPO;Dental',product2RecQuery.Product_Category__c);
        
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
        test.startTest();
        Case strRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        strRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        strRec.accountId = acc.Id;
        strRec.Status = 'Design In Progress';
        insert strRec;

        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals('Design In Progress',strCaseRec.status);
        
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,strCaseRec.id,product2Rec.id);
        bfAgrrement.AccountStructureCase__c = strCaseRec.id;
        insert bfAgrrement;
        System.assertEquals(strCaseRec.id,bfAgrrement.AccountStructureCase__c );
        
        Case idRec= GEMS_UtilityClassTest.insertionCase('GEMS ID Card');
        idRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        //idRec.accountId = acc.Id;
        idRec.Status = 'Completed';
        insert idRec;
        
        Id accidRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Case idCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:accidRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
          
        System.assertEquals(subCaseRec.Id,idCaseRec.GEMS_Account_Submission_Info__c );
                         
        GEMS_Prospective_ID_Card__c idCard = New GEMS_Prospective_ID_Card__c();
        idCard.Parent_ID_Card_Case__c = idCaseRec.Id;
        idCard.Prospective_ID_Card_Approved__c =true;
        idCard.Status__c = 'Request for Suppression';
        
        insert idCard;
        System.assertEquals(idCaseRec.Id,idCard.Parent_ID_Card_Case__c);
        
        ApexPages.currentpage().getParameters().put('caseid',idCaseRec.id);
        //ApexPages.StandardController std1 = new ApexPages.standardController(idCard);
        ApexPages.StandardController std = new ApexPages.standardController(idCaseRec);
        GEMS_ProspectiveIDCardBAAssignCntlr idassign = new GEMS_ProspectiveIDCardBAAssignCntlr(std);
        idassign.baCaseNums=bfAgrrement.Name;
        idassign.saveAndAssignBAs();
        idassign.gotoCase();
        idassign.dummy();
        idassign.idCardSave();
        
        PageReference pageRef1 = Page.GEMSProspectiveIDCardBAAssignment;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentpage().getParameters().put('id',idCard.id);
        ApexPages.StandardController std1 = new ApexPages.standardController(idCaseRec);
        GEMS_ProspectiveIDCardBAAssignCntlr idassign1 = new GEMS_ProspectiveIDCardBAAssignCntlr(std1);
        idassign1.baCaseNums=bfAgrrement.Name;
        idassign1.saveAndAssignBAs();
        idassign1.gotoCase();
        idassign1.dummy();
        idassign1.idCardSave();
        
        PageReference pageRef = Page.GEMSProspectiveIDCardBAAssignment;
        Test.setCurrentPage(pageRef);
        
       test.stopTest();                  
    }
    
    private static testmethod void GEMS_GEMSProspectiveIDCardBACntlr_TEST2(){
    
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testUser1;
    
         Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        product2Rec.Product_Category__c='EPO;PPO;Dental';
        insert product2Rec;
        
        Product2 product2RecQuery=[SELECT Id, Name, isActive, Product_Category__c from Product2 where Name='BCS Stop Loss'];
        System.assertEquals('BCS Stop Loss',product2RecQuery.Name);
        System.assertEquals('EPO;PPO;Dental',product2RecQuery.Product_Category__c);
        
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
        test.startTest();
        Case strRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        strRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        strRec.accountId = acc.Id;
        strRec.Status = 'Design In Progress';
        insert strRec;

        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        System.assertEquals('Design In Progress',strCaseRec.status);
        
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,strCaseRec.id,product2Rec.id);
        bfAgrrement.AccountStructureCase__c = strCaseRec.id;
        insert bfAgrrement;
        System.assertEquals(strCaseRec.id,bfAgrrement.AccountStructureCase__c );
       
        Case idRec= GEMS_UtilityClassTest.insertionCase('GEMS ID Card');
        idRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        //idRec.accountId = acc.Id;
        idRec.Status = 'Completed';
        insert idRec;
        
        Id accidRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Case idCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:accidRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
          
        System.assertEquals(subCaseRec.Id,idCaseRec.GEMS_Account_Submission_Info__c );
                         
        GEMS_Prospective_ID_Card__c idCard = New GEMS_Prospective_ID_Card__c();
        idCard.Parent_ID_Card_Case__c = idCaseRec.Id;
        idCard.Prospective_ID_Card_Approved_Date__c =system.today();
        idCard.Account_Setup_OSS_User__c =testUser1.id;
        //idCard.ownerid =testUser1.id;
        idCard.Prospective_ID_Card_Approved__c =false;
        idCard.Status__c = 'Request for Suppression';
        
        insert idCard;
        System.assertEquals(idCaseRec.Id,idCard.Parent_ID_Card_Case__c);
        
        ApexPages.currentpage().getParameters().put('caseid',idCaseRec.id);
        //ApexPages.StandardController std1 = new ApexPages.standardController(idCard);
        ApexPages.StandardController std = new ApexPages.standardController(idCaseRec);
        GEMS_ProspectiveIDCardBAAssignCntlr idassign = new GEMS_ProspectiveIDCardBAAssignCntlr(std);
        idassign.baCaseNums=bfAgrrement.Name;
        idassign.saveAndAssignBAs();
        idassign.gotoCase();
        idassign.dummy();
        idassign.idCardSave();
        
        PageReference pageRef1 = Page.GEMSProspectiveIDCardBAAssignment;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentpage().getParameters().put('id',idCard.id);
        ApexPages.StandardController std1 = new ApexPages.standardController(idCaseRec);
        GEMS_ProspectiveIDCardBAAssignCntlr idassign1 = new GEMS_ProspectiveIDCardBAAssignCntlr(std1);
        idassign1.baCaseNums=bfAgrrement.Name;
        idassign1.saveAndAssignBAs();
        idassign1.gotoCase();
        idassign1.dummy();
        idassign1.idCardSave();
        
        PageReference pageRef = Page.GEMSProspectiveIDCardBAAssignment;
        Test.setCurrentPage(pageRef);
        
       test.stopTest();                  
    }
*/
}