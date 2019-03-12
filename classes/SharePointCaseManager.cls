public class SharePointCaseManager implements IQueueable, Database.AllowsCallouts {

    @TestVisible private CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance {get; set;}
    @TestVisible private CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance {get; set;}
    @TestVisible private OrganizationDAO.IOrganizationDAO organizationDAOInstance {get; set;}
    @TestVisible private SharePointCalloutUtility.ISharePointCalloutUtility sharePointcalloutUtilityInstance {get; set;}
    @TestVisible private SharePointConfiguration sharePointConfigurationInstance {get; set;}

    private String action;
    private List<Case> newCases;
    private Map<Id, Case> oldCases;

    public static final String APEX_CLASS = 'Apex Class';
    public static final String SOBJECT_TYPE = String.valueOf(Case.sObjectType);
    public static final String HIGH_PRIORITY = 'High';

    public SharePointCaseManager(List<Case> newCases, Map<Id, Case> oldCases) {        
        this(newCases, oldCases, new CustomSettingDAO(), new CustomMetadataTypeDAO(),
             new OrganizationDAO(), new SharePointCalloutUtility(), new SharePointConfiguration());
    }

    @TestVisible private SharePointCaseManager(List<Case> newCases, Map<Id, Case> oldCases,
            CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance,
            CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance,
            OrganizationDAO.IOrganizationDAO organizationDAOInstance,
            SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance,
            SharePointConfiguration sharePointConfigurationInstance) {
                    
        this.newCases = newCases;
        this.oldCases = oldCases;
        this.customSettingDAOInstance = customSettingDAOInstance;
        this.customMetadatTypeDAOInstance = customMetadatTypeDAOInstance;
        this.organizationDAOInstance = organizationDAOInstance;
        this.sharePointCalloutUtilityInstance = sharePointCalloutUtilityInstance;
        this.sharePointConfigurationInstance = sharePointConfigurationInstance;
    }

    public void setSObject(List<SObject> sObjects) {
        this.newCases = (List<Case>) sObjects;
    }

    public void execute(QueueableContext context) {
        Map<String, Exception> exceptions = new Map <String, Exception>();
        String recDetails;
        //Map containing parent Opp info including account id and opp name
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        for (Opportunity opp : [Select Id, Name, AccountId From Opportunity WHERE Id IN
                                (Select Opportunity_Name__c from Case WHERE Id IN :newCases)]) {
            oppMap.put(opp.Id, opp);
        }

        Map<Id, Account> accMap = new Map<Id, Account>();
        for (Account acc : [Select Id, Name, External_Id__c From Account WHERE Id IN
                            (Select AccountId from Opportunity WHERE Id IN :oppMap.keySet())]) {
            accMap.put(acc.Id, acc);
        }

        
        HttpResponse response;
        String oldFolderName;
        String newFolderName;
        String action;

        for (Case currCase : newCases) {
        //SFDC-5096 Malathi.K Check if Account Maintenance Case 
        if (currCase.type == 'Account Maintenance'){
          sharePointConfigurationInstance = new SharePointConfiguration(true); 
          sharePointCalloutUtilityInstance = new  SharePointCalloutUtility(sharePointConfigurationInstance);       
        }
        else
        {
            sharePointCalloutUtilityInstance = new SharePointCalloutUtility();
        }
            if (oldCases.isEmpty() ) {
                //SFDC-5096 Malathi.K Check if Account Maintenance Case
                if (currCase.type == 'Account Maintenance'){
                  newFolderName = SharePointFolderBuilder.buildAcctMaintCaseFolderPath(currCase.CaseNumber, currCase.Account_Name__c, currCase.Account_Number__c );
                }
                else{
                newFolderName = SharePointFolderBuilder.buildCaseFolderPath(currCase.CaseNumber,currCase.Opportunity_Name__c, oppMap, accMap );
                }
                action = SharePointCalloutUtility.CREATE_FOLDER;
            } else if ( !oldCases.isEmpty() ) {
               if (currCase.type == 'Account Maintenance'){
                 newFolderName = SharePointFolderBuilder.buildAcctMaintCaseFolderPath(currCase.CaseNumber, currCase.Account_Name__c, currCase.Account_Number__c );
                 oldFolderName = SharePointFolderBuilder.buildAcctMaintCaseFolderPath(oldCases.get(currCase.Id).CaseNumber, oldCases.get(currCase.Id).Account_Name__c,oldCases.get(currCase.Id).Account_Number__c);
               }
               else
               {
                newFolderName = SharePointFolderBuilder.buildCaseFolderPath( currCase.CaseNumber, currCase.Opportunity_Name__c, oppMap, accMap );
                oldFolderName = SharePointFolderBuilder.buildCaseFolderPath( oldCases.get(currCase.Id).CaseNumber, oldCases.get(currCase.Id).Opportunity_Name__c, oppMap, accMap );
                }
                action = SharePointCalloutUtility.MODIFY_FOLDER;
            }

            recDetails = currCase.caseNumber + ' ' + currCase.Id + ' Folder: ' + newFolderName;

            if (!Test.isRunningTest()) {
                try {
                    response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( action, newFolderName, oldFolderName, currCase);
                    system.debug('case create folder resp::::'+response);
                     if (response.getStatusCode() == 500) {
                     newFolderName = SharePointFolderBuilder.buildAcctMaintAcctFolderPath(currCase.Account_Name__c, currCase.Account_Number__c ); 
                     response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( action, newFolderName, oldFolderName, currCase);                      
                      system.debug('case create Acct folder resp::::'+response);
                       if (response.getStatusCode() == 201) {
                         newFolderName = SharePointFolderBuilder.buildAcctMaintCaseFolderPath(currCase.CaseNumber, currCase.Account_Name__c, currCase.Account_Number__c );
                        response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( action, newFolderName, oldFolderName, currCase);
                        system.debug('Maint case create folder second lvl resp::::'+response);
                       }                      
                      }                    
                    else {                    
                       if (response.getStatusCode() == 401 && response.getBody().contains(sharePointConfigurationInstance.getTokenExpiredResponseText())) {
                        sharePointCalloutUtilityInstance.refreshAccessToken();
                        //retry
                        response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( action, newFolderName, oldFolderName, CurrCase);
                      }  
                        }
                    if (response.getStatusCode() == 201) {
                        if ( action.equalsIgnoreCase('CreateFolder') ) {
                            //callout to change the content type of the list item
                            //additional attributes on the folder get set here
                            response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( 'UpdateContentType', newFolderName, newFolderName, currCase);
                            response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( 'CreateFolder', newFolderName + '/DeletedDocs', null, currCase);
                        }
                    } else if (response.getStatusCode() == 204 && action.equalsIgnoreCase(SharePointCalloutUtility.MODIFY_FOLDER) ) {
                        System.debug('Folder has been modified');
                    } else {
                        SharePointCaseManagerException e = new SharePointCaseManagerException(response.getBody());
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
                                                  e, SharePointCaseManager.class.getName() +
                                                  '.execute()', HIGH_PRIORITY);
            }
        }
    }

    public class SharePointCaseManagerException extends Exception {}
}