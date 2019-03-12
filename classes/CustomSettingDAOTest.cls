/**************************************************************************************
  Apex Class Name     : CustomSettingDAOTest
  Version             : 1.0
  Function            : This is a test class for CustomSettingDAO.
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------
* Alec Klein				5/25/2016
*************************************************************************************/
@isTest(SeeAllData = false)
public class CustomSettingDAOTest {
	@isTest public static void getUsernamePasswordCSByNameTest() {
		CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance = new CustomSettingDAO();
		Username_Password__c testEndpoint = new Username_Password__c();
		testEndpoint.Name = 'Test';
		testEndpoint.UserName__c = 'TestUsername';
		testEndpoint.Password__c = 'TestPassword';
		testEndpoint.EndPoinUrl__c = 'testendpoint.com';
		insert testEndpoint;
		Username_Password__c retrievedEndpoint = customSettingDAOInstance.getUsernamePasswordCSByName('Test');
		System.assertEquals(retrievedEndpoint.UserName__c, testEndpoint.UserName__c);
		System.assertEquals(retrievedEndpoint.Password__c, testEndpoint.Password__c);
		System.assertEquals(retrievedEndpoint.EndPoinUrl__c, testEndpoint.EndPoinUrl__c);
		System.assertEquals(retrievedEndpoint.Name, testEndpoint.Name);
	}

	@isTest public static void getEncryptionKeyCSByProfileIdTest() {
		CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance = new CustomSettingDAO();
		Encryption_Key__c testKey = new Encryption_Key__c();
		Profile testProfile = [SELECT Id FROM Profile LIMIT 1];
		testKey.Encryption_Key__c = 'testEncryptionKey';
		testKey.SetupOwnerId = testProfile.Id;
		insert testKey;
		Encryption_Key__c retrievedKey = customSettingDAOInstance.getEncryptionKeyCSByProfileId(testProfile.Id);
		System.assertEquals(testKey.Encryption_Key__c, retrievedKey.Encryption_Key__c);
	}
    
    @isTest public static void getAllSharePointOAuthsQuoteRq(){
        
        ProfileDAO profileDAOInstance = new ProfileDAO();
        Profile integrationProfile = profileDAOInstance.getProfileByName(System.Label.ProfileIntegrationProfile);
        
        Encryption_Key__c testKey = new Encryption_Key__c();
        testKey.Name = 'Test Key';
        testKey.Encryption_Key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        testKey.SetupOwnerId = integrationProfile.Id;
        insert testKey;
        
        String unencryptedSecretKey = 'secretkey';
        Blob cipherText = Crypto.encryptWithManagedIV('AES256', EncodingUtil.base64Decode(testKey.Encryption_Key__c), Blob.valueOf(unencryptedSecretKey));
        String encryptedMessage = EncodingUtil.base64Encode(cipherText);
        
        String length255key = '';
        for(Integer i = 0; i < 255; i++){
            length255key+='Z';
        }
        
        String length100key ='';
        for(Integer i = 0; i < 100; i++){
            length100key+='A';
        }
        
        /* insert a record in the Custom Setting */
        SharePoint_TEST_HeronQuotes__c QuoteReqAuth = new SharePoint_TEST_HeronQuotes__c();
        QuoteReqAuth.Name = 'TEST';
        QuoteReqAuth.Access_Token_1__c=length255key;
        QuoteReqAuth.Access_Token_2__c=length255key;
        QuoteReqAuth.Access_Token_3__c=length255key;
        QuoteReqAuth.Access_Token_4__c=length255key;
        QuoteReqAuth.Access_Token_5__c='Z';
        QuoteReqAuth.Refresh_Token_1__c=length100key;
        QuoteReqAuth.Refresh_Token_2__c=length100key;
        QuoteReqAuth.Client_ID__c='ABCDEFGHIJK1234567890';
        QuoteReqAuth.Client_Secret__c=encryptedMessage;
        QuoteReqAuth.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        insert QuoteReqAuth;
        
        /* create the DAO Object */        
        CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance = new CustomSettingDAO();
        
        /* List to hold return from Method */
        List<SharePoint_TEST_HeronQuotes__c> Assert1 = new List<SharePoint_TEST_HeronQuotes__c>();
        
        /* call the method */
        Assert1 = customSettingDAOInstance.getAllSharePointOAuthsQuoteRq();
        
        /* should only be 1 record returned */
        system.assert(Assert1.size()==1);
        
    }
    
    @isTest public static void getSPOAuthSettingsQuoteRq(){
        
        /* Create a User to act as the Profile on the Custom Setting */
        ProfileDAO profileDAOInstance = new ProfileDAO();
        Profile integrationProfile = profileDAOInstance.getProfileByName(System.Label.ProfileIntegrationProfile); /* value = Integration Profile */
        User integrationUser = TestClassUtiltity.CreateUserRecord(integrationProfile.Id, 'testUsername@intTest.com', 'test', 'testEmail@intTest.com');
        //insert integrationUser;
        
        Encryption_Key__c testKey = new Encryption_Key__c();
        testKey.Name = 'Test Key';
        testKey.Encryption_Key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        testKey.SetupOwnerId = integrationProfile.Id;
        insert testKey;
        
        String unencryptedSecretKey = 'secretkey';
        Blob cipherText = Crypto.encryptWithManagedIV('AES256', EncodingUtil.base64Decode(testKey.Encryption_Key__c), Blob.valueOf(unencryptedSecretKey));
        String encryptedMessage = EncodingUtil.base64Encode(cipherText);
        
        String length255key = '';
        for(Integer i = 0; i < 255; i++){
            length255key+='Z';
        }
        
        String length100key ='';
        for(Integer i = 0; i < 100; i++){
            length100key+='A';
        }                
           
        /* insert a record in the Custom Setting */
        SharePoint_PROD_HeronQuotes__c QuoteReqAuth = new SharePoint_PROD_HeronQuotes__c();
        QuoteReqAuth.SetupOwnerId = integrationUser.ProfileId;        
        QuoteReqAuth.Name = 'TESTXYZ';
        QuoteReqAuth.Access_Token_1__c=length255key;
        QuoteReqAuth.Access_Token_2__c=length255key;
        QuoteReqAuth.Access_Token_3__c=length255key;
        QuoteReqAuth.Access_Token_4__c=length255key;
        QuoteReqAuth.Access_Token_5__c='Z';
        QuoteReqAuth.Refresh_Token_1__c=length100key;
        QuoteReqAuth.Refresh_Token_2__c=length100key;
        QuoteReqAuth.Client_ID__c='ABCDEFGHIJK1234567890';
        QuoteReqAuth.Client_Secret__c=encryptedMessage;
        QuoteReqAuth.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        insert QuoteReqAuth;
        
        /* create the DAO Object */        
        CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance = new CustomSettingDAO();
        
        /* Declare variable for Return of Method */
        SharePoint_PROD_HeronQuotes__c assert1CS;
        
        /* call the method */
        assert1CS = customSettingDAOInstance.getSPOAuthSettingsQuoteRq(integrationUser.ProfileId);
        
        /* should only be 1 record returned */
        string assert1ST = assert1CS.Name;
        
        system.debug('debug: ' + assert1CS.Name);
        
        System.assertEquals('SharePoint PROD HeronQuotes (Profile)',assert1ST);        
    }
    
    @isTest public static void getAllSharePointOAuthsRqHub(){
        
        ProfileDAO profileDAOInstance = new ProfileDAO();
        Profile integrationProfile = profileDAOInstance.getProfileByName(System.Label.ProfileIntegrationProfile);
        
        Encryption_Key__c testKey = new Encryption_Key__c();
        testKey.Name = 'Test Key';
        testKey.Encryption_Key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        testKey.SetupOwnerId = integrationProfile.Id;
        insert testKey;
        
        String unencryptedSecretKey = 'secretkey';
        Blob cipherText = Crypto.encryptWithManagedIV('AES256', EncodingUtil.base64Decode(testKey.Encryption_Key__c), Blob.valueOf(unencryptedSecretKey));
        String encryptedMessage = EncodingUtil.base64Encode(cipherText);
        
        String length255key = '';
        for(Integer i = 0; i < 255; i++){
            length255key+='Z';
        }
        
        String length100key ='';
        for(Integer i = 0; i < 100; i++){
            length100key+='A';
        }
        
        /* insert a record in the Custom Setting */
        SPOAuthTestReqHub__c ReqHubAuth = new SPOAuthTestReqHub__c();
        ReqHubAuth.Name = 'TEST';
        ReqHubAuth.Access_Token_1__c=length255key;
        ReqHubAuth.Access_Token_2__c=length255key;
        ReqHubAuth.Access_Token_3__c=length255key;
        ReqHubAuth.Access_Token_4__c=length255key;
        ReqHubAuth.Access_Token_5__c='Z';
        ReqHubAuth.Refresh_Token_1__c=length100key;
        ReqHubAuth.Refresh_Token_2__c=length100key;
        ReqHubAuth.Client_ID__c='ABCDEFGHIJK1234567890';
        ReqHubAuth.Client_Secret__c=encryptedMessage;
        ReqHubAuth.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        insert ReqHubAuth;
        
        /* create the DAO Object */        
        CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance = new CustomSettingDAO();
        
        /* List to hold return from Method */
        List<SPOAuthTestReqHub__c> Assert1 = new List<SPOAuthTestReqHub__c>();
        
        /* call the method */
        Assert1 = customSettingDAOInstance.getAllSharePointOAuthsRqHub();
        
        /* should only be 1 record returned */
        system.assert(Assert1.size()==1);        
    }
    
     @isTest public static void getSPOAuthSettingsReqHub(){
        
        /* Create a User to act as the Profile on the Custom Setting */
        ProfileDAO profileDAOInstance = new ProfileDAO();
        Profile integrationProfile = profileDAOInstance.getProfileByName(System.Label.ProfileIntegrationProfile); /* value = Integration Profile */
        User integrationUser = TestClassUtiltity.CreateUserRecord(integrationProfile.Id, 'testUsername@intTest.com', 'test', 'testEmail@intTest.com');
                
        Encryption_Key__c testKey = new Encryption_Key__c();
        testKey.Name = 'Test Key';
        testKey.Encryption_Key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        testKey.SetupOwnerId = integrationProfile.Id;
        insert testKey;
        
        String unencryptedSecretKey = 'secretkey';
        Blob cipherText = Crypto.encryptWithManagedIV('AES256', EncodingUtil.base64Decode(testKey.Encryption_Key__c), Blob.valueOf(unencryptedSecretKey));
        String encryptedMessage = EncodingUtil.base64Encode(cipherText);
        
        String length255key = '';
        for(Integer i = 0; i < 255; i++){
            length255key+='Z';
        }
        
        String length100key ='';
        for(Integer i = 0; i < 100; i++){
            length100key+='A';
        }                
           
        /* insert a record in the Custom Setting */
        SharePointOAuthReqHub__c ReqHubAuth = new SharePointOAuthReqHub__c();
        ReqHubAuth.SetupOwnerId = integrationUser.ProfileId;        
        ReqHubAuth.Name = 'TESTXYZ';
        ReqHubAuth.Access_Token_1__c=length255key;
        ReqHubAuth.Access_Token_2__c=length255key;
        ReqHubAuth.Access_Token_3__c=length255key;
        ReqHubAuth.Access_Token_4__c=length255key;
        ReqHubAuth.Access_Token_5__c='Z';
        ReqHubAuth.Refresh_Token_1__c=length100key;
        ReqHubAuth.Refresh_Token_2__c=length100key;
        ReqHubAuth.Client_ID__c='ABCDEFGHIJK1234567890';
        ReqHubAuth.Client_Secret__c=encryptedMessage;
        ReqHubAuth.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        insert ReqHubAuth;
        
        /* create the DAO Object */        
        CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance = new CustomSettingDAO();
        
        /* Declare variable for Return of Method */
        SharePointOAuthReqHub__c assert1CS;
        
        /* call the method */
        assert1CS = customSettingDAOInstance.getSPOAuthSettingsReqHub(integrationUser.ProfileId);
        
        /* should only be 1 record returned */
        string assert1ST = assert1CS.Name;
        
        system.debug('debug: ' + assert1CS.Name);
        
        System.assertEquals('SharePoint OAuth ReqHub (Profile)',assert1ST);        
    }
    
    @isTest public static void getFIPSByStateAndZip(){
        
        SearchFIPS__c ARecord = new SearchFIPS__C();
        ARecord.Name = 'TEST123';
        ARecord.State__c = 'OK';
        ARecord.ZipCode__c = '74119';
        ARecord.FIPS_Code__c = 'ABC';
        Insert ARecord;
        
        /* create the DAO Object */        
        CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance = new CustomSettingDAO();
        
        SearchFIPS__c Assert1; 
        
        Assert1 = customSettingDAOInstance.getFIPSByStateAndZip('OK','74119');
        
        System.assert(Assert1.FIPS_Code__c=='ABC');
    }
    
    @isTest public static void getSharePointOAuthSettings() {
        CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance = new CustomSettingDAO();
        
        Profile testProfile = [SELECT Id FROM Profile LIMIT 1];
        
        SharePointOAuth__c testCS = new SharePointOAuth__c();
        testCS.SetupOwnerId = testProfile.Id;
        testCS.Client_ID__c='ABCDEFGHIJK1234567890';
        insert testCS;
        
        SharePointOAuth__c retrievedKey = customSettingDAOInstance.getSharePointOAuthSettings(testProfile.Id);
        System.assertEquals(testCS.Client_ID__c, retrievedKey.Client_ID__c);
    }
    
    @isTest public static void getAllSharePointOAuths() {
        CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance = new CustomSettingDAO();
        
        SharePointOAuthTEST__c testCS = new SharePointOAuthTEST__c();
        testCS.Name = 'TEST123';
        testCS.Client_ID__c='ABCDEFGHIJK1234567890';
        insert testCS;
        
        List<SharePointOAuthTEST__c> RetrievedValues = new List<SharePointOAuthTEST__c>();
        RetrievedValues = customSettingDAOInstance.getAllSharePointOAuths();
        System.assert(RetrievedValues.size()==1);
    }
    
    @isTest public static void getHeronOAuthSetting(){
        
        CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance = new CustomSettingDAO();
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User AUser = TestClassUtiltity.CreateUserRecord(pf.Id, 'testUsername@intTest.com', 'test', 'testEmail@intTest.com');
        
        Heron_OAuth__c AnEntryCS = new Heron_OAuth__c();        
        AnEntryCS.Name = 'TEST1234';
        AnEntryCS.SetupOwnerId = AUser.Id;
        AnEntryCS.Client_Id__c = 'ClientID';
        Insert AnEntryCS;
        
        Heron_OAuth__c Assert1 = new Heron_OAuth__c();
        ID UserID = AUser.Id;
        Assert1 = customSettingDAOInstance.getHeronOAuthSetting(UserID);
        
        System.assert(Assert1.Client_Id__c == 'ClientID');
    }       
    
    @isTest public static void getJWTOAuthSetting(){
        
        CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance = new CustomSettingDAO();
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User AUser = TestClassUtiltity.CreateUserRecord(pf.Id, 'testUsername@intTest.com', 'test', 'testEmail@intTest.com');
        
        OAuth_Jwt_Token__c AnEntryCS = new OAuth_Jwt_Token__c();        
        AnEntryCS.Name = 'TEST1234';
        AnEntryCS.SetupOwnerId = AUser.Id;
        AnEntryCS.Client_Id__c = 'ClientID';
        Insert AnEntryCS;
        
        OAuth_Jwt_Token__c Assert1 = new OAuth_Jwt_Token__c();
        ID UserID = AUser.Id;
        Assert1 = customSettingDAOInstance.getJWTOAuthSetting(UserID);
        
        System.assert(Assert1.Client_Id__c == 'ClientID');
    }    
}