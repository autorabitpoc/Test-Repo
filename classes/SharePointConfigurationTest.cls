@isTest (SeeAllData=false)
private class SharePointConfigurationTest{
    @isTest static void SharePointConfigurationConstructorTest(){
        
        ProfileDAO profileDAOInstance = new ProfileDAO();
        Profile integrationProfile = profileDAOInstance.getProfileByName(System.Label.ProfileIntegrationProfile);
        User integrationUser = TestClassUtiltity.CreateUserRecord(integrationProfile.Id, 'testUsername@intTest.com', 'test', 'testEmail@intTest.com');
        
        String length255key = '';
        for(Integer i = 0; i < 255; i++){
            length255key+='Z';
        }

        String length100key ='';
        for(Integer i = 0; i < 100; i++){
            length100key+='A';
        }
        
        Encryption_Key__c testKey = new Encryption_Key__c();
        testKey.Name = 'Test Key';
        testKey.Encryption_Key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        testKey.SetupOwnerId = integrationProfile.Id;
        insert testKey;
        
        String unencryptedSecretKey = 'secretkey';
        Blob cipherText = Crypto.encryptWithManagedIV('AES256', EncodingUtil.base64Decode(testKey.Encryption_Key__c), Blob.valueOf(unencryptedSecretKey));
        String encryptedMessage = EncodingUtil.base64Encode(cipherText);

        SharePointOAuthTEST__c testAuth = new SharePointOAuthTEST__c ();
        testAuth.Name = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        testAuth.Access_Token_1__c=length255key;
        testAuth.Access_Token_2__c=length255key;
        testAuth.Access_Token_3__c=length255key;
        testAuth.Access_Token_4__c=length255key;
        testAuth.Access_Token_5__c='Z';
        testAuth.Refresh_Token_1__c=length100key;
        testAuth.Refresh_Token_2__c=length100key;
        testAuth.Client_ID__c='ABCDEFGHIJK1234567890';
        testAuth.Client_Secret__c=encryptedMessage;
        testAuth.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();               
        
        SharePointOAuth__c oAuth = new SharePointOAuth__c();
        oAuth.Name = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        oAuth.Access_Token_1__c=length255key;
        oAuth.Access_Token_2__c=length255key;
        oAuth.Access_Token_3__c=length255key;
        oAuth.Access_Token_4__c=length255key;
        oAuth.Access_Token_5__c='Z';
        oAuth.Refresh_Token_1__c=length100key;
        oAuth.Refresh_Token_2__c=length100key;
        oAuth.Client_ID__c='ABCDEFGHIJK1234567890';
        oAuth.Client_Secret__c=encryptedMessage;
        oAuth.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();

        List<SharePointOAuthTEST__c> spOAuthTEST = new List<SharePointOAuthTEST__c>{testAuth};
        //List<SharePointOAuth__c> spOAuth = new List<SharePointOAuth__c>{oAuth};   
            

        fflib_ApexMocks customSettingMocks = new fflib_ApexMocks();

        CustomSettingDAO.ICustomSettingDAO customSettingMockDAO; 
        customSettingMockDAO = new MockDAOs.CustomSettingDAOMock(customSettingMocks);
        
        customSettingMocks.startStubbing();
        
        OrganizationDAO.IOrganizationDAO organizationDAOInstance = new OrganizationDAO();
        SharePointOAuthTEST__c cs = new SharePointOAuthTEST__c();        
        if (!organizationDAOInstance.isRunningInSandbox()) {
            customSettingMocks.when(customSettingMockDAO.getSharePointOAuthSettings(integrationProfile.Id))
                         .thenReturn(oAuth);
                        //.thenReturn(spOAuth);
        } else {
            customSettingMocks.when(customSettingMockDAO.getAllSharePointOAuths())
                        .thenReturn(spOAuthTEST);
        }
        
        
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getEncryptionKeyCSByProfileId(integrationProfile.Id))
                        .thenReturn(testKey);
        customSettingMocks.stopStubbing();

        SharePointConfiguration spc = new SharePointConfiguration(customSettingMockDAO, new CustomMetadataTypeDAO(),
                                                         new OrganizationDAO(), new EncryptionUtility(), new ProfileDAO());

        SharePoint_Configuration__mdt sharePointConfig;
        if (!spc.organizationDAOInstance.isRunningInSandbox()) {
            sharePointConfig = spc.customMetadatTypeDAOInstance.getSharePointConfigurationByName(SharePointConfiguration.SHAREPOINT_PROD_CONFIG);
        } else {
            sharePointConfig = spc.customMetadatTypeDAOInstance.getSharePointConfigurationByName(SharePointConfiguration.SHAREPOINT_TEST_CONFIG);
        }

        String gemsContentTypeId = spc.getGEMSContentTypeId();
        System.assertEquals(sharePointConfig.GEMS_Content_Type_Id__c, gemsContentTypeId);

        String lgnaContentTypeId = spc.getLGNAContentTypeId();
        System.assertEquals(sharePointConfig.Content_Type_Id__c, lgnaContentTypeId);

        String spListItemName = spc.getSharePointListItemName();
        System.assertEquals(sharePointConfig.List_Item_Name__c, spListItemName);

        String tokenExpiredText = spc.getTokenExpiredResponseText();
        System.assertEquals(sharePointConfig.Token_Expired_Response_Text__c, tokenExpiredText);

        String findFolderURL = spc.getFindFolderURL();
        System.assertEquals(sharePointConfig.Find_Folder_URL__c, findFolderURL);

        String viewURLPath = spc.getViewURLPath();
        System.assertEquals(sharePointConfig.View_URL_Path__c, viewURLPath);

        String teamURLPath = spc.getTeamURLPath();
        System.assertEquals(sharePointConfig.Team_Path__c, teamURLPath);
        
        String listName = spc.getListName();
        System.assertEquals(sharePointConfig.List_Name__c, listName);

        String siteRealm = spc.getSiteRealm();
        System.assertEquals(sharePointConfig.Site_Realm__c, siteRealm);

        String siteResource = spc.getSiteResource();
        System.assertEquals(sharePointConfig.SharePoint_Resource__c, siteResource);

        String redirectURI = spc.getRedirectURI();
        System.assertEquals('https%3A%2F%2F' + System.URL.getSalesforceBaseUrl().getHost().toLowerCase() + '%2Fapex%2FSharePointRefreshTokenPage', redirectURI);

        String resource = spc.getResource();
        String assembledResource = sharePointConfig.SharePoint_Resource__c+'/'+
                                    sharePointConfig.SharePoint_URL__c.remove(sharePointConfig.SharePoint_URL__c.left(8))+
                                    '@'+sharePointConfig.Site_Realm__c;
        System.assertEquals(assembledResource, resource);

        String clientId = 'ABCDEFGHIJK1234567890';
        System.assertEquals(testAuth.Client_ID__c, clientId);

        String clientSecret = spc.getClientSecret();
        System.assertEquals(spc.encryptionUtilityInstance.getDecryptedMessage(testAuth.Client_Secret__c), clientSecret);

        String accessToken = spc.getAccessToken();
        System.assertEquals(testAuth.Access_Token_1__c+testAuth.Access_Token_2__c+
                                testAuth.Access_Token_3__c+testAuth.Access_Token_4__c+
                                testAuth.Access_Token_5__c, accessToken);

        String refreshToken = spc.getRefreshToken();
        System.assertEquals(testAuth.Refresh_Token_1__c+testAuth.Refresh_Token_2__c, refreshToken);

        String sharepointURL = spc.getSharePointURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c, sharepointURL);

        String teamSharepointURL = spc.getTeamSharePointURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.Team_Path__c, teamSharepointURL);

        String realmURL = spc.getRealmURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.Realm_Path__c, realmURL);

        String authURL = spc.getAuthURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.Team_Path__c+sharePointConfig.Auth_URL_Path__c, authURL);

        String refreshTokenURL = spc.getRefreshTokenURL();
        System.assertEquals(sharePointConfig.Token_URL__c.replace(SharePointConfiguration.SITE_REALM, sharePointConfig.Site_Realm__c), refreshTokenURL);

        String listURL = spc.getListURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.List_URL_Path__c, listURL);

        String createURLPath = spc.getCreateURLPath();
        System.assertEquals(sharePointConfig.Create_URL_Path__c, createURLPath);

        String updateURLPath = spc.getUpdateURLPath();
        System.assertEquals(sharePointConfig.Update_URL_Path__c, updateURLPath);

        String deleteURL = spc.getDeleteURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.List_URL_Path__c, deleteURL);

        String updateURL = spc.getUpdateURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.List_URL_Path__c, listURL);

        String createURL = spc.getCreateURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.List_URL_Path__c, listURL);
    }
    
     @isTest static void SharePointConfigurationConstructorTest1(){
        
        ProfileDAO profileDAOInstance = new ProfileDAO();
        Profile integrationProfile = profileDAOInstance.getProfileByName(System.Label.ProfileIntegrationProfile);
        User integrationUser = TestClassUtiltity.CreateUserRecord(integrationProfile.Id, 'testUsername@intTest.com', 'test', 'testEmail@intTest.com');
        Boolean isAcctMaint = true;
        
        String length255key = '';
        for(Integer i = 0; i < 255; i++){
            length255key+='Z';
        }

        String length100key ='';
        for(Integer i = 0; i < 100; i++){
            length100key+='A';
        }
        
        Encryption_Key__c testKey = new Encryption_Key__c();
        testKey.Name = 'Test Key';
        testKey.Encryption_Key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        testKey.SetupOwnerId = integrationProfile.Id;
        insert testKey;
        
        String unencryptedSecretKey = 'secretkey';
        Blob cipherText = Crypto.encryptWithManagedIV('AES256', EncodingUtil.base64Decode(testKey.Encryption_Key__c), Blob.valueOf(unencryptedSecretKey));
        String encryptedMessage = EncodingUtil.base64Encode(cipherText);

        SharePointOAuthTEST__c testAuth = new SharePointOAuthTEST__c ();
        testAuth.Name = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        testAuth.Access_Token_1__c=length255key;
        testAuth.Access_Token_2__c=length255key;
        testAuth.Access_Token_3__c=length255key;
        testAuth.Access_Token_4__c=length255key;
        testAuth.Access_Token_5__c='Z';
        testAuth.Refresh_Token_1__c=length100key;
        testAuth.Refresh_Token_2__c=length100key;
        testAuth.Client_ID__c='ABCDEFGHIJK1234567890';
        testAuth.Client_Secret__c=encryptedMessage;
        testAuth.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        
        //SFDC-5096 Add code for testing Acct. Maintenance
        
        SPOAuthTestReqHub__c testReqHubAuth = new SPOAuthTestReqHub__c();
        testReqHubAuth.Name = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        testReqHubAuth.Access_Token_1__c=length255key;
        testReqHubAuth.Access_Token_2__c=length255key;
        testReqHubAuth.Access_Token_3__c=length255key;
        testReqHubAuth.Access_Token_4__c=length255key;
        testReqHubAuth.Access_Token_5__c='Z';
        testReqHubAuth.Refresh_Token_1__c=length100key;
        testReqHubAuth.Refresh_Token_2__c=length100key;
        testReqHubAuth.Client_ID__c='ABCDEFGHIJK1234567890';
        testReqHubAuth.Client_Secret__c=encryptedMessage;
        testReqHubAuth.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        
        SharePointOAuthReqHub__c ReqHubAuth = new SharePointOAuthReqHub__c();
        ReqHubAuth.Name = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
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
        
        
        SharePointOAuth__c oAuth = new SharePointOAuth__c();
        oAuth.Name = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        oAuth.Access_Token_1__c=length255key;
        oAuth.Access_Token_2__c=length255key;
        oAuth.Access_Token_3__c=length255key;
        oAuth.Access_Token_4__c=length255key;
        oAuth.Access_Token_5__c='Z';
        oAuth.Refresh_Token_1__c=length100key;
        oAuth.Refresh_Token_2__c=length100key;
        oAuth.Client_ID__c='ABCDEFGHIJK1234567890';
        oAuth.Client_Secret__c=encryptedMessage;
        oAuth.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();

        List<SharePointOAuthTEST__c> spOAuthTEST = new List<SharePointOAuthTEST__c>{testAuth};
        List<SharePointOAuth__c> spOAuth = new List<SharePointOAuth__c>{oAuth};
        //SFDC-5096
        List<SPOAuthTestReqHub__c> spOAuthTESTReqHub = new List<SPOAuthTestReqHub__c>{testReqHubAuth}; 
        //List<SharePointOAuthReqHub__c> spOAuthReqHub = new List<SharePointOAuthReqHub__c>{ReqHubAuth};

        fflib_ApexMocks customSettingMocks = new fflib_ApexMocks();

        CustomSettingDAO.ICustomSettingDAO customSettingMockDAO; 
        customSettingMockDAO = new MockDAOs.CustomSettingDAOMock(customSettingMocks);
        
        customSettingMocks.startStubbing();
        
        OrganizationDAO.IOrganizationDAO organizationDAOInstance = new OrganizationDAO();
        SharePointOAuthTEST__c cs = new SharePointOAuthTEST__c();        
        if (!organizationDAOInstance.isRunningInSandbox()) {
          if (isAcctMaint == true) {
            customSettingMocks.when(customSettingMockDAO.getSPOAuthSettingsReqHub(integrationProfile.Id))
                          .thenReturn(ReqHubAuth);
                        //.thenReturn(spOAuthReqHub);
          }
          else
          {
            customSettingMocks.when(customSettingMockDAO.getSharePointOAuthSettings(integrationProfile.Id))
                        .thenReturn(spOAuth);
           }             
        } else {
           if (isAcctMaint == true) {
           customSettingMocks.when(customSettingMockDAO.getAllSharePointOAuthsRqHub())
                        .thenReturn(spOAuthTESTReqHub);
           }
           else {  
            customSettingMocks.when(customSettingMockDAO.getAllSharePointOAuths())
                        .thenReturn(spOAuthTEST);
                        }
        }
        
        
        customSettingMocks.stopStubbing();

        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getEncryptionKeyCSByProfileId(integrationProfile.Id))
                        .thenReturn(testKey);
        customSettingMocks.stopStubbing();

        SharePointConfiguration spc = new SharePointConfiguration(customSettingMockDAO, new CustomMetadataTypeDAO(),
                                                         new OrganizationDAO(), new EncryptionUtility(), new ProfileDAO(),isAcctMaint);

        SharePoint_Configuration__mdt sharePointConfig;
        if (!spc.organizationDAOInstance.isRunningInSandbox()) {
          if (isAcctMaint == true) {
           sharePointConfig = spc.customMetadatTypeDAOInstance.getSharePointConfigurationByName(SharePointConfiguration.SP_PRODRQHUB_CONFIG);
          }
          else{ 
            sharePointConfig = spc.customMetadatTypeDAOInstance.getSharePointConfigurationByName(SharePointConfiguration.SHAREPOINT_PROD_CONFIG);
            }
        } else {
          if (isAcctMaint == true) {
           sharePointConfig = spc.customMetadatTypeDAOInstance.getSharePointConfigurationByName(SharePointConfiguration.SP_TESTRQHUB_CONFIG);
          }
          else{
            sharePointConfig = spc.customMetadatTypeDAOInstance.getSharePointConfigurationByName(SharePointConfiguration.SHAREPOINT_TEST_CONFIG);
            }
        }

        String gemsContentTypeId = spc.getGEMSContentTypeId();
        System.assertEquals(sharePointConfig.GEMS_Content_Type_Id__c, gemsContentTypeId);

        String lgnaContentTypeId = spc.getLGNAContentTypeId();
        System.assertEquals(sharePointConfig.Content_Type_Id__c, lgnaContentTypeId);

        String spListItemName = spc.getSharePointListItemName();
        System.assertEquals(sharePointConfig.List_Item_Name__c, spListItemName);

        String tokenExpiredText = spc.getTokenExpiredResponseText();
        System.assertEquals(sharePointConfig.Token_Expired_Response_Text__c, tokenExpiredText);

        String findFolderURL = spc.getFindFolderURL();
        System.assertEquals(sharePointConfig.Find_Folder_URL__c, findFolderURL);

        String viewURLPath = spc.getViewURLPath();
        System.assertEquals(sharePointConfig.View_URL_Path__c, viewURLPath);

        String teamURLPath = spc.getTeamURLPath();
        System.assertEquals(sharePointConfig.Team_Path__c, teamURLPath);
        
        String listName = spc.getListName();
        System.assertEquals(sharePointConfig.List_Name__c, listName);

        String siteRealm = spc.getSiteRealm();
        System.assertEquals(sharePointConfig.Site_Realm__c, siteRealm);

        String siteResource = spc.getSiteResource();
        System.assertEquals(sharePointConfig.SharePoint_Resource__c, siteResource);

        String redirectURI = spc.getRedirectURI();
       // System.assertEquals('https%3A%2F%2F' + System.URL.getSalesforceBaseUrl().getHost().toLowerCase() + '%2Fapex%2FSharePointRefreshTokenPageReqHub', redirectURI);

        String resource = spc.getResource();
        String assembledResource = sharePointConfig.SharePoint_Resource__c+'/'+
                                    sharePointConfig.SharePoint_URL__c.remove(sharePointConfig.SharePoint_URL__c.left(8))+
                                    '@'+sharePointConfig.Site_Realm__c;
        System.assertEquals(assembledResource, resource);

        String clientId = 'ABCDEFGHIJK1234567890';
        System.assertEquals(testReqHubAuth.Client_ID__c, clientId);

        String clientSecret = spc.getClientSecret();
        System.assertEquals(spc.encryptionUtilityInstance.getDecryptedMessage(testReqHubAuth.Client_Secret__c), clientSecret);       
        System.debug(testReqHubAuth.Client_Secret__c);

        String accessToken = spc.getAccessToken();
        System.assertEquals(testReqHubAuth.Access_Token_1__c+testReqHubAuth.Access_Token_2__c+
                                testReqHubAuth.Access_Token_3__c+testReqHubAuth.Access_Token_4__c+
                                testReqHubAuth.Access_Token_5__c, accessToken);

        String refreshToken = spc.getRefreshToken();
        System.assertEquals(testReqHubAuth.Refresh_Token_1__c+testReqHubAuth.Refresh_Token_2__c, refreshToken);

        String sharepointURL = spc.getSharePointURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c, sharepointURL);

        String teamSharepointURL = spc.getTeamSharePointURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.Team_Path__c, teamSharepointURL);

        String realmURL = spc.getRealmURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.Realm_Path__c, realmURL);

        String authURL = spc.getAuthURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.Team_Path__c+sharePointConfig.Auth_URL_Path__c, authURL);

        String refreshTokenURL = spc.getRefreshTokenURL();
        System.assertEquals(sharePointConfig.Token_URL__c.replace(SharePointConfiguration.SITE_REALM, sharePointConfig.Site_Realm__c), refreshTokenURL);

        String listURL = spc.getListURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.List_URL_Path__c, listURL);

        String createURLPath = spc.getCreateURLPath();
        System.assertEquals(sharePointConfig.Create_URL_Path__c, createURLPath);

        String updateURLPath = spc.getUpdateURLPath();
        System.assertEquals(sharePointConfig.Update_URL_Path__c, updateURLPath);

        String deleteURL = spc.getDeleteURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.List_URL_Path__c, deleteURL);

        String updateURL = spc.getUpdateURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.List_URL_Path__c, listURL);

        String createURL = spc.getCreateURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.List_URL_Path__c, listURL);
    }
    
    /* SFDC-4784 - 12/2017 - BEGIN */
    /* Copy of SharePointConfigurationConstructorTest1 updated for LGNA Quote Request effort */
    @isTest static void SharePointConfigurationConstructorTest2(){
        
        ProfileDAO profileDAOInstance = new ProfileDAO();
        Profile integrationProfile = profileDAOInstance.getProfileByName(System.Label.ProfileIntegrationProfile);
        User integrationUser = TestClassUtiltity.CreateUserRecord(integrationProfile.Id, 'testUsername@intTest.com', 'test', 'testEmail@intTest.com');        
        String callingSource = 'LGNAQuoteRq';
        
        String length255key = '';
        for(Integer i = 0; i < 255; i++){
            length255key+='Z';
        }
        
        String length100key ='';
        for(Integer i = 0; i < 100; i++){
            length100key+='A';
        }
        
        Encryption_Key__c testKey = new Encryption_Key__c();
        testKey.Name = 'Test Key';
        testKey.Encryption_Key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        testKey.SetupOwnerId = integrationProfile.Id;
        insert testKey;
        
        String unencryptedSecretKey = 'secretkey';
        Blob cipherText = Crypto.encryptWithManagedIV('AES256', EncodingUtil.base64Decode(testKey.Encryption_Key__c), Blob.valueOf(unencryptedSecretKey));
        String encryptedMessage = EncodingUtil.base64Encode(cipherText);
        
        SharePointOAuthTEST__c testAuth = new SharePointOAuthTEST__c ();
        testAuth.Name = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        testAuth.Access_Token_1__c=length255key;
        testAuth.Access_Token_2__c=length255key;
        testAuth.Access_Token_3__c=length255key;
        testAuth.Access_Token_4__c=length255key;
        testAuth.Access_Token_5__c='Z';
        testAuth.Refresh_Token_1__c=length100key;
        testAuth.Refresh_Token_2__c=length100key;
        testAuth.Client_ID__c='ABCDEFGHIJK1234567890';
        testAuth.Client_Secret__c=encryptedMessage;
        testAuth.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();       
        
        SPOAuthTestReqHub__c testReqHubAuth = new SPOAuthTestReqHub__c();
        testReqHubAuth.Name = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        testReqHubAuth.Access_Token_1__c=length255key;
        testReqHubAuth.Access_Token_2__c=length255key;
        testReqHubAuth.Access_Token_3__c=length255key;
        testReqHubAuth.Access_Token_4__c=length255key;
        testReqHubAuth.Access_Token_5__c='Z';
        testReqHubAuth.Refresh_Token_1__c=length100key;
        testReqHubAuth.Refresh_Token_2__c=length100key;
        testReqHubAuth.Client_ID__c='ABCDEFGHIJK1234567890';
        testReqHubAuth.Client_Secret__c=encryptedMessage;
        testReqHubAuth.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        
        SharePointOAuthReqHub__c ReqHubAuth = new SharePointOAuthReqHub__c();
        ReqHubAuth.Name = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
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
        
        SharePointOAuth__c oAuth = new SharePointOAuth__c();
        oAuth.Name = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        oAuth.Access_Token_1__c=length255key;
        oAuth.Access_Token_2__c=length255key;
        oAuth.Access_Token_3__c=length255key;
        oAuth.Access_Token_4__c=length255key;
        oAuth.Access_Token_5__c='Z';
        oAuth.Refresh_Token_1__c=length100key;
        oAuth.Refresh_Token_2__c=length100key;
        oAuth.Client_ID__c='ABCDEFGHIJK1234567890';
        oAuth.Client_Secret__c=encryptedMessage;
        oAuth.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        
        SharePoint_TEST_HeronQuotes__c QuoteReqAuth = new SharePoint_TEST_HeronQuotes__c();
        QuoteReqAuth.Name = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
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
        
		SharePoint_PROD_HeronQuotes__c QuoteReqProdAuth = new SharePoint_PROD_HeronQuotes__c();
        QuoteReqProdAuth.Name = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        QuoteReqProdAuth.Access_Token_1__c=length255key;
        QuoteReqProdAuth.Access_Token_2__c=length255key;
        QuoteReqProdAuth.Access_Token_3__c=length255key;
        QuoteReqProdAuth.Access_Token_4__c=length255key;
        QuoteReqProdAuth.Access_Token_5__c='Z';
        QuoteReqProdAuth.Refresh_Token_1__c=length100key;
        QuoteReqProdAuth.Refresh_Token_2__c=length100key;
        QuoteReqProdAuth.Client_ID__c='ABCDEFGHIJK1234567890';
        QuoteReqProdAuth.Client_Secret__c=encryptedMessage;
        QuoteReqProdAuth.Redirect_URI__c = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
        
        List<SharePointOAuthTEST__c> spOAuthTEST = new List<SharePointOAuthTEST__c>{testAuth};
            List<SharePointOAuth__c> spOAuth = new List<SharePointOAuth__c>{oAuth};
                List<SPOAuthTestReqHub__c> spOAuthTESTReqHub = new List<SPOAuthTestReqHub__c>{testReqHubAuth};                              
                    List<SharePoint_TEST_HeronQuotes__c> spOAuthTESTQuoteReq = new List<SharePoint_TEST_HeronQuotes__c>{QuoteReqAuth};
                        
                        fflib_ApexMocks customSettingMocks = new fflib_ApexMocks();
        
        CustomSettingDAO.ICustomSettingDAO customSettingMockDAO; 
        customSettingMockDAO = new MockDAOs.CustomSettingDAOMock(customSettingMocks);
        
        customSettingMocks.startStubbing();
        
        OrganizationDAO.IOrganizationDAO organizationDAOInstance = new OrganizationDAO();
        SharePointOAuthTEST__c cs = new SharePointOAuthTEST__c();        
        if (!organizationDAOInstance.isRunningInSandbox()) {
            if (callingSource == 'LGNAQuoteRq') {
                customSettingMocks.when(customSettingMockDAO.getSPOAuthSettingsQuoteRq(integrationProfile.Id))
                    .thenReturn(QuoteReqProdAuth);
            }
            else
            {
                customSettingMocks.when(customSettingMockDAO.getSharePointOAuthSettings(integrationProfile.Id))
                    .thenReturn(spOAuth);
            }             
        } else {
            if (callingSource == 'LGNAQuoteRq') {
                customSettingMocks.when(customSettingMockDAO.getAllSharePointOAuthsQuoteRq())
                    .thenReturn(spOAuthTESTQuoteReq);
            }
            else {  
                customSettingMocks.when(customSettingMockDAO.getAllSharePointOAuths())
                    .thenReturn(spOAuthTEST);
            }
        }
        
        
        customSettingMocks.stopStubbing();
        
        customSettingMocks.startStubbing();
        customSettingMocks.when(customSettingMockDAO.getEncryptionKeyCSByProfileId(integrationProfile.Id))
            .thenReturn(testKey);
        customSettingMocks.stopStubbing();
        
        SharePointConfiguration spc = new SharePointConfiguration(customSettingMockDAO, new CustomMetadataTypeDAO(),
                                                                  new OrganizationDAO(), new EncryptionUtility(), new ProfileDAO(),callingSource);
        
        SharePoint_Configuration__mdt sharePointConfig;
        if (!spc.organizationDAOInstance.isRunningInSandbox()) {
            if (callingSource == 'LGNAQuoteRq') {
                sharePointConfig = spc.customMetadatTypeDAOInstance.getSharePointConfigurationByName(SharePointConfiguration.SP_PRODQUOTERQ_CONFIG);
            }
            else{ 
                sharePointConfig = spc.customMetadatTypeDAOInstance.getSharePointConfigurationByName(SharePointConfiguration.SHAREPOINT_PROD_CONFIG);
            }
        } else {
            if (callingSource == 'LGNAQuoteRq') {
                sharePointConfig = spc.customMetadatTypeDAOInstance.getSharePointConfigurationByName(SharePointConfiguration.SP_TESTQUOTERQ_CONFIG);
            }
            else{
                sharePointConfig = spc.customMetadatTypeDAOInstance.getSharePointConfigurationByName(SharePointConfiguration.SHAREPOINT_TEST_CONFIG);
            }
        }
        
        String gemsContentTypeId = spc.getGEMSContentTypeId();
        System.assertEquals(sharePointConfig.GEMS_Content_Type_Id__c, gemsContentTypeId);
        
        String lgnaContentTypeId = spc.getLGNAContentTypeId();
        System.assertEquals(sharePointConfig.Content_Type_Id__c, lgnaContentTypeId);
        
        String spListItemName = spc.getSharePointListItemName();
        System.assertEquals(sharePointConfig.List_Item_Name__c, spListItemName);
        
        String tokenExpiredText = spc.getTokenExpiredResponseText();
        System.assertEquals(sharePointConfig.Token_Expired_Response_Text__c, tokenExpiredText);
        
        String findFolderURL = spc.getFindFolderURL();
        System.assertEquals(sharePointConfig.Find_Folder_URL__c, findFolderURL);
        
        String viewURLPath = spc.getViewURLPath();
        System.assertEquals(sharePointConfig.View_URL_Path__c, viewURLPath);
        
        String teamURLPath = spc.getTeamURLPath();
        System.assertEquals(sharePointConfig.Team_Path__c, teamURLPath);
        
        String listName = spc.getListName();
        System.assertEquals(sharePointConfig.List_Name__c, listName);
        
        String siteRealm = spc.getSiteRealm();
        System.assertEquals(sharePointConfig.Site_Realm__c, siteRealm);
        
        String siteResource = spc.getSiteResource();
        System.assertEquals(sharePointConfig.SharePoint_Resource__c, siteResource);
        
        String redirectURI = spc.getRedirectURI();        
        
        String resource = spc.getResource();
        String assembledResource = sharePointConfig.SharePoint_Resource__c+'/'+
            sharePointConfig.SharePoint_URL__c.remove(sharePointConfig.SharePoint_URL__c.left(8))+
            '@'+sharePointConfig.Site_Realm__c;
        System.assertEquals(assembledResource, resource);
        
        String clientId = 'ABCDEFGHIJK1234567890';
        System.assertEquals(QuoteReqAuth.Client_ID__c, clientId);
        
        String clientSecret = spc.getClientSecret();
        System.assertEquals(spc.encryptionUtilityInstance.getDecryptedMessage(QuoteReqAuth.Client_Secret__c), clientSecret);       
        System.debug(QuoteReqAuth.Client_Secret__c);
        
        String accessToken = spc.getAccessToken();
        System.assertEquals(QuoteReqAuth.Access_Token_1__c+QuoteReqAuth.Access_Token_2__c+
                            QuoteReqAuth.Access_Token_3__c+QuoteReqAuth.Access_Token_4__c+
                            QuoteReqAuth.Access_Token_5__c, accessToken);
        
        String refreshToken = spc.getRefreshToken();
        System.assertEquals(QuoteReqAuth.Refresh_Token_1__c+QuoteReqAuth.Refresh_Token_2__c, refreshToken);
        
        String sharepointURL = spc.getSharePointURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c, sharepointURL);
        
        String teamSharepointURL = spc.getTeamSharePointURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.Team_Path__c, teamSharepointURL);
        
        String realmURL = spc.getRealmURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.Realm_Path__c, realmURL);
        
        String authURL = spc.getAuthURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.Team_Path__c+sharePointConfig.Auth_URL_Path__c, authURL);
        
        String refreshTokenURL = spc.getRefreshTokenURL();
        System.assertEquals(sharePointConfig.Token_URL__c.replace(SharePointConfiguration.SITE_REALM, sharePointConfig.Site_Realm__c), refreshTokenURL);
        
        String listURL = spc.getListURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.List_URL_Path__c, listURL);
        
        String createURLPath = spc.getCreateURLPath();
        System.assertEquals(sharePointConfig.Create_URL_Path__c, createURLPath);
        
        String updateURLPath = spc.getUpdateURLPath();
        System.assertEquals(sharePointConfig.Update_URL_Path__c, updateURLPath);
        
        String deleteURL = spc.getDeleteURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.List_URL_Path__c, deleteURL);
        
        String updateURL = spc.getUpdateURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.List_URL_Path__c, listURL);
        
        String createURL = spc.getCreateURL();
        System.assertEquals(sharePointConfig.SharePoint_URL__c+sharePointConfig.List_URL_Path__c, listURL);
        
        
    }
    /* SFDC-4784 - 12/2017 - END */
    
}