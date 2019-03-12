@isTest(SeeAllData=false)
private class AccountDAOTest{

    @isTest
    static void accountDAOTest(){
        Test.StartTest();

        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(Alias = 'standt1', Email = 'john.testing@testorg.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'John', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'john.testing@testorg.com', isActive = TRUE);
        insert testUser;

        AccountDAO.IAccountDAO accountDAOInstance = new AccountDAO();

        Account testAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');

        Opportunity opp = new Opportunity(AccountId = testAcnt.Id, HCSC_Division__c = 'IL', Name='oppName 2',StageName = 'Expected In', CloseDate = system.Today().addYears(2), Expected_RFP_Release_Date__c = system.Today().addYears(1), Expected_Decision_Date__c = system.Today().addYears(1), RFI_RFP_Received_Date__c = system.Today().addYears(1), Primary_Closed_Reason__c = 'Savings');
        opp.Requested_Effective_Date__c = System.Today() + 1;    
        insert opp;
        Set<Id> accountIds = new Set<Id>();
        accountIds.add(testAcnt.Id);
        List<account> accountObjs = accountDAOInstance.getAccountsForProduct360(testUser.Id, accountIds);

        System.assertEquals(accountObjs.size(), 1);
        System.assertEquals(accountObjs[0].opportunities.size(), 1);

        accountObjs[0].Funding_Type__c = 'PREM';
        accountDAOInstance.updateAccounts( accountObjs );
        accountObjs = accountDAOInstance.getAccounts( accountIds );

        System.assertEquals(accountObjs.size(), 1);
        System.assertEquals(accountObjs[0].Funding_Type__c, 'PREM');
    
        Test.StopTest();
    }

    @isTest
    static void accountDAOComplexityScoreTest() {
        Test.startTest();
        Id groupAccRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId();
        AccountDAO.IAccountDAO accountDAOInstance = new AccountDAO();

        Account testAcnt = TestClassUtiltity.createAccountWithRecType('TestAccount', groupAccRecId);
        Set<Id> accountIds = new Set<Id>();
        accountIds.add(testAcnt.Id);

        List<Account> accountsForCase = accountDAOInstance.getCaseComplexityGroupAccounts(accountIds, groupAccRecId);
        List<Account> accountsForContact = accountDAOInstance.getContactComplexityGroupAccounts(accountIds, groupAccRecId);
        List<Account> accountsForCompetitorRelationship = accountDAOInstance.getCompetitorRelationshipComplexityGroupAccounts(accountIds, groupAccRecId);
        List<Account> accountsForBenefitAgreement = accountDAOInstance.getBenefitAgreementComplexityGroupAccounts(accountIds, groupAccRecId);
        System.assert(!accountsForCase.isEmpty());
        System.assert(!accountsForContact.isEmpty());
        System.assert(!accountsForCompetitorRelationship.isEmpty());
        System.assert(!accountsForBenefitAgreement.isEmpty());

        Test.stopTest();
    }
}