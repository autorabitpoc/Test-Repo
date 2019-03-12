/**************************************************************************************
Apex Class Name     : GEMS_AccountStrCreateServiceHelper_TEST
Version             : 1.0
Function            : This class is serves as Unit Test Class for GEMS_AccountStructureCreateServiceHelper 
Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------------                 
*   Siva Thimmannagari                   07/21/2016                Original Version
*************************************************************************************/ 
@isTest
private class GEMS_AccountStrCreateServiceHelper_TEST{  
    
    static public List<Case> accSubCase;
    static public Account accRec;
    static public product2 prd;
    static public case cs2;
    static public List<case> accStructureCase;
    static public GEMS_AccountStructureCreateServiceInput input = new GEMS_AccountStructureCreateServiceInput();
    @testSetup
    static void dataSetup() {
        
        Profile profileRec = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        List<User> userList = new List<User>();
        User testUser1 = GEMS_UtilityClassTest.CreateUserRecord(profileRec.Id, 'test1@user11.com', 'testUser1', 'test1@user.com');
        userList.add(testUser1);
        insert userList;
        
        accRec = new Account();
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec.RecordTypeId = recTypeId;
        accRec.Name = 'TestAccountForCaseTriggerHandler';
        accRec.Group_Number__c= 'B06093';
        accRec.external_id__c= 'B06093';
        accRec.BillingStreet ='Testing';
        accRec.BillingCity='TX';
        accRec.BillingState='CT';
        accRec.BillingPostalCode='534323';
        accRec.status__c = 'Active';
        
        Account accRec1 = new Account();
        accRec1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec1.Name = 'TestAccountForCaseTriggerHandler1';
        accRec1.Group_Number__c= 'B060931';
        accRec1.external_id__c= 'B0609';
        accRec1.BillingStreet ='Testing';
        accRec1.BillingCity='TX';
        accRec1.BillingState='CT';
        accRec1.BillingPostalCode='534323';
        accRec1.status__c = 'Active';
        
        List<Account> acclist = new List<Account>();
        acclist.add(accRec);
        acclist.add(accRec1);
        insert acclist;
        
        List<Account> accRecQuery=[SELECT ID, name FROM Account WHERE recordtypeid=:recTypeId ];
        System.assertEquals('TestAccountForCaseTriggerHandler',accRecQuery[0].Name);
        
        List<String> accountTeamRoleList = new  List<String>();
        
        accountTeamRoleList.add('Account Specialist');
        List<AccountTeamMember> accTeamMemberList = new List<AccountTeamMember> ();
        AccountTeamMember accTeamMemberAccSpecialist = new AccountTeamMember ();
        accTeamMemberAccSpecialist.UserId =userList[0].id;
        accTeamMemberAccSpecialist.TeamMemberRole = accountTeamRoleList[0];
        accTeamMemberAccSpecialist.AccountId =acclist[0].id;
        accTeamMemberList.add(accTeamMemberAccSpecialist);
        
        AccountTeamMember accTeamMemberAccSpecialist1 = new AccountTeamMember ();
        accTeamMemberAccSpecialist1.UserId =userList[0].id;
        accTeamMemberAccSpecialist1.TeamMemberRole = accountTeamRoleList[0];
        accTeamMemberAccSpecialist1.AccountId =acclist[1].id;
        accTeamMemberList.add(accTeamMemberAccSpecialist1);
        insert accTeamMemberList;
        
        List<Opportunity> optyList = new List<Opportunity>();
        Opportunity oppRec = new Opportunity();
        oppRec.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        oppRec.Name='CaseTriggerHandler';
        oppRec.accountId=acclist[0].Id;
        oppRec.Type='Other';
        oppRec.StageName=GEMS_UtilityClassTest.opportunityStatus();
        oppRec.Date_Closed__c = system.today();
        oppRec.Exchange_Offering_Type__c='No Private Exchange';
        oppRec.CloseDate=Date.Today().addDays(8);
        oppRec.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        oppRec.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        oppRec.Requested_Effective_Date__c=Date.Today().addDays(8);
        oppRec.Expected_Health_Members__c=2;
        oppRec.Account_Market_Segment__c='LG';
        oppRec.HCSC_Division__c='IL';
        oppRec.Region__c='N/A - IL';
        oppRec.District__c='290';
        oppRec.Clusters__c='020';
        oppRec.Primary_Closed_Reason__c='Other';
        
        optyList.add(oppRec);
        insert optyList;
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        List<case> caseList = new List<case>();
        case cs = new case();
        cs.accountid = accRecQuery[0].Id;
        cs.Opportunity_Name__c= oppRec.id;
        cs.recordtypeid = caseAccountSubmissionId;
        cs.status = 'New';
        
        case cs1 = new case();
        cs1.accountid = accRecQuery[1].Id;
        cs1.Opportunity_Name__c= oppRec.id;
        cs1.recordtypeid = caseAccountSubmissionId;
        cs1.status = 'New';
        
        caseList.add(cs);
        caseList.add(cs1);
        insert caseList;
        
        accSubCase = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        System.assertEquals('GEMS Account Submission',accSubCase[0].RecordType.Name); 
        System.assertEquals('GEMS Account Submission',accSubCase[1].RecordType.Name); 
        integer i=0;
        for(case accSubCase1:accSubCase ){
            accSubCase1.Status ='In Progress';
            accSubCase1.GEMS_Create_Account_Structure__c =true;
            accSubCase1.GEMS_Submission_Type__c = 'Renewal';
            accSubCase1.GEMS_Submission_Sub_Type__c = 'Account Structure Change';
            accSubCase1.GEMS_Products__c ='Dental;PPO;RX';
            accSubCase1.Funding_Type_Multiselect__c = 'ASO'; 
            accSubCase1.GEMS_Line_of_Business__c='ENA';
            accSubCase1.GEMS_Effective_Date__c = system.today();
            accSubCase1.GEMS_Case_Effective_Date__c= system.today();
            accSubCase1.GEMS_SBC_Required__c = 'Yes';
        }
        accSubCase[0].GEMS_Submission_Type__c = 'New Account';
        update accSubCase;
        
        Id caseAccountStrId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Case accStrCase = new Case();
        accStrCase.AccountId = accRec1.id;
        accStrCase.GEMS_Submission_Type__c = 'Renewal';
        accStrCase.GEMS_Submission_Sub_Type__c = 'Account Structure Change';
        accStrCase.GEMS_Account_Submission_Info__c = accSubCase[0].id;
        accStrCase.RecordTypeId = caseAccountStrId;
        accStrCase.Additional_Comments__c='test1';
        accStrCase.Status = 'Design In Progress';
        insert accStrCase;
        
        GEMS_Account_Structure_Response__c resp = new GEMS_Account_Structure_Response__c();
        resp.AccStructCaseId__c = accStrCase.Id;
        resp.Transaction_Id__c = String.valueOf(accStrCase.Id).right(5)+String.valueOf(System.now()).replaceAll('-','');
        insert resp;
        
        Product2 prod1 = new Product2();
        prod1.ProductCode='PPO';
        prod1.External_ID__c = 'P1234';
        prod1.Product_Category__c='Private Exchange';
        prod1.Name='Product1';
        prod1.IsActive = true;
        prod1.HCSC_State__c = 'IL';
        insert prod1;
        
            
        Plan__c p = new Plan__c();
        p.External_Id__c = 'P1234';
        p.Plan_Type__c = 'PDent';
        p.Product__c = prod1.Id;
        p.name='New Plan';
        insert p;
        
        String call1Str='{"status" : "S", "requestCode" : "T0000000080-Call1", "message" : "ACCOUNT STRUCTURE DATA RETRIEVED Part 1 SUCCESSFULLY", "groupSections" : null, "groupNumbers" : [ "001194", "001432", "001436" ], "characteristics" : [ { "reportingIndicator" : false, "productIndicator" : false, "otherIndicator" : true, "mandatoryGroupIndicator" : false, "mailIndicator" : false, "effectiveDate" : "2001-01-01", "characteristicValues" : [ { "valueCode" : "A", "value" : "Active", "effectiveDate" : "2001-01-01" }, { "valueCode" : "C", "value" : "COBRA", "effectiveDate" : "2001-01-01" }, { "valueCode" : "R", "value" : "Retired", "effectiveDate" : "2001-01-01" } ], "characteristicDescription" : "Hire Date", "characteristicCode" : "HIREDT", "billingIndicator" : false } ], "categories" : null, "billingProfiles" : null, "benefitAggrements" : null, "addresses" : [ { "zipCode" : "38103", "street" : "123 S. Front St.", "state" : "TX", "isThirdPartyAddress" : true, "isSubsidaryAddress" : true, "isStlmAddress" : true, "isPrimaryAddress" : true ,"isMailingAddress" : true, "isInvoiceAddress" : true, "isBillingAddress" : true, "isBaeAddress" : true, "countyCode" : "", "countryCode" : "", "contactPhoneNumber" : "9014957223", "contactName" : "Teresa James", "contactEmailAddress" : "", "cityName" : "Memphis", "addressSequence" : "6", "addressName" : "AUTOZONE PARTS, INC" } ], "accountStructureCaseID" : "500c0000008TYiYAAW", "accountDetails" : { "marketSegment" : "NAC", "effectiveDate" : "2001-01-01", "corpCode" : "IL1", "cobraCode" : "GRP", "cobraAutoCancel" : false, "autoCategorizationIndicator" : false, "accountNumber" : "A12", "accountName" : "Test Acc" } }' ;             
        String call2Str='{"status" : "S", "requestCode" : "T0000000080-Call2", "message" : "ACCOUNT STRUCTURE DATA RETRIEVED Part 2 SUCCESSFULLY", "groupSections" : null, "groupNumbers" : null, "characteristics" : null, "categories" : [ { "reportingIndicator" : false, "productIndicator" : true, "productBANumbers" : ["0017"], "membersDerivationTypeCode" : null, "mailingAddressSequence" : null, "mailIndicator" : true, "effectiveDate" : "2001-01-01", "categoryNumber" : "0010", "categoryDescription" : "ALL SUBSCRIBERS", "categoryCobraCode" : "MC", "categoryCharacteristics" : [{"characteristicCode":"HIREDT","valueCodes":["A"]}], "billingIndicator" : true } ], "billingProfiles" : null, "benefitAggrements" : [ { "scheduleCode" : "", "prodTypeCode" : "PPO+", "prescriptionDrugType" : null, "idCardType" : "AA1", "effectiveDate" : "2006-01-01", "dentalProductType" : null, "corporateProdNumber" : "P1234", "copays" : null, "baNumber" : "0017", "baFundType" : "PREM", "baDescription" : "BLUE" } ], "addresses" : null, "accountStructureCaseID" : "500c0000008TYiYAAW", "accountDetails" : { "marketSegment" : "NAC", "effectiveDate" : "2001-01-01", "corpCode" : "IL1", "cobraCode" : "GRP", "cobraAutoCancel" : false, "autoCategorizationIndicator" : false, "accountNumber" : "001432", "accountName" : "AUTOZONE PARTS, INC." } }' ;   
        String call3Str='{"status" : "S", "requestCode" : "T0000000080-Call3", "message" : "ACCOUNT STRUCTURE DATA Part 3 RETRIEVED SUCCESSFULLY", "groupSections" : [ { "spiCodes" : "130A1", "sectionNumber" : "1000", "sectionDescription" : "AUTOZONE PARTS, INC.", "majorMedicalPlanCode" : "", "groupNumber" : "001482", "effectiveDate" : "2003-01-01", "drugPlanCode" : "621", "dentalPlanCode" : "", "blueShieldPlanCode" : "621", "blueCrossPlanCode" : "121", "assignedCategoryNumbers" : [ "0010", "0025" ], "assignedBANumbers" : [ "0017" ], "alphaPrefix" : "AZW" }, { "spiCodes" : "130A1", "sectionNumber" : "2000", "sectionDescription" : "AUTOZONE PARTS, INC.", "majorMedicalPlanCode" : "", "groupNumber" : "001482", "effectiveDate" : "2003-01-01", "drugPlanCode" : "621", "dentalPlanCode" : "", "blueShieldPlanCode" : "621", "blueCrossPlanCode" : "121", "assignedCategoryNumbers" : [ "0010", "0026" ], "assignedBANumbers" : [ "0017" ], "alphaPrefix" : "AZW" } ], "groupNumbers" : null, "characteristics" : null, "categories" : null, "billingProfiles" : [ { "effectiveDate" : "2012-02-01", "description" : "COST PROFILE", "categoryNumbers" : [ "10" ], "billingProfileNumber" : "0000477978", "billingAddressSequence" : "6083", "baNumbers" : [ "0017", "15", "16", "6", "18", "22", "23" ] }, { "effectiveDate" : "2010-02-01", "description" : "COST PROFILE", "categoryNumbers" : [ "0" ], "billingProfileNumber" : "0000477978", "billingAddressSequence" : "6083", "baNumbers" : [ "6", "15", "16", "0017", "18", "22" ] } ], "benefitAggrements" : null, "addresses" : null, "accountStructureCaseID" : "500c0000008TYiYAAW", "accountDetails" : { "marketSegment" : "NAC", "effectiveDate" : "2001-01-01", "corpCode" : "IL1", "cobraCode" : "GRP", "cobraAutoCancel" : false, "autoCategorizationIndicator" : false, "accountNumber" : "001432", "accountName" : "AUTOZONE PARTS, INC." } }';

        GEMS_AccountStructureCreateService.addAttachmentToResponseRec(call1Str,resp.id,'Call1');
        GEMS_AccountStructureCreateService.addAttachmentToResponseRec(call2Str,resp.id,'Call2');
        GEMS_AccountStructureCreateService.addAttachmentToResponseRec(call3Str,resp.id,'Call3');
        
        GEMS_Corp_Characteristic_Code__c corpCharCode = new GEMS_Corp_Characteristic_Code__c();
        corpCharCode.CORP_Characteristic_Code__c = 'HIREDT';
        insert corpCharCode;
            
        GEMS_Characteristic__c chare = new GEMS_Characteristic__c();
        chare.Account__c = accRec1.Id;
        chare.Corp_Characteristic_Code__c = corpCharCode.id;
        insert chare;
            
        GEMS_Characteristic_Value__c charVal = new GEMS_Characteristic_Value__c();
        charVal.Characteristic__c = chare.Id;
        charVal.Code__c = 'A';
        insert charVal;
    } 

   private static testmethod void testCreateServiceForCall1() 
    {
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure'];
        string result;
        try{
            Test.startTest();
            //GEMS_AccountStructureCreateServiceInput input = new GEMS_AccountStructureCreateServiceInput();
            input.status = 'S';
            input.accountStructureCaseID = accStructureCase[0].id;//'500560000036y9l';
            
            GEMS_AccountStructureCreateServiceInput.AccountDetails accountDetails = new GEMS_AccountStructureCreateServiceInput.AccountDetails();
            list<GEMS_AccountStructureCreateServiceInput.Address> addresses = new list<GEMS_AccountStructureCreateServiceInput.Address>();
            list<GEMS_AccountStructureCreateServiceInput.BenefitAggrement> benefitAddrements = new list<GEMS_AccountStructureCreateServiceInput.BenefitAggrement>();
            list<GEMS_AccountStructureCreateServiceInput.Characteristic> characteristics = new list<GEMS_AccountStructureCreateServiceInput.Characteristic>();
            list<GEMS_AccountStructureCreateServiceInput.Category> categories = new list<GEMS_AccountStructureCreateServiceInput.Category>();
            list<GEMS_AccountStructureCreateServiceInput.BillingProfile> billingProfiles = new list<GEMS_AccountStructureCreateServiceInput.BillingProfile>();
            list<GEMS_AccountStructureCreateServiceInput.GroupSection> groupSections = new list<GEMS_AccountStructureCreateServiceInput.GroupSection>();
            GEMS_Account_Structure_Response__c resp =[Select Id, Transaction_Id__c from GEMS_Account_Structure_Response__c LIMIT 1];
            input.requestCode = resp.Transaction_Id__c + '-' + 'Call1';
            accountDetails.accountName = 'Test';
            accountDetails.accountNumber = '1234';
            accountDetails.effectiveDate = Date.today();   
            accountDetails.marketSegment = 'LG';    
            accountDetails.corpCode = 'IL1';
            accountDetails.cobraAutoCancel = true;
            accountDetails.cobraCode = 'GRP';    
            accountDetails.autoCategorizationIndicator = true;
            input.AccountDetails = accountDetails;
            
            GEMS_AccountStructureCreateServiceInput.Address addr1 = new GEMS_AccountStructureCreateServiceInput.Address();
            addr1.addressName = 'Primary';
            addr1.addressSequence = '1234';
            addr1.cityName = 'Richardson';
            addr1.contactEmailAddress = 'test@test.com';
            addr1.contactName = 'Test';
            addr1.contactPhoneNumber = '1231231234';
            addr1.countryCode = 'US';
            addr1.countyCode = '123';
            addr1.isBaeAddress = false;
            addr1.isBillingAddress = false;
            addr1.isInvoiceAddress = false;
            addr1.isMailingAddress = false;
            addr1.isPrimaryAddress = true;
            addr1.isStlmAddress = false;
            addr1.isSubsidaryAddress = false;
            addr1.isThirdPartyAddress = false;
            addr1.state = 'Alabama';
            addr1.street = 'Primary Street';
            addr1.zipCode = '12345';
            
            addresses.add(addr1);
            input.addresses = addresses;
            
            GEMS_AccountStructureCreateServiceInput.Category cat1 = new GEMS_AccountStructureCreateServiceInput.Category();
            cat1.billingIndicator = true;
            
            list<GEMS_AccountStructureCreateServiceInput.CategoryCharacteristic> catCharacteristics1 = new list<GEMS_AccountStructureCreateServiceInput.CategoryCharacteristic>();
            GEMS_AccountStructureCreateServiceInput.CategoryCharacteristic catCharacteristic1 = new GEMS_AccountStructureCreateServiceInput.CategoryCharacteristic();
            catCharacteristic1.characteristicCode = 'SPXRSK';
            list<string> s1 = new list<string>();
            s1.add('XYZ1');
            //s1.add('XYZ2');
            catCharacteristic1.valueCodes = s1;
            
            catCharacteristics1.add(catCharacteristic1);
            cat1.categoryCharacteristics = catCharacteristics1;
            
            cat1.categoryCobraCode = 'NC';
            cat1.categoryDescription = 'Category1';
            cat1.categoryNumber = '0010';
            cat1.effectiveDate = Date.today();
            cat1.mailIndicator = false;
            cat1.mailingAddressSequence = '';
            cat1.membersDerivationTypeCode = 'CT';
            list<string> baNumbers1 = new list<string>();
            baNumbers1.add('0017');
            cat1.productBANumbers = baNumbers1;
            cat1.productIndicator = true;
            cat1.reportingIndicator = false;
            
            categories.add(cat1);
            input.categories = categories;
            
            GEMS_AccountStructureCreateServiceInput.Characteristic characteristic1 = new GEMS_AccountStructureCreateServiceInput.Characteristic();
            characteristic1.billingIndicator = true ;
            characteristic1.characteristicCode = 'SPXRSK';
            characteristic1.characteristicDescription = 'SPXRSK DESC1';
            
            list<GEMS_AccountStructureCreateServiceInput.CharacteristicValue> characteristicValues1 = new list<GEMS_AccountStructureCreateServiceInput.CharacteristicValue>();
            GEMS_AccountStructureCreateServiceInput.CharacteristicValue characteristicValue1 = new GEMS_AccountStructureCreateServiceInput.CharacteristicValue();
            characteristicValue1.effectiveDate = Date.today();
            characteristicValue1.value = 'XYZ1 DESC';
            characteristicValue1.valueCode = 'XYZ1';
            characteristicValues1.add(characteristicValue1);            
            input.characteristics = characteristics;
            list<string> groupNumbers = new list<string>();
            groupNumbers.add('1234');
            groupNumbers.add('2345');
            groupNumbers.add('3456');
            groupNumbers.add('4567');
            input.groupNumbers = groupNumbers;
            GEMS_AccountStructureCreateServiceOutput output = GEMS_AccountStructureCreateService.createAccountStructure(input);
            system.debug('Final Status : ' + Output);
            input.status = 'S';
            Test.stopTest();            
        }
        catch(Exception ex)
        {
            result = ex.getLineNumber() + ' : ' + ex.getMessage();
        }
    }
    
    private static testmethod void testCreateServiceForCall2() 
    {
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure'];
        string result;
        try{
            Test.startTest();
            //GEMS_AccountStructureCreateServiceInput input = new GEMS_AccountStructureCreateServiceInput();
            input.status = 'S';
            input.accountStructureCaseID = accStructureCase[0].id;//'500560000036y9l';
            
            GEMS_AccountStructureCreateServiceInput.AccountDetails accountDetails = new GEMS_AccountStructureCreateServiceInput.AccountDetails();
            list<GEMS_AccountStructureCreateServiceInput.Address> addresses = new list<GEMS_AccountStructureCreateServiceInput.Address>();
            list<GEMS_AccountStructureCreateServiceInput.BenefitAggrement> benefitAddrements = new list<GEMS_AccountStructureCreateServiceInput.BenefitAggrement>();
            list<GEMS_AccountStructureCreateServiceInput.Characteristic> characteristics = new list<GEMS_AccountStructureCreateServiceInput.Characteristic>();
            list<GEMS_AccountStructureCreateServiceInput.Category> categories = new list<GEMS_AccountStructureCreateServiceInput.Category>();
            list<GEMS_AccountStructureCreateServiceInput.BillingProfile> billingProfiles = new list<GEMS_AccountStructureCreateServiceInput.BillingProfile>();
            list<GEMS_AccountStructureCreateServiceInput.GroupSection> groupSections = new list<GEMS_AccountStructureCreateServiceInput.GroupSection>();
            GEMS_Account_Structure_Response__c resp = [Select Id, Transaction_Id__c from GEMS_Account_Structure_Response__c LIMIT 1];
            input.requestCode = resp.Transaction_Id__c + '-' + 'Call2';
            accountDetails.accountName = 'Test';
            accountDetails.accountNumber = '1234';
            accountDetails.effectiveDate = Date.today();   
            accountDetails.marketSegment = 'LG';    
            accountDetails.corpCode = 'IL1';
            accountDetails.cobraAutoCancel = true;
            accountDetails.cobraCode = 'GRP';    
            accountDetails.autoCategorizationIndicator = true;
            input.AccountDetails = accountDetails;
            
            
            GEMS_AccountStructureCreateServiceInput.BenefitAggrement ba1 = new GEMS_AccountStructureCreateServiceInput.BenefitAggrement();
            ba1.baDescription = 'BA1';
            ba1.baFundType = 'ASO';
            ba1.baNumber = '0017';
            ba1.corporateProdNumber = '9718';
            ba1.effectiveDate = Date.today();
            ba1.idCardType = 'XYZ';
            ba1.prodTypeCode = 'PPO';
            ba1.scheduleCode = 'ABX';
            
            
            input.benefitAggrements = benefitAddrements;
            
            GEMS_AccountStructureCreateServiceInput.Category cat1 = new GEMS_AccountStructureCreateServiceInput.Category();
            cat1.billingIndicator = true;
            
            cat1.categoryCobraCode = 'NC';
            cat1.categoryDescription = 'Category1';
            cat1.categoryNumber = '0010';
            cat1.effectiveDate = Date.today();
            cat1.mailIndicator = false;
            cat1.mailingAddressSequence = '';
            cat1.membersDerivationTypeCode = 'CT';
            list<string> baNumbers1 = new list<string>();
            baNumbers1.add('0017');
            cat1.productBANumbers = baNumbers1;
            cat1.productIndicator = true;
            cat1.reportingIndicator = false;
            categories.add(cat1);
            input.categories = categories;
            
            
            GEMS_AccountStructureCreateServiceOutput output = GEMS_AccountStructureCreateService.createAccountStructure(input);
            system.debug('Final Status : ' + Output);
            input.status = 'S';
            GEMS_AccountStructureCreateServiceOutput output1 = GEMS_AccountStructureCreateService.createAccountStructure(input);
            Test.stopTest();   
        }
        catch(Exception ex)
        {
            result = ex.getLineNumber() + ' : ' + ex.getMessage();
        }
    }
    
    private static testmethod void testCreateServiceForCall3() 
    {
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure'];
        string result;
        try{
            Test.startTest();
            input.status = 'S';
            input.accountStructureCaseID = accStructureCase[0].id;
            
            GEMS_AccountStructureCreateServiceInput.AccountDetails accountDetails = new GEMS_AccountStructureCreateServiceInput.AccountDetails();
            list<GEMS_AccountStructureCreateServiceInput.Address> addresses = new list<GEMS_AccountStructureCreateServiceInput.Address>();
            list<GEMS_AccountStructureCreateServiceInput.BenefitAggrement> benefitAddrements = new list<GEMS_AccountStructureCreateServiceInput.BenefitAggrement>();
            list<GEMS_AccountStructureCreateServiceInput.Characteristic> characteristics = new list<GEMS_AccountStructureCreateServiceInput.Characteristic>();
            list<GEMS_AccountStructureCreateServiceInput.Category> categories = new list<GEMS_AccountStructureCreateServiceInput.Category>();
            list<GEMS_AccountStructureCreateServiceInput.BillingProfile> billingProfiles = new list<GEMS_AccountStructureCreateServiceInput.BillingProfile>();
            list<GEMS_AccountStructureCreateServiceInput.GroupSection> groupSections = new list<GEMS_AccountStructureCreateServiceInput.GroupSection>();
            GEMS_Account_Structure_Response__c resp =[Select Id, Transaction_Id__c from GEMS_Account_Structure_Response__c LIMIT 1];
            input.requestCode = resp.Transaction_Id__c + '-' + 'Call3';
            accountDetails.accountName = 'Test';
            accountDetails.accountNumber = '1234';
            accountDetails.effectiveDate = Date.today();   
            accountDetails.marketSegment = 'LG';    
            accountDetails.corpCode = 'IL1';
            accountDetails.cobraAutoCancel = true;
            accountDetails.cobraCode = 'GRP';    
            accountDetails.autoCategorizationIndicator = true;
            input.AccountDetails = accountDetails;
            
            GEMS_AccountStructureCreateServiceInput.Address addr1 = new GEMS_AccountStructureCreateServiceInput.Address();
            addr1.addressName = 'Primary';
            addr1.addressSequence = '1234';
            addr1.cityName = 'Richardson';
            addr1.contactEmailAddress = 'test@test.com';
            addr1.contactName = 'Test';
            addr1.contactPhoneNumber = '1231231234';
            addr1.countryCode = 'US';
            addr1.countyCode = '123';
            addr1.isBaeAddress = false;
            addr1.isBillingAddress = false;
            addr1.isInvoiceAddress = false;
            addr1.isMailingAddress = false;
            addr1.isPrimaryAddress = true;
            addr1.isStlmAddress = false;
            addr1.isSubsidaryAddress = false;
            addr1.isThirdPartyAddress = false;
            addr1.state = 'Alabama';
            addr1.street = 'Primary Street';
            addr1.zipCode = '12345';
            
            
            addresses.add(addr1);
            input.addresses = addresses;
            
            GEMS_AccountStructureCreateServiceInput.BenefitAggrement ba1 = new GEMS_AccountStructureCreateServiceInput.BenefitAggrement();
            ba1.baDescription = 'BA1';
            ba1.baFundType = 'ASO';
            ba1.baNumber = '0017';
            ba1.corporateProdNumber = '9718';
            ba1.effectiveDate = Date.today();
            ba1.idCardType = 'XYZ';
            ba1.prodTypeCode = 'PPO';
            ba1.scheduleCode = 'ABX';
            
            
            benefitAddrements.add(ba1);
            input.benefitAggrements = benefitAddrements;
            
            GEMS_AccountStructureCreateServiceInput.Category cat1 = new GEMS_AccountStructureCreateServiceInput.Category();
            cat1.billingIndicator = true;
            
            list<GEMS_AccountStructureCreateServiceInput.CategoryCharacteristic> catCharacteristics1 = new list<GEMS_AccountStructureCreateServiceInput.CategoryCharacteristic>();
            GEMS_AccountStructureCreateServiceInput.CategoryCharacteristic catCharacteristic1 = new GEMS_AccountStructureCreateServiceInput.CategoryCharacteristic();
            catCharacteristic1.characteristicCode = 'SPXRSK';
            list<string> s1 = new list<string>();
            s1.add('XYZ1');
            //s1.add('XYZ2');
            catCharacteristic1.valueCodes = s1;
            
            catCharacteristics1.add(catCharacteristic1);
            cat1.categoryCharacteristics = catCharacteristics1;
            
            cat1.categoryCobraCode = 'NC';
            cat1.categoryDescription = 'Category1';
            cat1.categoryNumber = '0010';
            cat1.effectiveDate = Date.today();
            cat1.mailIndicator = false;
            cat1.mailingAddressSequence = '';
            cat1.membersDerivationTypeCode = 'CT';
            list<string> baNumbers1 = new list<string>();
            baNumbers1.add('0017');
            cat1.productBANumbers = baNumbers1;
            cat1.productIndicator = true;
            cat1.reportingIndicator = false;
            
            categories.add(cat1);
            input.categories = categories;
            
            
            GEMS_AccountStructureCreateServiceInput.BillingProfile billingProfile1 = new GEMS_AccountStructureCreateServiceInput.BillingProfile();
            list<string> babp1 = new list<string>();
            babp1.add('0017');
            billingProfile1.baNumbers = babp1;
            billingProfile1.billingAddressSequence = '2345';
            billingProfile1.billingProfileNumber = '1234';
            list<string> catbp1 = new list<string>();
            catbp1.add('0010');
            billingProfile1.categoryNumbers =  catbp1;
            billingProfile1.description = 'Billing Profile1';
            billingProfile1.effectiveDate = Date.today();
            
            billingProfiles.add(billingProfile1);
            input.billingProfiles = billingProfiles;
            
            GEMS_AccountStructureCreateServiceInput.GroupSection groupsection1 = new GEMS_AccountStructureCreateServiceInput.GroupSection();
            groupsection1.groupNumber = '1234' ;
            list<string> babrp1 = new list<string>();
            babrp1.add('0017');
            groupsection1.assignedBANumbers = babrp1;
            list<string> catbrp1 = new list<string>();
            catbrp1.add('0010');
            groupsection1.assignedCategoryNumbers = catbrp1;
            groupsection1.sectionNumber =  '1000';
            groupsection1.sectionDescription = 'BA1Category1';
            groupsection1.alphaPrefix = 'AL1' ;
            groupsection1.effectiveDate = Date.today(); 
            groupsection1.spiCodes = 'SPI1';
            groupsection1.blueCrossPlanCode = '123';
            groupsection1.blueShieldPlanCode =  '123';
            groupsection1.majorMedicalPlanCode = '123';
            groupsection1.drugPlanCode = '123';
            groupsection1.dentalPlanCode = '123';
            
            groupSections.add(groupsection1);
            input.groupSections = groupSections;
            
            list<string> groupNumbers = new list<string>();
            groupNumbers.add('1234');
            groupNumbers.add('2345');
            groupNumbers.add('3456');
            groupNumbers.add('4567');
            input.groupNumbers = groupNumbers;
            
            GEMS_AccountStructureCreateServiceOutput output = GEMS_AccountStructureCreateService.createAccountStructure(input);
            system.debug('Final Status : ' + Output);
            Test.stopTest();         
        }
        catch(Exception ex)
        {
            result = ex.getLineNumber() + ' : ' + ex.getMessage();
        }
    }
    
    private static testmethod void testCreateServiceForWithInvalidInput() 
    {
        Test.startTest();
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        List<Case> subCases = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId ];
        Case accSubCase1 = subCases[0];

            accSubCase1.Status ='In Progress';
            accSubCase1.GEMS_Create_Account_Structure__c =true;
            //accSubCase1.GEMS_Submission_Type__c = 'Renewal';
            accSubCase1.GEMS_Ready_to_release_to_screening__c='Released';
            //accSubCase1.GEMS_Submission_Sub_Type__c = 'Account Structure Change';
            accSubCase1.GEMS_Products__c ='Dental;PPO;RX';
            accSubCase1.Funding_Type_Multiselect__c = 'ASO'; 
            accSubCase1.GEMS_Line_of_Business__c='ENA';
            accSubCase1.GEMS_Effective_Date__c = system.today();
            accSubCase1.GEMS_Case_Effective_Date__c= system.today();
            accSubCase1.GEMS_SBC_Required__c = 'Yes';
        update accSubCase1;
        
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and Additional_Comments__c='test1'];
        System.assertNotEquals(0, accStructureCase.size());
        Case acStrCase = accStructureCase[0];
        acStrCase.GEMS_Account_Submission_Info__c = accSubCase1.Id;
        update acStrCase;
       // Test.stopTest();
        string result;
        try{                    
            List<GEMS_Account_Structure_Response__c> responses =[Select Id, Transaction_Id__c from GEMS_Account_Structure_Response__c];
            System.debug('responses::'+responses);
            GEMS_AccountStructureCreateServiceInput input = new GEMS_AccountStructureCreateServiceInput();
            input.status = 'S';
            input.accountStructureCaseID = acStrCase.id;
            input.requestCode = responses[0].Transaction_Id__c + '-' + 'Call3';
            
            GEMS_AccountStructureCreateServiceOutput output = GEMS_AccountStructureCreateService.createAccountStructure(input);
            system.debug('Final Status : ' + Output);         
        }

        catch(Exception ex)
        {
            result = ex.getLineNumber() + ' : ' + ex.getMessage();
        }
                Test.stopTest();
    }
    
    private static testmethod void testCreateServiceForErrorInputStatus() 
    {
        Test.startTest();
        Id caseAccountSubmissionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        List<Case> subCases = [SELECT Id, Subject, AccountId, RecordType.Name from Case where  recordtypeid = :caseAccountSubmissionId limit 1];
        Case accSubCase1 = subCases[0];
        //Test.startTest();
            accSubCase1.Status ='In Progress';
            accSubCase1.GEMS_Create_Account_Structure__c =true;
            accSubCase1.GEMS_Submission_Type__c = 'Renewal';
            accSubCase1.GEMS_Submission_Sub_Type__c = 'Account Structure Change';
            accSubCase1.GEMS_Products__c ='Dental;PPO;RX';
            accSubCase1.Funding_Type_Multiselect__c = 'ASO'; 
            accSubCase1.GEMS_Line_of_Business__c='ENA';
            accSubCase1.GEMS_Effective_Date__c = system.today();
            accSubCase1.GEMS_Case_Effective_Date__c= system.today();
            accSubCase1.GEMS_SBC_Required__c = 'Yes';
        update accSubCase1;
        
        accStructureCase =[select id,RecordType.Name from case where RecordType.Name ='GEMS Account Structure' and Additional_Comments__c='test1'];
        System.assertNotEquals(0, accStructureCase.size());
        Case acStrCase = accStructureCase[0];
        acStrCase.GEMS_Account_Submission_Info__c = accSubCase1.Id;
        update acStrCase;
       // Test.stopTest();
        string result;
        try{                    
            List<GEMS_Account_Structure_Response__c> responses =[Select Id, Transaction_Id__c from GEMS_Account_Structure_Response__c];
            System.debug('responses::'+responses);
            GEMS_AccountStructureCreateServiceInput input = new GEMS_AccountStructureCreateServiceInput();
            input.status = 'E';
            input.accountStructureCaseID = acStrCase.id;
            input.requestCode = responses[0].Transaction_Id__c + '-' + 'Call3';
            
            GEMS_AccountStructureCreateServiceOutput output = GEMS_AccountStructureCreateServiceHelper.consolidateAccountStructureDetails(input);
            system.debug('Final Status : ' + Output);         
        }
        catch(Exception ex)
        {
            result = ex.getLineNumber() + ' : ' + ex.getMessage();
        }
        Test.stopTest();
    }
    
    private static testmethod void testUpdateNumber() {
        Test.startTest();
        String s1 = '0';
        String s2 = '00';
        String s3 = '000';
        String r1=GEMS_AccountStructureCreateServiceHelper.updateNumber(s1);
        String r2=GEMS_AccountStructureCreateServiceHelper.updateNumber(s2);
        String r3=GEMS_AccountStructureCreateServiceHelper.updateNumber(s3);
        
        System.assertEquals(4,r1.length());
        System.assertEquals(4,r2.length());
        System.assertEquals(4,r3.length());
        Test.stopTest();    
    }
}