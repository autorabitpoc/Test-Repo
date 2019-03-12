global class SharePointRefreshTokenController implements Database.AllowsCallouts {

    public String teamSharePointURL;
    public String teamURLPath;
    public String viewURLPath;
    public String sharePointListName;
    public String sharePointURL;
    public String authCode;

    public Boolean isAuthUser;
    public SharePointRefreshTokenController sprException;

    public static final String APEX_CLASS = 'Apex Class';
    public static final String SOBJECT_TYPE = String.valueOf(Account.sObjectType);
    public static final String HIGH_PRIORITY = 'High';
    public static final String AUTH_CODE = 'code';
    
    @TestVisible private SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance;
    @TestVisible private SharePointConfiguration sharePointConfiguration;

    public SharePointRefreshTokenException spException;

    public SharePointRefreshTokenController () {
        this(new SharePointCalloutUtility(),
                            new SharePointConfiguration());
    }

     @TestVisible private SharePointRefreshTokenController (SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance,
                                                                        SharePointConfiguration sharePointConfiguration) {

        this.sharePointCalloutUtilityInstance = sharePointCalloutUtilityInstance;
        this.sharePointConfiguration = sharePointConfiguration;
        
        try{
            authCode =  ApexPages.currentPage().getParameters().get(AUTH_CODE); 
            sharePointCalloutUtilityInstance.getAccessAndRefreshToken(authCode);
        } catch (Exception e){
            spException = new SharePointRefreshTokenException(e);
        }
        
    }

    public void persistTokens(){
        if(spException != null){
            CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                            null, 'SharePointRefreshTokenController constructor', HIGH_PRIORITY);
        } else {
             sharePointCalloutUtilityInstance.persistTokens();
        }
    }

    public class SharePointRefreshTokenException extends Exception {}
}