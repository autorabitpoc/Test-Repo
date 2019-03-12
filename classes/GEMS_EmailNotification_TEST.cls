/**************************************************************************************
Apex Class Name     : GEMS_EmailNotification_TEST
Version             : 1.0
Function            : This class is serves as Unit Test Class for GEMS_EmailNotification
Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ranjit Gandhi       10/11/2017             SFDC 3434 GEMS: Systematic, Actionable Notifications of SharePoint Attachment Changes/Additions
*   Siva                    07/01/2016                Original Version
*************************************************************************************/
@isTest
public class GEMS_EmailNotification_TEST{
    private static testmethod void GEMS_EmailNotification_TEST1()
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
        
        Case medRec= GEMS_UtilityClassTest.insertionCase('GEMS Medical Benefit Coding');
        medRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        medRec.accountId = acc.Id;
        medRec.Status = 'Medical Benefits Production Ready';
        insert medRec;
        
        Id medicalRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Case medicalCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
                             where RecordTypeId=:medicalRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        
        System.assertEquals(subCaseRec.Id,medicalCaseRec.GEMS_Account_Submission_Info__c);
        
        GEMS_EmailNotification email = New GEMS_EmailNotification();
    }
    
    private static testmethod void GEMS_EmailNotification_TEST2()
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
        String[] toAddresses;
        List<Messaging.SingleEmailMessage> mailList;
        String htmlBody;
        String subject;
        GEMS_EmailNotification.sendSingleEmailNotification(toAddresses,subject,htmlBody,subRec);
        GEMS_EmailNotification.createMassEmailMessage(mailList,toAddresses,subject,htmlBody,subRec);
         // Ranjit Gandhi       10/11/2017             SFDC 3434 GEMS: Systematic, Actionable Notifications of SharePoint Attachment Changes/Additions
        GEMS_EmailNotification.createMassEmailMessageSBCBB(mailList,toAddresses,subject,htmlBody);
        GEMS_EmailNotification.createMassEmailNotificationWithTemplate(mailList, toAddresses, new EmailTemplate(), subRec,new Contact(LastName = 'Test'), new List<OrgWideEmailAddress>());

    }
    
    private static testmethod void GEMS_EmailNotification_TEST3(){
        test.starttest();
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.GEMS_Products__c = 'HCA;';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
        
        Id MedicalBALevelSubChildRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Medical Benefit Coding').getRecordTypeId();
        case medicalCase = new case();
        medicalCase.recordtypeid =MedicalBALevelSubChildRecordType;
        medicalCase.parentid=subRec.Id;
        medicalCase.GEMS_Account_Submission_Info__c=subRec.Id;
        medicalCase.status = 'In Progress';
        medicalCase.Production_Availability_Date__c = System.Today();
        insert medicalCase;
        
        medicalCase.status  = 'Medical Benefits Production Ready';  
        update  medicalCase;        
        test.stoptest();
        
    }
    
    private static testmethod void GEMS_EmailNotification_TEST4(){
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        List<User> userList = new List<User>();
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        User testUser2 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test2@user12.com', 'testUser2', 'test2@user.com');
        userList.add(testUser1);
        userList.add(testUser2);
        insert userList;
        
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        List<String> accountTeamRoleList = new  List<String>();
        
        accountTeamRoleList.add('Account Specialist');
        accountTeamRoleList.add('Benefit Coder');
        
        List<AccountTeamMember> accTeamMemberList = new List<AccountTeamMember>();
        for(Integer i=0; i<=1;i++)
        {
            AccountTeamMember accTeamMemberAccSpecialist =  new AccountTeamMember();
            accTeamMemberAccSpecialist.UserId =userList[i].id;
            accTeamMemberAccSpecialist.TeamMemberRole = accountTeamRoleList[i];
            accTeamMemberAccSpecialist.AccountId =accRec.id;
            accTeamMemberList.add(accTeamMemberAccSpecialist);
            
        }
        
        insert accTeamMemberList;
        
        Test.startTest();         
        Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        subRec.accountid = accRec.id;
        insert subRec;
        
        Gems_Attachment__c gemsattach = new Gems_Attachment__c();
        gemsattach.type__c = 'Benefit Adhoc Meeting Minutes';
        gemsattach.attachment__c = 'ts';
        gemsattach.case__c = Subrec.id;
        insert gemsattach;
        
        id caseGEMGetRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS GET').getRecordTypeId();
        case getCase = new case();
        getCase.recordtypeid = caseGEMGetRecordTypeId;
        getCase.GEMS_Client_Kickoff_Meeting_Comp_Date__c = System.today();
        getCase.status = 'New';
        getCase.GEMS_Verify_Benefit_Adhoc_Needed__c ='No';
        getCase.GEMS_Implementation_Is_Closed__c = false;
        getCase.gems_account_submission_info__c = subrec.id;
        getcase.accountid = accrec.id;
        insert getCase;
        
        id caseIdCardRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        case idCardCase = new case();
        idCardCase.recordtypeid = caseIdCardRecordTypeId;
        idCardCase.OwnerId = testUser1.Id;
        idCardCase.status = 'New';
        idCardCase.gems_account_submission_info__c = subrec.id;
        idCardCase.accountid = accrec.id;
        insert idCardCase;
        
        GEMS_Case_Statuses__c status = new GEMS_Case_Statuses__c();
        status.Name = 'Closed';
        insert status;
        
        Id PharmacyCaseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        case pharmacyCase = new Case();
        pharmacyCase.RecordTypeId = PharmacyCaseRecordType;
        pharmacyCase.GEMS_Account_Submission_Info__c=subRec.Id;
        pharmacyCase.status = 'In Progress';
        pharmacyCase.OwnerId = testUser1.Id;
        insert pharmacyCase;
        Id PharmacyBALevelCaseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS BA Level Pharmacy Coding').getRecordTypeId();
        case pharmacyBALevelCase = new Case();
        pharmacyBALevelCase.RecordTypeId = PharmacyBALevelCaseRecordType;
        pharmacyBALevelCase.GEMS_Account_Submission_Info__c=subRec.Id;
        pharmacyBALevelCase.ParentId = pharmacyCase.id;
        pharmacyBALevelCase.status = 'In Progress';
        pharmacyBALevelCase.OwnerId = testUser1.Id;
        insert pharmacyBALevelCase;
        GEMS_Pharmacy_Scope_Code__c scopeCode = new GEMS_Pharmacy_Scope_Code__c();
        scopeCode.Case__c = pharmacyCase.Id;
        scopeCode.OwnerId = testUser1.Id;
        scopeCode.Accums_Integration__c = 'No';
        scopeCode.Copay_Type__c = 'Flat';
        scopeCode.Formulary_Type__c = 'Basic';
        scopeCode.Scope_Status__c = 'No Scope Code Changes';
        scopeCode.Group_Pay_Code__c = 'TEST';
        scopeCode.Name = 'TEST';
        Insert scopeCode;
        pharmacyCase.OwnerId = testUser2.Id;
        update pharmacyCase;
        
       
        
        getCase.GEMS_Verify_Benefit_Adhoc_Needed__c = 'Yes';
        getCase.GEMS_Implementation_Is_Closed__c = true;
        getCase.GEMS_Internal_Benefit_Meeting_Start_Date__c = System.today();
        getCase.GEMS_Internal_Benefit_Meeting_Comp_Date__c= System.today();
        getCase.GEMS_External_Benefit_Meeting_Comp_Date__c= System.today();
        getCase.GEMS_External_Benefit_Meeting_Start_Date__c= System.today();
        getCase.status = 'Completed';
        update getCase;
        
        idCardCase.Status = 'Completed';
        update idCardCase;
        
        Test.stopTest();
    }
}