public class CaseFilesConnectController implements Database.AllowsCallouts {

    public Id caseId {get; set;}
    public Integer pageSize {get; set;}
    public Integer noOfPages {get; set;}
    public Integer totalNoOfRecs {get; set;}
    public Integer pageNumber {get; set;}
    private String baseQuery;
    public String fileName {get; set;}
    public String fileType {get; set;}
    public List<SharePointFilesWrapper> sharepointFiles {get; set;}
    public SPFilesJSON2Apex spFilesCon {get;set;}

    public Case caseRec {get; set;}
    public Boolean isDisabled {get; set;}
    public String folderLink {get; set;}
    public String requestLabel;
    public String result {get; set;}

	public Account acc;
	public Map<Id, Account> accMap;
	public Opportunity opp;
	public Map<Id, Opportunity> oppMap;

    public static String spUrl;
    public static String authUrl;
    public static String tokenUrl;
    public static String redirectUri;

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
    @TestVisible private SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance {get; set;}
    @TestVisible private SharePointConfiguration sharePointConfiguration {get; set;}

    public CaseFilesConnectException spException;
    public String errorString;

    public CaseFilesConnectController(ApexPages.StandardController std) {
        this(std, new CaseDAO(),
                    new SharePointCalloutUtility(),
                            new SharePointConfiguration());
    }

    @TestVisible private CaseFilesConnectController(ApexPages.StandardController std,
                                                        CaseDAO.ICaseDAO caseDAOInstance,
                                                                SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance,
                                                                    SharePointConfiguration sharePointConfiguration) {
        try{
            totalNoOfRecs = 0;
            pageSize = 4;

            this.caseDAOInstance = caseDAOInstance;
            this.sharePointCalloutUtilityInstance = sharePointCalloutUtilityInstance;
            this.sharePointConfiguration = sharePointConfiguration;
            
            spException = null;
            caseId = ApexPages.CurrentPage().getparameters().get('id');
            caseRec = caseDAOInstance.getCaseById(caseId);

            if(caseRec.Opportunity_Name__r.Id == null){
                errorString = System.Label.SharePoint_Missing_Opportunity_On_Case;
            } else {
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

        } catch(Exception e){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Unknown_Issue));
            spException = new CaseFilesConnectException('Unknown exception in the constructor initialization.' + e);
        }
    }
 
    public PageReference getInitialDocumentSet() {
        
        try {

            if(spException != null){
                CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                            null, APEX_CLASS + ' constructor', HIGH_PRIORITY);
                return null;
            }

            sharepointFiles = new List<SharePointFilesWrapper>();


            String folderName = SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber, caseRec.Opportunity_Name__r.Id, oppMap, accMap).replace(' ','%20');
            HttpResponse response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FILES, folderName, '', null);

            String responseJSON =  response.getBody().replace('__', '');

            if(response == null){
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sharepoint service may have timed out.  Please contact your administrator.'));
                spException = new CaseFilesConnectException('SHAREPOINT CALLOUT EXCEPTION: null http response.  REST Callout may have timed out.');
                CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                            null, CaseFilesConnectException.class.getName()+
                                                                'getInitialDocumentSet()', HIGH_PRIORITY);
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
                spFilesCon = (SPFilesJSON2Apex)System.JSON.deserialize(responseJSON, SPFilesJSON2Apex.class);
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
                    for(Integer i=0;i<pageSize ;i++){
                        if(!(i >= spFilesCon.d.results.size())){
                            SharePointFilesWrapper spWrapper = new SharePointFilesWrapper(spFilesCon.d.results[i]);
                            sharepointFiles.add(spWrapper);
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
        sharepointFiles = new List<SharePointFilesWrapper>();
        
        try {
            Integer offset = pageNumber * pageSize;

            for(Integer i=offset;i<(pageSize + offset);i++){
                if(!(i >= spFilesCon.d.results.size())){
                    SharePointFilesWrapper spWrapper = new SharePointFilesWrapper(spFilesCon.d.results[i]);
                    sharepointFiles.add(spWrapper);
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

                mainURL = teamSharePointURL + viewURLPath + '?sourcedoc=' + 
                            teamURLPath + sharePointListName + '/' +
                                SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber, caseRec.Opportunity_Name__r.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                                        '/' + (String.isEmpty(escapedFile)?EncodingUtil.urlEncode(fileName, UTF8_ENCODING):escapedFile); 
           
            } else {
                mainURL = teamSharePointURL  + sharePointListName + '/' +
                               SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber, caseRec.Opportunity_Name__r.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                                        '/' + fileName.replace(WHITE_SPACE, ENCODED_WHITE_SPACE);   
            }
           
            System.debug('MAIN URL - ' + mainURL);
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

    public PageReference downloadURL() {

        try {
            String mainURL;
            String escapedFile;

            mainURL = teamSharePointURL  + sharePointListName + '/' +
                               SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber, caseRec.Opportunity_Name__r.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                                        '/' + fileName.replace(WHITE_SPACE, ENCODED_WHITE_SPACE);     
          
            System.debug('MAIN URL - ' + mainURL);
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

    public void verifySharePointButton() {

        CaseFilesConnectException spException;
        try {
            sharePointCalloutUtilityInstance = new SharePointCalloutUtility();
            HttpResponse response = new HttpResponse();
            String folderName = 
                    SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber, caseRec.Opportunity_Name__r.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE);

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
 
    public class CaseFilesConnectException extends Exception {}

    public class SharePointFilesWrapper {
        public String name { get; set; }
        public String type { get; set; }
        public String author { get; set; }
        public Date createdDate { get; set; }
        public SPFilesJSON2Apex.Results file {get;set;} 

        public SharePointFilesWrapper(SPFilesJSON2Apex.Results file){
            this.file = file;
            this.name = file.name;
            if(file.Name != null){
                this.type = file.Name.substringAfterLast('.');
            }
            if(file.Author != null){
                this.author = file.Author.Title;   
            }
            if(file.Properties != null){
                this.createdDate = Date.valueOf(file.Properties.vti_x005f_timecreated.replace(TIME_SYMBOL,WHITE_SPACE)) ;
            }
        }

    }
}