/**************************************************************************************
  Apex Class Name     : GEMS_ProspectiveIDCardBAAssignCntlr_TEST
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_ProspectiveIDCardBAAssignCntlr
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Siva Thimmannagari          08/16/2016             Original Version
* Phani Kommareddy	      	  09/15/2017	     	 SFDC-2835 GEMS - Ability to request ID Card Prospective by Group Section
* Phani Kommareddy		   	  05/16/2018			 SFDC-6974 GEMS: ID Cards - Allow Prospective IDs to be attached to Prospective ID Card Form
*************************************************************************************/
@isTest
public class GEMS_ProspectiveIDCardBAAssignCntlr_TEST{
    private static testmethod void GEMS_ProspectiveIDCardBAAssignCntlr_TEST1()
    {
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
        idRec.accountId = acc.Id;
        idRec.Status = 'Completed';
        insert idRec;
        
        
        Id accidRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Case idCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:accidRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
 
        System.assertEquals(subCaseRec.Id,idCaseRec.GEMS_Account_Submission_Info__c );
                         
        GEMS_Prospective_ID_Card__c idCard = New GEMS_Prospective_ID_Card__c();
        idCard.Parent_ID_Card_Case__c = idCaseRec.Id;
        idCard.Prospective_ID_Card_Approved__c =true;
        idCard.Status__c = 'Request for prospective ID';
        idCard.Assignment_Type__c = 'Benefit Agreement';
        insert idCard;
       
        ApexPages.currentpage().getParameters().put('caseid',idCaseRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(idCaseRec);
        GEMS_ProspectiveIDCardBAAssignCntlr idassign = new GEMS_ProspectiveIDCardBAAssignCntlr(std);
        idassign.baCaseNums=bfAgrrement.Id;
        idassign.saveAndAssignBAs();
        idassign.gotoCase();
        idassign.dummy();
        idassign.submitProspectiveIdCard();
        PageReference pageRef1 = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef1);
      
        
        ApexPages.currentpage().getParameters().put('id',idCard .id);
        ApexPages.StandardController std1 = new ApexPages.standardController(idCaseRec);
      
        GEMS_ProspectiveIDCardBAAssignCntlr idassign1 = new GEMS_ProspectiveIDCardBAAssignCntlr(std1);
        idassign1.baCaseNums=bfAgrrement.Id;
        idassign1.saveAndAssignBAs();
        idassign1.gotoCase();
        idassign1.dummy();
         
        PageReference pageRef = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef); 
        
       test.stopTest();                  
    }
    
    private static testmethod void GEMS_ProspectiveIDCardBAAssignCntlr_TEST2()
    {
    
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
        
        GEMS_Prospective_ID_Card__c idCard = New GEMS_Prospective_ID_Card__c();
        idCard.Parent_ID_Card_Case__c = idCaseRec.Id;
        idCard.Prospective_ID_Card_Approved_Date__c =system.today();
        idCard.Account_Setup_OSS_User__c =testUser1.id;
        idCard.Prospective_ID_Card_Approved__c =false;
        idCard.Status__c = 'Request for prospective ID';
        idCard.Assignment_Type__c = 'Benefit Agreement';
        insert idCard;
        
        
        //SFDC-6974 GEMS: ID Cards - Allow Prospective IDs to be attached to Prospective ID Card Form
        GEMS_Prospective_ID_Card__c pidBefore = [select attachment__c from  GEMS_Prospective_ID_Card__c where id = : idCard.id limit 1] ;
        System.assertEquals(pidBefore.Attachment__c,'No');
        Attachment testAttachment = new Attachment();
        testAttachment.Body = Blob.valueOf('Body of a png file');
        testAttachment.Name = 'logo.png';
        testAttachment.ContentType = 'image/png';
        testAttachment.parentId = idCard.id;
        insert testAttachment;
        GEMS_Prospective_ID_Card__c pidAfter = [select attachment__c from  GEMS_Prospective_ID_Card__c where id = : idCard.id limit 1] ;
        System.assertEquals(pidAfter.Attachment__c,'Yes');
        
        ApexPages.currentpage().getParameters().put('caseid',idCaseRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(idCaseRec);
        GEMS_ProspectiveIDCardBAAssignCntlr idassign = new GEMS_ProspectiveIDCardBAAssignCntlr(std);
        idassign.baCaseNums=bfAgrrement.Id;
        idassign.saveAndAssignBAs();
        idassign.gotoCase();
        idassign.dummy();
        idassign.submitProspectiveIdCard();
        
        PageReference pageRef1 = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentpage().getParameters().put('id',idCard.id);
        ApexPages.StandardController std1 = new ApexPages.standardController(idCaseRec);
        GEMS_ProspectiveIDCardBAAssignCntlr idassign1 = new GEMS_ProspectiveIDCardBAAssignCntlr(std1);
        idassign1.baCaseNums=bfAgrrement.Id;
        idassign1.saveAndAssignBAs();
        idassign1.gotoCase();
        idassign1.dummy();
        idassign1.submitProspectiveIdCard();
        
        PageReference pageRef = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef);
        
       test.stopTest();                  
    }

    private static testmethod void GEMS_ProspectiveIDCardBAAssignCntlr_TEST3()
    {
    
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
        
        GEMS_Prospective_ID_Card__c idCard = New GEMS_Prospective_ID_Card__c();
        idCard.Parent_ID_Card_Case__c = idCaseRec.Id;
        idCard.Prospective_ID_Card_Approved_Date__c =system.today();
        idCard.Account_Setup_OSS_User__c =testUser1.id;
        idCard.Actual_Owner__c=testUser1.id;
        idCard.Prospective_ID_Card_Approved__c =false;
        idCard.Status__c = 'Request for prospective ID';
        idCard.Assignment_Type__c = 'Benefit Agreement';
        insert idCard;

        
        ApexPages.currentpage().getParameters().put('caseid',idCaseRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(idCaseRec);
        GEMS_ProspectiveIDCardBAAssignCntlr idassign = new GEMS_ProspectiveIDCardBAAssignCntlr(std);
        idassign.baCaseNums=bfAgrrement.Id;
        idassign.saveAndAssignBAs();
        idassign.gotoCase();
        idassign.dummy();
        idassign.submitProspectiveIdCard();
        
        PageReference pageRef1 = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentpage().getParameters().put('id',idCard.id);
        ApexPages.StandardController std1 = new ApexPages.standardController(idCaseRec);
        GEMS_ProspectiveIDCardBAAssignCntlr idassign1 = new GEMS_ProspectiveIDCardBAAssignCntlr(std1);
        idassign1.baCaseNums=bfAgrrement.Id;
        idassign1.saveAndAssignBAs();
        idassign1.gotoCase();
        idassign1.dummy();
        idassign1.submitProspectiveIdCard();
        
        PageReference pageRef = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef);
        
       test.stopTest();                  
    }
    
    private static testmethod void GEMS_ProspectiveIDCardBAAssignCntlr_TEST4()
    {
    
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        List<User> usrLst = new List<User>();
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        User testUser2 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user12.com', 'testUser2', 'test2@user.com');
        usrLst.add(testUser1);
        usrLst.add(testUser2);
        insert usrLst;
    
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
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        
        CaseTeamMember caseTeamMembr = new CaseTeamMember();
        caseTeamMembr.ParentId = subRec.Id;
        List<CaseTeamRole> rolesList = [Select ID from CaseTeamRole where name='Client Implementation Consultant'];
        caseTeamMembr.TeamRoleId = rolesList[0].Id;
        caseTeamMembr.MemberID = usrLst[1].ID;
        insert caseTeamMembr;
            
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
        idRec.Status = 'Completed';
        insert idRec;
        
        Case getRec= GEMS_UtilityClassTest.insertionCase('GEMS GET');
        getRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        getRec.accountId = acc.Id;
        getRec.Status = 'In Progress';
        insert getRec;
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
        
        GEMS_Prospective_ID_Card__c idCard = New GEMS_Prospective_ID_Card__c();
        idCard.Parent_ID_Card_Case__c = idCaseRec.Id;
        idCard.Prospective_ID_Card_Approved_Date__c =system.today();
        idCard.Account_Setup_OSS_User__c =usrLst[0].id;
        idCard.Prospective_ID_Card_Approved__c =false;
        idCard.Status__c = 'Request for prospective ID';
        idCard.Assignment_Type__c = 'Benefit Agreement';
        insert idCard;

        
        ApexPages.currentpage().getParameters().put('caseid',idCaseRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(idCaseRec);
        GEMS_ProspectiveIDCardBAAssignCntlr idassign = new GEMS_ProspectiveIDCardBAAssignCntlr(std);
        idassign.baCaseNums=bfAgrrement.Id;
        idassign.saveAndAssignBAs();
        idassign.gotoCase();
        idassign.dummy();
        idassign.submitProspectiveIdCard();
        
        PageReference pageRef1 = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentpage().getParameters().put('id',idCard.id);
        ApexPages.StandardController std1 = new ApexPages.standardController(idCaseRec);
        GEMS_ProspectiveIDCardBAAssignCntlr idassign1 = new GEMS_ProspectiveIDCardBAAssignCntlr(std1);
        idassign1.baCaseNums=bfAgrrement.Id;
        idassign1.saveAndAssignBAs();
        idassign1.gotoCase();
        idassign1.dummy();
        idassign1.submitProspectiveIdCard();
        
        PageReference pageRef = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef);
        
        idCard.Status__c = 'Prospective ID Card Completed';
        update idCard;
        
        test.stopTest();                  
    }
    
    private static testmethod void GEMS_ProspectiveIDCardBAAssignCntlr_TEST5()
    {
    
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        List<User> usrLst = new List<User>();
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        User testUser2 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user12.com', 'testUser2', 'test2@user.com');
        usrLst.add(testUser1);
        usrLst.add(testUser2);
        insert usrLst;
    
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
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        
        CaseTeamMember caseTeamMembr = new CaseTeamMember();
        caseTeamMembr.ParentId = subRec.Id;
        List<CaseTeamRole> rolesList = [Select ID from CaseTeamRole where name='Client Implementation Consultant'];
        caseTeamMembr.TeamRoleId = rolesList[0].Id;
        caseTeamMembr.MemberID = usrLst[1].ID;
        insert caseTeamMembr;
            
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
       
        Case idRec= GEMS_UtilityClassTest.insertionCaseMaintenance('GEMS ID Card');
        idRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        idRec.Status = 'Completed';
        insert idRec;
        
        Case getRec= GEMS_UtilityClassTest.insertionCase('GEMS GET');
        getRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        getRec.accountId = acc.Id;
        getRec.Status = 'In Progress';
        insert getRec;
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
        
        GEMS_Prospective_ID_Card__c idCard = New GEMS_Prospective_ID_Card__c();
        idCard.Parent_ID_Card_Case__c = idCaseRec.Id;
        idCard.Prospective_ID_Card_Approved_Date__c =system.today();
        idCard.Account_Setup_OSS_User__c =usrLst[0].id;
        idCard.Prospective_ID_Card_Approved__c =false;
        idCard.Status__c = 'Request for prospective ID';
        idCard.Assignment_Type__c = 'Benefit Agreement';
        insert idCard;

        
        ApexPages.currentpage().getParameters().put('caseid',idCaseRec.id);
        ApexPages.StandardController std = new ApexPages.standardController(idCaseRec);
        GEMS_ProspectiveIDCardBAAssignCntlr idassign = new GEMS_ProspectiveIDCardBAAssignCntlr(std);
        idassign.baCaseNums=bfAgrrement.Id;
        idassign.saveAndAssignBAs();
        idassign.gotoCase();
        idassign.dummy();
        idassign.submitProspectiveIdCard();
        
        PageReference pageRef1 = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentpage().getParameters().put('id',idCard.id);
        ApexPages.StandardController std1 = new ApexPages.standardController(idCaseRec);
        GEMS_ProspectiveIDCardBAAssignCntlr idassign1 = new GEMS_ProspectiveIDCardBAAssignCntlr(std1);
        idassign1.baCaseNums=bfAgrrement.Id;
        idassign1.saveAndAssignBAs();
        idassign1.gotoCase();
        idassign1.dummy();
        idassign1.submitProspectiveIdCard();
        
        PageReference pageRef = Page.GEMSIDCardSuppressionBAAssignment;
        Test.setCurrentPage(pageRef);
        
        idCard.Status__c = 'Prospective ID Card Completed';
        update idCard;
        
        test.stopTest();                  
    }
    
    
}