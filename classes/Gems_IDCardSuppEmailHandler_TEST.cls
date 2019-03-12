// Project:  GEMS Project - Wave 1.0b
// Release:  09/16/2016
// Authors :  Phani Kommareddy and Malathi Kethireddy
// Comments: Test class for Gems_IDCardSuppEmailHandler.apxc

@isTest() 
public  class Gems_IDCardSuppEmailHandler_TEST {
   /* public static List<GEMS_ID_Card_Suppression__c> IdCardSuppNewList = new List<GEMS_ID_Card_Suppression__c>();
    public static Map<Id,GEMS_ID_Card_Suppression__c> IdCardsSuppOldMap;
    
    public Gems_IDCardSuppEmailHandler_TEST(List<GEMS_ID_Card_Suppression__c> IdCardSuppNewList1, Map<Id,GEMS_ID_Card_Suppression__c> IdCardsSuppOldMap1) {
        IdCardSuppNewList  =IdCardSuppNewList1;
        IdCardsSuppOldMap = IdCardsSuppOldMap1;
        
    }
    */ 
    private static testmethod void Gems_IDCardSuppEmailHandler_TEST1(){
        System.debug('Test1');
        test.startTest();
        Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        product2Rec.Product_Category__c='EPO;PPO;Dental';
        //product2Rec.External_ID__c = 'TestProduct00101';
        insert product2Rec;
        System.debug('Test2');
        Product2 product2RecQuery=[SELECT Id, Name, isActive, Product_Category__c from Product2 where Name='BCS Stop Loss' limit 1];
        System.assertEquals('BCS Stop Loss',product2RecQuery.Name);
        //System.assertEquals('EPO;PPO;Dental',product2RecQuery.Product_Category__c);
        
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        //acc.External_ID__c = 'Test00010012';
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        System.debug('Test3');
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
        System.debug('Test4');
        
        Id subCaserecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        
        Case subCaseRec = [Select id, recordtype.id from case where recordtypeid=:subCaserecordTypeId limit 1];
        System.assertEquals(subCaserecordTypeId,subCaseRec.recordtype.id);
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        String ProfId=[select id from Profile where name like 'System%' Limit 1].Id;
        //System.debug(ProfId);
        Id TestMemUser = [Select ID from User where isActive=true and ProfileId=: ProfId limit 1].Id;
        caseTeamAccSpecMem.MemberId = TestMemUser ;
        insert caseTeamAccSpecMem;
        System.debug('Test5'+caseTeamAccSpecMem.MemberId);
        System.assertEquals(subCaseRec.Id,caseTeamAccSpecMem.ParentId );
        
        Case strRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        strRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        strRec.accountId = acc.Id;
        strRec.Status = 'Design In Progress';
        System.debug('Test5.1');
        insert strRec;
        System.debug('Test6');
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, status, RecordTypeId from Case 
                         where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id limit 1 ];
        System.assertEquals('Design In Progress',strCaseRec.status);
        
        GEMS_Benefit_Agreement__c bfAgrrement = GEMS_UtilityClassTest.insertionBenefitAgg(acc.id,strCaseRec.id,product2Rec.id);
        bfAgrrement.AccountStructureCase__c = strCaseRec.id;
        insert bfAgrrement;
        
        System.assertEquals(strCaseRec.id,bfAgrrement.AccountStructureCase__c );
        System.debug('Test7 strCaseRec.id '+strCaseRec.id);        
        Case idRec= GEMS_UtilityClassTest.insertionCase('GEMS ID Card');
        idRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        System.debug('Test7.1 subCaseRec.id '+subCaseRec.id);        
        idRec.accountId = acc.Id;
        idRec.Status = 'Completed';
        System.debug('Test 7.2 idRec '+idRec);
        insert idRec;
        
        System.debug('Test8');
        
        Id accidRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Id SubmissionId = [select GEMS_Account_Submission_Info__c  from case where RecordTypeId=:accidRecordTypeId limit 1 ].GEMS_Account_Submission_Info__c;
        Case idCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                         where RecordTypeId=:accidRecordTypeId  and GEMS_Account_Submission_Info__c =:SubmissionId  limit 1];
                         //:accidRecordTypeId and GEMS_Account_Submission_Info__c =:subCaseRec.Id ];
        
        //System.assertEquals(subCaseRec.Id,idCaseRec.GEMS_Account_Submission_Info__c );
        
        
        
        GEMS_ID_Card_Suppression__c idCardSup = New GEMS_ID_Card_Suppression__c();
        
        idCardSup.Parent_ID_Card_Case__c = idCaseRec.Id;
        idCardSup.Status__c = 'In Progress';
        idCardSup.Assignment_Type__c = 'Benefit Agreement';
        //old map values
        insert idCardSup;
        System.debug('Test9');
        System.debug('idCardSup :');
        System.debug('idCardSup :'+idCardSup.Id);
        
        Map<Id,GEMS_ID_Card_Suppression__c> IdCardsSuppOldMap = new Map<Id,GEMS_ID_Card_Suppression__c>();
        
        System.assertEquals(idCaseRec.Id,idCardSup.Parent_ID_Card_Case__c);
        System.debug('Test10');
        ApexPages.currentpage().getParameters().put('caseid',idCaseRec.id);
        ApexPages.currentpage().getParameters().put('id',idCaseRec.id);
        
        //ApexPages.StandardController std1 = new ApexPages.standardController(idCard);
        ApexPages.StandardController std = new ApexPages.standardController(idCaseRec);
        GEMS_IDCardSuppressionBAAssignCntlr idassign = new GEMS_IDCardSuppressionBAAssignCntlr(std);
        idassign.baCaseNums=bfAgrrement.Name;
        idassign.saveAndAssignBAs();
        idassign.gotoCase();
        idassign.dummy();
        //idassign.idCardSave();
        System.debug('Test11');
        List<GEMS_ID_Card_Suppression__c> IdCardSuppNewList = new List<GEMS_ID_Card_Suppression__c>();
        
        idCardSup.Parent_ID_Card_Case__c = idCaseRec.Id;
        idCardSup.Status__c = 'Request for Suppression';
        
        update idCardSup; 
        //idassign.submitIdCardSuppression();
        IdCardSuppNewList.add(idCardSup);
        idCardSup.Status__c = 'Suppression Completed';
        update idCardSup;
        IdCardSuppNewList.add(idCardSup);
        
        idCardSup.Status__c = 'Request for Removal of Suppression';
        update idCardSup;
        IdCardSuppNewList.add(idCardSup);
        
        idCardSup.Status__c = 'Removal Of Suppression Completed';
        update idCardSup;
        IdCardSuppNewList.add(idCardSup);
        
        //Gems_IDCardSuppEmailHandler.onIdCardUpdateSendNotificationToAccSubmitterCICAccMngmntUsers(IdCardSuppNewList,IdCardsSuppOldMap);
        System.debug('Test12');
        test.stopTest();
    }
}