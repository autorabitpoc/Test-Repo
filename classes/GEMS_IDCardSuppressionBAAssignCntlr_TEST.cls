/**************************************************************************************
  Apex Class Name     : GEMS_IDCardSuppressionBAAssignCntlr_TEST
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_IDCardSuppressionBAAssignCntlr
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*  Phani Kommareddy             08/16/2016                Original Version
*  Phani Kommareddy				09/15/2017		  		  SFDC-4483 GEMS - Ability to request ID Card Suppression/Unsuppression by Group Section
*************************************************************************************/
@isTest
public class GEMS_IDCardSuppressionBAAssignCntlr_TEST{
    private static testmethod void GEMS_IDCardSuppressionBAAssignCntlr_TEST1(){
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
        
        System.debug('Test5.1');
        insert strRec;
        System.debug('Test6');

        
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
        idRec.accountId = acc.Id;
        idRec.Status = 'Completed';
        insert idRec;
        
        
        Id accidRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Case idCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:accidRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        
        
        
        System.assertEquals(subCaseRec.Id,idCaseRec.GEMS_Account_Submission_Info__c );
                         
        GEMS_ID_Card_Suppression__c idCardSup = New GEMS_ID_Card_Suppression__c();
        
        idCardSup.Parent_ID_Card_Case__c = idCaseRec.Id;
        idCardSup.Status__c = 'Request for Suppression';
        idCardSup.Assignment_Type__c = 'Benefit Agreement';
        insert idCardSup;
        System.assertEquals(idCaseRec.Id,idCardSup.Parent_ID_Card_Case__c);
        
        ApexPages.currentpage().getParameters().put('caseid',idCaseRec.id);
        //ApexPages.currentpage().getParameters().put('id',idCaseRec.id);
        
        //ApexPages.StandardController std1 = new ApexPages.standardController(idCard);
        ApexPages.StandardController std = new ApexPages.standardController(idCaseRec);
        GEMS_IDCardSuppressionBAAssignCntlr idassign = new GEMS_IDCardSuppressionBAAssignCntlr(std);
        idassign.baCaseNums=bfAgrrement.Id;
        idassign.saveAndAssignBAs();
        idassign.gotoCase();
        idassign.dummy();
        //idassign.idCardSave();
        
        //PageReference pageRef1 = Page.GEMSProspectiveIDCardBAAssignment;
        PageReference pageRef1 = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef1);
      
        
        ApexPages.currentpage().getParameters().put('id',idCardSup.id);
        ApexPages.StandardController std1 = new ApexPages.standardController(idCaseRec);
      
        GEMS_IDCardSuppressionBAAssignCntlr idassign1 = new GEMS_IDCardSuppressionBAAssignCntlr(std1);
        idassign1.baCaseNums=bfAgrrement.Id;
        idassign1.saveAndAssignBAs();
        idassign1.gotoCase();
        idassign1.dummy();
        //idassign1.idCardSave();
         idassign1.submitIdCardSuppression();
        PageReference pageRef = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef); 
        System.debug('Test13');
       test.stopTest();                  
    }
    
    private static testmethod void GEMS_IDCardSuppressionBAAssignCntlr_TEST2(){
    
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
                         
        Case idbaRec= GEMS_UtilityClassTest.insertionCase('GEMS BA Level ID Card');
        idbaRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        idbaRec.ParentId=idRec.id;
        idbaRec.GEMS_Benefit_Agreement__c = bfAgrrement.Id;
        idbaRec.Status = 'Completed';
        insert idbaRec;
        
        GEMS_Benefit_Agreement__c bfAgrrement1 = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,idbaRec.id,product2Rec.id);
        bfAgrrement1.AccountStructureCase__c = strCaseRec.id;
        insert bfAgrrement1;
        
        GEMS_ID_Card_Suppression__c idCard = New GEMS_ID_Card_Suppression__c();
        idCard.Parent_ID_Card_Case__c = idCaseRec.Id;
        idCard.Status__c = 'Request for Suppression';
        idCard.Actual_Owner__c= testUser1.id;
        idCard.Assignment_Type__c = 'Benefit Agreement';
        insert idCard;
        System.assertEquals(idCaseRec.Id,idCard.Parent_ID_Card_Case__c);
        
        ApexPages.currentpage().getParameters().put('caseid',idCaseRec.id);
        //ApexPages.StandardController std1 = new ApexPages.standardController(idCard);
        ApexPages.StandardController std = new ApexPages.standardController(idCaseRec);
        GEMS_IDCardSuppressionBAAssignCntlr idassign = new GEMS_IDCardSuppressionBAAssignCntlr(std);
        idassign.baCaseNums=bfAgrrement.Id;
        idassign.saveAndAssignBAs();
        idassign.gotoCase();
        idassign.dummy();
        //idassign.idCardSave();
        
        
        PageReference pageRef1 = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentpage().getParameters().put('id',idCard.id);
        ApexPages.StandardController std1 = new ApexPages.standardController(idCaseRec);
        GEMS_IDCardSuppressionBAAssignCntlr idassign1 = new GEMS_IDCardSuppressionBAAssignCntlr(std1);
        idassign1.baCaseNums=bfAgrrement.Id;
        idassign1.saveAndAssignBAs();
        idassign1.gotoCase();
        idassign1.dummy();
        idassign1.submitIdCardSuppression();
        //idassign1.idCardSave();
        
        PageReference pageRef = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef);
        
       test.stopTest();                  
    }

        private static testmethod void GEMS_IDCardSuppressionBAAssignCntlr_TEST3(){
    
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
                         
        Case idbaRec= GEMS_UtilityClassTest.insertionCase('GEMS BA Level ID Card');
        idbaRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        idbaRec.ParentId=idRec.id;
        idbaRec.GEMS_Benefit_Agreement__c = bfAgrrement.Id;
        idbaRec.Status = 'Completed';
        insert idbaRec;
        
        GEMS_Benefit_Agreement__c bfAgrrement1 = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,idbaRec.id,product2Rec.id);
        bfAgrrement1.AccountStructureCase__c = strCaseRec.id;
        insert bfAgrrement1;
        
        GEMS_ID_Card_Suppression__c idCard = New GEMS_ID_Card_Suppression__c();
        idCard.Parent_ID_Card_Case__c = idCaseRec.Id;
        idCard.Status__c = 'Request for Suppression';
        idCard.Actual_Owner__c= testUser1.id;
        idCard.Assignment_Type__c = 'Benefit Agreement';
        insert idCard;
        System.assertEquals(idCaseRec.Id,idCard.Parent_ID_Card_Case__c);
        
        ApexPages.currentpage().getParameters().put('caseid',idCaseRec.id);
        //ApexPages.StandardController std1 = new ApexPages.standardController(idCard);
        ApexPages.StandardController std = new ApexPages.standardController(idCaseRec);
        GEMS_IDCardSuppressionBAAssignCntlr idassign = new GEMS_IDCardSuppressionBAAssignCntlr(std);
        idassign.baCaseNums=bfAgrrement.Id;
        idassign.saveAndAssignBAs();
        idassign.gotoCase();
        idassign.dummy();
        //idassign.idCardSave();
        
        
        PageReference pageRef1 = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentpage().getParameters().put('id',idCard.id);
        ApexPages.StandardController std1 = new ApexPages.standardController(idCaseRec);
        GEMS_IDCardSuppressionBAAssignCntlr idassign1 = new GEMS_IDCardSuppressionBAAssignCntlr(std1);
        idassign1.baCaseNums=bfAgrrement.Id;
        idassign1.saveAndAssignBAs();
        idassign1.gotoCase();
        idassign1.dummy();
        idassign1.submitIdCardSuppression();
        //idassign1.idCardSave();
        
        PageReference pageRef = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef);
        
       test.stopTest();                  
    }
    
    private static testmethod void GEMS_IDCardSuppressionBAAssignCntlr_TEST4(){
    
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testUser1;
        
        Profile profileRec1 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser2 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user111.com', 'testUser11', 'test11@user.com');
        insert testUser2;
        
        Profile profileRecA = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUserA = GEMS_UtilityClassTest.CreateUserRecord(profileRecA.Id, 'test1A@user111.com', 'testUser11A', 'test11A@user.com');
        insert testUserA;
        
        Profile profileRecB = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUserB = GEMS_UtilityClassTest.CreateUserRecord(profileRecB.Id, 'test1B@user111.com', 'testUser11B', 'test11B@user.com');
        insert testUserB;
        
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
        
        CaseTeamMember caseTeamMembr = new CaseTeamMember();
        caseTeamMembr.ParentId = subRec.Id;
        List<CaseTeamRole> rolesList = [Select ID from CaseTeamRole where name='Client Implementation Consultant'];
        caseTeamMembr.TeamRoleId = rolesList[0].Id;
        caseTeamMembr.MemberID = testUserA.ID;
        insert caseTeamMembr;
        
        CaseTeamMember caseTeamMembr1 = new CaseTeamMember();
        caseTeamMembr1.ParentId = subRec.Id;
        List<CaseTeamRole> rolesList1 = [Select ID from CaseTeamRole where name='Account Management Support'];
        caseTeamMembr1.TeamRoleId = rolesList1[0].Id;
        caseTeamMembr1.MemberID = testUserB.ID;
        insert caseTeamMembr1;
        
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
                         
        Case idbaRec= GEMS_UtilityClassTest.insertionCase('GEMS BA Level ID Card');
        idbaRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        idbaRec.ParentId=idRec.id;
        idbaRec.GEMS_Benefit_Agreement__c = bfAgrrement.Id;
        idbaRec.Status = 'Completed';
        insert idbaRec;
        
        GEMS_Benefit_Agreement__c bfAgrrement1 = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,idbaRec.id,product2Rec.id);
        bfAgrrement1.AccountStructureCase__c = strCaseRec.id;
        insert bfAgrrement1;
        
        GEMS_ID_Card_Suppression__c idCard = New GEMS_ID_Card_Suppression__c();
        idCard.Parent_ID_Card_Case__c = idCaseRec.Id;
        idCard.Status__c = 'Request for Suppression';
        idCard.Actual_Owner__c= testUser1.id;
        idCard.Assignment_Type__c = 'Benefit Agreement';
        insert idCard;
        System.assertEquals(idCaseRec.Id,idCard.Parent_ID_Card_Case__c);
        
        ApexPages.currentpage().getParameters().put('caseid',idCaseRec.id);
        //ApexPages.StandardController std1 = new ApexPages.standardController(idCard);
        ApexPages.StandardController std = new ApexPages.standardController(idCaseRec);
        GEMS_IDCardSuppressionBAAssignCntlr idassign = new GEMS_IDCardSuppressionBAAssignCntlr(std);
        idassign.baCaseNums=bfAgrrement.Id;
        idassign.saveAndAssignBAs();
        idassign.gotoCase();
        idassign.dummy();
        //idassign.idCardSave();
        
        
        PageReference pageRef1 = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentpage().getParameters().put('id',idCard.id);
        ApexPages.StandardController std1 = new ApexPages.standardController(idCaseRec);
        GEMS_IDCardSuppressionBAAssignCntlr idassign1 = new GEMS_IDCardSuppressionBAAssignCntlr(std1);
        idassign1.baCaseNums=bfAgrrement.Id;
        idassign1.saveAndAssignBAs();
        idassign1.gotoCase();
        idassign1.dummy();
        idassign1.submitIdCardSuppression();
        //idassign1.idCardSave();
        
        PageReference pageRef = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef);
        
        idCard.Status__c = 'Suppression Completed';
        update idCard;
        
        idCard.Status__c = 'Request for Suppression';
        update idCard;
        
        idCard.Status__c = 'Request for Removal Of Suppression';
        update idCard;
        
        idCard.Status__c = 'Removal Of Suppression Completed';
        update idCard;
        
       test.stopTest();                  
    }
    
    private static testmethod void GEMS_IDCardSuppressionBAAssignCntlr_TEST5(){
    
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        insert testUser1;
        
        Profile profileRec1 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser2 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user111.com', 'testUser11', 'test11@user.com');
        insert testUser2;
        
        Profile profileRecA = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUserA = GEMS_UtilityClassTest.CreateUserRecord(profileRecA.Id, 'test1A@user111.com', 'testUser11A', 'test11A@user.com');
        insert testUserA;
        
        Profile profileRecB = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUserB = GEMS_UtilityClassTest.CreateUserRecord(profileRecB.Id, 'test1B@user111.com', 'testUser11B', 'test11B@user.com');
        insert testUserB;
        
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
        
        CaseTeamMember caseTeamMembr = new CaseTeamMember();
        caseTeamMembr.ParentId = subRec.Id;
        List<CaseTeamRole> rolesList = [Select ID from CaseTeamRole where name='Client Implementation Consultant'];
        caseTeamMembr.TeamRoleId = rolesList[0].Id;
        caseTeamMembr.MemberID = testUserA.ID;
        insert caseTeamMembr;
        
        CaseTeamMember caseTeamMembr1 = new CaseTeamMember();
        caseTeamMembr1.ParentId = subRec.Id;
        List<CaseTeamRole> rolesList1 = [Select ID from CaseTeamRole where name='Account Management Support'];
        caseTeamMembr1.TeamRoleId = rolesList1[0].Id;
        caseTeamMembr1.MemberID = testUserB.ID;
        insert caseTeamMembr1;
        
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
       
        Case idRec= GEMS_UtilityClassTest.insertionCaseMaintenance('GEMS ID Card');
        idRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        //idRec.accountId = acc.Id;
        idRec.Status = 'Completed';
        insert idRec;
        
        Id accidRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Case idCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:accidRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
          
        System.assertEquals(subCaseRec.Id,idCaseRec.GEMS_Account_Submission_Info__c );
                         
        Case idbaRec= GEMS_UtilityClassTest.insertionCase('GEMS BA Level ID Card');
        idbaRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        idbaRec.ParentId=idRec.id;
        idbaRec.GEMS_Benefit_Agreement__c = bfAgrrement.Id;
        idbaRec.Status = 'Completed';
        insert idbaRec;
        
        GEMS_Benefit_Agreement__c bfAgrrement1 = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,idbaRec.id,product2Rec.id);
        bfAgrrement1.AccountStructureCase__c = strCaseRec.id;
        insert bfAgrrement1;
        
        GEMS_ID_Card_Suppression__c idCard = New GEMS_ID_Card_Suppression__c();
        idCard.Parent_ID_Card_Case__c = idCaseRec.Id;
        idCard.Status__c = 'Request for Suppression';
        idCard.Actual_Owner__c= testUser1.id;
        idCard.Assignment_Type__c = 'Benefit Agreement';
        insert idCard;
        System.assertEquals(idCaseRec.Id,idCard.Parent_ID_Card_Case__c);
        
        ApexPages.currentpage().getParameters().put('caseid',idCaseRec.id);
        //ApexPages.StandardController std1 = new ApexPages.standardController(idCard);
        ApexPages.StandardController std = new ApexPages.standardController(idCaseRec);
        GEMS_IDCardSuppressionBAAssignCntlr idassign = new GEMS_IDCardSuppressionBAAssignCntlr(std);
        idassign.baCaseNums=bfAgrrement.Id;
        idassign.saveAndAssignBAs();
        idassign.gotoCase();
        idassign.dummy();
        //idassign.idCardSave();
        
        
        PageReference pageRef1 = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentpage().getParameters().put('id',idCard.id);
        ApexPages.StandardController std1 = new ApexPages.standardController(idCaseRec);
        GEMS_IDCardSuppressionBAAssignCntlr idassign1 = new GEMS_IDCardSuppressionBAAssignCntlr(std1);
        idassign1.baCaseNums=bfAgrrement.Id;
        idassign1.saveAndAssignBAs();
        idassign1.gotoCase();
        idassign1.dummy();
        idassign1.submitIdCardSuppression();
        //idassign1.idCardSave();
        
        PageReference pageRef = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef);
        
        idCard.Status__c = 'Suppression Completed';
        update idCard;
        
        idCard.Status__c = 'Request for Suppression';
        update idCard;
        
        idCard.Status__c = 'Request for Removal Of Suppression';
        update idCard;
        
        idCard.Status__c = 'Removal Of Suppression Completed';
        update idCard;
        
       test.stopTest();                  
    }
}