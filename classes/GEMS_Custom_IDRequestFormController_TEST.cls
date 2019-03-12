/**************************************************************************************
  Apex Class Name     : GEMS_Custom_IDRequestFormController_TEST 
  Version             : 1.0
  Function            : This class is serves as Unit Test Class for GEMS_Custom_IDRequestFormController
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Siva             06/16/2016                Original Version
*   Phani Kommareddy 09/15/2017		       SFDC-4442 GEMS - Ability to associate group sections to Custom ID Card requests
*************************************************************************************/
@isTest
public class GEMS_Custom_IDRequestFormController_TEST {
    private static testmethod void GEMS_Custom_IDRequestFormController_TEST1()
    {
        
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        
        Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        insert product2Rec;
        
        Product2 product2RecQuery=[SELECT Id, Name, isActive from Product2 where Name='BCS Stop Loss'];
        System.assertEquals('BCS Stop Loss',product2RecQuery.Name);
        
        Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'submitted';
        subCaseRec.accountId = acc.Id;
        insert subCaseRec;
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user11.com');
        insert testuser;
        
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test11@user11.com', 'testUser11', 'test11@user11.com');
        insert testuser1;
         
        List<CaseTeamMember> caseteamlist = new List<caseTeamMember>();
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        CaseTeamMember caseTeamAccSpecMem1 = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Management Support');
        caseTeamAccSpecMem.MemberID =testuser.id;
        caseTeamAccSpecMem1.MemberID =testuser1.id; 
        caseteamlist.add(caseTeamAccSpecMem );
        caseteamlist.add(caseTeamAccSpecMem1 );
        insert caseteamlist;
        
        AccountTeamMember accTeamAccSpecMem = new AccountTeamMember();
        accTeamAccSpecMem.AccountId = acc.Id;
        accTeamAccSpecMem.UserId=testuser.id;
        accTeamAccSpecMem.TeamMemberRole='Account Specialist';
        insert accTeamAccSpecMem;
        
        Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        subStrRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        substrRec.Status = 'Design In Progress';
        subStrRec.accountId = acc.Id;
        insert subStrRec;
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
        where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        
        test.startTest();
        Case idCase= GEMS_UtilityClassTest.insertionCase1('GEMS ID Card');
        idCase.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        insert idCase;
        
        GEMS_Custom_ID_Request_Form__c custId = New GEMS_Custom_ID_Request_Form__c();
        custId.Custom_ID_Request_Form_Case__c = idCase.id;
        custId.Status__c='In Progress';
        custId.Print_Client_Logo__c='Yes';
        custId.Print_Company_Name__c='Yes';
        custId.Print_Company_Plan_Name__c='Yes';
        custId.Alternative_Network__c='Yes';
        custId.Include_a_custom_card_carrier__c='Yes';
        custId.Print_FAMILY_SINGLE_Coverage_on_card__c='N/A when IDs are issued at the member level';
        custId.Print_C_S_alpha_prefix_on_card__c='Yes (standard)';
        custId.Print_custom_face_message_s_on_front__c='Yes';
        custId.Print_Carve_Out_Rx_Vendor_Logo__c='Yes';
        custId.Combine_Health_Dental_Cards__c='No';
        custId.Include_a_custom_web_address_extension_o__c='Yes, list custom website';
        custId.Include_client_web_address__c='Yes, list custom website';
        custId.Status__c='In Progress';
        custId.Select_one_option_for_phone_numbers_on_t__c='Include standard phone numbers?';
        custId.Select_one_option_for_the_Back_Text_Mess__c='Include standard back messages?';
        custId.Issuance_Type__c = 'Full Issuance';
        custId.Assignment_Type__c = 'Benefit Agreement';
        insert custId;
        
        GEMS_Group_Section__c  Groupsec=GEMS_UtilityClassTest.insertionGroup(acc.Id,subCaseRec.Id);        
        insert Groupsec;
        
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(acc.Id,subCaseRec.Id,product2RecQuery.Id);        
        insert benefit;
        System.assertEquals('1234',benefit.Name);
        
        GEMS_BA_Assignment__c assign =GEMS_UtilityClassTest.insertionBaAssign(acc.Id,subCaseRec.Id,benefit.Id,Groupsec.Id);        
        insert assign ;
        System.assertEquals('ABS',assign.Name);  
        
        ApexPages.currentpage().getParameters().put('id',custId.id);
        ApexPages.StandardController std = new ApexPages.standardController(idCase);
        GEMS_Custom_IDRequestFormController sbcSec = new GEMS_Custom_IDRequestFormController (std);
        sbcSec.baCaseNums = benefit.Id+',';
        sbcSec.gsCaseNums = GroupSec.Id+',';
        PageReference pageRef = Page.GEMSCustomIDBAAssignment;
        Test.setCurrentPage(pageRef);
        sbcSec.saveAndAssignBAs();
        sbcSec.gotoCase();
        sbcSec.getClientlogoItems();
        sbcSec.getCompanyNameItems();
        sbcSec.getCompanyPlanNameItems();
        sbcSec.getAlternativeNetworkItems();
        sbcSec.getCustomCardCarrierItems();
        sbcSec.getFamilyOrSingleCoverageItems();
        sbcSec.getCustomStandardAlphaPrefixItems();
        sbcSec.getCustomFaceMesssageItems();
        sbcSec.getCarvedOutRxVendorLogoItems();
        sbcSec.getCombineHealthAndMedicalCardsItems();
        sbcSec.getIncludeCustomWebAddressOnBackItems();
        sbcSec.getIncludeClientWebAddressItems();
        sbcSec.getSelectOneOptionForPhoneNumbersItems();
        sbcSec.getSelectOneOptionForBackTextItems();
        test.stopTest();
    }
    
    private static testmethod void GEMS_Custom_IDRequestFormController_TEST2()
    {
        
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        
        Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        insert product2Rec;
        
        Product2 product2RecQuery=[SELECT Id, Name, isActive from Product2 where Name='BCS Stop Loss'];
        System.assertEquals('BCS Stop Loss',product2RecQuery.Name);
        
        Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'In Progress';
        subCaseRec.accountId = acc.Id;
        insert subCaseRec;
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        user usr=[select id from user where id = :userinfo.getUserId()];
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        
        
        Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        subStrRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        substrRec.Status = 'Design In Progress';
        subStrRec.accountId = acc.Id;
        insert subStrRec;
        
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
        where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];
        
        test.startTest();
        Case idCase= GEMS_UtilityClassTest.insertionCase1('GEMS ID Card');
        idCase.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
         insert idCase;
        
        GEMS_Custom_ID_Request_Form__c custId = New GEMS_Custom_ID_Request_Form__c();
        custId.Custom_ID_Request_Form_Case__c = idCase.id;
        custId.Status__c='In Progress';
        custId.Print_Client_Logo__c='No';
        custId.Print_Company_Name__c='No';
        custId.Print_Company_Plan_Name__c='No';
        custId.Alternative_Network__c='No';
        custId.Include_a_custom_card_carrier__c='No';
        custId.Print_FAMILY_SINGLE_Coverage_on_card__c='Yes(standard)';
        custId.Print_C_S_alpha_prefix_on_card__c='Yes';
        custId.Print_custom_face_message_s_on_front__c='No';
        custId.Print_Carve_Out_Rx_Vendor_Logo__c='No';
        custId.Combine_Health_Dental_Cards__c='N/A';
        custId.Select_one_option_for_phone_numbers_on_t__c='Include standard phone numbers?';
        custId.Select_one_option_for_the_Back_Text_Mess__c='Include standard back messages?';
        custId.Issuance_Type__c = 'Full Issuance';
        custId.Assignment_Type__c = 'Benefit Agreement';
        insert custId;
        
        GEMS_Custom_ID_Request_Form__c reqForm =[select id,Custom_ID_Request_Form_Case__c from GEMS_Custom_ID_Request_Form__c where Custom_ID_Request_Form_Case__c =:idCase.id ];
        System.assertEquals(idCase.id,reqForm .Custom_ID_Request_Form_Case__c ); 
        
        GEMS_Group_Section__c  Groupsec=GEMS_UtilityClassTest.insertionGroup(acc.Id,subCaseRec.Id);        
        insert Groupsec;
        
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(acc.Id,subCaseRec.Id,product2RecQuery.Id);        
        insert benefit;
        System.assertEquals('1234',benefit.Name);
        
        GEMS_BA_Assignment__c assign =GEMS_UtilityClassTest.insertionBaAssign(acc.Id,subCaseRec.Id,benefit.Id,Groupsec.Id);        
        insert assign ;
        System.assertEquals('ABS',assign.Name);  
        
        ApexPages.currentpage().getParameters().put('id',custId.id);

        ApexPages.StandardController std = new ApexPages.standardController(idCase);
        GEMS_Custom_IDRequestFormController sbcSec = new GEMS_Custom_IDRequestFormController (std);
        sbcSec.baCaseNums = benefit.Id+',';
        sbcSec.gsCaseNums = groupsec.id+',';
        PageReference pageRef = Page.GEMSCustomIDBAAssignment;
        Test.setCurrentPage(pageRef);
        sbcSec.saveAndAssignBAs();
        sbcSec.gotoCase();
        sbcSec.getClientlogoItems();
        sbcSec.getCompanyNameItems();
        sbcSec.getCompanyPlanNameItems();
        sbcSec.getAlternativeNetworkItems();
        sbcSec.getCustomCardCarrierItems();
        sbcSec.getFamilyOrSingleCoverageItems();
        sbcSec.getCustomStandardAlphaPrefixItems();
        sbcSec.getCustomFaceMesssageItems();
        sbcSec.getCarvedOutRxVendorLogoItems();
        sbcSec.getCombineHealthAndMedicalCardsItems();
        sbcSec.getIncludeCustomWebAddressOnBackItems();
        sbcSec.getIncludeClientWebAddressItems();
        sbcSec.getSelectOneOptionForPhoneNumbersItems();
        sbcSec.getSelectOneOptionForBackTextItems();
        sbcSec.submitIdCard();
        sbcSec.dummy();
        sbcSec.saveResult='ABS';
        test.stopTest();
    }
    private static testmethod void GEMS_Custom_IDRequestFormController_TEST3()
    {
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        
        Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        insert product2Rec;
        
        Product2 product2RecQuery=[SELECT Id, Name, isActive from Product2 where Name='BCS Stop Loss'];
        System.assertEquals('BCS Stop Loss',product2RecQuery.Name);
        
        Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'In Progress';
        subCaseRec.accountId = acc.Id;
        insert subCaseRec;
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'praveen.bokka@capgemini.com');
        insert testuser;
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        
        Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        subStrRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        substrRec.Status = 'Design In Progress';
        subStrRec.accountId = acc.Id;
        insert subStrRec;
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
        where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];

        test.startTest();
        Case idCase= GEMS_UtilityClassTest.insertionCase1('GEMS ID Card');
        idCase.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        insert idCase;
        
        GEMS_Custom_ID_Request_Form__c custId = New GEMS_Custom_ID_Request_Form__c();
        custId.Custom_ID_Request_Form_Case__c = idCase.id;
        custId.Status__c='In Progress'; 
        custId.Print_Client_Logo__c='No';
        custId.Print_Company_Name__c='No';
        custId.Print_Company_Plan_Name__c='No';
        custId.Alternative_Network__c='No';
        custId.Include_a_custom_card_carrier__c='No';
        custId.Print_FAMILY_SINGLE_Coverage_on_card__c='Yes(standard)';
        custId.Print_C_S_alpha_prefix_on_card__c='Yes';
        custId.Print_custom_face_message_s_on_front__c='No';
        custId.Print_Carve_Out_Rx_Vendor_Logo__c='No';
        custId.Combine_Health_Dental_Cards__c='N/A';
        custId.Select_one_option_for_phone_numbers_on_t__c='Include standard phone numbers?';
        custId.Select_one_option_for_the_Back_Text_Mess__c='Include standard back messages?';
        custId.Issuance_Type__c = 'Full Issuance';
        custId.Assignment_Type__c = 'Benefit Agreement';
        insert custId;
        
        GEMS_Group_Section__c  Groupsec=GEMS_UtilityClassTest.insertionGroup(acc.Id,subCaseRec.Id);        
        insert Groupsec;
        
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(acc.Id,subCaseRec.Id,product2RecQuery.Id);        
        insert benefit;
        System.assertEquals('1234',benefit.Name);
        
        GEMS_BA_Assignment__c assign =GEMS_UtilityClassTest.insertionBaAssign(acc.Id,subCaseRec.Id,benefit.Id,Groupsec.Id);        
        insert assign ;
        System.assertEquals('ABS',assign.Name);  

        ApexPages.currentpage().getParameters().put('caseId',idCase.id);
        ApexPages.StandardController std2 = new ApexPages.standardController(idCase);
        GEMS_Custom_IDRequestFormController sbcSec = new GEMS_Custom_IDRequestFormController (std2);
        sbcSec.baCaseNums = benefit.Id+',';
        sbcSec.gsCaseNums = Groupsec.id+',';
        sbcSec.customIdCard.Issuance_Type__c = 'Full Issuance';
        PageReference pageRef = Page.GEMSCustomIDBAAssignment;
        Test.setCurrentPage(pageRef);
        sbcSec.saveAndAssignBAs();
        sbcSec.gotoCase();
        sbcSec.getClientlogoItems();
        sbcSec.getCompanyNameItems();
        sbcSec.getCompanyPlanNameItems();
        sbcSec.getAlternativeNetworkItems();
        sbcSec.getCustomCardCarrierItems();
        sbcSec.getFamilyOrSingleCoverageItems();
        sbcSec.getCustomStandardAlphaPrefixItems();
        sbcSec.getCustomFaceMesssageItems();
        sbcSec.getCarvedOutRxVendorLogoItems();
        sbcSec.getCombineHealthAndMedicalCardsItems();
        sbcSec.getIncludeCustomWebAddressOnBackItems();
        sbcSec.getIncludeClientWebAddressItems();
        sbcSec.getSelectOneOptionForPhoneNumbersItems();
        sbcSec.getSelectOneOptionForBackTextItems();
        sbcSec.submitIdCard();
        sbcSec.dummy();
        sbcSec.saveResult='ABS';
        test.stopTest();
    }
    
	private static testmethod void GEMS_Custom_IDRequestFormController_TEST4()    {
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        Account accRec=[SELECT ID, Name from Account where Name='BenefitAgreementControllerTest'];
        System.assertEquals('BenefitAgreementControllerTest',accRec.Name);
        
        Product2 product2Rec=GEMS_UtilityClassTest.insertionProduct();
        insert product2Rec;
        
        Product2 product2RecQuery=[SELECT Id, Name, isActive from Product2 where Name='BCS Stop Loss'];
        System.assertEquals('BCS Stop Loss',product2RecQuery.Name);
        
        Case subCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subCaseRec.status = 'In Progress';
        subCaseRec.accountId = acc.Id;
        insert subCaseRec;
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUser = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'praveen.bokka@capgemini.com');
        insert testuser;
        
        CaseTeamMember caseTeamAccSpecMem = GEMS_UtilityClassTest.insertionCaseTeam(subCaseRec.Id,'Account Specialist');
        insert caseTeamAccSpecMem;
        
        Case subStrRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Structure');
        subStrRec.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        substrRec.Status = 'Design In Progress';
        subStrRec.accountId = acc.Id;
        insert subStrRec;
        
        Id accStrRecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case strCaseRec=[SELECT Id, GEMS_Account_Submission_Info__c, Opportunity_Name__c, GEMS_Temp_Scope_Code__c, Group_Number_s__c, RecordTypeId from Case 
        where RecordTypeId=:accStrRecordTypeId and GEMS_Account_Submission_Info__c =: subCaseRec.Id ];

        test.startTest();
        Case idCase= GEMS_UtilityClassTest.insertionCaseMaintenance('GEMS ID Card');
        idCase.GEMS_Account_Submission_Info__c  = subCaseRec.Id;
        insert idCase;
        
        GEMS_Custom_ID_Request_Form__c custId = New GEMS_Custom_ID_Request_Form__c();
        custId.Custom_ID_Request_Form_Case__c = idCase.id;
        custId.Status__c='In Progress'; 
        custId.Print_Client_Logo__c='No';
        custId.Print_Company_Name__c='No';
        custId.Print_Company_Plan_Name__c='No';
        custId.Alternative_Network__c='No';
        custId.Include_a_custom_card_carrier__c='No';
        custId.Print_FAMILY_SINGLE_Coverage_on_card__c='Yes(standard)';
        custId.Print_C_S_alpha_prefix_on_card__c='Yes';
        custId.Print_custom_face_message_s_on_front__c='No';
        custId.Print_Carve_Out_Rx_Vendor_Logo__c='No';
        custId.Combine_Health_Dental_Cards__c='N/A';
        custId.Select_one_option_for_phone_numbers_on_t__c='Include standard phone numbers?';
        custId.Select_one_option_for_the_Back_Text_Mess__c='Include standard back messages?';
        custId.Issuance_Type__c = 'Full Issuance';
        custId.Assignment_Type__c = 'Benefit Agreement';
        insert custId;
        
        GEMS_Group_Section__c  Groupsec=GEMS_UtilityClassTest.insertionGroup(acc.Id,subCaseRec.Id);        
        insert Groupsec;
        
        GEMS_Benefit_Agreement__c benefit=GEMS_UtilityClassTest.insertionBenefit(acc.Id,subCaseRec.Id,product2RecQuery.Id);        
        insert benefit;
        System.assertEquals('1234',benefit.Name);
        
        GEMS_BA_Assignment__c assign =GEMS_UtilityClassTest.insertionBaAssign(acc.Id,subCaseRec.Id,benefit.Id,Groupsec.Id);        
        insert assign ;
        System.assertEquals('ABS',assign.Name);  

        ApexPages.currentpage().getParameters().put('caseId',idCase.id);
        ApexPages.StandardController std2 = new ApexPages.standardController(idCase);
        GEMS_Custom_IDRequestFormController sbcSec = new GEMS_Custom_IDRequestFormController (std2);
        sbcSec.baCaseNums = benefit.Id+',';
        sbcSec.gsCaseNums = Groupsec.id+',';
        sbcSec.customIdCard.Issuance_Type__c = 'Full Issuance';
        PageReference pageRef = Page.GEMSCustomIDBAAssignment;
        Test.setCurrentPage(pageRef);
        sbcSec.saveAndAssignBAs();
        sbcSec.gotoCase();
        sbcSec.getClientlogoItems();
        sbcSec.getCompanyNameItems();
        sbcSec.getCompanyPlanNameItems();
        sbcSec.getAlternativeNetworkItems();
        sbcSec.getCustomCardCarrierItems();
        sbcSec.getFamilyOrSingleCoverageItems();
        sbcSec.getCustomStandardAlphaPrefixItems();
        sbcSec.getCustomFaceMesssageItems();
        sbcSec.getCarvedOutRxVendorLogoItems();
        sbcSec.getCombineHealthAndMedicalCardsItems();
        sbcSec.getIncludeCustomWebAddressOnBackItems();
        sbcSec.getIncludeClientWebAddressItems();
        sbcSec.getSelectOneOptionForPhoneNumbersItems();
        sbcSec.getSelectOneOptionForBackTextItems();
        sbcSec.submitIdCard();
        sbcSec.dummy();
        sbcSec.saveResult='ABS';
        test.stopTest();
    }
    
}