public with sharing class CustomSettingDAO implements ICustomSettingDAO{ 
    public interface ICustomSettingDAO{
        Username_Password__c getUsernamePasswordCSByName(String endpoint);
        Encryption_Key__c getEncryptionKeyCSByProfileId(Id profileId);
        SearchFIPS__c getFIPSByStateAndZip(String state, String zip);
        SharePointOAuth__c getSharePointOAuthSettings(Id userId);
        Heron_OAuth__c getHeronOAuthSetting (Id userId);
        OAuth_Jwt_Token__c getJWTOAuthSetting(Id userId);
        OAuth_Jwt_Token2__c getJWTOAuthSettingCallOut(String calloutName);
        List<SharePointOAuthTEST__c> getAllSharePointOAuths();
        SharePointOAuthReqHub__c getSPOAuthSettingsReqHub(Id userId);
        List<SPOAuthTestReqHub__c> getAllSharePointOAuthsRqHub(); 
        //SFDC-4784
        SharePoint_PROD_HeronQuotes__c getSPOAuthSettingsQuoteRq(Id userId);
        List<SharePoint_TEST_HeronQuotes__c> getAllSharePointOAuthsQuoteRq();        
    }

    public Username_Password__c getUsernamePasswordCSByName(String endpoint){
        return Username_Password__c.getInstance(endpoint);
    }

    public Encryption_Key__c getEncryptionKeyCSByProfileId(Id profileId){
        return Encryption_Key__c.getInstance(profileId);
    }

    public SearchFIPS__c getFIPSByStateAndZip(String state, String zip){
        return [SELECT FIPS_Code__c FROM SearchFIPS__C WHERE State__c =: state AND ZipCode__c =: zip LIMIT 1];
    }
 
    public SharePointOAuth__c getSharePointOAuthSettings(Id profileId){
        return SharePointOAuth__c.getInstance(profileId);
    }

    public List<SharePointOAuthTEST__c> getAllSharePointOAuths(){
        return [Select Name, Redirect_URI__c, Access_Token_1__c, Access_Token_2__c, Access_Token_3__c, 
            Access_Token_4__c, Access_Token_5__c, Refresh_Token_1__c, Refresh_Token_2__c, Client_ID__c, Client_Secret__c from SharePointOAuthTEST__c ];
    }
    
    //SFDC-5096 Get oAuth settings for Request Hub production      
    public SharePointOAuthReqHub__c getSPOAuthSettingsReqHub(Id profileId){
        return SharePointOAuthReqHub__c.getInstance(profileId);
    }
    
    // SFDC-5096 Get oAuth settings for Sandbox Request Hub
     public List<SPOAuthTestReqHub__c> getAllSharePointOAuthsRqHub(){
        return [Select Name, Redirect_URI__c, Access_Token_1__c, Access_Token_2__c, Access_Token_3__c, 
            Access_Token_4__c, Access_Token_5__c, Refresh_Token_1__c, Refresh_Token_2__c, Client_ID__c, Client_Secret__c from SPOAuthTestReqHub__c]; 
    } 
    
    //SFDC-4784 Get oAuth settings for Quote Request production      
    public SharePoint_PROD_HeronQuotes__c getSPOAuthSettingsQuoteRq(Id profileId){
        return SharePoint_PROD_HeronQuotes__c.getInstance(profileId);
    }
    
    // SFDC-4784 Get oAuth settings for Sandbox Quote Request
     public List<SharePoint_TEST_HeronQuotes__c> getAllSharePointOAuthsQuoteRq(){
        return [Select Name, Redirect_URI__c, Access_Token_1__c, Access_Token_2__c, Access_Token_3__c, 
            Access_Token_4__c, Access_Token_5__c, Refresh_Token_1__c, Refresh_Token_2__c, Client_ID__c, Client_Secret__c from SharePoint_TEST_HeronQuotes__c]; 
    }     

    public Heron_OAuth__c getHeronOAuthSetting(Id userId){
        return Heron_OAuth__c.getInstance(userId);
    }
    
     public OAuth_Jwt_Token__c getJWTOAuthSetting(Id userId){
        return OAuth_Jwt_Token__c.getInstance(userId);
    }
     public OAuth_Jwt_Token2__c getJWTOAuthSettingCallOut(String calloutName){
        return OAuth_Jwt_Token2__c.getInstance(calloutName);
    }
}