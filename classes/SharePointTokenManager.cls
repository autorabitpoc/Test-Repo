public class SharePointTokenManager implements Database.AllowsCallouts {

    public String teamSharePointURL {get; set;} 
    public String teamURLPath {get; set;}
    public String viewURLPath {get; set;}
    public String sharePointListName {get; set;}
    public String sharePointURL {get; set;}
    public String findFolderURL {get; set;}
    public String clientId {get;set;}
    public String redirectURI {get;set;}
    public String authURLPath {get;set;}

    @TestVisible private SharePointConfiguration sharePointConfiguration {get; set;}

    public SharePointTokenManager () {
        this(new SharePointConfiguration());
    }

    @TestVisible private SharePointTokenManager (SharePointConfiguration sharePointConfiguration) {


        this.sharePointConfiguration = sharePointConfiguration;

        teamSharePointURL = sharePointConfiguration.getTeamSharePointURL();
        teamURLPath = sharePointConfiguration.getTeamURLPath();
        viewURLPath = sharePointConfiguration.getViewURLPath();
        sharePointListName = sharePointConfiguration.getListName();
        sharePointURL = sharePointConfiguration.getSharePointURL();
        findFolderURL = sharePointConfiguration.getFindFolderURL();
        clientId = sharePointConfiguration.getClientId();
        authURLPath = sharePointConfiguration.getAuthURL();
        redirectURI = sharePointConfiguration.getRedirectURI(); 
    }
}