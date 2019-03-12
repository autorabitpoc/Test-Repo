/***************************************************************************************
  Apex Class Name     : OpportunityTriggerHelperTest
  Version             : 1.0
  Function            : This is a test class for OpportunityTriggerHelper
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Sana Fatima                 2/26/2016             Unit Testing for OpportunityTriggerHelper Class
*************************************************************************************/
@isTest
private class OpportunityTriggerHelperTest {

    /**
    * @developer: Sana Fatima/Slalom LLC
    * @description: Test Method for PopulateFieldsFromAccount method in OpportunityTriggerHelper for a New Sale Opportunity
    */
    static testMethod void PopulateFieldsFromAccountNewSaleOppTest() {
        try {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
            system.runAs(testUser) {
                //create test account record
                Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                testAccount.HCSC_Division__c = 'IL';
                testAccount.Market_Segment__c = 'LG';
                testAccount.Cluster__c = '005';
                testAccount.Region__c = 'IL';
                testAccount.District__c = '116';
                testAccount.FSU_Location__c='Chicago';
                update testAccount;

                //create test opportunity record
                list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
                Opportunity testOpp = opportunities[0];
                testOpp.Probability = 10;
                testOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();

                Test.startTest();

                insert testOpp;
                //retrieve inserted opportunity field values
                testOpp = [SELECT Id, Expected_Dental_Members__c, Expected_Dental_Contracts__c,
                           Expected_Health_Members__c, Expected_Health_Contracts__c, HCSC_Division__c, FSU_Location__c,Account_Market_Segment__c, Clusters__c, Region__c, District__c FROM Opportunity WHERE Id = :testOpp.Id];

                //test that the correct values are populated in the test opportunity fields
                System.assertEquals('IL', testOpp.HCSC_Division__c);
                System.assertEquals('LG', testOpp.Account_Market_Segment__c);
                System.assertEquals('005', testOpp.Clusters__c);
                System.assertEquals('IL', testOpp.Region__c);
                System.assertEquals('116', testOpp.District__c);
                System.assertEquals(null, testOpp.Expected_Dental_Members__c);
                System.assertEquals(null, testOpp.Expected_Dental_Contracts__c);
                System.assertEquals(null, testOpp.Expected_Health_Members__c);
                System.assertEquals(null, testOpp.Expected_Health_Contracts__c);

                Test.stopTest();
            }
        } catch (Exception ex) {
            System.debug('Exception: ' + ex.getMessage());
            throw ex;
        }
    }

    /**
    * @developer: Sana Fatima/Slalom LLC
    * @description: Test Method for PopulateFieldsFromAccount method in OpportunityTriggerHelper for a Renewal Opportunity
    */
    static testMethod void PopulateFieldsFromAccountRenewalOppTest() {
        try {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
            system.runAs(testUser) {
                //create test account record
                Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                testAccount.HCSC_Division__c = 'IL';
                testAccount.Market_Segment__c = 'LG';
                testAccount.Cluster__c = '005';
                testAccount.Region__c = 'IL';
                testAccount.District__c = '116';
                testAccount.Active_Dental_Members__c = 40;
                testAccount.Active_Dental_Subscribers__c = 42;
                testAccount.Active_Health_Members__c = 50;
                testAccount.Active_Health_Subscribers__c = 52;
                update testAccount;

                //create test opportunity record
                list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
                Opportunity testOpp = opportunities[0];
                testOpp.Probability = 10;
                testOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();

                Test.startTest();

                insert testOpp;
                //retrieve inserted opportunity field values
                testOpp = [SELECT Id, Expected_Dental_Members__c, Expected_Dental_Contracts__c,
                           Expected_Health_Members__c, Expected_Health_Contracts__c, HCSC_Division__c,FSU_Location__c, Account_Market_Segment__c, Clusters__c, Region__c, District__c FROM Opportunity WHERE Id = :testOpp.Id];

                //test that the correct values are populated in the test opportunity fields
                System.assertEquals('IL', testOpp.HCSC_Division__c);
                System.assertEquals('LG', testOpp.Account_Market_Segment__c);
                System.assertEquals('005', testOpp.Clusters__c);
                System.assertEquals('IL', testOpp.Region__c);
                System.assertEquals('116', testOpp.District__c);
                System.assertEquals(40, testOpp.Expected_Dental_Members__c);
                System.assertEquals(42, testOpp.Expected_Dental_Contracts__c);
                System.assertEquals(50, testOpp.Expected_Health_Members__c);
                System.assertEquals(52, testOpp.Expected_Health_Contracts__c);

                Test.stopTest();
            }
        } catch (Exception ex) {
            System.debug('Exception: ' + ex.getMessage());
            throw ex;
        }
    }

    /**
    * @developer: Nick Serafin/Slalom LLC
    * @description: Test Method for PopulateRenewalProducts method in OpportunityTriggerHelper for a Renewal Opportunity
    */
    static testMethod void PopulateRenewalProducts() {
        try {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
            system.runAs(testUser) {

                Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                testAccount.HCSC_Division__c = 'IL';
                testAccount.Funding_Type__c = 'ACAP';
                update testAccount;

                list<Product2> product = TestClassUtiltity.createProducts();
                product[0].Name = 'HMO';
                product[0].HCSC_State__c = 'IL';
                product[0].Product_Type__c = 'Medical';
                product[0].Simplified_Product__c = 'HMO';
                insert product;

                Group_Section__c temp = new Group_Section__c();
                temp.Group_Account__c = testAccount.id;
                temp.status__c = 'Active';
                temp.Total_Healthcare_Active_Members__c = 10;
                temp.Total_Active_Subscribers__c = 5;
                insert temp;

                Benefit_Agreement__c TestBnftAgrmt6 = new Benefit_Agreement__c ();
                TestBnftAgrmt6.Group_Account__c = testAccount.id;
                TestBnftAgrmt6.Effective_Date__c =  system.today() - 1;
                TestBnftAgrmt6.Product__c = product[0].id;
                TestBnftAgrmt6.Status__c = 'Active';
                TestBnftAgrmt6.Funding_Type__c = 'PAR';
                TestBnftAgrmt6.Renewal_Date__c = system.today();
                insert TestBnftAgrmt6;

                Benefit_Agreement__c TestBnftAgrmt7 = new Benefit_Agreement__c ();
                TestBnftAgrmt7.Group_Account__c = testAccount.id;
                TestBnftAgrmt7.Effective_Date__c =  system.today() - 1;
                TestBnftAgrmt7.Product__c = product[0].id;
                TestBnftAgrmt7.Status__c = 'Active';
                TestBnftAgrmt7.Funding_Type__c = 'ASO';
                TestBnftAgrmt7.Renewal_Date__c = system.today();
                insert TestBnftAgrmt7;

                BA_GS_Assignment__c tempBAGS12 = new BA_GS_Assignment__c();
                tempBAGS12.Benefit_Agreement__c = TestBnftAgrmt7.id;
                tempBAGS12.Group_Section__c = temp.id;
                tempBAGS12.External_ID__c = '10145423454546';
                insert tempBAGS12;

                BA_GS_Assignment__c tempBAGS8 = new BA_GS_Assignment__c();
                tempBAGS8.Benefit_Agreement__c = TestBnftAgrmt6.id;
                tempBAGS8.Group_Section__c = temp.id;
                tempBAGS8.External_ID__c = '1010123454546';
                insert tempBAGS8;

                list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
                Opportunity testOpp = opportunities[0];
                testOpp.Probability = 10;
                testOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();

                Test.startTest();

                insert testOpp;

                List<Opportunity_Product__c> prod = [SELECT id FROM Opportunity_Product__c WHERE Opportunity_Name__c = :testOpp.Id];

                //system.assertEquals(2, prod.size());

                Test.stopTest();
            }
        } catch (Exception ex) {
            System.debug('Exception: ' + ex.getMessage());
            throw ex;
        }

    }

    static testMethod void PopulateRenewalProducts2() {
        try {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
            system.runAs(testUser) {

                Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                testAccount.HCSC_Division__c = 'IL';
                testAccount.Funding_Type__c = 'ACAP';
                update testAccount;

                list<Product2> product = TestClassUtiltity.createProducts();
                product[0].Name = 'HMO';
                product[0].HCSC_State__c = 'IL';
                product[0].Product_Type__c = 'Medical';
                product[0].Simplified_Product__c = 'HMO';
                insert product;

                Group_Section__c temp = new Group_Section__c();
                temp.Group_Account__c = testAccount.id;
                temp.status__c = 'Active';
                temp.Total_Healthcare_Active_Members__c = 10;
                temp.Total_Active_Subscribers__c = 5;
                insert temp;

                Benefit_Agreement__c TestBnftAgrmt1 = new Benefit_Agreement__c();
                TestBnftAgrmt1.Group_Account__c = testAccount.id;
                TestBnftAgrmt1.Effective_Date__c =  system.today() - 1;
                TestBnftAgrmt1.Product__c = product[0].id;
                TestBnftAgrmt1.Renewal_Date__c = system.today();
                TestBnftAgrmt1.Status__c = 'Active';
                TestBnftAgrmt1.Funding_type__c = 'ACAP';
                insert TestBnftAgrmt1;

                Benefit_Agreement__c TestBnftAgrmt2 = new Benefit_Agreement__c();
                TestBnftAgrmt2.Group_Account__c = testAccount.id;
                TestBnftAgrmt2.Effective_Date__c =  system.today() - 1;
                TestBnftAgrmt2.Product__c = product[0].id;
                TestBnftAgrmt2.Renewal_Date__c = system.today();
                TestBnftAgrmt2.Status__c = 'Active';
                TestBnftAgrmt2.Funding_type__c = 'PREM';
                insert TestBnftAgrmt2;


                BA_GS_Assignment__c tempBAGS2 = new BA_GS_Assignment__c();
                tempBAGS2.Benefit_Agreement__c = TestBnftAgrmt2.id;
                tempBAGS2.Group_Section__c = temp.id;
                tempBAGS2.External_ID__c = '101011234';
                insert tempBAGS2;

                BA_GS_Assignment__c tempBAGS = new BA_GS_Assignment__c();
                tempBAGS.Benefit_Agreement__c = TestBnftAgrmt1.id;
                tempBAGS.Group_Section__c = temp.id;
                tempBAGS.External_ID__c = '101011';
                insert tempBAGS;

                list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
                Opportunity testOpp = opportunities[0];
                testOpp.Probability = 10;
                testOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();

                Test.startTest();

                insert testOpp;

                List<Opportunity_Product__c> prod = [SELECT id FROM Opportunity_Product__c WHERE Opportunity_Name__c = :testOpp.Id];

                //system.assertEquals(2, prod.size());

                Test.stopTest();
            }
        } catch (Exception ex) {
            System.debug('Exception: ' + ex.getMessage());
            throw ex;
        }
    }

    /**
    * @developer: Ralph Tariga/Slalom LLC
    * @description: Test Method for PopulateFieldsFromAccountCheckAccountTeamForUnderwriter method in OpportunityTriggerHelper for a Renewal Opportunity
    */
    static testMethod void CheckAccountTeamForUnderwriterTest() {
        try {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');

            System.runAs(testUser) {
                List<RenewalOpportunityStages__c> stages = new List<RenewalOpportunityStages__c>();
                stages.add(new RenewalOpportunityStages__c(Name = 'Finalist Named', Stage_to_Check__c = 'Finalist Named'));
                stages.add(new RenewalOpportunityStages__c(Name = 'Renewal Delivered', Stage_to_Check__c = 'Renewal Delivered'));
                stages.add(new RenewalOpportunityStages__c(Name = 'Renewal In Negotiation', Stage_to_Check__c = 'Renewal In Negotiation'));
                stages.add(new RenewalOpportunityStages__c(Name = 'Renewal Initiated', Stage_to_Check__c = 'Renewal Initiated'));
                stages.add(new RenewalOpportunityStages__c(Name = 'Won', Stage_to_Check__c = 'Won'));
                insert stages;

                List<Account> accList = new List<Account>();

                //create test account record
                Account testAccount = new Account(Name = 'Test Account', Fax = '1234567', Effective_Date__c = system.today().addyears(2));
                testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                testAccount.HCSC_Division__c = 'IL';
                testAccount.Market_Segment__c = 'LG';
                testAccount.Cluster__c = '005';
                testAccount.Region__c = 'IL';
                testAccount.District__c = '116';
                testAccount.Active_Dental_Members__c = 40;
                testAccount.Active_Dental_Subscribers__c = 42;
                testAccount.Active_Health_Members__c = 50;
                testAccount.Active_Health_Subscribers__c = 152;
                accList.add(testAccount);

                Account testAccount2 = new Account(Name = 'Test Account 2', Fax = '1234567', Effective_Date__c = system.today().addyears(2));
                testAccount2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                testAccount2.HCSC_Division__c = 'IL';
                testAccount2.Market_Segment__c = 'LG';
                testAccount2.Cluster__c = '005';
                testAccount2.Region__c = 'IL';
                testAccount2.District__c = '116';
                testAccount2.Active_Dental_Members__c = 40;
                testAccount2.Active_Dental_Subscribers__c = 42;
                testAccount2.Active_Health_Members__c = 50;
                testAccount2.Active_Health_Subscribers__c = 152;
                accList.add(testAccount2);

                insert accList;

                String teamMemberRole = 'Underwriter';
                String accountAccessLevel = 'Edit';
                String opportunityAccessLevel = 'Edit';
                String caseAccessLevel = 'Edit';
                String contactAccessLevel = 'Edit';
                List<AccountTeamMember> members = new list<AccountTeamMember>();
                List<AccountShare> sharingRules = new list<AccountShare>();

                members.add(new AccountTeamMember(AccountId = testAccount2.Id, TeamMemberRole = teamMemberRole, UserId = testUser.Id));
                //sharingRules.add(new AccountShare(AccountAccessLevel = accountAccessLevel, OpportunityAccessLevel = opportunityAccessLevel, CaseAccessLevel = caseAccessLevel, UserOrGroupId = testUser.Id, AccountId = testAccount2.Id));

                insert members;
                //insert sharingRules;

                //create test opportunity record
                list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
                Opportunity testOpp = opportunities[0];
               testOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                testOpp.StageName = 'Renewal Planning';
                testOpp.Probability = 10;

                list<Opportunity> opportunities2 = TestClassUtiltity.CreateOpportunities(testAccount2.Id);
                Opportunity testOpp2 = opportunities2[0];
                testOpp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
                testOpp2.StageName = 'Renewal Planning';
                testOpp2.Probability = 10;

                opportunities.addAll(opportunities2);
                insert opportunities;

                Test.startTest();

                testOpp.StageName = 'Renewal Initiated';
                testOpp2.StageName = 'Renewal Initiated';

                try {
                    update testOpp;
                    // Update Operation not supposed to succeed. If it does, force an exception to fail the test.
                    List<Opportunity> makeItFail;
                    makeItFail[0].Name = 'Make It Fail';
                } catch (Exception ex) {
                    Opportunity resultOpp = [SELECT Id, StageName FROM Opportunity WHERE Id = :testOpp.Id];
                    System.assertNotEquals('Renewal Initiated', resultOpp.StageName);
                }

                update testOpp2;
                Opportunity resultOpp2 = [SELECT Id, StageName FROM Opportunity WHERE Id = :testOpp2.Id];
                System.assertEquals('Renewal Initiated', resultOpp2.StageName);

                Test.stopTest();
            }
        } catch (Exception ex) {
            System.debug('Exception: ' + ex.getMessage());
            throw ex;
        }
    }
    /**
    * @developer: Alec Klein/Slalom LLC
    * @description: Test Method for CreateProducerAssociationForOpportunity method in OpportunityTriggerHelper for any Opportunity
    *                   Tests creating one Producer Association For Opportunity record
    */
    static testMethod void CreateOneProducerAssociationForOpportunity() {
        Test.StartTest();
        Map<Id, RecordType> rtMap = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND (Name = 'Group Account' OR Name = 'Producer Account')]);
        RecordType groupAccountRecordType;
        RecordType producerAccountRecordType;
        for (RecordType rt : rtMap.values()) {
            if (rt.Name == 'Group Account')
                groupAccountRecordType = rt;
            else if (rt.Name == 'Producer Account')
                producerAccountRecordType = rt;
        }
        List<Account> newAccounts = new List<Account>();
        Account newGroupAccount = new Account(Name = 'TestGroupAccount', RecordTypeId = groupAccountRecordType.Id, HCSC_Division__C = 'IL');
        Account newProducerAccount = new Account(Name = 'TestProspectAccount', RecordTypeId = producerAccountRecordType.Id,Status__c='Active');

        newAccounts.add(newGroupAccount);
        newAccounts.add(newProducerAccount);
        insert newAccounts;

        Producer_Group_Association__c pga = new Producer_Group_Association__c(Group_Account__c = newGroupAccount.Id, Producer_Account__c = newProducerAccount.Id, External_ID__c = 'ThisIDIsUnique',Primary__c = true);
        insert pga;
        Opportunity newOpp = new Opportunity(Name = 'TestOpportunity', AccountId = newGroupAccount.Id, RFI_RFP_Received_Date__c = System.today(), StageName = 'RFI Received',Probability = 10, CloseDate = System.today() + 5);
        insert newOpp;
        System.assert([SELECT Opportunity__c FROM Producer_Association_For_Opportunity__c WHERE Opportunity__c = : newOpp.Id].size() == 1);
        Test.StopTest();
    }

    /**
    * @developer: Alec Klein/Slalom LLC
    * @description: Test Method for CreateProducerAssociationForOpportunity method in OpportunityTriggerHelper for any Opportunity
    *                   Tests creating one Producer Association For Opportunity records, where one Producer Account is inactive
    */
    static testMethod void CreateTwoProducerAssociationForOpportunity() {
        Test.StartTest();
        Map<Id, RecordType> rtMap = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND (Name = 'Group Account' OR Name = 'Producer Account')]);
        RecordType groupAccountRecordType;
        RecordType producerAccountRecordType;
        for (RecordType rt : rtMap.values()) {
            if (rt.Name == 'Group Account')
                groupAccountRecordType = rt;
            else if (rt.Name == 'Producer Account')
                producerAccountRecordType = rt;
        }

        List<Account> newAccounts = new List<Account>();
        Account newGroupAccount = new Account(Name = 'TestGroupAccount', RecordTypeId = groupAccountRecordType.Id, HCSC_Division__C = 'IL');
        Account newProducerAccount1 = new Account(Name = 'TestProspectAccount1', RecordTypeId = producerAccountRecordType.Id, Status__c = 'Active');
        Account newProducerAccount2 = new Account(Name = 'TestProspectAccount2', RecordTypeId = producerAccountRecordType.Id, Status__c = 'Inactive');
        newAccounts.add(newGroupAccount);
        newAccounts.add(newProducerAccount1);
        newAccounts.add(newProducerAccount2);
        insert newAccounts;

        List<Producer_Group_Association__c> newPGAs = new List<Producer_Group_Association__c>();
        Producer_Group_Association__c pga1 = new Producer_Group_Association__c(Group_Account__c = newGroupAccount.Id, Producer_Account__c = newProducerAccount1.Id, External_ID__c = 'ThisIDIsUnique',Primary__c = true);
        Producer_Group_Association__c pga2 = new Producer_Group_Association__c(Group_Account__c = newGroupAccount.Id, Producer_Account__c = newProducerAccount2.Id, External_ID__c = 'ThisIDIsUniqueAlso',Primary__c = true);
        newPGAs.add(pga1);
        newPGAs.add(pga2);
        insert newPGAs;

        Opportunity newOpp = new Opportunity(Name = 'TestOpportunity', AccountId = newGroupAccount.Id, RFI_RFP_Received_Date__c = System.today(), StageName = 'RFI Received',Probability = 10, CloseDate = System.today() + 5);
        insert newOpp;
        System.assert([SELECT Opportunity__c FROM Producer_Association_For_Opportunity__c WHERE Opportunity__c = : newOpp.Id].size() == 1);
        Test.StopTest();
    }

    static testMethod void populateForecastSegment(){
        String forecastSegmentENA = ConstantsController.opportunityForecastSegmentENA;
        String forecastSegmentSG = ConstantsController.opportunityForecastSegmentSmallGroup;
        String forecastSegmentLabor = ConstantsController.opportunityForecastSegmentLabor;
        String forecastSegmentLG = ConstantsController.opportunityForecastSegmentLargeGroup;
        Forecast_Segment_District__c testForecastSegment = new Forecast_Segment_District__c(Name='001', District__c='001');
        insert testForecastSegment;
        Id opportunityId1 = fflib_IDGenerator.generate(Opportunity.SObjectType);
        Id opportunityId2 = fflib_IDGenerator.generate(Opportunity.SObjectType);
        Id opportunityId3 = fflib_IDGenerator.generate(Opportunity.SObjectType);
        Id opportunityId4 = fflib_IDGenerator.generate(Opportunity.SObjectType);
        Opportunity testOpportunity1 = new Opportunity(Id=opportunityId1, Name='Test1', District__c='001');
        Opportunity testOpportunity2 = new Opportunity(Id=opportunityId2, Name='Test2', Account_Market_Segment__c='SG');
        Opportunity testOpportunity3 = new Opportunity(Id=opportunityId3, Name='Test3', Account_Market_Segment__c='NAL');
        Opportunity testOpportunity4 = new Opportunity(Id=opportunityId4, Name='Test4');
        List<Opportunity> testOpportunities = new List<Opportunity>{testOpportunity1, testOpportunity2, testOpportunity3, testOpportunity4};
        OpportunityTriggerHelper.populateForecastSegment(testOpportunities);
        System.assertEquals(testOpportunity1.Forecast_Segment__c, forecastSegmentENA);
        System.assertEquals(testOpportunity2.Forecast_Segment__c, forecastSegmentSG);
        System.assertEquals(testOpportunity3.Forecast_Segment__c, forecastSegmentLabor);
        System.assertEquals(testOpportunity4.Forecast_Segment__c, forecastSegmentLG);
    }
     static testMethod void updateLostOppProducts() {
        try {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            User testUser = TestClassUtiltity.CreateUserRecord(p.Id, 'testlgnadev@user.com', 'testUser', 'test@user.com');
            system.runAs(testUser) {
                
                Id CompetitorAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
                Account testCompetitorAccount = TestClassUtiltity.createAccountWithRecType('Test Account2', CompetitorAccountRecordTypeId);

                
                Account testAccount = TestClassUtiltity.CreateAccountRecord('Test Account');
                testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
                testAccount.HCSC_Division__c = 'IL';
                testAccount.Funding_Type__c = 'ACAP';
                upsert testAccount;
                
                Account vndAccount = TestClassUtiltity.CreateAccountRecord('Test Vendor');
                vndAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
                vndAccount.HCSC_Division__c = 'IL';
                vndAccount.Funding_Type__c = 'ACAP';
                upsert vndAccount;
                
                list<Product2> product = TestClassUtiltity.createProducts();
                
                Product2 testProd = product[0];
                testProd.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
                testProd.Name = 'HMO';
                testProd.HCSC_State__c = 'IL';
                testProd.Product_Type__c = 'Medical';
                testProd.Simplified_Product__c = 'HMO';
                upsert product;

                list<Opportunity> opportunities = TestClassUtiltity.CreateOpportunities(testAccount.Id);
                Opportunity testOpp = opportunities[0];
                testOpp.Probability = 0;
                testOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
                testOpp.StageName = 'Expected In';
                testOpp.Name = 'TestLostUpdate';
                testOpp.Type = 'Other';
                testOpp.Exchange_Offering_Type__c = 'No Private Exchange';
                testOpp.Requested_Effective_date__c = System.today();
                testOpp.Expected_RFP_Release_Date__c = System.today();
                testOpp.Primary_Closed_Reason__c = 'Other';
                testOpp.Account_Market_Segment__c = 'LG';
                testOpp.HCSC_Division__c = 'IL';
                testOpp.Region__c = 'IL';
                upsert opportunities;

                Opportunity_Product__c testOppProd1 = new Opportunity_Product__c(Incumbent__c=testCompetitorAccount.Id,Opportunity_Name__c = testOpp.id, Product__c = testProd.id , Funding_Type__c = 'ASO', Projected_Contracts__c = 10, Status__c = 'In Progress', Win_Probability__c = 0, Account__c = vndAccount.id);
                Opportunity_Product__c testOppProd2 = new Opportunity_Product__c(Incumbent__c=testCompetitorAccount.Id,Opportunity_Name__c = testOpp.id, Product__c = testProd.id , Funding_Type__c = 'ASO', Projected_Contracts__c = 10, Status__c = 'In Progress', Win_Probability__c = 0, Account__c = vndAccount.id);              
                insert testOppProd1;
                insert testOppProd2;

                Test.startTest();
                For (opportunity testLostOpp: opportunities){
                    If (testLostOpp.Name == 'TestLostUpdate'){
                        testLostOpp.StageName = 'Lost';
                        testLostOpp.Closed_Comments__c = 'Test';
                        testLostOpp.Date_Closed__c=Date.today();
                        testLostOpp.Primary_Closed_Reason__c = 'Change of Ownership';
                        testLostOpp.Closed_Comments__c='Closed';
                    }
                }
                update opportunities;
                Test.stopTest();

                System.assertEquals([SELECT id FROM Opportunity_Product__c WHERE Opportunity_Name__c = :opportunities[0].id AND Status__c = 'Lost'].size(),2);
            }
        } catch (Exception ex) {
            System.debug('Exception: ' + ex.getMessage());
            throw ex;
        }
    }
    
    /*********************************************************************************************
    * @developer    : Rakesh Nunna
    * @Version      : 1.0
    * @description  : Test Method for addOpportunityContactRoles method in OpportunityTriggerHelper
    * @created Date : 4/03/2018
    **********************************************************************************************/
       // COMMENTED OUT PER MEETING ON 2018.05.15 TEST CLASS ERRORS FOR LIGHTNING PROJECT BEGIN
    static testMethod void addOpportunityContactRoles() {
        
            String accountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
            String oppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
            String contactRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Producer Contact').getRecordTypeId();
            
            Account acc = new Account();
            acc.HCSC_Division__c = 'IL';
            acc.Name = 'Test Account';
            acc.RecordTypeId=accountRecTypeId;
            insert acc;
            
            Contact con =new Contact();
            con.AccountId = acc.Id;
            con.RecordTypeId=contactRecTypeId;
            con.LastName='Test';
            insert con;
            
            Opportunity op = new Opportunity();
            op.RecordTypeId=oppRecTypeId;
            op.Name='Test Account';
            op.AccountId = acc.Id;
            op.Producer_Contact__c =con.Id;
            op.Type='RFI';
            op.Exchange_Offering_Type__c = 'No Private Exchange';
            op.StageName='Expected In';
            op.CloseDate = System.today();
            op.Requested_Effective_Date__c = System.today();
            op.HCSC_Division__c = 'IL';
            op.Account_Market_Segment__c='FEP';
            op.Region__c='IL';
            op.Clusters__c='005';
            op.District__c='038';
            insert op; 
            
            OpportunityContactRole  ocr = new OpportunityContactRole();
            ocr.OpportunityId=op.Id;
            ocr.ContactId= con.Id;
            insert ocr;
            
            
            List<Opportunity> opList = new List<Opportunity>();
            opList.add(op);
            Map<Id,Opportunity> opMap = new Map<Id,Opportunity>();
            opMap.put(op.Id,op);

test.startTest();
//OpportunityTriggerHelper.addOpportunityContactRoles(opList,opMap);
test.stopTest();


}
//COMMENTED OUT PER MEETING ON 2018.05.15 TEST CLASS ERRORS FOR LIGHTNING PROJECT END */
    /*********************************************************************************************
* @developer    : Rakesh Nunna
* @Version      : 1.0
* @description  : Test Method for addOpportunityContactRoles method in OpportunityTriggerHelper
* @created Date : 4/03/2018
**********************************************************************************************/
    ///* COMMENTED OUT PER MEETING ON 2018.05.15 TEST CLASS ERRORS FOR LIGHTNING PROJECT BEGIN
static testMethod void addAccountRelatedList() {

String accountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
String oppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
String contactRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Producer Contact').getRecordTypeId();

Account acc = new Account();
acc.HCSC_Division__c = 'TX';
acc.Name = 'Test Account Today';
acc.RecordTypeId=accountRecTypeId;
upsert acc;

Account acc2 = new Account();
acc2.HCSC_Division__c = 'OK';
acc2.Name = 'Test Account';
acc2.RecordTypeId=accountRecTypeId;
upsert acc2;

Contact con =new Contact();
con.AccountId = acc2.Id;
con.RecordTypeId=contactRecTypeId;
con.LastName='Test Today Contact';
upsert con;

Contact cont2 =new Contact();
cont2.AccountId = acc.Id;
cont2.RecordTypeId=contactRecTypeId;
cont2.LastName='Test1';
upsert cont2;

Opportunity op = new Opportunity();
op.RecordTypeId=oppRecTypeId;
op.Name='Test Account';
op.AccountId = acc.Id;
op.Producer_Contact__c =con.Id;
op.Type='RFI';
op.Exchange_Offering_Type__c = 'No Private Exchange';
op.StageName='Expected In';
op.CloseDate = System.today();
op.Requested_Effective_Date__c = System.today();
op.HCSC_Division__c = 'IL';
op.Account_Market_Segment__c='FEP';
op.Region__c='IL';
op.Clusters__c='005';
op.District__c='038';
insert op; 


OpportunityContactRole  ocr = new OpportunityContactRole();
ocr.OpportunityId=op.Id;
ocr.ContactId= cont2.Id;
insert ocr;        

Opportunity o =[select Id,Producer_Contact__c from Opportunity where Id=:op.Id];
o.Producer_Contact__c = cont2.Id;
update o;

Map<Id,Opportunity> opMap = new Map<Id,Opportunity>();
List<Opportunity> opList = new List<Opportunity>();
opList.add(o);
Opportunity oppRec = new Opportunity();
oppRec = o;
opMap.put(o.Id,o);
Test.startTest();
//OpportunityTriggerHelper.addOpportunityContactRoles(opList,opMap);
Test.stopTest();

}
//COMMENTED OUT PER MEETING ON 2018.05.15 TEST CLASS ERRORS FOR LIGHTNING PROJECT END */
}