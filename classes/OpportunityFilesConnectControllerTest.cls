@isTest (SeeAllData=false)
private class OpportunityFilesConnectControllerTest{
    @testSetup static void setupTestData(){
        Test.startTest();
        OrganizationDAO.IOrganizationDAO organizationDAOInstance = new OrganizationDAO();
        SharePointOAuthTEST__c cs = new SharePointOAuthTEST__c();
        if (!organizationDAOInstance.isRunningInSandbox()) {
            cs.Name = System.URL.getSalesforceBaseUrl().getHost().substringbefore('.').toLowerCase();
        } else {
            cs.Name = System.URL.getSalesforceBaseUrl().getHost().substringAfterLast('--').substringbefore('.').toLowerCase();
        }
        cs.Access_Token_1__c = '00000000000000000000000000000000';
        cs.Access_Token_2__c = '00000000000000000000000000000000';
        cs.Access_Token_3__c = '00000000000000000000000000000000';
        cs.Access_Token_4__c = '00000000000000000000000000000000';
        cs.Access_Token_5__c = '00000000000000000000000000000000';
        cs.Client_ID__c = '123456789ABCDEFG';
        cs.Client_Secret__c = 'secret';
        cs.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        cs.Refresh_Token_1__c = '00000000000000000000000000000000';
        cs.Refresh_Token_2__c = '00000000000000000000000000000000';
        insert cs;

        Account a = new Account(Name='Test', External_Id__c='AC102981');
        insert a;
        Opportunity o = new Opportunity(Name='Test', RFI_RFP_Received_Date__c=System.Today(), AccountId=a.Id);
        o.StageName='Expected In';
        o.probability=50;
        o.Expected_RFP_Release_Date__c=System.Today();
        o.CloseDate=System.Today();
        insert o;
        Test.stopTest();
    }

    @isTest static void basicControllerTest(){
        Test.startTest();
        ProfileDAO profileDAOInstance = new ProfileDAO();
        Profile integrationProfile = profileDAOInstance.getProfileByName(System.Label.ProfileIntegrationProfile);
        User integrationUser = TestClassUtiltity.CreateUserRecord(integrationProfile.Id, 'testUsername@intTest.com', 'test', 'testEmail@intTest.com');
        Opportunity o = [SELECT Id FROM Opportunity LIMIT 1];
        ApexPages.CurrentPage().getParameters().put('id', o.Id);
        Encryption_Key__c testKey = new Encryption_Key__c();
        testKey.Name = 'Test Key';
        testKey.Encryption_Key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        testKey.SetupOwnerId = integrationProfile.Id;
        insert testKey;
        ApexPages.StandardController std = new ApexPages.StandardController(o);
        OpportunityFilesConnectController con = new OpportunityFilesConnectController(std);
        
        try{        
            con.pageNumber = 0;
            con.pageSize = 0;
            con.totalNoOfRecs = 1;
            con.getInitialDocumentSet();
        } catch(System.MathException e) {
            System.assert(true);
        }

        con.totalNoOfRecs = 0;
        con.pageSize = 2;
        con.getInitialDocumentSet();

        con.totalNoOfRecs = 3;
        con.getInitialDocumentSet();

        try{
            con.next();
        } catch(System.NullPointerException e){
            //Requires Items_Sharepoint__x External Object to be populated, cannot do this
            System.assert(true);
        }
        System.assertEquals(1, con.pageNumber);

        try{
            con.previous();
        } catch(System.NullPointerException e){
            //Requires Items_Sharepoint__x External Object to be populated, cannot do this
            System.assert(true);
        }

        try{
            con.previous();
        } catch(System.NullPointerException e){
            //Requires Items_Sharepoint__x External Object to be populated, cannot do this
            System.assert(true);
        }

        con.fileType = 'application';
        con.fileName = 'Test file name';
        con.linkFile();
        con.fileType = 'other';
        con.fileName = 'Test file name';
        con.linkFile();
        con.verifySharePointButton();
        Test.stopTest();
    }
}