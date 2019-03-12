/**************************************************************************************
Apex Class Name     : QuoteFilesConnect
Version             : 1.0
Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------------                 
*   Ranjit Gandhi/Malathi          // 4784
*************************************************************************************/ 
public class QuoteFilesConnect implements Database.AllowsCallouts {
    
    public Id QuoteReqid {get; set;}
    public Integer pageSize {get; set;}
    public Integer noOfPages {get; set;}
    public Integer totalNoOfRecs {get; set;}
    public Integer pageNumber {get; set;}
    private String baseQuery;
    public String fileName {get; set;}
    public String fileType {get; set;}
    public List<SharePointFilesWrapper> sharepointFiles {get; set;}
    public GEMS_SPFilesJSON2Apex spFilesCon {get;set;}
    
    public Quote_Request_Summary__c QuoteReqRec {get; set;}
    public Quote QuoteRec {get; set;}
    
    public Boolean isDisabled {get; set;}
    public String folderLink {get; set;}
    public String folderPath {get; set;}
    public String requestLabel;
    public String result {get; set;}   
   
    //SFDC-4784
    public Boolean isQuotePage {get; set;}
    
    public static String spUrl;
    public static String authUrl;
    public static String tokenUrl;
    public static String redirectUri;
    
    public Account acc;
    // 4784
    String callingSource = 'LGNAQuoteRq';
    public Quote quotevar;
    public Quote_Request_Summary__c quoteRequestVar;
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
    public String quotestr;
    
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
    
    public QuoteFilesConnectException spException;
    public String errorString;
    
    public QuoteFilesConnect(ApexPages.StandardController std) {
        this(std, new CaseDAO(),
             new ItemsSharePointDAO(),
             new SharePointCalloutUtility(),
             new SharePointConfiguration());
             
    }    
    
    @TestVisible private QuoteFilesConnect(ApexPages.StandardController std,
                                           CaseDAO.ICaseDAO caseDAOInstance,
                                           ItemsSharePointDAO.IItemsSharePointDAO itemsSharePointDAOInstance,
                                           SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance,
                                           SharePointConfiguration sharePointConfiguration) {
                                               
                                               pageSize = 4;
                                               pageNumber = 0;
                                               totalNoOfRecs = 0;
                                               
                                               QuoteReqid = ApexPages.CurrentPage().getparameters().get('id'); 
                                               quotestr =  QuoteReqid + '';
                                              // quotestr.substring(0,3);
                                              
                                                  system.debug('isQuotePage - quotestr ' + isQuotePage + quotestr);
                                               
                                                this.isQuotePage = false;
                                               //Id QuoterectypId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Price Matrix Quote').getRecordTypeId();
                                               
                                              If (quotestr.substring(0,3) == '0Q0' )
                                               //If (QuoterectypId  == '012190000000LHY') 
                                                 this.isQuotePage = true;
                                               
                                               system.debug('isQuotePage - quotestr ' + isQuotePage + quotestr);
                                               
                                               sharePointConfiguration = new SharePointConfiguration('LGNAQuoteRq'); // Aadd the right string parameter
                                               sharePointCalloutUtilityInstance = new  SharePointCalloutUtility(sharePointConfiguration);
                                               system.debug('test1--sharePointConfiguration-' + sharePointConfiguration); 
                                               system.debug('test1--sharePointCalloutUtilityInstance-' + sharePointCalloutUtilityInstance);                  
                                               
                                               
                                               
                                               this.caseDAOInstance = caseDAOInstance;
                                               this.itemsSharePointDAOInstance = itemsSharePointDAOInstance;
                                               this.sharePointCalloutUtilityInstance = sharePointCalloutUtilityInstance;
                                               this.sharePointConfiguration = sharePointConfiguration;
                                               
                                               spException = null;
                                               
                                               If (isQuotePage == true) {
                                                   QuoteRec = caseDAOInstance.getQuoteById(QuoteReqId);
                                               } else {
                                                  QuoteReqRec = caseDAOInstance.getQuoteReqById(QuoteReqId);
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
    system.debug('isQuotePage - ' +isQuotePage);
    system.debug(' quotestr - ' +quotestr);
    
}

public PageReference getInitialDocumentSet() {
    
    try {
        if(spException != null){
            CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                              null, APEX_CLASS + ' constructor', HIGH_PRIORITY);
            return null;
        }
        
        sharepointFiles = new List<SharePointFilesWrapper>();        
        String folderName;
        folderName = SharePointFolderBuilder.buildQuoteRqFolderPath(QuoteReqRec.name, 
                                                                    QuoteReqRec.Quote_Name__r.Name, QuoteReqRec.Opportunity_Name__c, 
                                                                    QuoteReqRec.Account_Name_tx__c,QuoteReqRec.Account_Number__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE);
        //system.debug('ZC - folderName = '+folderName);
        
        folderPath = folderName;
        //system.debug('test3--sharePointConfiguration-' + sharePointConfiguration); 
        //system.debug('test3--sharePointCalloutUtilityInstance-' + sharePointCalloutUtilityInstance); 
        HttpResponse response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FILES, folderName, '', null);
        
        if(response == null){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sharepoint service may have timed out.  Please contact your administrator.'));
            spException = new QuoteFilesConnectException('SHAREPOINT CALLOUT EXCEPTION: null http response.  Callout request may have timed out.');
            CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                              null, QuoteFilesConnectException.class.getName()+
                                              ' getInitialDocumentSet()', HIGH_PRIORITY);
            return null;
        }
        
        if (response.getStatusCode() == 401 && response.getBody().contains(sharePointConfiguration.getTokenExpiredResponseText())){
            sharePointCalloutUtilityInstance.refreshAccessToken();
            response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FILES, folderName, '', null);
            if(response.getStatusCode() != 200){
                this.isDisabled = true;
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Authentication_Issue));
                spException = new QuoteFilesConnectException('SHAREPOINT CALLOUT EXCEPTION'+ NEW_LINE + 
                                                             'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                             'HTTP Response Body - ' + response.getBody());
                
                CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                  null, QuoteFilesConnectException.class.getName()+
                                                  'verifySharePointButton()', HIGH_PRIORITY);
            }
        } else if(response.getStatusCode() != 200){
            this.isDisabled = true;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Unknown_Issue));
            spException = new QuoteFilesConnectException('Unknown exception with callout.'+ NEW_LINE + 
                                                         'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                         'HTTP Response Body - ' + response.getBody());
            
            CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                              null, QuoteFilesConnectException.class.getName()+
                                              'verifySharePointButton()', HIGH_PRIORITY);
        } else {
            
            String responseJSON =  response.getBody().replace(DOUBLE_UNDERSCORE, EMPTY_STRING);
            spFilesCon = (GEMS_SPFilesJSON2Apex)System.JSON.deserialize(responseJSON, GEMS_SPFilesJSON2Apex.class);
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
        spException = new QuoteFilesConnectException(errorString);
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
        spException = new QuoteFilesConnectException('Issue with document query: ' + e);
        CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                          null, QuoteFilesConnectException.class.getName()+
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
                SharePointFolderBuilder.buildQuoteRqFolderPath
                (QuoteReqRec.name, QuoteReqRec.Quote_Name__r.Name, QuoteReqRec.Opportunity_Name__c,QuoteReqRec.Account_Name_tx__c,QuoteReqRec.Account_Number__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                '/' + (String.isEmpty(escapedFile)?EncodingUtil.urlEncode(fileName, UTF8_ENCODING):escapedFile);
            
            
        } else {
            
            mainURL = teamSharePointURL  + sharePointListName + '/' +
                SharePointFolderBuilder.buildQuoteRqFolderPath(QuoteReqRec.name, QuoteReqRec.Quote_Name__r.Name, QuoteReqRec.Opportunity_Name__c,QuoteReqRec.Account_Name_tx__c,QuoteReqRec.Account_Number__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                '/' + fileName.replace(WHITE_SPACE, ENCODED_WHITE_SPACE);}
        
        
        PageReference sharePointLink = new PageReference(mainURL);
        return sharePointLink;
        
    } catch (Exception e) {
        spException = new QuoteFilesConnectException('Issue with SharePoint link to file: ' + e);
        CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                          null, QuoteFilesConnectException.class.getName()+
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
    
    QuoteFilesConnectException spException;
    try {
        
      
        HttpResponse response = new HttpResponse();
        //System.debug('=QuoteRec.Opportunity.id='+QuoteRec.Opportunity_Name__r.Id);
        //System.debug('=oppMap'+oppMap);
        
        String folderName;
                  //  System.debug('QuoteRec.Name, QuoteRec.Opportunity.Name, QuoteRec.Account.Name,QuoteRec.Account.External_Id__c'+QuoteRec.Name+' '+ QuoteRec.Opportunity.Name+ ' '+QuoteRec.Account.Name+' '+QuoteRec.Account.External_Id__c);
		
        
      
        if (isQuotePage == true) {
            System.debug('QuoteRec.Name, QuoteRec.Opportunity.Name, QuoteRec.Account.Name,QuoteRec.Account.External_Id__c'+QuoteRec.Name+' '+ QuoteRec.Opportunity.Name+ ' '+QuoteRec.Account.Name+' '+QuoteRec.Account.External_Id__c);
            folderName = SharePointFolderBuilder.buildQuoteRqQuoteFolderPath(QuoteRec.Name, QuoteRec.Opportunity.Name, 
                                                                    QuoteRec.Account.Name,QuoteRec.Account.External_Id__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE);            
        }
        else 
            folderName = SharePointFolderBuilder.buildQuoteRqFolderPath(QuoteReqRec.name, 
                                                                    QuoteReqRec.Quote_Name__r.Name, QuoteReqRec.Opportunity_Name__c, 
                                                                    QuoteReqRec.Account_Name_tx__c,QuoteReqRec.Account_Number__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE);
        system.debug('folderName: '+folderName);
        
        
        sharePointCalloutUtilityInstance = new  SharePointCalloutUtility(sharePointConfiguration);
        
        system.debug('test5--sharePointConfiguration-' + sharePointConfiguration); 
        system.debug('test5--sharePointCalloutUtilityInstance-' + sharePointCalloutUtilityInstance); 
        
        If (isQuotePage == true) {
            response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FOLDER, folderName, EMPTY_STRING, QuoteRec);
        }else {
           response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FOLDER, folderName, EMPTY_STRING, QuoteReqRec);
        }
        if (response.getStatusCode() == 401 && response.getBody().contains(sharePointConfiguration.getTokenExpiredResponseText())){
            sharePointCalloutUtilityInstance.refreshAccessToken();
            
            If (isQuotePage == true) {
               response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FOLDER, folderName, EMPTY_STRING, QuoteRec);
             }else {
                 response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FOLDER, folderName, EMPTY_STRING, QuoteReqRec);
              }
            if(response.getStatusCode() != 200){
                this.isDisabled = true;
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Authentication_Issue));
                spException = new QuoteFilesConnectException('SHAREPOINT CALLOUT EXCEPTION'+ NEW_LINE + 
                                                             'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                             'HTTP Response Body - ' + response.getBody());
                
                CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                  null, QuoteFilesConnectException.class.getName()+
                                                  'verifySharePointButton()', HIGH_PRIORITY);
            }
        } else if(response.getStatusCode() != 200){
            this.isDisabled = true;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Unknown_Issue));
            spException = new QuoteFilesConnectException('Unknown exception with callout.'+ NEW_LINE + 
                                                         'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                         'HTTP Response Body - ' + response.getBody());
            
            CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                              null, QuoteFilesConnectException.class.getName()+
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
                                          null, QuoteFilesConnectException.class.getName()+
                                          'verifySharePointButton()', HIGH_PRIORITY);
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
            
            
            mainURL = teamSharePointURL + viewURLPath + '?sourcedoc=' + 
                teamURLPath + sharePointListName + '/' +
                SharePointFolderBuilder.buildQuoteRqFolderPath(QuoteReqRec.name, 
                                                                    QuoteReqRec.Quote_Name__r.Name, QuoteReqRec.Opportunity_Name__c, 
                                                                    QuoteReqRec.Account_Name_tx__c,QuoteReqRec.Account_Number__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                '/' + EncodingUtil.urlEncode(spfilename, UTF8_ENCODING); 
            
            
            mainURL += escapedFile;
        } else 
        {
            
            mainURL = teamSharePointURL  + sharePointListName + '/' +
                SharePointFolderBuilder.buildQuoteRqFolderPath(QuoteReqRec.name, 
                                                                    QuoteReqRec.Quote_Name__r.Name, QuoteReqRec.Opportunity_Name__c, 
                                                                    QuoteReqRec.Account_Name_tx__c,QuoteReqRec.Account_Number__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                '/' + spfilename.replace(WHITE_SPACE, ENCODED_WHITE_SPACE); 
            
            
        }
        
        PageReference sharePointLink = new PageReference(mainURL);
        return sharePointLink;
        
    } catch (Exception e) {
        spException = new QuoteFilesConnectException('Issue with SharePoint link to file: ' + e);
        CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                          null, QuoteFilesConnectException.class.getName()+
                                          'linkFile()', HIGH_PRIORITY);
        return null;
    }
}

public PageReference downloadURL() {
    
    try {
        String mainURL;
        String escapedFile;
        
        
        mainURL = teamSharePointURL  + sharePointListName + '/' +
            SharePointFolderBuilder.buildQuoteRqFolderPath(QuoteReqRec.name, 
                                                                    QuoteReqRec.Quote_Name__r.Name, QuoteReqRec.Opportunity_Name__c, 
                                                                    QuoteReqRec.Account_Name_tx__c,QuoteReqRec.Account_Number__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
            '/' + fileName.replace(WHITE_SPACE, ENCODED_WHITE_SPACE);  
        
        
        PageReference sharePointLink = new PageReference(mainURL);
        return sharePointLink;
        
    } catch (Exception e) {
        spException = new QuoteFilesConnectException('Issue with SharePoint link to file: ' + e);
        CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                          null, QuoteFilesConnectException.class.getName()+
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

public class QuoteFilesConnectException extends Exception {}

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
        spException = new QuoteFilesConnectException('Issue with document name: ' + ex);
        CreateExceptionLog.insertErrorLog(spException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                          null, QuoteFilesConnectException.class.getName()+
                                          attachmentName, HIGH_PRIORITY);
    }
    return attachmentName;
}
}