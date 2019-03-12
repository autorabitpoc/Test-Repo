public class SharePointAccountManager implements IQueueable, Database.AllowsCallouts {

    @TestVisible private CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance {get; set;}
    @TestVisible private CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance {get; set;}
    @TestVisible private OrganizationDAO.IOrganizationDAO organizationDAOInstance {get; set;}
    @TestVisible private SharePointCalloutUtility.ISharePointCalloutUtility sharePointcalloutUtilityInstance {get; set;}
    @TestVisible private SharePointConfiguration sharePointConfigurationInstance {get; set;}

    private String action;
    private List<Account> newAccounts;
    private Map<Id, Account> oldAccounts;

    public static final String APEX_CLASS = 'Apex Class';
    public static final String SOBJECT_TYPE = String.valueOf(Account.sObjectType);
    public static final String HIGH_PRIORITY = 'High';

    public SharePointAccountManager(List<Account> newAccounts, Map<Id, Account> oldAccounts) {
        this(newAccounts, oldAccounts, new CustomSettingDAO(), new CustomMetadataTypeDAO(),
             new OrganizationDAO(), new SharePointCalloutUtility(), new SharePointConfiguration());
    }

    @TestVisible private SharePointAccountManager(List<Account> newAccounts, Map<Id, Account> oldAccounts,
            CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance,
            CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance,
            OrganizationDAO.IOrganizationDAO organizationDAOInstance,
            SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance,
            SharePointConfiguration sharePointConfigurationInstance) {

        this.newAccounts = newAccounts;
        this.oldAccounts = oldAccounts;
        this.customSettingDAOInstance = customSettingDAOInstance;
        this.customMetadatTypeDAOInstance = customMetadatTypeDAOInstance;
        this.organizationDAOInstance = organizationDAOInstance;
        this.sharePointCalloutUtilityInstance = sharePointCalloutUtilityInstance;
        this.sharePointConfigurationInstance = sharePointConfigurationInstance;
    }

    public void setSObject(List<SObject> sObjects) {
        this.newAccounts = (List<Account>) sObjects;
    }

    public void execute(QueueableContext context) {
        Map<String, Exception> exceptions = new Map <String, Exception>();
        String recDetails;
        sharePointCalloutUtilityInstance = new SharePointCalloutUtility();
        HttpResponse response;
        String oldFolderName;
        String newFolderName;
        String action;

        for (Account acc : newAccounts) {
            if ( oldAccounts.isEmpty() ) {
                newFolderName = SharePointFolderBuilder.buildAccountFolderName( acc.Name, acc.External_ID__c );
                action = SharePointCalloutUtility.CREATE_FOLDER;
            } else if ( !oldAccounts.isEmpty() ) {
                newFolderName = SharePointFolderBuilder.buildAccountFolderName( acc.Name, acc.External_ID__c );
                oldFolderName = SharePointFolderBuilder.buildAccountFolderName( oldAccounts.get(acc.Id).Name, oldAccounts.get(acc.Id).External_ID__c );
                action = SharePointCalloutUtility.MODIFY_FOLDER;
            }
            recDetails = acc.Name + ' ' + acc.Id + ' Folder: ' + newFolderName;

            if (!Test.isRunningTest()) {
                try {
                    response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( action, newFolderName, oldFolderName, acc);

                    if (response.getStatusCode() == 401 && response.getBody().contains(sharePointConfigurationInstance.getTokenExpiredResponseText())) {
                        sharePointCalloutUtilityInstance.refreshAccessToken();
                        response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( action, newFolderName, oldFolderName, acc);
                    }
                    if (response.getStatusCode() == 201 && action.equalsIgnoreCase(SharePointCalloutUtility.CREATE_FOLDER) ) {
                        //callout to change the content type of the list item
                        response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( 'UpdateContentType', newFolderName, newFolderName, acc);

                        response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( 'CreateFolder', newFolderName + '/MISC', null, acc);
                    } else if (response.getStatusCode() == 204 && action.equalsIgnoreCase(SharePointCalloutUtility.MODIFY_FOLDER) ) {
                        System.debug('Folder has been modified');
                    } else {
                        SharePointAccountManagerException e = new SharePointAccountManagerException(response.getBody());
                        exceptions.put('SP Callout Response ' + recDetails, e);
                    }
                    //checks if token has expired and refreshes the token if it is
                    sharePointCalloutUtilityInstance.updateAccessToken();
                } catch (System.CalloutException e) {
                    exceptions.put('SP Callout Exception ' + recDetails, e);
                } catch (Exception e) {
                    exceptions.put('SP Exception ' + recDetails, e);
                }
            }
        }

        if ( !exceptions.isEmpty() ) {
            for ( String e : exceptions.keySet() ) {
                CreateExceptionLog.insertErrorLog(exceptions.get(e), null, null, null, APEX_CLASS, SOBJECT_TYPE,
                                                  e, SharePointAccountManager.class.getName() +
                                                  '.execute()', HIGH_PRIORITY);
            }
        }
    }

    public class SharePointAccountManagerException extends Exception {}
}