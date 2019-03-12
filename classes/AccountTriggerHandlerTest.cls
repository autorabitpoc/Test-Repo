@isTest
private class AccountTriggerHandlerTest {

    @isTest
    static void addAE2AndUnderwritertoAccountTeamTest() {

        Test.startTest();
        List<User> testUsers = new List<User>();
        Account testAccount = new Account( Name = 'Test Account' );
        Profile p = [SELECT Id FROM Profile WHERE Name = 'LGNA - Account Management'];
        testUsers.add(new User(Alias = 'standt1', Email = 'john.testing@testorg.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'John', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'john.testing@testorg.com', isActive = TRUE));
        testUSers.add(new User(Alias = 'standt2', Email = 'jane.testing@testorg.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'Jane', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'jane.testing@testorg.com', isActive = TRUE));       
        testUsers.add(new User(Alias = 'standt3', Email = 'jim.testing@testorg.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'Jim', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'jim.testing@testorg.com', isActive = TRUE, Lan_Id__c = 'UU456'));     
        testUsers.add(new User(Alias = 'standt4', Email = 'bob.testing@testorg.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'Bob', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'bob.testing@testorg.com', isActive = TRUE, Lan_Id__c = 'UU4567'));        
        testUsers.add(new User(Alias = 'standt5', Email = 'dan.testing@testorg.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'Dan', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'dan.testing@testorg.com', isActive = TRUE, Lan_Id__c = 'UU4568'));        
        testUsers.add(new User(Alias = 'standt6', Email = 'sana.testing@testorg.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'Sana', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'sana.testing@testorg.com', isActive = TRUE, Lan_Id__c = 'UU4569'));
        insert testUsers;

        testAccount.Account_Cluster_Name__c = 'John Testing';
        testAccount.Account_Executive_2__c = 'Jane Testing';
        testAccount.Underwriter_User_ID__c = 'UU456';
        List<AccountTeamMember> acctTeamMember = new List<AccountTeamMember>();
        List<String> memberName = new List<String>();
        List<String> memberNamequery = new List<String>();
        insert testAccount;

        acctTeamMember = [select User.Name, Account.Name, AccountAccessLevel, CreatedDate, CreatedBy.Name from AccountTeamMember where Account.Name = 'Test Account'];

        System.assertEquals(3, acctTeamMember.size());

        testAccount.Account_Cluster_Name__c = 'Dan Testing';
        testAccount.Account_Executive_2__c = 'Sana Testing';
        testAccount.Underwriter_User_ID__c = 'UU4567';

        update testAccount;

        acctTeamMember = [select User.Name, Account.Name, AccountAccessLevel, CreatedDate, CreatedBy.Name from AccountTeamMember where Account.Name = 'Test Account'];

        System.assertEquals(6, acctTeamMember.size());

        Test.stopTest();

    }


    @isTest
    static void updateRegionTest() {

        Test.startTest();
        List<Account> accs = new List<Account>();

        for (Integer i = 0; i < 5; i ++) {
            accs.add(new Account(name = 'Test' + i, RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get( 'Group Account' ).getRecordTypeId()));
        }


        accs[0].HCSC_Division__c = 'TX';
        accs[1].HCSC_Division__c = 'NM';
        accs[2].HCSC_Division__c = 'MT';
        accs[3].HCSC_Division__c = 'OK';
        accs[4].HCSC_Division__c = 'IL';

        insert accs;

        List<Account> accAfterInsert = [Select Name, Id, Region__c from Account];

        System.assertEquals('TX', accAfterInsert[0].Region__c);
        System.assertEquals('NM', accAfterInsert[1].Region__c);
        System.assertEquals('MT', accAfterInsert[2].Region__c);
        System.assertEquals('OK', accAfterInsert[3].Region__c);
        System.assertEquals('IL', accAfterInsert[4].Region__c);
        Test.stopTest();
    }
    
    @isTest
    static void clientProfileFieldCompletionRateTest() {
        Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId();

        Test.startTest();

        Account testAccount = TestClassUtiltity.createAccountWithRecType('Test Acc', recId);
        testAccount = [SELECT CPFieldCompletionRate__c FROM Account WHERE id = :testAccount.id];
        
        System.assert(testAccount.CPFieldCompletionRate__c != null);
        
        Decimal oldRate = testAccount.CPFieldCompletionRate__c;
        testAccount.Risk_Reason__c = 'Test';
        testAccount.HCSC_Division__c = 'TX';
        
        update testAccount;
        testAccount = [SELECT CPFieldCompletionRate__c FROM Account WHERE id = :testAccount.id];
        
        System.assert(testAccount.CPFieldCompletionRate__c > oldRate);
        
        Test.stopTest();
    }

    @isTest static void populateForecastSegment(){
        String forecastSegmentENA = ConstantsController.accountForecastSegmentENA;
        String forecastSegmentSG = ConstantsController.accountForecastSegmentSmallGroup;
        String forecastSegmentLabor = ConstantsController.accountForecastSegmentLabor;
        String forecastSegmentLG = ConstantsController.accountForecastSegmentLargeGroup;
        Forecast_Segment_District__c testForecastSegment = new Forecast_Segment_District__c(Name='001', District__c='001');
        insert testForecastSegment;
        Id accountId1 = fflib_IDGenerator.generate(Account.SObjectType);
        Id accountId2 = fflib_IDGenerator.generate(Account.SObjectType);
        Id accountId3 = fflib_IDGenerator.generate(Account.SObjectType);
        Id accountId4 = fflib_IDGenerator.generate(Account.SObjectType);
        Account testAccount1 = new Account(Id=accountId1, Name='Test1', District__c='001');
        Account testAccount2 = new Account(Id=accountId2, Name='Test2', Market_Segment__c='SG');
        Account testAccount3 = new Account(Id=accountId3, Name='Test3', Market_Segment__c='NAL');
        Account testAccount4 = new Account(Id=accountId4, Name='Test4');
        List<Account> testAccounts = new List<Account>{testAccount1, testAccount2, testAccount3, testAccount4};
        AccountTriggerHandler.populateForecastSegment(testAccounts);
        System.assertEquals(testAccount1.Forecast_Segment__c, forecastSegmentENA);
        System.assertEquals(testAccount2.Forecast_Segment__c, forecastSegmentLG);
        System.assertEquals(testAccount3.Forecast_Segment__c, forecastSegmentLabor);
        System.assertEquals(testAccount4.Forecast_Segment__c, forecastSegmentLG);
    }

    @isTest
    static void complexityScoreFieldCompletionTest() {
        Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId();

        Test.startTest();

        Account testAccount = TestClassUtiltity.createAccountWithRecType('Test Acc', recId);
        testAccount = [SELECT Complexity_Score__c FROM Account WHERE id = :testAccount.id];
        testAccount.Funding_Type__c = 'ASO';
        update testAccount;
        testAccount = [SELECT New_Complexity_Score__c FROM Account WHERE id = :testAccount.id];

        System.assert(testAccount.New_Complexity_Score__c != null);
        
        Decimal oldScore = testAccount.New_Complexity_Score__c;
        testAccount.Ceded__c = true;
        testAccount.HCM_Program_Model__c = 'BCC Elite';
        testAccount.Funding_Type__c = 'PREM';
        testAccount.Cobra_Administration_Type__c = 'HCSC';
        testAccount.Exchange_Account__c = true;
        testAccount.Exchange_Name__c = 'Mercer Marketplace';
        testAccount.Sliced__c = true;
		testAccount.Premium_Type__c = 'PP';
        update testAccount;
        testAccount = [SELECT New_Complexity_Score__c FROM Account WHERE id = :testAccount.id];
        
        System.assert(testAccount.New_Complexity_Score__c > oldScore);
        
        Test.stopTest();
    }

    @isTest
    static void populateContractSignerFieldsTest(){

        Id groupAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.Account_Group_Account_Record_Type).getRecordTypeId();
        Account testAcnt = TestClassUtiltity.createAccountWithRecType('Test Account', groupAccountRecordTypeId);

        Contact testCon = new Contact(AccountId = testAcnt.Id, FirstName = 'Test', LastName = 'Contact', Email = '123@gmail.com', Phone = '(312) 647-1822', Title = 'Mr');
        insert testCon;


        Id customContractsCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CaseRecordTypeCustomContracts).getRecordTypeId();
        Case testCase = new Case(AccountId = testAcnt.Id, Number_of_Lives__c = 2, Negotiation_Type__c = 'Strong', Agreement_Submitted__c = 'None', 
                                State__c = 'IL', Status = 'Request from Sales & Marketing, Draft', Account_Type_Custom_Contract__c = 'New', RecordTypeId = customContractsCaseRecordTypeId);
        insert testCase;
		Test.startTest();
        testAcnt.Contract_Signer__c = testCon.Id;
        update testAcnt;
		Test.stopTest();
        List<Case> updatedCase = [SELECT Full_Name__c, Email__c, Phone__c, Title__c FROM Case];
		System.assertEquals(1, updatedCase.size()); 
        System.assertEquals('Test Contact', updatedCase[0].Full_Name__c); 
        System.assertEquals('123@gmail.com', updatedCase[0].Email__c);
        System.assertEquals('(312) 647-1822', updatedCase[0].Phone__c);
        System.assertEquals('Mr', updatedCase[0].Title__c);

        
    }

    @isTest
    static void updateOpportunityWeeklyActivityModifiedDateTest(){

        Test.startTest();
        Account testAccount1 = new Account(name='test1');
        Account testAccount2 = new Account(name='test2');
        Account testAccount3 = new Account(name='test3');



        List<Account> testAccs = new List<Account>();
        testAccs.add(testAccount1);
        testAccs.add(testAccount2);
        testAccs.add(testAccount3);
        insert testAccs;

        Opportunity testOp1 = new Opportunity(name='test1', AccountId = testAccount1.Id, StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1));
        Opportunity testOp2 = new Opportunity(name='test2', AccountId = testAccount2.Id, StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1));
        Opportunity testOp3 = new Opportunity(name='test3', AccountId = testAccount3.Id, StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1));
        List<Opportunity> testOps = new List<Opportunity>();
        testOps.add(testOp1);
        testOps.add(testOp2);
        testOps.add(testOp3);
        insert testOps;

        System.assertEquals(testOp2.Weekly_Activity_Modified_Date__c, null);
        testAccount1.Current_Risk_Level__c = '3 - Medium';
        testAccount2.Status__c = 'Active';
        testAccount3.Critical_Account__c = True;
        update testAccs;

        List<Opportunity> resultOps = [select Id, Name, Weekly_Activity_Modified_Date__c from Opportunity where Id in :testOps limit 3];
        System.assertNotEquals(resultOps[0].Weekly_Activity_Modified_Date__c, null);
        System.assertNotEquals(resultOps[1].Weekly_Activity_Modified_Date__c, null);
        System.assertNotEquals(resultOps[2].Weekly_Activity_Modified_Date__c, null);
        Test.stopTest();

    }

    //SFDC-4729: The following test method is to test cancelSubmissionCase and futureCancelSubCase methods in AccountTriggerHandler.
    @isTest
    static void cancelCaseofAccount(){
        test.startTest();
        Account testAccount = new Account(name = 'testAccount');
        insert testAccount;
        Opportunity testOpp = new Opportunity(name='test1', AccountId = testAccount.Id, StageName = 'Qualification', CloseDate = system.Today().addYears(2), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1));
        insert testOpp;
        Id submissionCaseRecordId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
        Case testCase = new Case(AccountId = testAccount.Id, Number_of_Lives__c = 2, Negotiation_Type__c = 'Strong', Agreement_Submitted__c = 'None', State__c = 'IL', 
                                 Status = 'Request from Sales & Marketing, Draft', Account_Type_Custom_Contract__c = 'New', RecordTypeId = submissionCaseRecordId);
        insert testCase;
        Contact testCont = new Contact(FirstName = 'No Reply', LastName = 'GEMS', email = 'no-reply@hcsc.com');
        insert testCont;        
        testAccount.status__c = 'Cancelled';
        testAccount.Cancellation_Date__c = system.today();
        update testAccount;
        test.stopTest();
        Case checkCase = [select id, status from case where id = :testCase.id];
        system.assertEquals('Cancelled', checkCase.status);
    }    
 
}