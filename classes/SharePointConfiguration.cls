/***********************************************************************************************************
* Apex Class Name     : SharePointConfiguration
* Version             : 1.0
* Function            : Class builds the configuration data for the SharePoint server connections.
* Modification Log    :
* Developer				Date			Description
* ----------------------------------------------------------------------------
* Sana Fatima/Slalom					Initial version creation
* Malathi Kethireddy	09/22/17		SFDC-5096 - Account Maintenance SharePoint
* Zachary Campbell		12/22/17		SFDC-4784 - Quote Request SharePoint
***********************************************************************************************************/
public class SharePointConfiguration{
    
    private String accessToken;
    private String refreshToken;
    private String realmURL;
    private String sharePointURL;
    private String realmPath;
    private String siteRealm;
    private String authURL;
    private String listURLPath;
    private String updateURLPath;
    private String deletetURLPath;
    private String createURLPath;
    private String listURL;
    private String updateURL;
    private String deletetURL;
    private String createURL;
    private String teamURLPath;
    private String authURLPath;
    private String tokenURL;
    private String refreshTokenURL;
    private String deleteURLPath;
    private String deleteURL;
    private String sharePointTeamURL;
    private String redirectURI;
    private String clientId;
    private String clientSecret;
    private String sharePointResource;
    private String siteResource;
    private String listName;
    private String viewURLPath;
    private String findFolderURL;
    private String findFilesURL;
    private String tokenExpiredText;
    private String listItemName;
    private String contentTypeId;        
    private String gemsContentTypeId;
    private Boolean isActMaint = false; 
    private String callingSource;
    
    private SharePointOAuth__c oAuthSettings;
    private SharePointOAuthTEST__c oAuthTestSettings;
    //SFDC-5096 New OAuth for Request Hub
    private SharePointOAuthReqHub__c oAuthSettingsReqHub;
    private SPOAuthTestReqHub__c oAuthTestReqHubSettings;
    private SharePoint_Configuration__mdt sharePointConfig;
    //SFDC-4784 New OAuth for Request Quote    
    private SharePoint_PROD_HeronQuotes__c oAuthSettingsQuoteRq;
    private SharePoint_TEST_HeronQuotes__c oAuthTestQuoteRqSettings;
    
    public static final String SITE_REALM = '<site_realm>';
    public static final String SHAREPOINT_PROD_CONFIG = 'SharePoint_PROD';
    public static final String SHAREPOINT_TEST_CONFIG = 'SharePoint_TEST';
    //SDFC-5096 Malathi.K Define SP Config for Account Maintenance
    public static final String SP_PRODRQHUB_CONFIG = 'SharePoint_PROD_Rqst_Hub';
    public static final String SP_TESTRQHUB_CONFIG = 'SharePoint_TEST_Rqst_Hub';
    //SDFC-4784 - Define SP Config for Request Quote      
    public static final String SP_PRODQUOTERQ_CONFIG = 'SharePoint_PROD_HeronQuotes';
    public static final String SP_TESTQUOTERQ_CONFIG = 'SharePoint_TEST_HeronQuotes';         
    
    @TestVisible private CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance {get; set;}
    @TestVisible private CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance {get; set;}
    @TestVisible private OrganizationDAO.IOrganizationDAO organizationDAOInstance {get; set;}
    @TestVisible private EncryptionUtility.IEncryptionUtility encryptionUtilityInstance {get; set;}
    @TestVisible private ProfileDAO.IProfileDAO  profileDAOInstance {get; set;}
    
    public SharePointConfiguration(){
        this(new CustomSettingDAO(), new CustomMetadataTypeDAO(), new OrganizationDAO(), new EncryptionUtility(), new ProfileDAO());
    }
    //SFDC-5096 Malathi.K
    public SharePointConfiguration(Boolean isAcctMaint) {
        this(new CustomSettingDAO(), new CustomMetadataTypeDAO(), new OrganizationDAO(), new EncryptionUtility(), new ProfileDAO(), isAcctMaint);
    }
    
    //SFDC-4784
    public SharePointConfiguration(String callingSource) {
        this(new CustomSettingDAO(), new CustomMetadataTypeDAO(), new OrganizationDAO(), new EncryptionUtility(), new ProfileDAO(), callingSource);
    }
    
    @TestVisible private SharePointConfiguration(CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance,
                                                 CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance,
                                                 OrganizationDAO.IOrganizationDAO organizationDAOInstance,
                                                 EncryptionUtility.IEncryptionUtility encryptionUtilityInstance,
                                                 ProfileDAO.IProfileDAO profileDAOInstance){
                                                     system.debug('non account maintenance');
                                                     this.customSettingDAOInstance = customSettingDAOInstance;
                                                     this.customMetadatTypeDAOInstance = customMetadatTypeDAOInstance;
                                                     this.organizationDAOInstance = organizationDAOInstance;
                                                     this.encryptionUtilityInstance = encryptionUtilityInstance;
                                                     this.profileDAOInstance = profileDAOInstance;
                                                     this.isActMaint = false;
                                                     
                                                     Id intProfileId = profileDAOInstance.getProfileByName(System.Label.ProfileIntegrationProfile).Id;
                                                     Id profileId;
                                                     
                                                     String orgDomain = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
                                                     List<SharePointOAuthTEST__c> spOAuthRouter;
                                                     
                                                     if (!organizationDAOInstance.isRunningInSandbox()) {
                                                         profileId = intProfileId;                           
                                                         sharePointConfig = customMetadatTypeDAOInstance.getSharePointConfigurationByName(SHAREPOINT_PROD_CONFIG);                
                                                         oAuthSettings = customSettingDAOInstance.getSharePointOAuthSettings(profileId);               
                                                     } else {
                                                         spOAuthRouter = customSettingDAOInstance.getAllSharePointOAuths();
                                                         profileId = profileDAOInstance.getProfileByName(System.Label.System_Admin_Profile).Id;
                                                         
                                                         for(SharePointOAuthTEST__c oauth: spOAuthRouter){
                                                             //System.debug('orgDomain - ' + orgDomain + '        oauth.Name' + oauth.Name);
                                                             if(orgDomain.contains(oauth.Name)){
                                                                 oAuthTestSettings = oauth;
                                                             }
                                                         }
                                                         sharePointConfig = customMetadatTypeDAOInstance.getSharePointConfigurationByName(SHAREPOINT_TEST_CONFIG);                    
                                                     }
                                                     
                                                     Encryption_Key__c encryptionKey = customSettingDAOInstance.getEncryptionKeyCSByProfileId(intProfileId);
                                                     Blob cryptoKey = EncodingUtil.base64Decode(encryptionKey.Encryption_Key__c);
                                                     
                                                     sharePointURL = sharePointConfig.SharePoint_URL__c;
                                                     realmPath = sharePointConfig.Realm_Path__c;
                                                     realmURL = sharePointURL + realmPath;
                                                     
                                                     teamURLPath   = sharePointConfig.Team_Path__c;
                                                     sharePointTeamURL = sharePointURL + teamURLPath;
                                                     
                                                     authURLPath   = sharePointConfig.Auth_URL_Path__c;
                                                     authURL = sharePointURL + teamURLPath + authURLPath;
                                                     
                                                     tokenURL = sharePointConfig.Token_URL__c;
                                                     //System.debug('token url in spconfig: '+tokenURL);
                                                     siteRealm = sharePointConfig.Site_Realm__c;
                                                     //System.debug('site realm in spconfig: '+siteRealm);
                                                     if ( siteRealm != null ) {                                             
                                                         refreshTokenURL = tokenURL.replace(SITE_REALM,siteRealm);
                                                     }
                                                     
                                                     listURLPath   = sharePointConfig.List_URL_Path__c;
                                                     listURL = sharePointURL + listURLPath;
                                                     
                                                     deleteURLPath = sharePointConfig.Delete_URL_Path__c;
                                                     deleteURL = sharePointURL + listURLPath;
                                                     
                                                     updateURLPath = sharePointConfig.Update_URL_Path__c;
                                                     updateURL = sharePointURL + listURLPath;
                                                     
                                                     createURLPath = sharePointConfig.Create_URL_Path__c;
                                                     createURL = sharePointURL + listURLPath;
                                                     
                                                     siteResource   = sharePointConfig.SharePoint_Resource__c;
                                                     sharePointResource = siteResource + '/' + sharePointURL.remove(sharePointURL.left(8)) + '@' + siteRealm;
                                                     //System.debug('SHAREPOINT - ' + sharePointResource);
                                                     findFolderURL = sharePointConfig.Find_Folder_URL__c;
                                                     
                                                     findFilesURL = sharePointConfig.Find_Files_URL__c;
                                                     
                                                     viewURLPath = sharePointConfig.View_URL_Path__c;
                                                     
                                                     listName = sharePointConfig.List_Name__c;
                                                     
                                                     tokenExpiredText = sharePointConfig.Token_Expired_Response_Text__c;
                                                     
                                                     listItemName = sharePointConfig.List_Item_Name__c;
                                                     
                                                     contentTypeId = sharePointConfig.Content_Type_Id__c;
                                                     
                                                     gemsContentTypeId = sharePointConfig.GEMS_Content_Type_Id__c;
                                                     
                                                     if(!organizationDAOInstance.isRunningInSandbox()){
                                                         if(oAuthSettings.Access_Token_1__c != null) {
                                                             accessToken  = oAuthSettings.Access_Token_1__c;
                                                         }
                                                         if(oAuthSettings.Access_Token_2__c != null) {
                                                             accessToken  += oAuthSettings.Access_Token_2__c;
                                                         }
                                                         if(oAuthSettings.Access_Token_3__c != null) {
                                                             accessToken  += oAuthSettings.Access_Token_3__c;
                                                         }
                                                         if(oAuthSettings.Access_Token_4__c != null) {
                                                             accessToken  += oAuthSettings.Access_Token_4__c;
                                                         }
                                                         if(oAuthSettings.Access_Token_5__c != null) {
                                                             accessToken  += oAuthSettings.Access_Token_5__c;
                                                         }
                                                         if(oAuthSettings.Refresh_Token_1__c != null) {
                                                             refreshToken = oAuthSettings.Refresh_Token_1__c;
                                                         }
                                                         if(oAuthSettings.Refresh_Token_2__c != null) {
                                                             refreshToken += oAuthSettings.Refresh_Token_2__c;
                                                         }
                                                         if(oAuthSettings.Redirect_URI__c != null) {
                                                             redirectURI = oAuthSettings.Redirect_URI__c;
                                                         }
                                                     } else {
                                                         if(oAuthTestSettings.Access_Token_1__c != null) {
                                                             accessToken  = oAuthTestSettings.Access_Token_1__c;
                                                         }
                                                         if(oAuthTestSettings.Access_Token_2__c != null) {
                                                             accessToken  += oAuthTestSettings.Access_Token_2__c;
                                                         }
                                                         if(oAuthTestSettings.Access_Token_3__c != null) {
                                                             accessToken  += oAuthTestSettings.Access_Token_3__c;
                                                         }
                                                         if(oAuthTestSettings.Access_Token_4__c != null) {
                                                             accessToken  += oAuthTestSettings.Access_Token_4__c;
                                                         }
                                                         if(oAuthTestSettings.Access_Token_5__c != null) {
                                                             accessToken  += oAuthTestSettings.Access_Token_5__c;
                                                         }
                                                         if (oAuthTestSettings.Refresh_Token_1__c != null) {
                                                             refreshToken = oAuthTestSettings.Refresh_Token_1__c;
                                                         }
                                                         if (oAuthTestSettings.Refresh_Token_2__c != null) {
                                                             refreshToken += oAuthTestSettings.Refresh_Token_2__c;
                                                         }
                                                         if (oAuthTestSettings.Redirect_URI__c != null) {
                                                             redirectURI = oAuthTestSettings.Redirect_URI__c;
                                                         }
                                                     }
                                                     
                                                     if(oAuthSettings != null && oAuthSettings.Client_Id__c != null){
                                                         clientId = oAuthSettings.Client_Id__c;
                                                     } else if(oAuthTestSettings != null && oAuthTestSettings.Client_Id__c != null) {
                                                         clientId = oAuthTestSettings.Client_Id__c;
                                                     }
                                                 }
    
    //SFDC-5096 - Added for Account Maintenance.
    @TestVisible private SharePointConfiguration(CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance,
                                                 CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance,
                                                 OrganizationDAO.IOrganizationDAO organizationDAOInstance,
                                                 EncryptionUtility.IEncryptionUtility encryptionUtilityInstance,
                                                 ProfileDAO.IProfileDAO profileDAOInstance,
                                                 Boolean isAcctMaint){
                                                     this.customSettingDAOInstance = customSettingDAOInstance;
                                                     this.customMetadatTypeDAOInstance = customMetadatTypeDAOInstance;
                                                     this.organizationDAOInstance = organizationDAOInstance;
                                                     this.encryptionUtilityInstance = encryptionUtilityInstance;
                                                     this.profileDAOInstance = profileDAOInstance;
                                                     this.isActMaint = isAcctMaint;
                                                     
                                                     Id intProfileId = profileDAOInstance.getProfileByName(System.Label.ProfileIntegrationProfile).Id;
                                                     Id profileId;
                                                                                                          
                                                     String orgDomain = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
                                                     List<SharePointOAuthTEST__c> spOAuthRouter;
                                                     List<SPOAuthTestReqHub__c> spOAuthRouterRqhub;
                                                     
                                                     if (!organizationDAOInstance.isRunningInSandbox()) {
                                                         profileId = intProfileId;
                                                         if (isAcctMaint == true) {
                                                             system.debug('Acc maint Prod. instance ');                 
                                                             sharePointConfig = customMetadatTypeDAOInstance.getSharePointConfigurationByName(SP_PRODRQHUB_CONFIG);
                                                             oAuthSettingsReqHub = customSettingDAOInstance.getSPOAuthSettingsReqHub(profileId);
                                                         }                
                                                     } else {
                                                         if (isAcctMaint == true) {
                                                             system.debug('acc maint sandbox: ');
                                                             spOAuthRouterRqhub = customSettingDAOInstance.getAllSharePointOAuthsRqHub();
                                                             profileId = profileDAOInstance.getProfileByName(System.Label.System_Admin_Profile).Id;
                                                             
                                                             for(SPOAuthTestReqHub__c oauth: spOAuthRouterRqhub){
                                                                 //System.debug('orgDomain - ' + orgDomain + '        oauth.Name' + oauth.Name);
                                                                 if(orgDomain.contains(oauth.Name)){
                                                                     oAuthTestReqHubSettings = oauth;
                                                                 }
                                                             } 
                                                             sharePointConfig = customMetadatTypeDAOInstance.getSharePointConfigurationByName(SP_TESTRQHUB_CONFIG);                                                                                         
                                                         }                        
                                                     }
                                                     
                                                     Encryption_Key__c encryptionKey = customSettingDAOInstance.getEncryptionKeyCSByProfileId(intProfileId);            
                                                     Blob cryptoKey = EncodingUtil.base64Decode(encryptionKey.Encryption_Key__c);
                                                     
                                                     sharePointURL = sharePointConfig.SharePoint_URL__c;
                                                     realmPath = sharePointConfig.Realm_Path__c;
                                                     realmURL = sharePointURL + realmPath;
                                                     
                                                     teamURLPath   = sharePointConfig.Team_Path__c;
                                                     sharePointTeamURL = sharePointURL + teamURLPath;
                                                     
                                                     authURLPath   = sharePointConfig.Auth_URL_Path__c;
                                                     authURL = sharePointURL + teamURLPath + authURLPath;
                                                     
                                                     tokenURL = sharePointConfig.Token_URL__c;
                                                     //System.debug('token url in spconfig: '+tokenURL);
                                                     siteRealm = sharePointConfig.Site_Realm__c;
                                                     //System.debug('site realm in spconfig: '+siteRealm);
                                                     if (siteRealm != null) {                                             
                                                         refreshTokenURL = tokenURL.replace(SITE_REALM,siteRealm);
                                                     }
                                                     
                                                     listURLPath = sharePointConfig.List_URL_Path__c;
                                                     listURL = sharePointURL + listURLPath;
                                                     
                                                     deleteURLPath = sharePointConfig.Delete_URL_Path__c;
                                                     deleteURL = sharePointURL + listURLPath;
                                                     
                                                     updateURLPath = sharePointConfig.Update_URL_Path__c;
                                                     updateURL = sharePointURL + listURLPath;
                                                     
                                                     createURLPath = sharePointConfig.Create_URL_Path__c;
                                                     createURL = sharePointURL + listURLPath;
                                                     
                                                     siteResource = sharePointConfig.SharePoint_Resource__c;
                                                     sharePointResource = siteResource + '/' + sharePointURL.remove(sharePointURL.left(8)) + '@' + siteRealm;
                                                     //System.debug('SHAREPOINT - ' + sharePointResource);
                                                     findFolderURL = sharePointConfig.Find_Folder_URL__c;
                                                     
                                                     findFilesURL = sharePointConfig.Find_Files_URL__c;
                                                     
                                                     viewURLPath = sharePointConfig.View_URL_Path__c;
                                                     
                                                     listName = sharePointConfig.List_Name__c;
                                                     
                                                     tokenExpiredText = sharePointConfig.Token_Expired_Response_Text__c;
                                                     
                                                     listItemName = sharePointConfig.List_Item_Name__c;
                                                     
                                                     contentTypeId = sharePointConfig.Content_Type_Id__c;
                                                     
                                                     gemsContentTypeId = sharePointConfig.GEMS_Content_Type_Id__c;                        
                                                     
                                                     //SFDC-5096 Add for Production Acct. Maint. later
                                                     if(!organizationDAOInstance.isRunningInSandbox()){
                                                         if (isAcctMaint == true) {
                                                             //system.debug('Acct. Maint. Prod. instance ');
                                                             if(oAuthSettingsReqHub.Access_Token_1__c != null) {
                                                                 accessToken  = oAuthSettingsReqHub.Access_Token_1__c;
                                                             }
                                                             if(oAuthSettingsReqHub.Access_Token_2__c != null) {
                                                                 accessToken  += oAuthSettingsReqHub.Access_Token_2__c;
                                                             }
                                                             if(oAuthSettingsReqHub.Access_Token_3__c != null) {
                                                                 accessToken  += oAuthSettingsReqHub.Access_Token_3__c;
                                                             }
                                                             if(oAuthSettingsReqHub.Access_Token_4__c != null) {
                                                                 accessToken  += oAuthSettingsReqHub.Access_Token_4__c;
                                                             }
                                                             if(oAuthSettingsReqHub.Access_Token_5__c != null) {
                                                                 accessToken  += oAuthSettingsReqHub.Access_Token_5__c;
                                                             }
                                                             if(oAuthSettingsReqHub.Refresh_Token_1__c != null) {
                                                                 refreshToken = oAuthSettingsReqHub.Refresh_Token_1__c;
                                                             }
                                                             if(oAuthSettingsReqHub.Refresh_Token_2__c != null) {
                                                                 refreshToken += oAuthSettingsReqHub.Refresh_Token_2__c;
                                                             }
                                                             if(oAuthSettingsReqHub.Redirect_URI__c != null) {
                                                                 redirectURI = oAuthSettingsReqHub.Redirect_URI__c;
                                                             }                                                                                                                                
                                                         }              
                                                     } else {                                                     
                                                         if (isAcctMaint == true) {
                                                             //system.debug('Acc maintenance sandbox: ');                                          
                                                             if(oAuthTestReqHubSettings.Access_Token_1__c != null) {
                                                                 accessToken  = oAuthTestReqHubSettings.Access_Token_1__c;
                                                             }
                                                             if(oAuthTestReqHubSettings.Access_Token_2__c != null) {
                                                                 accessToken  += oAuthTestReqHubSettings.Access_Token_2__c;
                                                             }
                                                             if(oAuthTestReqHubSettings.Access_Token_3__c != null) {
                                                                 accessToken  += oAuthTestReqHubSettings.Access_Token_3__c;
                                                             }
                                                             if(oAuthTestReqHubSettings.Access_Token_4__c != null) {
                                                                 accessToken  += oAuthTestReqHubSettings.Access_Token_4__c;
                                                             }
                                                             if(oAuthTestReqHubSettings.Access_Token_5__c != null) {
                                                                 accessToken  += oAuthTestReqHubSettings.Access_Token_5__c;
                                                             }                                          
                                                             if(oAuthTestReqHubSettings.Refresh_Token_1__c != null) {
                                                                 refreshToken = oAuthTestReqHubSettings.Refresh_Token_1__c;
                                                             }
                                                             if(oAuthTestReqHubSettings.Refresh_Token_2__c != null) {
                                                                 refreshToken += oAuthTestReqHubSettings.Refresh_Token_2__c;
                                                             }
                                                             system.debug('refresh token: '+ refreshToken);
                                                             if(oAuthTestReqHubSettings.Redirect_URI__c != null) {
                                                                 redirectURI = oAuthTestReqHubSettings.Redirect_URI__c;
                                                             }
                                                         }                  
                                                     }
                                                     
                                                     if(!organizationDAOInstance.isRunningInSandbox()){
                                                         if (isAcctMaint == true) {
                                                             if(oAuthSettingsReqHub != null && oAuthSettingsReqHub.Client_Id__c != null){
                                                                 clientId = oAuthSettingsReqHub.Client_Id__c;
                                                             }
                                                         }                          
                                                     } else {
                                                         if (isAcctMaint == true) {
                                                             if(oAuthTestReqHubSettings!= null && oAuthTestReqHubSettings.Client_Id__c != null) {
                                                                 clientId = oAuthTestReqHubSettings.Client_Id__c;
                                                             }
                                                         }                     
                                                     }        
                                                 }  
                                                //sfdc-5096 End
    
    //SFDC-4784
    @TestVisible private SharePointConfiguration(CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance,
                                                 CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance,
                                                 OrganizationDAO.IOrganizationDAO organizationDAOInstance,
                                                 EncryptionUtility.IEncryptionUtility encryptionUtilityInstance,
                                                 ProfileDAO.IProfileDAO profileDAOInstance,
                                                 String callingSource){
                                                     this.customSettingDAOInstance = customSettingDAOInstance;
                                                     this.customMetadatTypeDAOInstance = customMetadatTypeDAOInstance;
                                                     this.organizationDAOInstance = organizationDAOInstance;
                                                     this.encryptionUtilityInstance = encryptionUtilityInstance;
                                                     this.profileDAOInstance = profileDAOInstance;
                                                     this.callingSource = callingSource;
                                                     
                                                     Id intProfileId = profileDAOInstance.getProfileByName(System.Label.ProfileIntegrationProfile).Id;
                                                     Id profileId;
                                                     
                                                     String orgDomain = System.URL.getSalesforceBaseUrl().getHost().toLowerCase();
                                                     List<SharePointOAuthTEST__c> spOAuthRouter;
                                                     List<SharePoint_TEST_HeronQuotes__c> spOAuthRouterQuoteRq;
                                                     
                                                     if (!organizationDAOInstance.isRunningInSandbox()) {
                                                         profileId = intProfileId;
                                                         if (callingSource == 'LGNAQuoteRq') {
                                                             system.debug('Quote request Prod. instance ');                 
                                                             sharePointConfig = customMetadatTypeDAOInstance.getSharePointConfigurationByName(SP_PRODQUOTERQ_CONFIG);
                                                             oAuthSettingsQuoteRq = customSettingDAOInstance.getSPOAuthSettingsQuoteRq(profileId);
                                                         }                
                                                     } else {
                                                         if (callingSource == 'LGNAQuoteRq') {
                                                             system.debug('quote request sandbox: ');
                                                             spOAuthRouterQuoteRq = customSettingDAOInstance.getAllSharePointOAuthsQuoteRq();
                                                             profileId = profileDAOInstance.getProfileByName(System.Label.System_Admin_Profile).Id;
                                                             
                                                             for(SharePoint_TEST_HeronQuotes__c oauth: spOAuthRouterQuoteRq){
                                                                 //System.debug('orgDomain - ' + orgDomain + '        oauth.Name' + oauth.Name);
                                                                 if(orgDomain.contains(oauth.Name)){
                                                                     oAuthTestQuoteRqSettings = oauth;
                                                                 }
                                                             } 
                                                             sharePointConfig = customMetadatTypeDAOInstance.getSharePointConfigurationByName(SP_TESTQUOTERQ_CONFIG);                                                                                         
                                                         }                        
                                                     }
                                                     
                                                     Encryption_Key__c encryptionKey = customSettingDAOInstance.getEncryptionKeyCSByProfileId(intProfileId);            
                                                     Blob cryptoKey = EncodingUtil.base64Decode(encryptionKey.Encryption_Key__c);
                                                     
                                                     sharePointURL = sharePointConfig.SharePoint_URL__c;
                                                     realmPath = sharePointConfig.Realm_Path__c;
                                                     realmURL = sharePointURL + realmPath;
                                                     
                                                     teamURLPath   = sharePointConfig.Team_Path__c;
                                                     sharePointTeamURL = sharePointURL + teamURLPath;
                                                     
                                                     authURLPath   = sharePointConfig.Auth_URL_Path__c;
                                                     authURL = sharePointURL + teamURLPath + authURLPath;
                                                     
                                                     tokenURL = sharePointConfig.Token_URL__c;
                                                     //System.debug('token url in spconfig: '+tokenURL);
                                                     siteRealm = sharePointConfig.Site_Realm__c;
                                                     //System.debug('site realm in spconfig: '+siteRealm);
                                                     if ( siteRealm != null ) {                                             
                                                         refreshTokenURL = tokenURL.replace(SITE_REALM,siteRealm);
                                                     }
                                                     
                                                     listURLPath = sharePointConfig.List_URL_Path__c;
                                                     listURL = sharePointURL + listURLPath;
                                                     
                                                     deleteURLPath = sharePointConfig.Delete_URL_Path__c;
                                                     deleteURL = sharePointURL + listURLPath;
                                                     
                                                     updateURLPath = sharePointConfig.Update_URL_Path__c;
                                                     updateURL = sharePointURL + listURLPath;
                                                     
                                                     createURLPath = sharePointConfig.Create_URL_Path__c;
                                                     createURL = sharePointURL + listURLPath;
                                                     
                                                     siteResource = sharePointConfig.SharePoint_Resource__c;
                                                     sharePointResource = siteResource + '/' + sharePointURL.remove(sharePointURL.left(8)) + '@' + siteRealm;
                                                     //System.debug('SHAREPOINT - ' + sharePointResource);
                                                     findFolderURL = sharePointConfig.Find_Folder_URL__c;
                                                     
                                                     findFilesURL = sharePointConfig.Find_Files_URL__c;
                                                     
                                                     viewURLPath = sharePointConfig.View_URL_Path__c;
                                                     
                                                     listName = sharePointConfig.List_Name__c;
                                                     
                                                     tokenExpiredText = sharePointConfig.Token_Expired_Response_Text__c;
                                                     
                                                     listItemName = sharePointConfig.List_Item_Name__c;
                                                     
                                                     contentTypeId = sharePointConfig.Content_Type_Id__c;
                                                     
                                                     gemsContentTypeId = sharePointConfig.GEMS_Content_Type_Id__c;                        
                                                     
                                                     //SFDC-5096 Add for Production Acct. Maint. later
                                                     if(!organizationDAOInstance.isRunningInSandbox()){
                                                         if (callingSource == 'LGNAQuoteRq') {
                                                             //system.debug('Quote Request Prod. instance ');
                                                             if(oAuthSettingsQuoteRq.Access_Token_1__c != null) {
                                                                 accessToken  = oAuthSettingsQuoteRq.Access_Token_1__c;
                                                             }
                                                             if(oAuthSettingsQuoteRq.Access_Token_2__c != null) {
                                                                 accessToken  += oAuthSettingsQuoteRq.Access_Token_2__c;
                                                             }
                                                             if(oAuthSettingsQuoteRq.Access_Token_3__c != null) {
                                                                 accessToken  += oAuthSettingsQuoteRq.Access_Token_3__c;
                                                             }
                                                             if(oAuthSettingsQuoteRq.Access_Token_4__c != null) {
                                                                 accessToken  += oAuthSettingsQuoteRq.Access_Token_4__c;
                                                             }
                                                             if(oAuthSettingsQuoteRq.Access_Token_5__c != null) {
                                                                 accessToken  += oAuthSettingsQuoteRq.Access_Token_5__c;
                                                             }
                                                             if(oAuthSettingsQuoteRq.Refresh_Token_1__c != null) {
                                                                 refreshToken = oAuthSettingsQuoteRq.Refresh_Token_1__c;
                                                             }
                                                             if(oAuthSettingsQuoteRq.Refresh_Token_2__c != null) {
                                                                 refreshToken += oAuthSettingsQuoteRq.Refresh_Token_2__c;
                                                             }
                                                             if(oAuthSettingsQuoteRq.Redirect_URI__c != null) {
                                                                 redirectURI = oAuthSettingsQuoteRq.Redirect_URI__c;
                                                             }                                                                                                                                
                                                         }              
                                                     } else {                                                     
                                                         if (callingSource == 'LGNAQuoteRq') {
                                                             //system.debug('Quote Request sandbox: ');                                          
                                                             if(oAuthTestQuoteRqSettings.Access_Token_1__c != null) {
                                                                 accessToken  = oAuthTestQuoteRqSettings.Access_Token_1__c;
                                                             }
                                                             if(oAuthTestQuoteRqSettings.Access_Token_2__c != null) {
                                                                 accessToken  += oAuthTestQuoteRqSettings.Access_Token_2__c;
                                                             }
                                                             if(oAuthTestQuoteRqSettings.Access_Token_3__c != null) {
                                                                 accessToken  += oAuthTestQuoteRqSettings.Access_Token_3__c;
                                                             }
                                                             if(oAuthTestQuoteRqSettings.Access_Token_4__c != null) {
                                                                 accessToken  += oAuthTestQuoteRqSettings.Access_Token_4__c;
                                                             }
                                                             if(oAuthTestQuoteRqSettings.Access_Token_5__c != null) {
                                                                 accessToken  += oAuthTestQuoteRqSettings.Access_Token_5__c;
                                                             }                                          
                                                             if(oAuthTestQuoteRqSettings.Refresh_Token_1__c != null) {
                                                                 refreshToken = oAuthTestQuoteRqSettings.Refresh_Token_1__c;
                                                             }
                                                             if(oAuthTestQuoteRqSettings.Refresh_Token_2__c != null) {
                                                                 refreshToken += oAuthTestQuoteRqSettings.Refresh_Token_2__c;
                                                             }
                                                             system.debug('refresh token: '+ refreshToken);
                                                             if(oAuthTestQuoteRqSettings.Redirect_URI__c != null) {
                                                                 redirectURI = oAuthTestQuoteRqSettings.Redirect_URI__c;
                                                             }
                                                         }                  
                                                     }
                                                     
                                                     if(!organizationDAOInstance.isRunningInSandbox()){
                                                         if (callingSource == 'LGNAQuoteRq') {
                                                             if(oAuthSettingsQuoteRq != null && oAuthSettingsQuoteRq.Client_Id__c != null){
                                                                 clientId = oAuthSettingsQuoteRq.Client_Id__c;
                                                             }
                                                         }                          
                                                     } else {
                                                         if (callingSource == 'LGNAQuoteRq') {
                                                             if(oAuthTestQuoteRqSettings!= null && oAuthTestQuoteRqSettings.Client_Id__c != null) {
                                                                 clientId = oAuthTestQuoteRqSettings.Client_Id__c;
                                                             }
                                                         }                     
                                                     }        
                                                 }
                                                //SFDC-4784 End
    
    public String getGEMSContentTypeId(){
        return gemsContentTypeId;
    }
    
    public String getLGNAContentTypeId(){
        return contentTypeId;
    }
    
    public String getSharePointListItemName(){
        return listItemName;
    }
    
    public String getTokenExpiredResponseText(){
        return tokenExpiredText;
    }
    
    public String getFindFolderURL(){
        return findFolderURL;
    }
    
    public String getFindFilesURL() {
        return findFilesURL;
    }
    
    public Boolean isAccessTokenExpired(){
        if (isActMaint == true) { 
            return DateTime.newInstance(1970, 1, 1).addSeconds(Integer.valueOf(oAuthSettingsReqHub.Access_Token_Expiration__c)) <  datetime.now();
		//SFDC-4784
        } else if (callingSource == 'LGNAQuoteRq') {
            return DateTime.newInstance(1970, 1, 1).addSeconds(Integer.valueOf(oAuthSettingsQuoteRq.Access_Token_Expiration__c)) <  datetime.now();
        } else { 
            return DateTime.newInstance(1970, 1, 1).addSeconds(Integer.valueOf(oAuthSettings.Access_Token_Expiration__c)) <  datetime.now();
        }
    }
    
    public String getViewURLPath(){
        return viewURLPath;
    }
    
    public String getTeamURLPath(){
        return teamURLPath;
    }
    
    public String getListName(){
        return listName;
    }
    
    public String getSiteRealm(){
        return siteRealm;
    }
    
    public String getSiteResource(){
        return siteResource;
    }
    
    public String getRedirectURI(){
        return 'https%3A%2F%2F' + redirectURI + '%2Fapex%2FSharePointRefreshTokenPage';
    }          
    
    public String getResource(){
        return sharePointResource;
    }
    
    public String getClientId(){
        //System.debug('IN getClientId.');
        return clientId;
    }
    
    public String getClientSecret(){
        //System.debug('IN getClientSecret.'); 
        // Ask Krishna do we need to add for acctmaint flag
        if (!organizationDAOInstance.isRunningInSandbox()) {          
            if (isActMaint == true) {
                //System.debug('IN ClientSecret 1.');
                //System.debug(encryptionUtilityInstance.getDecryptedMessage(oAuthSettings.Client_Secret__c));
                return encryptionUtilityInstance.getDecryptedMessage(oAuthSettingsReqHub.Client_Secret__c);
            //SFDC-4784
            } else if (callingSource == 'LGNAQuoteRq') {
                //System.debug('IN ClientSecret 1.');
                //System.debug(encryptionUtilityInstance.getDecryptedMessage(oAuthSettings.Client_Secret__c));
                return encryptionUtilityInstance.getDecryptedMessage(oAuthSettingsQuoteRq.Client_Secret__c); 
            } else {
                // if(oAuthSettings != null){ Malathi Commentd out
                //System.debug('IN ClientSecret 1.');
                //System.debug(encryptionUtilityInstance.getDecryptedMessage(oAuthSettings.Client_Secret__c));
                return encryptionUtilityInstance.getDecryptedMessage(oAuthSettings.Client_Secret__c);
                // }
            }
        } else {
            if (isActMaint == true) {                
                //System.debug('IN ReqhubgetClientSecret.');
                //System.debug('ClientSecret -- ' + oAuthTestReqHubSettings.Client_Secret__c);
                //System.debug(encryptionUtilityInstance.getDecryptedMessage(oAuthTestReqHubSettings.Client_Secret__c));
                return encryptionUtilityInstance.getDecryptedMessage(oAuthTestReqHubSettings.Client_Secret__c);
                //return encryptionUtilityInstance.getDecryptedMessage(oAuthTestReqHubSettings.Client_Secret__c);               
            //SFDC-4784
            } else if (callingSource == 'LGNAQuoteRq') {
                //System.debug('IN ReqhubgetClientSecret.');
                //System.debug('ClientSecret -- ' + oAuthTestReqHubSettings.Client_Secret__c);
                //System.debug(encryptionUtilityInstance.getDecryptedMessage(oAuthTestReqHubSettings.Client_Secret__c));
                return encryptionUtilityInstance.getDecryptedMessage(oAuthTestQuoteRqSettings.Client_Secret__c);
                //return encryptionUtilityInstance.getDecryptedMessage(oAuthTestReqHubSettings.Client_Secret__c);               
            } else {  
                //System.debug('IN ClientSecret 2.');          
                //System.debug(encryptionUtilityInstance.getDecryptedMessage(oAuthTestSettings.Client_Secret__c));
                return encryptionUtilityInstance.getDecryptedMessage(oAuthTestSettings.Client_Secret__c);
            }
        }
    }
    
    public String getAccessToken(){
        return accessToken;
    }
    
    public void setAccessToken(String accessToken){
        if(accessToken != null && !accessToken.equals('')){
            if (!organizationDAOInstance.isRunningInSandbox()) {
                if (isActMaint == true) {
                    oAuthSettingsReqHub.Access_Token_1__c = accessToken.left(255);
                    oAuthSettingsReqHub.Access_Token_2__c = accessToken.remove(oAuthSettingsReqHub.Access_Token_1__c).left(255);
                    oAuthSettingsReqHub.Access_Token_3__c = accessToken.remove(oAuthSettingsReqHub.Access_Token_1__c + oAuthSettingsReqHub.Access_Token_2__c).left(255);
                    oAuthSettingsReqHub.Access_Token_4__c = accessToken.remove(oAuthSettingsReqHub.Access_Token_1__c + oAuthSettingsReqHub.Access_Token_2__c + oAuthSettingsReqHub.Access_Token_3__c).left(255);
                    oAuthSettingsReqHub.Access_Token_5__c = accessToken.remove(oAuthSettingsReqHub.Access_Token_1__c + oAuthSettingsReqHub.Access_Token_2__c + oAuthSettingsReqHub.Access_Token_3__c + oAuthSettingsReqHub.Access_Token_4__c).left(255);
                    update oAuthSettingsReqHub;                                                                        
                }
                //SFDC-4784
                else if (callingSource == 'LGNAQuoteRq') { 
                    oAuthSettingsQuoteRq.Access_Token_1__c = accessToken.left(255);
                    oAuthSettingsQuoteRq.Access_Token_2__c = accessToken.remove(oAuthSettingsQuoteRq.Access_Token_1__c).left(255);
                    oAuthSettingsQuoteRq.Access_Token_3__c = accessToken.remove(oAuthSettingsQuoteRq.Access_Token_1__c + oAuthSettingsQuoteRq.Access_Token_2__c).left(255);
                    oAuthSettingsQuoteRq.Access_Token_4__c = accessToken.remove(oAuthSettingsQuoteRq.Access_Token_1__c + oAuthSettingsQuoteRq.Access_Token_2__c + oAuthSettingsQuoteRq.Access_Token_3__c).left(255);
                    oAuthSettingsQuoteRq.Access_Token_5__c = accessToken.remove(oAuthSettingsQuoteRq.Access_Token_1__c + oAuthSettingsQuoteRq.Access_Token_2__c + oAuthSettingsQuoteRq.Access_Token_3__c + oAuthSettingsQuoteRq.Access_Token_4__c).left(255);
                    update oAuthSettingsQuoteRq;                                                                        
                }                   
                else { 
                    oAuthSettings.Access_Token_1__c = accessToken.left(255);
                    oAuthSettings.Access_Token_2__c = accessToken.remove(oAuthSettings.Access_Token_1__c).left(255);
                    oAuthSettings.Access_Token_3__c = accessToken.remove(oAuthSettings.Access_Token_1__c + oAuthSettings.Access_Token_2__c).left(255);
                    oAuthSettings.Access_Token_4__c = accessToken.remove(oAuthSettings.Access_Token_1__c + oAuthSettings.Access_Token_2__c + oAuthSettings.Access_Token_3__c).left(255);
                    oAuthSettings.Access_Token_5__c = accessToken.remove(oAuthSettings.Access_Token_1__c + oAuthSettings.Access_Token_2__c + oAuthSettings.Access_Token_3__c + oAuthSettings.Access_Token_4__c).left(255);
                    update oAuthSettings;
                }
            } else {
                if (isActMaint == true) {
                    oAuthTestReqHubSettings.Access_Token_1__c = accessToken.left(255);
                    oAuthTestReqHubSettings.Access_Token_2__c = accessToken.remove(oAuthTestReqHubSettings.Access_Token_1__c).left(255);
                    oAuthTestReqHubSettings.Access_Token_3__c = accessToken.remove(oAuthTestReqHubSettings.Access_Token_1__c + oAuthTestReqHubSettings.Access_Token_2__c).left(255);
                    oAuthTestReqHubSettings.Access_Token_4__c = accessToken.remove(oAuthTestReqHubSettings.Access_Token_1__c + oAuthTestReqHubSettings.Access_Token_2__c + oAuthTestReqHubSettings.Access_Token_3__c).left(255);
                    oAuthTestReqHubSettings.Access_Token_5__c = accessToken.remove(oAuthTestReqHubSettings.Access_Token_1__c + oAuthTestReqHubSettings.Access_Token_2__c + oAuthTestReqHubSettings.Access_Token_3__c + oAuthTestReqHubSettings.Access_Token_4__c).left(255);
                    update oAuthTestReqHubSettings;
                }    
                //SFDC-4784
                else if (callingSource == 'LGNAQuoteRq') {
                    
                    oAuthTestQuoteRqSettings.Access_Token_1__c = accessToken.left(255);
                    oAuthTestQuoteRqSettings.Access_Token_2__c = accessToken.remove(oAuthTestQuoteRqSettings.Access_Token_1__c).left(255);
                    oAuthTestQuoteRqSettings.Access_Token_3__c = accessToken.remove(oAuthTestQuoteRqSettings.Access_Token_1__c + oAuthTestQuoteRqSettings.Access_Token_2__c).left(255);
                    oAuthTestQuoteRqSettings.Access_Token_4__c = accessToken.remove(oAuthTestQuoteRqSettings.Access_Token_1__c + oAuthTestQuoteRqSettings.Access_Token_2__c + oAuthTestQuoteRqSettings.Access_Token_3__c).left(255);
                    oAuthTestQuoteRqSettings.Access_Token_5__c = accessToken.remove(oAuthTestQuoteRqSettings.Access_Token_1__c + oAuthTestQuoteRqSettings.Access_Token_2__c + oAuthTestQuoteRqSettings.Access_Token_3__c + oAuthTestQuoteRqSettings.Access_Token_4__c).left(255);
                    update oAuthTestQuoteRqSettings;
                }      
                else{                                
                    oAuthTestSettings.Access_Token_1__c = accessToken.left(255);
                    oAuthTestSettings.Access_Token_2__c = accessToken.remove(oAuthTestSettings.Access_Token_1__c).left(255);
                    oAuthTestSettings.Access_Token_3__c = accessToken.remove(oAuthTestSettings.Access_Token_1__c + oAuthTestSettings.Access_Token_2__c).left(255);
                    oAuthTestSettings.Access_Token_4__c = accessToken.remove(oAuthTestSettings.Access_Token_1__c + oAuthTestSettings.Access_Token_2__c + oAuthTestSettings.Access_Token_3__c).left(255);
                    oAuthTestSettings.Access_Token_5__c = accessToken.remove(oAuthTestSettings.Access_Token_1__c + oAuthTestSettings.Access_Token_2__c + oAuthTestSettings.Access_Token_3__c + oAuthTestSettings.Access_Token_4__c).left(255);
                    update oAuthTestSettings;
                }
            }
        }
    }
    
    public String getRefreshToken(){
        return refreshToken;
    }
    
    public void setRefreshToken(String refreshToken){
        if(refreshToken != null && !refreshToken.equals('')){
            if (!organizationDAOInstance.isRunningInSandbox()) {
                if (isActMaint == true) {
                    oAuthSettingsReqHub.Refresh_Token_1__c = refreshToken.left(255);
                    if ( refreshToken.length() > 255 ) {
                        oAuthSettingsReqHub.Refresh_Token_2__c = refreshToken.remove(oAuthSettingsReqHub.Refresh_Token_1__c).left(255);
                    }
                    update oAuthSettingsReqHub; 
                //SFDC-4784                
                } else if (callingSource == 'LGNAQuoteRq') {
                    oAuthSettingsQuoteRq.Refresh_Token_1__c = refreshToken.left(255);
                    if ( refreshToken.length() > 255 ) {
                        oAuthSettingsQuoteRq.Refresh_Token_2__c = refreshToken.remove(oAuthSettingsQuoteRq.Refresh_Token_1__c).left(255);
                    }
                    update oAuthSettingsQuoteRq;                                                         
                } else {
                    oAuthSettings.Refresh_Token_1__c = refreshToken.left(255);
                    if ( refreshToken.length() > 255 ) {
                        oAuthSettings.Refresh_Token_2__c = refreshToken.remove(oAuthSettings.Refresh_Token_1__c).left(255);
                    }
                    update oAuthSettings;
                }
            } else {
                if (isActMaint == true) {
                    oAuthTestReqHubSettings.Refresh_Token_1__c = refreshToken.left(255);
                    if ( refreshToken.length() > 255 ) {
                        oAuthTestReqHubSettings.Refresh_Token_2__c = refreshToken.remove(oAuthTestReqHubSettings.Refresh_Token_1__c).left(255);
                    }
                    update oAuthTestReqHubSettings;                                                            
                }
				//SFDC-4784
                if (callingSource == 'LGNAQuoteRq') {
                    oAuthTestQuoteRqSettings.Refresh_Token_1__c = refreshToken.left(255);
                    if ( refreshToken.length() > 255 ) {
                        oAuthTestQuoteRqSettings.Refresh_Token_2__c = refreshToken.remove(oAuthTestQuoteRqSettings.Refresh_Token_1__c).left(255);
                    }
                    update oAuthTestQuoteRqSettings;                                                            
                } else {                
                    oAuthTestSettings.Refresh_Token_1__c = refreshToken.left(255);
                    if ( refreshToken.length() > 255 ) {
                        oAuthTestSettings.Refresh_Token_2__c = refreshToken.remove(oAuthTestSettings.Refresh_Token_1__c).left(255);
                    }
                    update oAuthTestSettings;
                }
            }
        }
    }
    
    public String getSharePointURL(){
        return sharePointURL;
    }
    
    public String getTeamSharePointURL(){
        return sharePointTeamURL;
    }
    
    public String getRealmURL(){
        return realmURL;
    }
    
    public String getAuthURL(){
        return authURL;
    }
    
    public String getRefreshTokenURL(){
        return refreshTokenURL;
    }
    
    public String getListURL(){
        return listURL;
    }
    
    public String getCreateURLPath(){
        return createURLPath;
    }
    
    public String getUpdateURLPath(){
        return updateURLPath;
    }
    
    public String getDeleteURL(){
        return deleteURL;
    }
    
    public String getUpdateURL(){
        return updateURL;
    }
    
    public String getCreateURL(){
        return createURL;
    } 
    
}