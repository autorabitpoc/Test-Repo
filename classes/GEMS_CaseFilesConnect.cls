/**************************************************************************************
  Apex Class Name     : GEMS_CaseFilesConnect
  Version             : 1.0
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------------                 
*   Ranjit Gandhi           09/26/2017               SFDC-5038- GEMS - Display Last Modified By Date in the Sharepoint Files Section
*************************************************************************************/ 
public class GEMS_CaseFilesConnect implements Database.AllowsCallouts {

    public Id caseId {get; set;}
    public Integer pageSize {get; set;}
    public Integer noOfPages {get; set;}
    public Integer totalNoOfRecs {get; set;}
    public Integer pageNumber {get; set;}
    private String baseQuery;
    public String fileName {get; set;}
    public String fileType {get; set;}
    public List<SharePointFilesWrapper> sharepointFiles {get; set;}
    public GEMS_SPFilesJSON2Apex spFilesCon {get;set;}
    
    public Case caseRec {get; set;}
    public Boolean isDisabled {get; set;}
    public String folderLink {get; set;}
    public String folderPath {get; set;}
    public String requestLabel;
    public String result {get; set;}
    //SFDC-5096
    public Boolean isAcctMaintcase {get; set;}
    
    public static String spUrl;
    public static String authUrl;
    public static String tokenUrl;
    public static String redirectUri;
    
    public Account acc;
    public Map<Id, Account> accMap;
    public Opportunity opp;
    public Map<Id, Opportunity> oppMap;

    public static String clientId;
    public static String clientSecret;

    public static String staticRefreshToken;
    public static String staticAccessToken;

    public String teamSharePointURL;
    public String teamURLPath;
    public String viewURLPath;
    public String sharePointListName;
    public String sharePointURL;
    public String findFolderURL;

    public static final String EMPTY_STRING = '';
    public static final String NEW_LINE = '\n';
    public static final String UTF8_ENCODING = 'UTF-8';
    public static final String APEX_CLASS = 'Apex Class';
    public static final String SOBJECT_TYPE = String.valueOf(Account.sObjectType);
    public static final String HIGH_PRIORITY = 'High';
    public static final String PDF = 'pdf';
    public static final String PNG = 'png';
    public static final String CDB = 'csv';
    public static final String TXT = 'txt';
    public static final String XLTM = 'xltm';
    public static final String XML = 'xml';
    public static final String WHITE_SPACE = ' ';
    public static final String PLUS_SYMBOL = '+';
    public static final String DOUBLE_UNDERSCORE = '__';
    public static final String ENCODED_WHITE_SPACE = '%20';
    public static final String TIME_SYMBOL = 'T';

    public static Set<String> fileTypes = new Set<String>{PDF,PNG,CDB,TXT,XLTM,XML};

    @TestVisible private CaseDAO.ICaseDAO caseDAOInstance {get; set;}
    @TestVisible private ItemsSharePointDAO.IItemsSharePointDAO itemsSharePointDAOInstance {get; set;}
    @TestVisible private SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance {get; set;}
    @TestVisible private SharePointConfiguration sharePointConfiguration {get; set;}

    public CaseFilesConnectException spException;
    public String errorString;

    public GEMS_CaseFilesConnect(ApexPages.StandardController std) {
        this(std, new CaseDAO(),
                    new ItemsSharePointDAO(),
                        new SharePointCalloutUtility(),
                            new SharePointConfiguration());
    }    

    @TestVisible private GEMS_CaseFilesConnect(ApexPages.StandardController std,
                                                CaseDAO.ICaseDAO caseDAOInstance,
                                                    ItemsSharePointDAO.IItemsSharePointDAO itemsSharePointDAOInstance,
                                                        SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance,
                                                            SharePointConfiguration sharePointConfiguration) {

        pageSize = 4;
        pageNumber = 0;
        totalNoOfRecs = 0;
        
        caseId = ApexPages.CurrentPage().getparameters().get('id');
        
        
        /* 04/04/2017 Malathi.K Jira# 2726 */
        /* 04/21/2017 Malathi.K Jira# 4373 Replaced Parentid with gems_account_submission_info__C */    
         case casetype;                     
         casetype = [SELECT Id, Type, gems_account_submission_info__C FROM Case where Id = :caseId];
           If ((casetype.Type != 'Account Submission') && (casetype.Type != 'Account Maintenance')) {
                caseId = casetype.gems_account_submission_info__C;
                casetype = [SELECT Id, Type, gems_account_submission_info__C FROM Case where Id = :caseId];
              }
         
              
          this.isAcctMaintcase = false;     
       // SFDC-5096 Account Maintenance - Malathi.K       
           System.debug('casetypevalue=' +casetype.Type);
        if (casetype.Type == 'Account Maintenance'){
          System.debug('entered test1--');
          this.isAcctMaintcase = true;  
          sharePointConfiguration = new SharePointConfiguration(true); 
          sharePointCalloutUtilityInstance = new  SharePointCalloutUtility(sharePointConfiguration);
          system.debug('test1--sharePointConfiguration-' + sharePointConfiguration); 
          system.debug('test1--sharePointCalloutUtilityInstance-' + sharePointCalloutUtilityInstance);                  
        }           


        this.caseDAOInstance = caseDAOInstance;
        this.itemsSharePointDAOInstance = itemsSharePointDAOInstance;
        this.sharePointCalloutUtilityInstance = sharePointCalloutUtilityInstance;
        this.sharePointConfiguration = sharePointConfiguration;
        
        spException = null;
                                                               
        
        caseRec = caseDAOInstance.getCaseById(caseId);
        
        //SFDC-5096 - Added criteria to bring Opp. and Account Info. for only Non. Acct. Maint. Cases
        if (casetype.Type != 'Account Maintenance'){
          if(caseRec.Opportunity_Name__r.Id == null){
            errorString = System.Label.SharePoint_Missing_Opportunity_On_Case;
           }

         opp = [SELECT Id, AccountId, Name FROM Opportunity WHERE Id =: caseRec.Opportunity_Name__c];
         oppMap = new Map<Id, Opportunity>{opp.Id => opp};
         acc = [SELECT Id, Name, External_Id__c FROM Account WHERE Id =: opp.AccountId];
         accMap = new Map<Id, Account>{acc.Id => acc};
        }

        staticAccessToken = sharePointConfiguration.getAccessToken();
        staticRefreshToken = sharePointConfiguration.getRefreshToken();
        teamSharePointURL = sharePointConfiguration.getTeamSharePointURL();
        teamURLPath = sharePointConfiguration.getTeamURLPath();
        viewURLPath = sharePointConfiguration.getViewURLPath();
        sharePointListName = sharePointConfiguration.getListName();
        sharePointURL = sharePointConfiguration.getSharePointURL();
        findFolderURL = sharePointConfiguration.getFindFolderURL();

        this.isDisabled = true;
        this.folderLink = EMPTY_STRING;
        
        system.debug('test2--sharePointConfiguration-' + sharePointConfiguration); 
        system.debug('test2--sharePointCalloutUtilityInstance-' + sharePointCalloutUtilityInstance); 
    }
 
    public PageReference getInitialDocumentSet() {

        try {
            if(spException != null){
                CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                            null, APEX_CLASS + ' constructor', HIGH_PRIORITY);
                return null;
            }

            sharepointFiles = new List<SharePointFilesWrapper>();
            
            //SFDC-5096 Malathi.K - Get the right folder path respectively for Acct: Maintenance type
            String folderName;
             if (caseRec.Type == 'Account Maintenance') {                                    
                   folderName = SharePointFolderBuilder.buildAcctMaintCaseFolderPath(caseRec.CaseNumber, CaseRec.Account.Name, CaseRec.Account.External_Id__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE);
                 }
             else{                                   
                 folderName = SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber, caseRec.Opportunity_Name__r.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE);
             }
                        
            folderPath = folderName;
               system.debug('test3--sharePointConfiguration-' + sharePointConfiguration); 
                  system.debug('test3--sharePointCalloutUtilityInstance-' + sharePointCalloutUtilityInstance); 
            HttpResponse response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FILES, folderName, '', null);

            if(response == null){
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sharepoint service may have timed out.  Please contact your administrator.'));
                spException = new CaseFilesConnectException('SHAREPOINT CALLOUT EXCEPTION: null http response.  Callout request may have timed out.');
                CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                                null, CaseFilesConnectException.class.getName()+
                                                                    ' getInitialDocumentSet()', HIGH_PRIORITY);
                return null;
            }

            if (response.getStatusCode() == 401 && response.getBody().contains(sharePointConfiguration.getTokenExpiredResponseText())){
                sharePointCalloutUtilityInstance.refreshAccessToken();
                response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FILES, folderName, '', null);
                if(response.getStatusCode() != 200){
                    this.isDisabled = true;
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Authentication_Issue));
                    spException = new CaseFilesConnectException('SHAREPOINT CALLOUT EXCEPTION'+ NEW_LINE + 
                                                                   'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                                   'HTTP Response Body - ' + response.getBody());

                    CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                            null, CaseFilesConnectException.class.getName()+
                                                                'verifySharePointButton()', HIGH_PRIORITY);
                }
            } else if(response.getStatusCode() != 200){
                this.isDisabled = true;
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Unknown_Issue));
                spException = new CaseFilesConnectException('Unknown exception with callout.'+ NEW_LINE + 
                                                            'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                            'HTTP Response Body - ' + response.getBody());

                CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                            null, CaseFilesConnectException.class.getName()+
                                                                                'verifySharePointButton()', HIGH_PRIORITY);
            } else {

                String responseJSON =  response.getBody().replace(DOUBLE_UNDERSCORE, EMPTY_STRING);
                spFilesCon = (GEMS_SPFilesJSON2Apex)System.JSON.deserialize(responseJSON, GEMS_SPFilesJSON2Apex.class);
                 /**************SFDC-7915 call future method for SharePoint To GEMS Attachment sync*********************/
                if(caseRec.Type != GEMS_Constants.TypeAccountMaintenance){
                  GEMS_Utility.AutoGemsAttSyncOnPageVisit(teamSharePointURL,sharePointListName,folderPath,responseJSON,CaseId);   
                }   
                /**************SFDC-7915*******************************************************************************/
            }


            if(spFilesCon != null){
                totalNoOfRecs = spFilesCon.d.results.size();

                pageNumber = 0;

                if (totalNoOfRecs <= 0) {
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Records to Display'));
                } else {

                    noOfPages = totalNoOfRecs / pageSize;
                    if (Math.mod(totalNoOfRecs, pageSize) > 0){
                        noOfPages++;
                    }
                    
                    sharepointFiles.clear();

                    for(Integer i=0;i<pageSize ;i++){
                        if(!(i >= spFilesCon.d.results.size())){
                            SharePointFilesWrapper spFile = new SharePointFilesWrapper(spFilesCon.d.results[i]);
                            sharePointFiles.add(spFile);
                        }
                    }
                }   
            }
        } catch (Exception e) {
           errorString += NEW_LINE + 'Exception occured while getting document set.';
           spException = new CaseFilesConnectException(errorString);
        }
        return null;
    }
   
    public PageReference next() {
        pageNumber++;

        queryDocuments();
        return null;
    }

    public PageReference previous() {
        pageNumber--;

        if (pageNumber < 0) {
            return null;
        }

        queryDocuments();
        return null;
    }

    private void queryDocuments() {
        try {
            Integer offset = pageNumber * pageSize;
            sharepointFiles.clear();
            for(Integer i=offset;i<(pageSize + offset);i++){
                if(!(i >= spFilesCon.d.results.size())){
                    SharePointFilesWrapper spFile = new SharePointFilesWrapper(spFilesCon.d.results[i]);
                    sharePointFiles.add(spFile);
                }
            }
        } catch (Exception e) {
            spException = new CaseFilesConnectException('Issue with document query: ' + e);
            CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                            null, CaseFilesConnectException.class.getName()+
                                                                'queryDocuments()', HIGH_PRIORITY);
            ApexPages.addMessages(e);
        }
    }

    public PageReference linkFile() {

        try {
            String mainURL;
            String escapedFile;

            if (!fileTypeCheck(fileType)) {

                if (fileName.containsWhitespace()) {
                    escapedFile = fileName.replace(WHITE_SPACE, PLUS_SYMBOL);
                }

                if (caseRec.Type == 'Account Maintenance') {
                    mainURL = teamSharePointURL + viewURLPath + '?sourcedoc=' + 
                            teamURLPath + sharePointListName + '/' +
                                SharePointFolderBuilder.buildAcctMaintCaseFolderPath(caseRec.CaseNumber,CaseRec.Account.Name, CaseRec.Account.External_Id__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                                        '/' + (String.isEmpty(escapedFile)?EncodingUtil.urlEncode(fileName, UTF8_ENCODING):escapedFile);
                   }
                   else{ mainURL = teamSharePointURL + viewURLPath + '?sourcedoc=' + 
                            teamURLPath + sharePointListName + '/' +
                                SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber, caseRec.Opportunity_Name__r.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                                        '/' + (String.isEmpty(escapedFile)?EncodingUtil.urlEncode(fileName, UTF8_ENCODING):escapedFile); 
                                        }
            } else {
              if (caseRec.Type == 'Account Maintenance') {
                  mainURL = teamSharePointURL  + sharePointListName + '/' +
                               SharePointFolderBuilder.buildAcctMaintCaseFolderPath(caseRec.CaseNumber,CaseRec.Account.Name, CaseRec.Account.External_Id__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                                        '/' + fileName.replace(WHITE_SPACE, ENCODED_WHITE_SPACE);}
                else { 
                  mainURL = teamSharePointURL  + sharePointListName + '/' +
                               SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber, caseRec.Opportunity_Name__r.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                                        '/' + fileName.replace(WHITE_SPACE, ENCODED_WHITE_SPACE);  }   
            }
            PageReference sharePointLink = new PageReference(mainURL);
            return sharePointLink;

        } catch (Exception e) {
            spException = new CaseFilesConnectException('Issue with SharePoint link to file: ' + e);
            CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                            null, CaseFilesConnectException.class.getName()+
                                                                'linkFile()', HIGH_PRIORITY);
            return null;
        }
    }

    public Boolean fileTypeCheck(String fileType){
        for(String type: fileTypes){
            if(fileType.toLowerCase().contains(type)){
                return true;
            }
        }
        return false;
    }

    public void verifySharePointButton() {

        CaseFilesConnectException spException;
        try {
           system.debug('test4--sharePointConfiguration-' + sharePointConfiguration); 
          system.debug('test4--sharePointCalloutUtilityInstance-' + sharePointCalloutUtilityInstance); 
           // sharePointCalloutUtilityInstance = new SharePointCalloutUtility(); Malathi.K Commented check it out
            HttpResponse response = new HttpResponse();
            System.debug('=caseRec.Opportunity_Name__r.Id='+caseRec.Opportunity_Name__r.Id);
            System.debug('=oppMap'+oppMap);
            
            String folderName;
            system.debug('caseRec.Type: '+caseRec.Type);
            if (caseRec.Type == 'Account Maintenance') {
              folderName = 
                    SharePointFolderBuilder.buildAcctMaintCaseFolderPath(caseRec.CaseNumber,CaseRec.Account.Name, CaseRec.Account.External_Id__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE);
                system.debug('folderName: '+folderName);
             } else{
               folderName = 
                    SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber, caseRec.Opportunity_Name__r.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE);
            system.debug('folderName: ' + folderName);
            }
            // Krishna added the line below - check it out
            sharePointCalloutUtilityInstance = new  SharePointCalloutUtility(sharePointConfiguration);
             
            system.debug('test5--sharePointConfiguration-' + sharePointConfiguration); 
          system.debug('test5--sharePointCalloutUtilityInstance-' + sharePointCalloutUtilityInstance); 
          
            response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FOLDER, folderName, EMPTY_STRING, caseRec);

            if (response.getStatusCode() == 401 && response.getBody().contains(sharePointConfiguration.getTokenExpiredResponseText())){
                sharePointCalloutUtilityInstance.refreshAccessToken();
                response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FOLDER, folderName, EMPTY_STRING, caseRec);
                if(response.getStatusCode() != 200){
                    this.isDisabled = true;
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Authentication_Issue));
                    spException = new CaseFilesConnectException('SHAREPOINT CALLOUT EXCEPTION'+ NEW_LINE + 
                                                                   'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                                   'HTTP Response Body - ' + response.getBody());

                    CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                            null, CaseFilesConnectException.class.getName()+
                                                                'verifySharePointButton()', HIGH_PRIORITY);
                }
            } else if(response.getStatusCode() != 200){
                this.isDisabled = true;
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Unknown_Issue));
                spException = new CaseFilesConnectException('Unknown exception with callout.'+ NEW_LINE + 
                                                            'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                            'HTTP Response Body - ' + response.getBody());

                CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                            null, CaseFilesConnectException.class.getName()+
                                                                                'verifySharePointButton()', HIGH_PRIORITY);
            } else {
                this.isDisabled = false;
                this.folderLink = sharePointURL + teamURLPath + sharePointListName +
                                    '/' + folderName;
            }

            sharePointCalloutUtilityInstance.updateAccessToken();

        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Unknown_Issue));
            CreateExceptionLog.insertErrorLog(e, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                            null, CaseFilesConnectException.class.getName()+
                                                                    'verifySharePointButton()', HIGH_PRIORITY);
        }
    }

    public void syncDocumentsFromItems_SharePointObj()
    {
        System.debug('Into Sync Method');
        try{
            System.debug('CaseId=====>'+CaseId);
            System.debug('String.valueOf(caseId).substring(0,15)=====>'+String.valueOf(caseId).substring(0,15));

            String mainURL;
            mainURL = teamSharePointURL  + sharePointListName + '/' + folderPath; 

            List<SharePointFilesWrapper> sharePointDocs = new List<SharePointFilesWrapper>();

            for(GEMS_SPFilesJSON2Apex.Results r : spFilesCon.d.results){
                    SharePointFilesWrapper spFile = new SharePointFilesWrapper(r);
                    spFile.DownloadURL = mainURL + '/' + r.Name;
                    sharePointDocs.add(spFile);
                    System.debug('RESULT = ' + r);
            }

            List<GEMS_Attachment__c> gemsAttachments = [SELECT Id, Name, SharePointExtId__c,Account_Name__c, Attachment__c, BA_Info__c, Case__c, Description__c,
                                                        AttachmentUrl__c
                                                        FROM GEMS_Attachment__c
                                                        WHERE Case__c =: caseId
                                                        ];
            
            System.debug('===>sharePointDocs:'+sharePointDocs);
            System.debug('===>gemsAttachments:'+gemsAttachments);

            Map<String,GEMS_Attachment__c> stringGemsAttachRecMap = new Map<String,GEMS_Attachment__c> ();
            Map<String,SharePointFilesWrapper> stringSharePointRecMap = new Map<String,SharePointFilesWrapper> ();
            
            /*October hot fix 2016
                The below code added to restrict file name length to 80 characters as the 
                name field in GEMS_Attachment__c object max allowed length is 80 */
            for(GEMS_Attachment__c attachmntRec: gemsAttachments) {
                stringGemsAttachRecMap .put(attachmntRec.Name,attachmntRec);
            }
            
            /*October hot fix 2016
                The below code added to restrict file name length to 80 characters as the 
                name field in GEMS_Attachment__c object max allowed length is 80 */
            for(SharePointFilesWrapper attachmntRec: sharePointDocs) {
                String sharePointAttachmentName = subStringAttachmentName(attachmntRec.Name);
                stringSharePointRecMap.put(sharePointAttachmentName,attachmntRec);
            }

            List<GEMS_Attachment__c> gemsAttachmentsToBeInserted = new List<GEMS_Attachment__c>();
            List<GEMS_Attachment__c> gemsAttachmentsToBeDeleted = new List<GEMS_Attachment__c>();

            for(SharePointFilesWrapper sharePointDoc: sharePointDocs) {
                System.debug('=====>sharePointDoc' +sharePointDoc);
                /*October hot fix 2016
                The below code added to restrict file name length to 80 characters as the 
                name field in GEMS_Attachment__c object max allowed length is 80 */
                String sharePointFileName = sharepointDoc.Name;
                if(sharePointFileName != null && sharePointFileName.length() > 80) {
                    sharePointFileName = subStringAttachmentName(sharePointFileName);
                }
                if (!gemsAttachments.isEmpty() && gemsAttachments != null) {
                    if(!stringGemsAttachRecMap.containsKey(sharePointFileName)) {

                        GEMS_Attachment__c gemsAttachFile = new GEMS_Attachment__c();
                        gemsAttachFile.Name = sharePointFileName;
                        gemsAttachFile.AttachmentUrl__c=sharepointDoc.DownloadUrl;
                        gemsAttachFile.BA_Info__c = sharepointDoc.BAInfo;
                        gemsAttachFile.Case__c = caseId;
                        gemsAttachFile.Description__c = sharepointDoc.CaseDescription;
                        gemsAttachFile.Type__c = sharepointDoc.DocumentType;
                        gemsAttachFile.Level__c  = sharepointDoc.Level;
                        gemsAttachFile.SharePointExtId__c = sharepointDoc.ExternalId;
                        gemsAttachFile.File_Name__c = sharepointDoc.Name; //New field added and populating for preserve total file name 
                        gemsAttachmentsToBeInserted.add(gemsAttachFile);

                    } else if(stringGemsAttachRecMap.containsKey(sharePointFileName)) {

                        GEMS_Attachment__c gemsAttachFile = new GEMS_Attachment__c();
                        gemsAttachFile.id= stringGemsAttachRecMap.get(sharePointFileName).id;
                        gemsAttachFile .AttachmentUrl__c=sharepointDoc.DownloadUrl;
                        gemsAttachFile .BA_Info__c = sharepointDoc.BAInfo;
                        gemsAttachFile .Case__c = caseId;
                        gemsAttachFile .Description__c = sharepointDoc.CaseDescription;
                        gemsAttachFile .Type__c = sharepointDoc.DocumentType;
                        gemsAttachFile.Level__c  = sharepointDoc.Level;
                        gemsAttachFile.SharePointExtId__c = sharepointDoc.ExternalId;
                        gemsAttachFile.File_Name__c = sharepointDoc.Name;//New field added and populating for preserve total file name 
                        gemsAttachmentsToBeInserted.add(gemsAttachFile);
                    }
                    
                } else if(gemsAttachments.isEmpty()){
                    GEMS_Attachment__c gemsAttachFile = new GEMS_Attachment__c();
                    gemsAttachFile.Name = sharePointFileName;
                    gemsAttachFile.AttachmentUrl__c=sharepointDoc.DownloadUrl;
                    gemsAttachFile.BA_Info__c = sharepointDoc.BAInfo;
                    gemsAttachFile.Case__c = caseId;
                    gemsAttachFile.Description__c = sharepointDoc.CaseDescription;
                    gemsAttachFile.Type__c = sharepointDoc.DocumentType;
                    gemsAttachFile.Level__c  = sharepointDoc.Level;
                    gemsAttachFile.SharePointExtId__c = sharepointDoc.ExternalId;
                    gemsAttachFile.File_Name__c = sharepointDoc.Name;//New field added and populating for preserve total file name 
                    gemsAttachmentsToBeInserted.add(gemsAttachFile);
                }

            }
            if(!gemsAttachmentsToBeInserted.isEmpty()){
                System.debug('--upserting--');
                upsert gemsAttachmentsToBeInserted;
            }
                    
            for(GEMS_Attachment__c attachmntRec: gemsAttachments) {
                if(!stringSharePointRecMap.containsKey(attachmntRec.Name) && attachmntRec.SharePointExtId__c != null)
                    gemsAttachmentsToBeDeleted.add(attachmntRec);
            }
            
            if(!gemsAttachmentsToBeDeleted.isEmpty()) {
                System.debug('--deleting--');
                delete gemsAttachmentsToBeDeleted;
            }
        } catch(Exception ex) {
            System.debug('An Exception has been occured during the syncDocumentsFromItems_SharePointObj'+ ex.getMessage());
        }
}

    public PageReference SFlinkFile(String spfilename) {

        try {
            String mainURL;
            String escapedFile;

            if (fileType.contains('application') && !fileType.contains(PDF) && !fileType.contains('octet-stream')) {

                if (spfilename.containsWhitespace()) {
                    escapedFile = spfilename.replace(WHITE_SPACE, PLUS_SYMBOL);
                }

                 if (caseRec.Type == 'Account Maintenance') {
                   mainURL = teamSharePointURL + viewURLPath + '?sourcedoc=' + 
                                teamURLPath + sharePointListName + '/' +
                                    SharePointFolderBuilder.buildAcctMaintCaseFolderPath(caseRec.CaseNumber,CaseRec.Account.Name, CaseRec.Account.External_Id__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                                            '/' + EncodingUtil.urlEncode(spfilename, UTF8_ENCODING); 
                                            }
                 else{                           
                   mainURL = teamSharePointURL + viewURLPath + '?sourcedoc=' + 
                                teamURLPath + sharePointListName + '/' +
                                    SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber, caseRec.Opportunity_Name__r.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                                            '/' + EncodingUtil.urlEncode(spfilename, UTF8_ENCODING); }
                mainURL += escapedFile;
            } else 
               {
                 if (caseRec.Type == 'Account Maintenance') {
                   mainURL = teamSharePointURL  + sharePointListName + '/' +
                               SharePointFolderBuilder.buildAcctMaintCaseFolderPath(caseRec.CaseNumber,CaseRec.Account.Name, CaseRec.Account.External_Id__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                                        '/' + spfilename.replace(WHITE_SPACE, ENCODED_WHITE_SPACE); 
                                        }
                  else{                                    
                   mainURL = teamSharePointURL  + sharePointListName + '/' +
                               SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber, caseRec.Opportunity_Name__r.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                                        '/' + spfilename.replace(WHITE_SPACE, ENCODED_WHITE_SPACE); }    
            }
            
            PageReference sharePointLink = new PageReference(mainURL);
            return sharePointLink;

        } catch (Exception e) {
            spException = new CaseFilesConnectException('Issue with SharePoint link to file: ' + e);
            CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                            null, CaseFilesConnectException.class.getName()+
                                                                'linkFile()', HIGH_PRIORITY);
            return null;
        }
    }

    public PageReference downloadURL() {

        try {
            String mainURL;
            String escapedFile;

             if (caseRec.Type == 'Account Maintenance') { 
               mainURL = teamSharePointURL  + sharePointListName + '/' +
                           SharePointFolderBuilder.buildAcctMaintCaseFolderPath(caseRec.CaseNumber,CaseRec.Account.Name, CaseRec.Account.External_Id__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                                    '/' + fileName.replace(WHITE_SPACE, ENCODED_WHITE_SPACE);  }
            else {
              mainURL = teamSharePointURL  + sharePointListName + '/' +
                           SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber, caseRec.Opportunity_Name__r.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                                    '/' + fileName.replace(WHITE_SPACE, ENCODED_WHITE_SPACE);   
                  }                    

            PageReference sharePointLink = new PageReference(mainURL);
            return sharePointLink;

        } catch (Exception e) {
            spException = new CaseFilesConnectException('Issue with SharePoint link to file: ' + e);
            CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                            null, CaseFilesConnectException.class.getName()+
                                                                'linkFile()', HIGH_PRIORITY);
            return null;
        }
    }

    public class SharePointFilesWrapper {
        public String name {get; set;}
        public String type {get; set;}
        public String documentType {get; set;}
        public String level {get; set; }
        public String baInfo {get; set;}
        public String caseDescription {get; set;}
        public String author {get; set;}
        public Date createdDate {get; set;}
        
        //Ranjit Gandhi SFDC-5038- GEMS - Display Last Modified By Date & Date in Sharepoint
        public Date TimeLastModified {get; set;}
        public String ModifiedBy {get; set;}
        
        
        public GEMS_SPFilesJSON2Apex.Results file {get;set;}
        public String downloadURL {get; set;}
        public String externalId {get; set;}

        public SharePointFilesWrapper(GEMS_SPFilesJSON2Apex.Results file){
            this.file = file;
            this.name = file.Name;
            if ( file.Name != null ) {
                this.type = file.Name.substringAfterLast('.');
            }
            this.author = file.Author.Title;
            if ( file.Properties.vti_x005f_timecreated != null ) {
                this.createdDate = Date.valueOf(file.Properties.vti_x005f_timecreated);
            }
            //Ranjit Gandhi- SFDC-5038- GEMS - Display Last Modified By Date in the Sharepoint Files Section
            // Last modified date on Sharepoint section
            if(file.Properties.vti_x005f_timelastmodified !=null)
            {
                this.TimeLastModified=Date.valueOf(file.Properties.vti_x005f_timelastmodified);
            }
            this.documentType = file.Properties.DocumentType;
            this.level = file.Properties.DocumentLevel;
            this.baInfo = file.Properties.BAInfo;
            this.caseDescription = file.Properties.CaseDescription;
            this.externalId = file.Properties.ODatax005f_dlc_x005f_DocId;
            
            //Ranjit Gandhi- SFDC-5038- GEMS - Display Last Modified By Date in the Sharepoint Files Section
            // Modified by on Sharepoint section
            
            
        
                String modifiedsplit=file.Properties.vti_x005f_modifiedby.substringAfter('membership|');
                modifiedsplit=modifiedsplit.substringBefore('@');
                this.ModifiedBy=modifiedsplit;
                    
            
        }
    }

    public class CaseFilesConnectException extends Exception {}
    
   /******************************************************************** 
    *    Method Name : subStringAttachmentName
    *   @description : This new method is added for October hot fix 2016
                    This method is to substring to 80 characters to the attachment name as its maximum length is 80 characters
    *   @parameters  :   String attachmentName
    *   @return type :   String
    *   @Author : Balaram
    ***************************************************************/
    public String subStringAttachmentName(String attachmentName) {
        try {
            if(attachmentName != null && attachmentName.length() > 80) {
                attachmentName = attachmentName.subString(0,80);
            }
        }catch(Exception ex) {
            spException = new CaseFilesConnectException('Issue with document name: ' + ex);
            CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                            null, CaseFilesConnectException.class.getName()+
                                                                attachmentName, HIGH_PRIORITY);
        }
        return attachmentName;
    }
}