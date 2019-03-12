/**************************************************************************************
Apex Class Name     : GEMS_SharePointUtilityController 
Version             : 1.0
Function            : This is a GEMS Sharepoint Utility Class for Opportunity and Submission Case
Modification Log    :
Developer             Date                   Description
------------------------------------------------------------------------------------ 
Gokul Bharati         09/17/2017             This is a GEMS Sharepoint Utility Class for Opportunity and Submission Case
Jenny Dalsania		  06/26/2018			 SFDC 9616 GEMS: Add Contract Admin Request to Cosmetic and Account Eligibility Maintenance Cases - Sharepoint
**************************************************************************************/
public class GEMS_SharePointUtilityController implements Database.AllowsCallouts{
    
    public integer fakeErrorCode;//used for test class only
    public Boolean hasPageError { get { return ApexPages.hasMessages(); } }
    
    public Id recordId;
    public void setrecordId (Id value) {
        recordId = value;
    }
    public Id getrecordId() {
        return recordId;
    }
    
    public Id caseId;
    public void setcaseId (Id value) {
        caseId = value;
    }
    public Id getcaseId() {
        return caseId;
    }
    
    public Id opportunityId;
    public void setopportunityId (Id value) {
        opportunityId = value;
    }
    public Id getopportunityId() {
        return opportunityId;
    }
    
    public Case caseRec{get;set;} 
    public Account accRec{get;set;}
    public Map<Id, Account> accMap {get;set;}
    public Opportunity oppRec{get;set;}
    public Map<Id, Opportunity> oppMap {get;set;}
    
    public String casefileName {get; set;}
    public String casefileType {get; set;}
    public String oppfileName {get; set;}
    public String oppfileType {get; set;}
    public List<OpportunitySharePointFilesWrapper> OppSharepointFiles {get; set;}
    public List<CaseSharePointFilesWrapper> CaseSharepointFiles {get; set;}
    public GEMS_SPFilesJSON2Apex spCaseFilesCon;
    public SPFilesJSON2Apex spOppFilesCon;
    
    
    public string staticRefreshToken {get;set;} 
    public string staticAccessToken {get;set;} 
    public String teamSharePointURL {get;set;} 
    public String teamURLPath {get;set;} 
    public String viewURLPath {get;set;} 
    public String sharePointListName {get;set;} 
    public String sharePointURL {get;set;} 
    public String findFolderURL {get;set;} 
    public Boolean caseIsDisabled {get;set;}
    public Boolean oppIsDisabled {get;set;}
    public String folderPath {get;set;} 
    
    public String casefolderLink {get;set;}
    public String OppfolderLink {get;set;}
    
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
    public static final String XLSX ='xlsx';
    public static final String DOCX ='docx';
    public static final String WHITE_SPACE = ' ';
    public static final String PLUS_SYMBOL = '+';
    public static final String DOUBLE_UNDERSCORE = '__';
    public static final String ENCODED_WHITE_SPACE = '%20';
    public static final String TIME_SYMBOL = 'T';
    
    public static Set<String> fileTypes = new Set<String>{PDF,PNG,CDB,TXT,XLTM,XML,XLSX,DOCX};  
        
    public Integer casepageSize {get;set;}
    public Integer casenoOfPages {get;set;}
    public Integer casetotalNoOfRecs {get;set;}
    public Integer casepageNumber {get;set;}
    
    public Integer opppageSize {get;set;}
    public Integer oppnoOfPages {get;set;}
    public Integer opptotalNoOfRecs {get;set;}
    public Integer opppageNumber {get;set;}
    
    public AccountDAO.IAccountDAO AccountDAOInstance {get;set;}
    public CaseDAO.ICaseDAO caseDAOInstance {get;set;}
    public OpportunityDAO.IOpportunityDAO opportunityDAOInstance{get;set;}
    public ItemsSharePointDAO.IItemsSharePointDAO itemsSharePointDAOInstance {get;set;}
    public SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance {get;set;}
    public SharePointConfiguration sharePointConfiguration {get;set;}
    
    public CaseFilesConnectException spCaseException;
    public OpportunityFilesConnectException spOppException;
    
    public class CaseFilesConnectException extends Exception {}
    public class OpportunityFilesConnectException extends Exception {}
    
    public GEMS_SharePointUtilityController() {
        casetotalNoOfRecs = 0;
        casepageSize = 4;
        casepageNumber = 0;
        opptotalNoOfRecs = 0;
        opppageSize = 4;
        opppageNumber = 0;
        //Instantiate in the constructor to make it accesible by all methods 
        this.caseDAOInstance = new caseDAO();
        this.AccountDAOInstance = new AccountDAO();
        this.opportunityDAOInstance = new opportunityDAO();
    }
    
    //Account Submission Share Point Config 
    public void SetUpSharePointConfig(){           
        //instantiate
        this.itemsSharePointDAOInstance = new itemsSharePointDAO();
        this.sharePointConfiguration = new sharePointConfiguration(); 
        this.sharePointCalloutUtilityInstance = new SharePointCalloutUtility(sharePointConfiguration);                                                           
        this.staticAccessToken = sharePointConfiguration.getAccessToken();
        this.staticRefreshToken = sharePointConfiguration.getRefreshToken();
        this.teamSharePointURL = sharePointConfiguration.getTeamSharePointURL();
        this.teamURLPath = sharePointConfiguration.getTeamURLPath();
        this.viewURLPath = sharePointConfiguration.getViewURLPath();
        this.sharePointListName = sharePointConfiguration.getListName();
        this.sharePointURL = sharePointConfiguration.getSharePointURL();
        this.findFolderURL = sharePointConfiguration.getFindFolderURL();
        this.caseIsDisabled = true;
        this.oppIsDisabled = true;
        this.OppfolderLink = EMPTY_STRING;
        this.CasefolderLink = EMPTY_STRING;
        spCaseException = null; 
        spOppException = null; 
    }
    
    //Account Maintenance Share Point Config 
    //Passing the boolean value isAcctMaint as true to sharePointConfiguration
    //SFDC 9616 GEMS: Add Contract Admin Request to Cosmetic and Account Eligibility Maintenance Cases - Sharepoint
    public void SetUpSharePointMainConfig(){           
        //instantiate
        this.itemsSharePointDAOInstance = new itemsSharePointDAO();
        this.sharePointConfiguration = new sharePointConfiguration(true); 
        this.sharePointCalloutUtilityInstance = new SharePointCalloutUtility(sharePointConfiguration);                                                           
        this.staticAccessToken = sharePointConfiguration.getAccessToken();
        this.staticRefreshToken = sharePointConfiguration.getRefreshToken();
        this.teamSharePointURL = sharePointConfiguration.getTeamSharePointURL();
        this.teamURLPath = sharePointConfiguration.getTeamURLPath();
        this.viewURLPath = sharePointConfiguration.getViewURLPath();
        this.sharePointListName = sharePointConfiguration.getListName();
        this.sharePointURL = sharePointConfiguration.getSharePointURL();
        this.findFolderURL = sharePointConfiguration.getFindFolderURL();
        this.caseIsDisabled = true;
        this.oppIsDisabled = true;
        this.OppfolderLink = EMPTY_STRING;
        this.CasefolderLink = EMPTY_STRING;
        spCaseException = null; 
        spOppException = null; 
    }
    
    /*********************************************Opportunity Share Point Code**********************************************/
    
    public class OpportunitySharePointFilesWrapper {
        public String name { get; set; }
        public String type { get; set; }
        public String author { get; set; }
        public Date createdDate { get; set; }
        public SPFilesJSON2Apex.Results file {get;set;} 
        
        public OpportunitySharePointFilesWrapper(SPFilesJSON2Apex.Results file){
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
    
    public PageReference fetchOpportunityInitialDocumentSet() {
        try {
            if(opportunityId!=null){
                SetUpSharePointConfig();
                oppRec =  opportunityDAOInstance.getOpportunityById(opportunityId); 
                oppMap = new Map<Id,Opportunity>{opportunityId => oppRec};
                    if(oppRec.AccountId!=null){
                        set<Id> accountIds=new set<Id>();
                        accountIds.add(oppRec.AccountId);
                        accRec = AccountDAOInstance.getAccounts(accountIds)[0]; 
                        accMap = new Map<Id,Account>{oppRec.AccountId=> accRec };
                            } 
            }       
            if(spOppException != null){
                CreateExceptionLog.insertErrorLog(spOppException, null, null, null, APEX_CLASS, SOBJECT_TYPE,null, 'OpportunityFilesConnectController constructor', HIGH_PRIORITY);
                return null;
            }
            
            OppSharepointFiles = new List<OpportunitySharePointFilesWrapper>();
            String folderName = SharePointFolderBuilder.buildOpportunityFolderPath(oppRec.Name,accRec.Id, accMap).replace(WHITE_SPACE,ENCODED_WHITE_SPACE);           
            HttpResponse response = new HttpResponse();
            if(!Test.isRunningTest()){
                response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FILES,folderName, '', null);
                system.debug('<<<<<<<Response Opportunity Body>>>>>>'+response.getBody());
            }
            else if(Test.isRunningTest()){
                response = GEMS_SharePointUtilityController.FakeSharePointCallout(fakeErrorCode,'Opportunity');
            }
            
            if(response == null){
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sharepoint service may have timed out.  Please contact your administrator.'));
                spOppException = new OpportunityFilesConnectException('SHAREPOINT CALLOUT EXCEPTION: null http response.  Callout request may have timed out.');
                CreateExceptionLog.insertErrorLog(spOppException , null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                  null, OpportunityFilesConnectException.class.getName()+
                                                  'getOpportunityInitialDocumentSet()', HIGH_PRIORITY);
                return null;
            }
            
            if (response.getStatusCode() == 401 && response.getBody().contains(sharePointConfiguration.getTokenExpiredResponseText())){
                sharePointCalloutUtilityInstance.refreshAccessToken();
                response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FILES, folderName, '', null);
                if(response.getStatusCode() != 200){
                    this.oppisDisabled = true;
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Authentication_Issue));
                    spOppException = new OpportunityFilesConnectException('SHAREPOINT CALLOUT EXCEPTION'+ NEW_LINE + 
                                                                          'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                                          'HTTP Response Body - ' + response.getBody());
                    
                    CreateExceptionLog.insertErrorLog(spOppException , null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                      null, OpportunityFilesConnectException.class.getName()+
                                                      'getOpportunityInitialDocumentSet()', HIGH_PRIORITY);
                    return null;
                }
            } else if(response.getStatusCode() != 200){
                this.oppisDisabled = true;
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Unknown_Issue));
                spOppException = new OpportunityFilesConnectException('Unknown exception with callout.'+ NEW_LINE + 
                                                                      'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                                      'HTTP Response Body - ' + response.getBody());
                
                CreateExceptionLog.insertErrorLog(spOppException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                  null, OpportunityFilesConnectException.class.getName()+
                                                  'getOpportunityInitialDocumentSet()', HIGH_PRIORITY);
                return null;
            } else {
                String responseJSON =  response.getBody().replace(DOUBLE_UNDERSCORE, EMPTY_STRING);
                spOppFilesCon = (SPFilesJSON2Apex)System.JSON.deserialize(responseJSON, SPFilesJSON2Apex.class);
            }
            
            if(spOppFilesCon != null){
                opptotalNoOfRecs = spOppFilesCon.d.results.size();
                
                opppageNumber = 0;
                
                if (opptotalNoOfRecs <= 0) {
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Records to Display'));
                } else {
                    
                    oppnoOfPages = opptotalNoOfRecs / opppageSize;
                    if (Math.mod(opptotalNoOfRecs, opppageSize) > 0){
                        oppnoOfPages++;
                    }
                    OppSharepointFiles.clear();
                    for(Integer i=0;i<opppageSize ;i++){
                        if(!(i >= spOppFilesCon.d.results.size())){
                            OpportunitySharePointFilesWrapper spFile = new OpportunitySharePointFilesWrapper(spOppFilesCon.d.results[i]);
                            OppSharepointFiles.add(spFile);
                        }
                    }
                    oppverifySharePointButton();  
                }   
            }
        } catch (Exception e) {
            system.debug('Error Line Number'+e.getLineNumber()+'Error Message'+e.getMessage());
            spOppException = new OpportunityFilesConnectException('SHAREPOINT CALLOUT EXCEPTION - ' + e);
            CreateExceptionLog.insertErrorLog(spOppException, null, null, null, APEX_CLASS, SOBJECT_TYPE,
                                              null, OpportunityFilesConnectException.class.getName()+
                                              'getOppotyunityInitialDocumentSet()', HIGH_PRIORITY);
        }
        return null;
    }
    
    public PageReference oppnext() {
        opppageNumber++;
        
        oppqueryDocuments();
        return null;
    }
    
    public PageReference oppprevious() {
        opppageNumber--;
        
        if (opppageNumber < 0) {
            return null;
        }
        
        oppqueryDocuments();
        return null;
    }
    
    public void oppqueryDocuments() {
        
        try {
            Integer offset = opppageNumber * opppageSize;
            OppSharepointFiles.clear();
            for(Integer i=offset;i<(opppageSize + offset);i++){
                if(!(i >= spOppFilesCon.d.results.size())){
                    OpportunitySharePointFilesWrapper  spWrapper = new OpportunitySharePointFilesWrapper (spOppFilesCon.d.results[i]);
                    OppSharepointFiles.add(spWrapper);
                }
            }
        } catch (Exception e) {
            system.debug('Error Line Number'+e.getLineNumber()+'Error Message'+e.getMessage());
            spOppException = new OpportunityFilesConnectException('Issue with document query: ' + e);
            CreateExceptionLog.insertErrorLog(spOppException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                              null, OpportunityFilesConnectException.class.getName()+
                                              'oppqueryDocuments()', HIGH_PRIORITY);
            ApexPages.addMessages(e);
        }
    }
    public String oppLinkURL{get;set;} 
    public PageReference opplinkFile() {
        
        try {
            oppLinkURL='';
            String escapedFile;
            
            if (!oppfileTypeCheck(oppfileType)) {
                if (oppfileName.containsWhitespace()) {
                    escapedFile = oppfileName.replace(WHITE_SPACE, PLUS_SYMBOL);
                }
                
                
                oppLinkURL = teamSharePointURL + viewURLPath + '?sourcedoc=' + 
                    teamURLPath + sharePointListName + '/' +
                    SharePointFolderBuilder.buildOpportunityFolderPath(oppRec.Name,accRec.Id, accMap).replace(WHITE_SPACE,ENCODED_WHITE_SPACE) + 
                    '/' + (String.isEmpty(escapedFile)?EncodingUtil.urlEncode(oppfileName, UTF8_ENCODING):escapedFile); 
                
            } else {
                
                oppLinkURL = teamSharePointURL  + sharePointListName + '/' +
                    SharePointFolderBuilder.buildOpportunityFolderPath(oppRec.Name,accRec.Id, accMap).replace(WHITE_SPACE,ENCODED_WHITE_SPACE) +  
                    '/' + oppfileName.replace(WHITE_SPACE, ENCODED_WHITE_SPACE); 
                
            }
            
        } catch (Exception e) {
            system.debug('Error Line Number'+e.getLineNumber()+'Error Message'+e.getMessage());
            spOppException = new OpportunityFilesConnectException('Issue with SharePoint link to file: ' + e);
            CreateExceptionLog.insertErrorLog(spOppException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                              null, OpportunityFilesConnectException.class.getName()+
                                              'opplinkFile()', HIGH_PRIORITY);
            return null;
        }
        return null;
        
    }
    
    public Boolean oppfileTypeCheck(String fileType){
        for(String type: fileTypes){
            if(fileType.toLowerCase().contains(type)){
                return true;
            }
        }
        return false;
    }
    public String oppDwnURL{get;set;} 
    public PageReference oppdownloadURL() {
        
        try {
            oppDwnURL='';
            String escapedFile;
            
            oppDwnURL = teamSharePointURL  + sharePointListName + '/' +
                SharePointFolderBuilder.buildOpportunityFolderPath(oppRec.Name,accRec.Id, accMap).replace(WHITE_SPACE,ENCODED_WHITE_SPACE) +  
                '/' + oppfileName.replace(WHITE_SPACE, ENCODED_WHITE_SPACE);
            
        } catch (Exception e) {
            system.debug('Error Line Number'+e.getLineNumber()+'Error Message'+e.getMessage());
            spOppException = new OpportunityFilesConnectException('Issue with SharePoint link to file: ' + e);
            CreateExceptionLog.insertErrorLog(spOppException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                              null, OpportunityFilesConnectException.class.getName()+
                                              'oppdownloadURL()', HIGH_PRIORITY);
            return null;
        }
        return null;
        
    }
    
    public PageReference oppverifySharePointButton() {
        try {
            if(opportunityId!=null){
                SetUpSharePointConfig();
                oppRec =  opportunityDAOInstance.getOpportunityById(opportunityId); 
                oppMap = new Map<Id,Opportunity>{opportunityId => oppRec};
                    if(oppRec.AccountId!=null){
                        set<Id> accountIds=new set<Id>();
                        accountIds.add(oppRec.AccountId);
                        accRec = AccountDAOInstance.getAccounts(accountIds)[0]; 
                        accMap = new Map<Id,Account>{oppRec.AccountId=> accRec };
                            }
                HttpResponse response = new HttpResponse();
                String folderName = SharePointFolderBuilder.buildOpportunityFolderPath(oppRec.Name, oppRec.AccountId, accMap).replace(WHITE_SPACE,ENCODED_WHITE_SPACE);
                if(!Test.isRunningTest()){
                    response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FOLDER, folderName, EMPTY_STRING, oppRec);
                }
                else if(Test.isRunningTest()){
                    response = GEMS_SharePointUtilityController.FakeSharePointCallout(fakeErrorCode,'Opportunity');
                }
                if (response.getStatusCode() == 401 && response.getBody().contains(sharePointConfiguration.getTokenExpiredResponseText())){
                    sharePointCalloutUtilityInstance.refreshAccessToken();
                    response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FOLDER, folderName, EMPTY_STRING, oppRec);
                    if(response.getStatusCode() != 200){
                        this.oppisDisabled = true;
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Authentication_Issue));
                        spOppException = new OpportunityFilesConnectException('SHAREPOINT CALLOUT EXCEPTION'+ NEW_LINE + 
                                                                              'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                                              'HTTP Response Body - ' + response.getBody());
                        
                        CreateExceptionLog.insertErrorLog(spOppException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                          null, OpportunityFilesConnectException.class.getName()+
                                                          'oppverifySharePointButton()', HIGH_PRIORITY);
                    }
                } else if(response.getStatusCode() != 200){
                    this.oppisDisabled = true;
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Unknown_Issue));
                    spOppException = new OpportunityFilesConnectException('Unknown exception with callout.'+ NEW_LINE + 
                                                                          'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                                          'HTTP Response Body - ' + response.getBody());
                    
                    CreateExceptionLog.insertErrorLog(spOppException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                      null, OpportunityFilesConnectException.class.getName()+
                                                      'oppverifySharePointButton()', HIGH_PRIORITY);
                } else {
                    this.oppisDisabled = false;
                    this.OppfolderLink = sharePointURL + teamURLPath + sharePointListName +
                        '/' + folderName;
                    if(!String.isBlank(OppfolderLink) && recordId != null){
                        GEMS_SBC_BB_Form__c rec=new GEMS_SBC_BB_Form__c(Id=recordId);
                        rec.Opportunity_SharePoint_Link__c=OppfolderLink;
                        update rec;
                    }
                }
                
                sharePointCalloutUtilityInstance.updateAccessToken();
            }
        } catch (Exception e) {
            system.debug('Error Line Number'+e.getLineNumber()+'Error Message'+e.getMessage());
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Unknown_Issue));
            CreateExceptionLog.insertErrorLog(e, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                              null, OpportunityFilesConnectException.class.getName()+
                                              'oppverifySharePointButton()', HIGH_PRIORITY);
        }
        return null;
    }
    
    /*********************************************Case Share Point Code**********************************************/
    
    
    public class CaseSharePointFilesWrapper {
        public String name {get; set;}
        public String type {get; set;}
        public String documentType {get; set;}
        public String level {get; set; }
        public String baInfo {get; set;}
        public String caseDescription {get; set;}
        public String author {get; set;}
        public Date createdDate {get; set;}
        public GEMS_SPFilesJSON2Apex.Results file {get;set;}
        public String downloadURL {get; set;}
        public String externalId {get; set;}
        
        public CaseSharePointFilesWrapper(GEMS_SPFilesJSON2Apex.Results file){
            this.file = file;
            this.name = file.Name;
            if ( file.Name != null ) {
                this.type = file.Name.substringAfterLast('.');
            }
            this.author = file.Author.Title;
            if ( file.Properties.vti_x005f_timecreated != null ) {
                this.createdDate = Date.valueOf(file.Properties.vti_x005f_timecreated);
            }
            this.documentType = file.Properties.DocumentType;
            this.level = file.Properties.DocumentLevel;
            this.baInfo = file.Properties.BAInfo;
            this.caseDescription = file.Properties.CaseDescription;
            this.externalId = file.Properties.ODatax005f_dlc_x005f_DocId;
        }
    }
    
    public PageReference fetchCaseInitialDocumentSet() {
        try {
            if(CaseId!=null){ 
                caseRec = caseDAOInstance.getCaseById(caseId);
                //SFDC 9616 GEMS: Add Contract Admin Request to Cosmetic and Account Eligibility Maintenance Cases - Sharepoint
                if(caseRec.Type!=NULL && caseRec.Type == 'Account Maintenance'){
                    //Maintenance Share Point Config
                    SetUpSharePointMainConfig();  
                } 
                else{
                    //Submission Share Point Config
                    SetUpSharePointConfig();  
                }
                opportunityId = (opportunityId == null || string.isBlank(opportunityId))?caseRec.Opportunity_Name__r.Id:opportunityId;  
                if(opportunityId!=null){
                    oppRec =  opportunityDAOInstance.getOpportunityById(opportunityId);  
                    oppMap = new Map<Id, Opportunity>{opportunityId => oppRec};
                        }
                if(oppRec!=NULL){
                    if(oppRec.AccountId!=null){
                        set<Id> accountIds=new set<Id>();
                        accountIds.add(oppRec.AccountId);
                        accRec = AccountDAOInstance.getAccounts(accountIds)[0]; 
                        accMap = new Map<Id,Account>{oppRec.AccountId=> accRec };
                            }
                } 
                if(spCaseException != null){
                    CreateExceptionLog.insertErrorLog(spCaseException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                      null,'GEMS_CaseFilesConnect constructor', HIGH_PRIORITY);
                    return null;
                }
                CaseSharepointFiles  = new List<CaseSharePointFilesWrapper>();
                
                String folderName='';
                if(caseRec.Type != NULL && caseRec.Type == 'Account Maintenance'){
                    folderName = SharePointFolderBuilder.buildAcctMaintCaseFolderPath(caseRec.CaseNumber, CaseRec.Account.Name, CaseRec.Account.External_Id__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE);
                }
                else{
                    folderName = SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber,OppRec.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE); 
                }
                //String folderName = SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber,OppRec.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE);        
                
                folderPath = folderName; 
                HttpResponse response=new HttpResponse();
                if(!Test.isRunningTest()){
                    response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FILES, folderName, '', null);
                    system.debug('<<<<<<<Response Case Body>>>>>>'+response.getBody());
                }
                else if(Test.isRunningTest()){
                    response = GEMS_SharePointUtilityController.FakeSharePointCallout(fakeErrorCode,'Case'); 
                }
                
                if(response == null){
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sharepoint service may have timed out.  Please contact your administrator.'));
                    spCaseException = new CaseFilesConnectException('SHAREPOINT CALLOUT EXCEPTION: null http response.  Callout request may have timed out.');
                    CreateExceptionLog.insertErrorLog(spCaseException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                      null, CaseFilesConnectException.class.getName()+
                                                      'getCaseInitialDocumentSet()', HIGH_PRIORITY);
                    return null;
                }
                
                if (response.getStatusCode() == 401 && response.getBody().contains(sharePointConfiguration.getTokenExpiredResponseText())){
                    sharePointCalloutUtilityInstance.refreshAccessToken();
                    response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FILES, folderName, '', null);
                    if(response.getStatusCode() != 200){
                        this.caseisDisabled = true;
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Authentication_Issue));
                        spCaseException = new CaseFilesConnectException('SHAREPOINT CALLOUT EXCEPTION'+ NEW_LINE + 
                                                                        'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                                        'HTTP Response Body - ' + response.getBody());
                        
                        CreateExceptionLog.insertErrorLog(spCaseException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                          null, CaseFilesConnectException.class.getName()+
                                                          'getCaseInitialDocumentSet()', HIGH_PRIORITY);
                        return null;
                    }
                } else if(response.getStatusCode() != 200){
                    this.caseisDisabled = true;
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Unknown_Issue));
                    spCaseException = new CaseFilesConnectException('Unknown exception with callout.'+ NEW_LINE + 
                                                                    'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                                    'HTTP Response Body - ' + response.getBody());
                    
                    CreateExceptionLog.insertErrorLog(spCaseException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                      null, CaseFilesConnectException.class.getName()+
                                                      'getCaseInitialDocumentSet()', HIGH_PRIORITY);
                    return null;  
                } else {
                    String responseJSON =  response.getBody().replace(DOUBLE_UNDERSCORE, EMPTY_STRING);
                    spCaseFilesCon = (GEMS_SPFilesJSON2Apex)System.JSON.deserialize(responseJSON, GEMS_SPFilesJSON2Apex.class);
                }
                
                
                if(spCaseFilesCon != null){
                    casetotalNoOfRecs = spCaseFilesCon .d.results.size();
                    
                    casepageNumber = 0;
                    
                    if (casetotalNoOfRecs <= 0) {
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Records to Display'));
                    } else {
                        
                        casenoOfPages = casetotalNoOfRecs / casepageSize;
                        if (Math.mod(casetotalNoOfRecs, casepageSize) > 0){
                            casenoOfPages++;
                        }
                        
                        CaseSharepointFiles.clear();
                        
                        for(Integer i=0;i<casepageSize ;i++){
                            if(!(i >= spCaseFilesCon.d.results.size())){
                                CaseSharePointFilesWrapper spFile = new CaseSharePointFilesWrapper(spCaseFilesCon .d.results[i]);
                                CaseSharepointFiles .add(spFile);
                            }
                        }
                        caseverifySharePointButton(); 
                    }   
                }
            } 
        } catch (Exception e) {
            system.debug('Error Line Number'+e.getLineNumber()+'Error Message'+e.getMessage());
            spCaseException = new CaseFilesConnectException('SHAREPOINT CALLOUT EXCEPTION - ' + e);
            CreateExceptionLog.insertErrorLog(spCaseException , null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                              null, CaseFilesConnectException.class.getName()+
                                              'getCaseInitialDocumentSet()', HIGH_PRIORITY);
        }
        return null;
    }
    
    public PageReference caseverifySharePointButton() {
        try {    
            if(CaseId!=null){   
                //SFDC 9616 GEMS: Add Contract Admin Request to Cosmetic and Account Eligibility Maintenance Cases - Sharepoint
                if(caseRec.Type!=NULL && caseRec.Type == 'Account Maintenance'){
                    //Maintenance Share Point Config
                    SetUpSharePointMainConfig();  
                } 
                else{
                    //Submission Share Point Config
                    SetUpSharePointConfig();  
                }
                opportunityId = (opportunityId == null || string.isBlank(opportunityId))?caseRec.Opportunity_Name__r.Id:opportunityId;         
                if(opportunityId!=null){
                    oppRec =  opportunityDAOInstance.getOpportunityById(opportunityId);  
                    oppMap = new Map<Id, Opportunity>{opportunityId => oppRec};
                        }
                
                if(oppRec!=NULL){
                    if(oppRec.AccountId!=null){
                        set<Id> accountIds=new set<Id>();
                        accountIds.add(oppRec.AccountId);
                        accRec = AccountDAOInstance.getAccounts(accountIds)[0]; 
                        accMap = new Map<Id,Account>{oppRec.AccountId=> accRec };
                            }
                }
                
                String folderName='';
                if(caseRec.Type != NULL && caseRec.Type == 'Account Maintenance'){
                    folderName = SharePointFolderBuilder.buildAcctMaintCaseFolderPath(caseRec.CaseNumber, CaseRec.Account.Name, CaseRec.Account.External_Id__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE);
                }
                else{
                    folderName = SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber, caseRec.Opportunity_Name__r.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE);     
                }
                
                HttpResponse response = new HttpResponse();
                if(!Test.isRunningTest()){
                    response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FOLDER, folderName, EMPTY_STRING, caseRec);
                }
                else if(Test.isRunningTest()){
                    response = GEMS_SharePointUtilityController.FakeSharePointCallout(fakeErrorCode,'Case');
                }
                if (response.getStatusCode() == 401 && response.getBody().contains(sharePointConfiguration.getTokenExpiredResponseText())){
                    sharePointCalloutUtilityInstance.refreshAccessToken();
                    response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout(SharePointCalloutUtility.GET_FOLDER, folderName, EMPTY_STRING, caseRec);
                    if(response.getStatusCode() != 200){
                        this.caseisDisabled = true;
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Authentication_Issue));
                        spcaseException = new CaseFilesConnectException('SHAREPOINT CALLOUT EXCEPTION'+ NEW_LINE + 
                                                                        'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                                        'HTTP Response Body - ' + response.getBody());
                        
                        CreateExceptionLog.insertErrorLog(spcaseException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                          null, CaseFilesConnectException.class.getName()+
                                                          'caseverifySharePointButton()', HIGH_PRIORITY);
                    }
                } else if(response.getStatusCode() != 200){
                    this.caseisDisabled = true;
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Unknown_Issue));
                    spcaseException = new CaseFilesConnectException('Unknown exception with callout.'+ NEW_LINE + 
                                                                    'HTTP Response Status Code - ' + response.getStatusCode() + NEW_LINE +
                                                                    'HTTP Response Body - ' + response.getBody());
                    
                    CreateExceptionLog.insertErrorLog(spcaseException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                                      null, CaseFilesConnectException.class.getName()+
                                                      'caseverifySharePointButton()', HIGH_PRIORITY);
                } else {
                    this.caseisDisabled = false;
                    this.CasefolderLink = sharePointURL + teamURLPath + sharePointListName +
                        '/' + folderName;
                    if(!String.isBlank(CasefolderLink) && recordId != null){
                        GEMS_SBC_BB_Form__c rec=new GEMS_SBC_BB_Form__c(Id=recordId);
                        rec.Case_SharePoint_Link__c=CasefolderLink;
                        update rec;
                    }                    
                }
                
                sharePointCalloutUtilityInstance.updateAccessToken();
            }  
        } catch (Exception e) {
            system.debug('Error Line Number'+e.getLineNumber()+'Error Message'+e.getMessage());
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.SharePoint_Unknown_Issue));
            CreateExceptionLog.insertErrorLog(e, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                              null, CaseFilesConnectException.class.getName()+
                                              'caseverifySharePointButton()', HIGH_PRIORITY);
        }
        return null;
    }
    
    public PageReference casenext() {
        casepageNumber++;
        
        casequeryDocuments();
        return null;
    }
    
    public PageReference caseprevious() {
        casepageNumber--;
        
        if (casepageNumber < 0) {
            return null;
        }
        casequeryDocuments();
        return null;
    }
    
    public void casequeryDocuments() {
        try {
            Integer offset = casepageNumber * casepageSize;
            casesharepointFiles.clear();
            for(Integer i=offset;i<(casepageSize + offset);i++){
                if(!(i >= spcaseFilesCon.d.results.size())){
                    CaseSharePointFilesWrapper spFile = new CaseSharePointFilesWrapper(spcaseFilesCon.d.results[i]);
                    casesharepointFiles.add(spFile);
                }
            }
        } catch (Exception e) {
            spcaseException = new CaseFilesConnectException('Issue with document query: ' + e);
            CreateExceptionLog.insertErrorLog(spcaseException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                              null, CaseFilesConnectException.class.getName()+
                                              'casequeryDocuments()', HIGH_PRIORITY);
            ApexPages.addMessages(e);
        }
    }
    public string caselinkURL {get;set;}
    public PageReference caselinkFile() {
        
        try {
            String escapedFile;
            
            if (!casefileTypeCheck(casefileType)) {
                
                if (casefileName.containsWhitespace()) {
                    escapedFile = casefileName.replace(WHITE_SPACE, PLUS_SYMBOL);
                }
                //SFDC 9616 GEMS: Add Contract Admin Request to Cosmetic and Account Eligibility Maintenance Cases - Sharepoint
                if (caseRec.Type == 'Account Maintenance') {
                    caselinkURL = teamSharePointURL + viewURLPath + '?sourcedoc=' +     
                        teamURLPath + sharePointListName + '/' +
                        SharePointFolderBuilder.buildAcctMaintCaseFolderPath(caseRec.CaseNumber,CaseRec.Account.Name, CaseRec.Account.External_Id__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                        '/' + EncodingUtil.urlEncode(casefileName, UTF8_ENCODING);                           
                }
                else{
                    caselinkURL = teamSharePointURL + viewURLPath + '?sourcedoc=' + 
                        teamURLPath + sharePointListName + '/' +
                        SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber, oppRec.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                        '/' + (String.isEmpty(escapedFile)?EncodingUtil.urlEncode(casefileName, UTF8_ENCODING):escapedFile); 
                }
            } else { 
                if(caseRec.Type == 'Account Maintenance') {
                    caselinkURL = teamSharePointURL  + sharePointListName + '/' +    
                        SharePointFolderBuilder.buildAcctMaintCaseFolderPath(caseRec.CaseNumber,CaseRec.Account.Name, CaseRec.Account.External_Id__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                        '/' + casefileName.replace(WHITE_SPACE, ENCODED_WHITE_SPACE); 
                    
                }
                else{
                    caselinkURL = teamSharePointURL  + sharePointListName + '/' +
                        SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber, oppRec.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                        '/' + casefileName.replace(WHITE_SPACE, ENCODED_WHITE_SPACE);   
                }
            }
        } catch (Exception e) {
            spcaseException = new CaseFilesConnectException('Issue with SharePoint link to file: ' + e);
            CreateExceptionLog.insertErrorLog(spcaseException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                              null, CaseFilesConnectException.class.getName()+
                                              'caselinkFile()', HIGH_PRIORITY);
            return null;
        }
        return null;
    }
    
    public Boolean casefileTypeCheck(String fileType){
        for(String type: fileTypes){
            if(fileType.toLowerCase().contains(type)){
                return true;
            }
        }
        return false;
    }
    
    public string caseDwnURL {get;set;}
    public PageReference casedownloadURL() {
        
        try {
            String escapedFile;
            //SFDC 9616 GEMS: Add Contract Admin Request to Cosmetic and Account Eligibility Maintenance Cases - Sharepoint
            if (caseRec.Type == 'Account Maintenance') {
                caseDwnURL = teamSharePointURL  + sharePointListName + '/' +
                    SharePointFolderBuilder.buildAcctMaintCaseFolderPath(caseRec.CaseNumber,CaseRec.Account.Name, CaseRec.Account.External_Id__c).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                    '/' + casefileName.replace(WHITE_SPACE, ENCODED_WHITE_SPACE);  
            } 
            else{
                caseDwnURL = teamSharePointURL  + sharePointListName + '/' +
                    SharePointFolderBuilder.buildCaseFolderPath(caseRec.CaseNumber,oppRec.Id, oppMap, accMap).replace(WHITE_SPACE, ENCODED_WHITE_SPACE) + 
                    '/' + casefileName.replace(WHITE_SPACE, ENCODED_WHITE_SPACE);  
            }    
            
        } catch (Exception e) {
            spcaseException = new CaseFilesConnectException('Issue with SharePoint link to file: ' + e);
            CreateExceptionLog.insertErrorLog(spcaseException, null, null, null, APEX_CLASS, SOBJECT_TYPE, 
                                              null, CaseFilesConnectException.class.getName()+
                                              'casedownloadURL()', HIGH_PRIORITY);
            return null;
        }
        return null;
    }
    
    public static HttpResponse FakeSharePointCallout(integer fakeErrorCode,string obj){
        if(Test.isRunningTest()){
            HttpResponse response = new HttpResponse();
            if(obj != null){
                if(fakeErrorCode == 200){
                    if(obj == 'Opportunity'){
                        response.setStatusCode(fakeErrorCode);
                        response.setBody([Select Body,Name,Id from StaticResource where Name = 'GEMSOpportunitySharePointFiles' LIMIT 1].Body.toString());
                    }
                    else if(obj == 'Case'){
                        response.setStatusCode(fakeErrorCode);
                        response.setBody([Select Body,Name,Id from StaticResource where Name = 'GEMSCaseSharePointFiles' LIMIT 1].Body.toString());
                    }
                    return response;
                } 
                else if(fakeErrorCode == 401){
                    if(obj == 'Opportunity'){
                        response.setStatusCode(fakeErrorCode);
                        response.setBody([Select Body,Name,Id from StaticResource where Name = 'GEMSOpportunitySharePointFiles' LIMIT 1].Body.toString());
                    }
                    else if(obj == 'Case'){
                        response.setStatusCode(fakeErrorCode);
                        response.setBody([Select Body,Name,Id from StaticResource where Name = 'GEMSCaseSharePointFiles' LIMIT 1].Body.toString());
                    }
                    return response;
                } 
                else if(fakeErrorCode == 500){
                    response.setStatusCode(fakeErrorCode);
                    response.setBody('Internal Server Error');
                    
                }
                else{
                    response.setStatusCode(fakeErrorCode);
                    response=null; 
                }
            }   
        }
        return null;
    }
    
}