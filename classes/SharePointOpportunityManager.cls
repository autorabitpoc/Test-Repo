public class SharePointOpportunityManager implements IQueueable, Database.AllowsCallouts {

    @TestVisible private CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance {get; set;}
    @TestVisible private CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance {get; set;}
    @TestVisible private OrganizationDAO.IOrganizationDAO organizationDAOInstance {get; set;}
    @TestVisible private SharePointCalloutUtility.ISharePointCalloutUtility sharePointcalloutUtilityInstance {get; set;}
    @TestVisible private SharePointConfiguration sharePointConfigurationInstance {get; set;}

    private String action;
    private List<Opportunity> newOpps;
    private Map<Id, Opportunity> oldOpps;

    public static final String APEX_CLASS = 'Apex Class';
    public static final String SOBJECT_TYPE = String.valueOf(Opportunity.sObjectType);
    public static final String HIGH_PRIORITY = 'High';

    static String[] subFoldersList = new String[] { //MISC folder should not have a SALESFORCE id!!!!!
        'MISC'
    };

    public SharePointOpportunityManager(List<Opportunity> newOpps, Map<Id, Opportunity> oldOpps) {
        this(newOpps, oldOpps, new CustomSettingDAO(), new CustomMetadataTypeDAO(),
             new OrganizationDAO(), new SharePointCalloutUtility(), new SharePointConfiguration());
    }

    @TestVisible private SharePointOpportunityManager(List<Opportunity> newOpps, Map<Id, Opportunity> oldOpps,
            CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance,
            CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance,
            OrganizationDAO.IOrganizationDAO organizationDAOInstance,
            SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance,
            SharePointConfiguration sharePointConfigurationInstance) {

        this.newOpps = newOpps;
        this.oldOpps = oldOpps;
        this.customSettingDAOInstance = customSettingDAOInstance;
        this.customMetadatTypeDAOInstance = customMetadatTypeDAOInstance;
        this.organizationDAOInstance = organizationDAOInstance;
        this.sharePointCalloutUtilityInstance = sharePointCalloutUtilityInstance;
        this.sharePointConfigurationInstance = sharePointConfigurationInstance;
    }

    public void setSObject(List<SObject> sObjects) {
        this.newOpps = (List<Opportunity>) sObjects;
    }

    public void execute(QueueableContext context) {
        Map<String, Exception> exceptions = new Map <String, Exception>();
        String recDetails;
        //Map containing parent account info
        Map<Id, Account> accMap = new Map<Id, Account>();
        for (Account acc : [Select Id, Name, External_Id__c From Account WHERE Id IN
                            (Select AccountId from Opportunity WHERE Id IN :newOpps)]) {
            accMap.put(acc.Id, acc);
        }

        sharePointCalloutUtilityInstance = new SharePointCalloutUtility();
        HttpResponse response;
        String oldFolderName;
        String newFolderName;
        String action;

        for (Opportunity opp : newOpps) {
            if ( oldOpps.isEmpty() ) {
                newFolderName = SharePointFolderBuilder.buildOpportunityFolderPath( opp.Name, opp.AccountId, accMap);
                action = SharePointCalloutUtility.CREATE_FOLDER;
            } else if ( !oldOpps.isEmpty() ) {
                newFolderName = SharePointFolderBuilder.buildOpportunityFolderPath( opp.Name, opp.AccountId, accMap);
                oldFolderName = SharePointFolderBuilder.buildOpportunityFolderPath( oldOpps.get(opp.Id).Name, oldOpps.get(opp.Id).AccountId, accMap);
                action = SharePointCalloutUtility.MODIFY_FOLDER;
            }
            recDetails = opp.Name + ' ' + opp.Id + ' Folder: ' + newFolderName;

            if (!Test.isRunningTest()) {
                try {
                    response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( action, newFolderName, oldFolderName, opp);

                    if (response.getStatusCode() == 401 && response.getBody().contains(sharePointConfigurationInstance.getTokenExpiredResponseText())) {
                        sharePointCalloutUtilityInstance.refreshAccessToken();
                        //retry
                        response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( action, newFolderName, oldFolderName, opp);

                    }
                    if (response.getStatusCode() == 201) {
                        if ( action.equalsIgnoreCase('CreateFolder') ) {
                            //callout to change the content type of the list item
                            //additional attributes on the folder get set here
                            response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( 'UpdateContentType', newFolderName, newFolderName, opp);

                            response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( 'CreateFolder', newFolderName + '/MISC', null, opp);

                        }
                    } else if (response.getStatusCode() == 204 && action.equalsIgnoreCase(SharePointCalloutUtility.MODIFY_FOLDER) ) {
                        System.debug('Folder has been modified');
                    } else {
                        SharePointOpportunityManagerException e = new SharePointOpportunityManagerException(response.getBody());
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
                                                  e, SharePointOpportunityManager.class.getName() +
                                                  '.execute()', HIGH_PRIORITY);
            }
        }

    }

    public class SharePointOpportunityManagerException extends Exception {}
}