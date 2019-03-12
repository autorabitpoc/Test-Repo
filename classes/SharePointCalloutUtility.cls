/*
* @author      : Sana Fatima & Robert Bonslater/Slalom
* @description : Used to make all REST callouts to SharePoint site.
*       All business logic (i.e. folder name creation/pruning) will take place in the respective
*       SharePointObjectManager for each Account, Opportunity and Case object. 
*/
public class SharePointCalloutUtility implements ISharePointCalloutUtility { 
    
    public interface ISharePointCalloutUtility {
        Object sendCallout(String action, String folderName, String folderPath, SObject sObj);
        void refreshAccessToken();
        void updateAccessToken();
        void getAccessAndRefreshToken(String authCode);
        void persistTokens();
    }

    private String clientId;
    private String clientSecret;
    private String sharePointURL;
    private String realmURL;
    private String resource;

    public static String staticRefreshToken;
    public static String staticAccessToken;
    public static Boolean accessTokenIsExpired;

    public SharePointJSON2Apex accessAndRefresh; 

    private String tokenURL;
    private String redirectURI;

    public static final String FOLDER_NAME = '<folder_name>';
    public static final String TEAM_PATH = '<team_path>';
    public static final String AUTHORIZATION = 'Authorization';
    public static final String ACCEPT = 'accept';
    public static final String BEARER = 'Bearer ';
    public static final String GET = 'GET';
    public static final String POST = 'POST';
    public static final String METADATA = '__metadata';
    public static final String TYPE = 'type';
    public static final String CREATE_FOLDER = 'CreateFolder';
    public static final String UPDATE_CONTENT_TYPE = 'UpdateContentType';
    public static final String MODIFY_FOLDER = 'ModifyFolder';
    public static final String GET_FOLDER = 'GetFolder';
    public static final String GET_FILES = 'GetFiles';
    public static final String GEMS = 'GEMS';
    public static final String GET_ACCESS_AND_REFRESH = 'GetAccessAndRefresh';

    transient HttpRequest request;
    HttpResponse response;

    @TestVisible private SharePointConfiguration sharePointConfiguration {get; set;}
    
    public SharePointCalloutUtility( ) {
        this(new HttpRequest(), new SharePointConfiguration());
    }
    //SFDC-5096
    public SharePointCalloutUtility(SharePointConfiguration sharePointConfiguration ) {
        this(new HttpRequest(), sharePointConfiguration );
    }

    @TestVisible private SharePointCalloutUtility(HttpRequest request, 
                                            SharePointConfiguration sharePointConfiguration){
        this.request = request;
        this.sharePointConfiguration = sharePointConfiguration;

        this.clientId = sharePointConfiguration.getClientId();
        this.clientSecret = sharePointConfiguration.getClientSecret();
        this.sharePointURL = sharePointConfiguration.getSharePointURL();
        this.resource = sharePointConfiguration.getResource();
        this.realmURL = sharePointConfiguration.getRealmURL();
        
        tokenURL = sharePointConfiguration.getRefreshTokenURL();
        redirectURI = sharePointConfiguration.getRedirectURI();
        staticAccessToken = sharePointConfiguration.getAccessToken();
        staticRefreshToken = sharePointConfiguration.getRefreshToken();
       //System.debug'SPCUtility: Static access token: ' + staticAccessToken);
       System.debug('SPCUtility: Static refresh token: ' + staticRefreshToken);
        accessTokenIsExpired = false;
    }

    public Object sendCallout(String action, String folderName, String folderPath, SObject sObj){
       System.debug('staticAccessToken: ' + staticAccessToken);
       System.debug('staticRefreshToken: ' + staticRefreshToken);
        //staticAccessToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IlZXVkljMVdEMVRrc2JiMzAxc2FzTTVrT3E1USIsImtpZCI6IlZXVkljMVdEMVRrc2JiMzAxc2FzTTVrT3E1USJ9.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTBmZjEtY2UwMC0wMDAwMDAwMDAwMDAvbXlmeWkuc2hhcmVwb2ludC5jb21AMmUwY2I2NDQtYzA5NC00MWQ3LWFiM2QtNDMyMDFkYTI0NDM4IiwiaXNzIjoiMDAwMDAwMDEtMDAwMC0wMDAwLWMwMDAtMDAwMDAwMDAwMDAwQDJlMGNiNjQ0LWMwOTQtNDFkNy1hYjNkLTQzMjAxZGEyNDQzOCIsImlhdCI6MTUwMzA3OTAyNCwibmJmIjoxNTAzMDc5MDI0LCJleHAiOjE1MDMwODI5MjQsImFjdG9yIjoiMjdjYjE3YjQtOWRkZS00Y2JhLTllNDgtMjgyYmJlOTU4OTE0QDJlMGNiNjQ0LWMwOTQtNDFkNy1hYjNkLTQzMjAxZGEyNDQzOCIsImlkZW50aXR5cHJvdmlkZXIiOiJ1cm46ZmVkZXJhdGlvbjptaWNyb3NvZnRvbmxpbmUiLCJuYW1laWQiOiIxMDAzN2ZmZTk0NjIxMGFhIn0.t2caq3CtUdr6CPgwWc0XG9gjaQ1jVWRxlc_b_BDiuoI3QOtGTThw7C3OX5bijgLKmLVDaluWrXfB_WTBd0PP_KaYqoFp4Xx6E4TLq0iKfJh167ioEET_5JCmPTybWhUBBV-QccXBI9mPhI-JRehKYnd7qzCoRAxWHP_xWoW5J0rCfFqOWNwKgJo-tuIQqXuPxGL-Gf_CyZnoniEFzCjfFxWFMMxX6Czum2L2kokACu3pW_Jf5G7giMLnv4mHYPL8f36_SoMI_1ooSS4DX7DL3b44OG4wAbi-eP3eTUbsMzMTckmJ_9FsusEkra18iedm1rw4CL6K3hFY-LiBpViQaQ';
       //System.debug'TESTING 2: ' + staticAccessToken);
        if(Limits.getCallouts() < Limits.getLimitCallouts()){
            if(action.equalsIgnoreCase(CREATE_FOLDER)){
                return sendCalloutToCreateFolder( folderName, folderPath );
            } else if(action.equalsIgnoreCase(UPDATE_CONTENT_TYPE)){
                return sendCalloutToUpdateContentType( folderName, folderPath, sObj ); 
            } else if(action.equalsIgnoreCase(MODIFY_FOLDER)){
                return sendCalloutToModifyFolder( folderName, folderPath, sObj );
            } else if(action.equalsIgnoreCase(GET_FOLDER)){
                return sendCalloutToGetFolder( folderName );
            } else if(action.equalsIgnoreCase(GET_FILES)){
                return sendCalloutToGetFiles( folderName );
            }
        }
        return null;
    }

    public HttpResponse sendCalloutToGetFolder(String folderName) {

        Http http = new Http();
        request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setMethod(GET);
        String authorizationHeader = BEARER + staticAccessToken;
       //System.debug'authorizationHeader: '+authorizationHeader);
        request.setHeader(AUTHORIZATION, authorizationHeader);
        request.setHeader(ACCEPT, 'application/json;odata=verbose');

        String listName = sharePointConfiguration.getListName();
        String endPoint = sharePointConfiguration.getSharePointURL() + 
                                sharePointConfiguration.getTeamURLPath() + 
                                    sharePointConfiguration.getFindFolderURL().
                                        replace(FOLDER_NAME,folderName).
                                        replace(TEAM_PATH,listName.removeStart('/'));                                          
        
        request.setEndpoint(endPoint);
       //System.debug'get folder callout request:'+request);
       //System.debug'SPCUtility: ENDPOINT: ' + request.getEndpoint());
        return http.send(request);       
    } 

    public HttpResponse sendCalloutToGetFiles(String folderName) {

        Http http = new Http();
        request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setMethod(GET);
        String authorizationHeader = BEARER + staticAccessToken;
        request.setHeader(AUTHORIZATION, authorizationHeader);
        request.setHeader(ACCEPT, 'application/json;odata=verbose');

        String listName = sharePointConfiguration.getListName();
        String endPoint = sharePointConfiguration.getSharePointURL() + 
                                sharePointConfiguration.getTeamURLPath() + 
                                    sharePointConfiguration.getFindFilesURL().
                                        replace(FOLDER_NAME,folderName).
                                            replace(TEAM_PATH,listName.removeStart('/'));
        
        request.setEndpoint(endPoint);
       //System.debug'SPCUtility: ENDPOINT: ' + request.getEndpoint());
        return http.send(request);       
    } 

    public HttpResponse sendCalloutToCreateFolder(String folderName, String folderPath) {

        Http http = new Http();
        request = new HttpRequest();
        request.setMethod(POST);
        
        String authorizationHeader = BEARER + staticAccessToken;
        String serverRelativeURL = sharePointConfiguration.getTeamURLPath() + sharePointConfiguration.getListName();
        String endPoint = sharePointConfiguration.getCreateURLPath().replace(TEAM_PATH, sharePointConfiguration.getTeamURLPath());

        request.setHeader(AUTHORIZATION, authorizationHeader);
        request.setHeader('X-RequestDigest', 'form digest value');
        request.setHeader(ACCEPT, 'application/json;odata=verbose');
        request.setHeader('content-type', 'application/json;odata=verbose');

        request.setBody('{ "' + METADATA + '": { "' + TYPE + '": "SP.Folder" }, "ServerRelativeUrl": "' 
                            + serverRelativeURL + '/' + folderName + '"}'); 
        request.setEndpoint(sharePointURL + endPoint);
        return http.send(request);        
    } 

    public HttpResponse sendCalloutToUpdateContentType(String folderName, String folderPath, SObject sObj) {

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod(POST);

        String authorizationHeader = BEARER + staticAccessToken;
        String encodedFolderPath = EncodingUtil.urlEncode(folderPath, 'UTF-8').replaceAll('\\+', '%20');
        String endPoint = sharePointConfiguration.getUpdateURLPath().replace(TEAM_PATH, sharePointConfiguration.getTeamURLPath()).replace(FOLDER_NAME, encodedFolderPath);
       //System.debug'SPCUtility: endPoint '+ endPoint);
        String salesforceId;
        String contentTypeId;

        Id gemsAccSubRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get( Label.GEMS_Account_Submission ).getRecordTypeId();
        Id groupAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId();
        Id prospectAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Prospect ).getRecordTypeId();
        //SFDC-5096
        Id gemsAccMaintRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();

        request.setHeader(AUTHORIZATION, authorizationHeader);
        request.setHeader('X-RequestDigest', 'form digest value');
        request.setHeader(ACCEPT, 'application/json;odata=verbose');
        request.setHeader('content-type', 'application/json;odata=verbose');
        request.setHeader('IF-MATCH', '*');
        request.setHeader('X-HTTP-Method', 'MERGE');
        
        //Request body is dependent on Sobject Type 
        //body needs LGNA or GEMs content type id 
        salesforceId = sObj.Id;
        if ( sObj instanceof Account ) {
            Account acc = (Account) sObj;
            String accFullName = acc.Name;
            String recTypeName;
            if(acc.RecordTypeId == groupAccountRecTypeId){
                recTypeName = 'GROUP_ACCOUNT';
            } else if(acc.RecordTypeId == prospectAccountRecTypeId) {
                recTypeName = 'PROSPECT_ACCOUNT';
            }
            String grouping;
            if ( acc.Effective_Date__c != null) {
                grouping = acc.HCSC_Division__c + '+' + acc.Effective_Date__c.format() 
                    + '+' + recTypeName;    
            } else {
                grouping = acc.HCSC_Division__c + '+' + acc.Effective_Date__c +
                    '+' + recTypeName;
            }
            contentTypeId = sharePointConfiguration.getLGNAContentTypeId();

            request.setBody('{ "' + METADATA + '": { "' + TYPE + '": "SP.Data.' + sharePointConfiguration.getSharePointListItemName()
                    + '" }, "ContentTypeId":"' + contentTypeId + '", "SalesforceId": "'  
                    + salesforceId + '", "FullAccountName": "' + accFullName + '", "ViewGrouping": "' 
                    + grouping + '", "Title": "' + folderName + '", "FileLeafRef": "' + folderName + '"}'); 
        } else {
            contentTypeId = sharePointConfiguration.getLGNAContentTypeId();
            if ( sObj instanceof Case ) {
                Case currCase = (Case) sObj;
                //if the case record type is GEMS Account Submission change to GEMS Content Type Id
                if ((currCase.RecordTypeId == gemsAccSubRecordTypeId) || (currCase.RecordTypeId == gemsAccMaintRecordTypeId)) {
                    contentTypeId = sharePointConfiguration.getGEMSContentTypeId();
                }
            }
            request.setBody('{ "' + METADATA + '": { "' + TYPE + '": "SP.Data.' + sharePointConfiguration.getSharePointListItemName()
                    + '" }, "ContentTypeId":"' + contentTypeId + '", "SalesforceId": "' 
                    + salesforceId + '", "Title": "' + folderName + '", "FileLeafRef": "' + folderName + '"}');
        }     
        request.setEndpoint(sharePointURL + endPoint);
       //System.debug'SPCUtility: setEndPoint '+ sharePointUrl + endPoint);
        return http.send(request);        
    }  

    public HttpResponse sendCalloutToModifyFolder(String folderName, String folderPath, SObject sObj) {

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod(POST);

        String authorizationHeader = BEARER + staticAccessToken;
        String encodedFolderPath = EncodingUtil.urlEncode(folderPath, 'UTF-8').replaceAll('\\+', '%20');
        String endPoint = sharePointConfiguration.getUpdateURLPath().replace(TEAM_PATH, sharePointConfiguration.getTeamURLPath()).replace(FOLDER_NAME, encodedFolderPath);
        String salesforceId;

        request.setHeader(AUTHORIZATION, authorizationHeader);
        request.setHeader('X-RequestDigest', 'form digest value');
        request.setHeader(ACCEPT, 'application/json;odata=verbose');
        request.setHeader('content-type', 'application/json;odata=verbose');
        request.setHeader('IF-MATCH', '*');
        request.setHeader('X-HTTP-Method', 'MERGE');

        Id groupAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId();
        Id prospectAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Prospect ).getRecordTypeId();

        //Request body is dependent on Sobject Type 
        //body does not need content type id
        salesforceId = sObj.Id;
        if ( sobj instanceof Account ) {
            Account acc = (Account) sObj;
            String accFullName = acc.Name;
            String recTypeName;
            if(acc.RecordTypeId == groupAccountRecTypeId){
                recTypeName = 'GROUP_ACCOUNT';
            } else if(acc.RecordTypeId == prospectAccountRecTypeId) {
                recTypeName = 'PROSPECT_ACCOUNT';
            }
            String grouping;
            if( acc.Effective_Date__c != null) {
                grouping = acc.HCSC_Division__c + '+' + acc.Effective_Date__c.format() 
                    + '+' + recTypeName;    
            } else {
                grouping = acc.HCSC_Division__c + '+' + acc.Effective_Date__c
                    + '+' + recTypeName;
            }
            request.setBody('{ "' + METADATA + '": { "' + TYPE + '": "SP.Data.' + sharePointConfiguration.getSharePointListItemName() 
                    + '" },  "SalesforceId": "' + salesforceId + '", "FullAccountName": "' + accFullName + '", "ViewGrouping": "' 
                    + grouping + '", "Title": "' + folderName + '", "FileLeafRef": "' + folderName + '"}'); 
        } else {
             request.setBody('{ "' + METADATA + '": { "' + TYPE + '": "SP.Data.' + sharePointConfiguration.getSharePointListItemName() 
                    + '" },  "SalesforceId": "' + salesforceId + '", "Title": "' + folderName + '", "FileLeafRef": "' 
                    + folderName + '"}');
        }
        request.setEndpoint(sharePointURL + endPoint);
        return http.send(request);        
    }

    public void refreshAccessToken() {
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HTTPResponse res = new HTTPResponse(); 
        String realm = getRealm();
         System.debug('SPCUtility: staticRefreshToken: '+ staticRefreshToken);
   
       //System.debug'SPCUtility: Realm: '+ getRealm());
        req.setMethod(POST);
        req.setHeader(ACCEPT,'application/json;odata=verbose');
       //System.debug'SPCUtility: TokenUrl: '+ tokenUrl);
        req.setEndpoint(tokenUrl);
        String reqBody = 'grant_type=refresh_token'
        +'&client_id=' + clientId
        + EncodingUtil.urlEncode('@' + realm, 'UTF-8')
        +'&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8')
        +'&refresh_token=' + staticRefreshToken
        +'&redirect_uri='+ EncodingUtil.urlEncode(redirectUri, 'UTF-8')
        +'&resource='+ resource;
        + EncodingUtil.urlEncode('@' + realm, 'UTF-8')
        ;
       //System.debug'SpcUtility: requestBody: '+reqBody);
       //System.debug'SPCUtility: clientId: '+ clientId);
       //System.debug'SPCUtility: client secret: '+ clientSecret);
       System.debug('SPCUtility: staticRefreshToken: '+ staticRefreshToken);
       //System.debug'SPCUtility: Resource: '+ resource);

        req.setBody(reqBody);
         
        try {
            res = http.send(req);
        }
        catch(System.CalloutException e) {
           //System.debug'SPCUtility: Callout error: '+ e);       
        }
       //System.debug'SPCUtility: response: ' + res.getBody());
        String accessToken = parseHTTPResponse(res, 'access_token');
       //System.debug'SPCUtility: New Access Token: '+ accessToken);
        accessTokenIsExpired = true;
        if (accessToken != null) {
            accessTokenIsExpired = true;
            staticAccessToken = accessToken;
        }
    }

    public void getAccessAndRefreshToken(String authCode) {
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HTTPResponse res = new HTTPResponse(); 
        String realm = getRealm();
        req.setMethod(POST);
        req.setHeader(ACCEPT,'application/json;odata=verbose');

       //System.debug'**clientId - ' + clientId);
       //System.debug'**clientSecret - ' + clientSecret);
       //System.debug'**resource - ' + EncodingUtil.urlEncode(resource, 'UTF-8'));
       //System.debug'**URL - ' + sharePointConfiguration.getRedirectURI());

        req.setEndpoint(sharePointConfiguration.getRefreshTokenURL());
        String reqBody = 'grant_type=authorization_code'
            +'&client_id=' + clientId 
            + EncodingUtil.urlEncode('@' + realm, 'UTF-8')
            +'&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8')
            + '&code=' + authCode
            +'&redirect_uri=' + sharePointConfiguration.getRedirectURI()
            +'&resource=' + EncodingUtil.urlEncode(resource, 'UTF-8');
       //System.debug'REQUEST: ' + req);
        req.setBody(reqBody);
       //System.debug'**AUTH CODE - ' + req.getBody());
       //System.debug'**REQUEST - ' + authCode);
        try {
            res = http.send(req);
        }catch(System.CalloutException e) {
           //System.debug'SPCUtility: Callout error: '+ e);       
        }

        accessAndRefresh = (SharePointJSON2Apex)System.JSON.deserialize(res.getBody(), SharePointJSON2Apex.class);
    }

    public void persistTokens(){
       //System.debug'persisting tokens');
        sharePointConfiguration.setAccessToken(accessAndRefresh.access_token);
        sharePointConfiguration.setRefreshToken(accessAndRefresh.refresh_token);
       //System.debug'tokens are persisted');
    }

    public void updateAccessToken() {
        try {
           //System.debug'SPCUtility: UpdateAccessToken: accessTokenIsExpired = '+accessTokenIsExpired);
            if( accessTokenIsExpired == true) {
                sharePointConfiguration.setAccessToken( staticAccessToken );
                accessTokenIsExpired = false;
            }
        } catch (DmlException e) {
           //System.debug'SPCUtility: DML Exception '+ e.getMessage() );
        } catch(Exception e) {
           //System.debug'SPCUtility: General Exception '+ e.getMessage() );
        }
    }

    public String getRealm(){
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        String result=null;

        req.setMethod('GET');
        req.setHeader(AUTHORIZATION,'Bearer');
        req.setEndpoint(realmURL);
        res = http.send(req);

        String wwwauth = res.getHeader('WWW-Authenticate');
        String[] wwwauthArray = wwwauth.split(',');
        String[] realmArray = null;
        for(String s : wwwauthArray){
            if(s.IndexOf('Bearer realm') > -1) {
                realmArray = s.split('=');
                result = realmArray[1].trim().remove('"');
            }
        }
        return result;
    }

    public String parseHTTPResponse(HTTPResponse res, String searchParm){
        
        String result = null;

        if(res.getStatus() == 'SUCCESS' || res.getStatus() == 'OK'){ 
            
            // Parse JSON response to get all the totalPrice field values.
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null && result == null ) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == searchParm)) {
                    parser.nextToken();
                    result = parser.getText();
                }
            }
        }
        else {
           //System.debug'SPCUtility: BODY: '+res.getBody());
           //System.debug'SPCUtility: STATUS:'+res.getStatus());
           //System.debug'SPCUtility: STATUS_CODE:'+res.getStatusCode());
        }
        return result;
    }

    public class SharePointJSON2Apex {

        public String token_type;
        public String expires_in;
        public String not_before;
        public String expires_on;
        public String resource;
        public String access_token;
        public String refresh_token;

        
        public SharePointJSON2Apex parse(String json) {
            return (SharePointJSON2Apex) System.JSON.deserialize(json, SharePointJSON2Apex.class);
        }
    }
}