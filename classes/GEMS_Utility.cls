/*******************************************************************************
* Date       Name           Description
* 02/02/2018   Malathi.K      SFDC-8405 Send email when new documents are added/updated on Sharepoint.
* 7-21-2017    Luke Chen      refactor to add createTask() method
* 1-17-2018    Gokul Bharati  US-7915 Auto Sync SharePoint Files To GEMS Attachments
* 3-06-2018    Gokul Bharati  SFDC-8428 GEMS: Prod Issue - Update Sharepoint logic to check the Actual Share Point File Name 
* 3-15-2018    Gokul Bharati  SFDC-8669 GEMS: Sharepoint Error - due to URL > 255 characters
* 4-20-2018    Luke Chen      SFDC-9342 GEMS: Prod Issue - 360 view showing a different open/closed date than actual cases
* 6-21-2018    Gokul Bharati  SFDC-10379 GEMS: Allow only current assignee to close Shared Accums Forms
*******************************************************************************/
public class GEMS_Utility {
    
    /******************************************************************** 
*   @Method Name :   retriveCustomMetaDataByProductType
*   @description :   This method is to Retrieve Process Metadata based on the submission type subtype and producttype (Dec'16 Release)
*   @parameters  :   Set<String> submissionTypeCaseSet, String productType
*   @return type :   List<GEMS_Process_Metadata__mdt>
***************************************************************/
    public static List<GEMS_Process_Metadata__mdt> retriveCustomMetaDataByProductType(Set<String> submissionTypeCaseSet, String productType) {
        List<GEMS_Process_Metadata__mdt> processMetaData = null;
        try {
            processMetaData = [select Account_Submission_Sub_Type__c, Account_Submission_Type__c, Business_Process__c, 
                               Create_Manaual_Eligibility__c, Create_Membership__c, Create_Eligibility_Process__c,  
                               Create_ID_Card__c from GEMS_Process_Metadata__mdt
                               where GEMS_Product__c =: productType and Create_Process__c =: true and Account_Submission_Type__c =: submissionTypeCaseSet
                              ];
            
        }
        catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_Utility.retriveCustomMetaDataByProductType(String productType)','High');  
            
        }
        return processMetaData;
    }
    
    /******************************************************************** 
*   @Method Name :   retriveCustomMetaDataByProductTypeIndividual
*   @description :   This method is to Retrieve Process Metadata based on the submission type subtype and producttype (Dec'16 Release)
*   @parameters  :   String submissionTypeCase, String productType, String submissionSubType, String businessProcess
*   @return type :   List<GEMS_Process_Metadata__mdt>
***************************************************************/
    public static List<GEMS_Process_Metadata__mdt> retriveCustomMetaDataByProductTypeIndividual(String submissionTypeCase, String productType, String submissionSubType, String businessProcess) {
        List<GEMS_Process_Metadata__mdt> processMetaData = null;
        try {
            processMetaData = [select Account_Submission_Sub_Type__c, Account_Submission_Type__c, Business_Process__c, 
                               Create_Manaual_Eligibility__c, Create_Membership__c, Create_Eligibility_Process__c,  
                               Create_ID_Card__c from GEMS_Process_Metadata__mdt
                               where Account_Submission_Type__c =: submissionTypeCase and GEMS_Product__c =: productType and Account_Submission_Sub_Type__c =:submissionSubType
                               and Business_Process__c =: businessProcess and Create_Process__c =: true
                              ];
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_Utility.retriveCustomMetaDataByProductTypeIndividual(String submissionTypeCase, String productType, String submissionSubType, String businessProcess)','High');  
        }
        return processMetaData;
    }
    
    /******************************************************************** 
*   @Method Name :   retriveCustomMetaDataByProductTypeIndividual
*   @description :   This method is to Retrieve Process Metadata based on the submission type subtype and producttype (Dec'16 Release)
*   @parameters  :   Set<String> submissionTypeCaseSet, String productType, Set<String> submissionSubTypeSet
*   @return type :   String submissionTypeCase, String productType, String submissionSubType
***************************************************************/
    public static List<GEMS_Process_Metadata__mdt> retriveCustomMetaDataByProductTypeIndividual(String submissionTypeCase, String productType, String[] submissionSubType) {
        List<GEMS_Process_Metadata__mdt> processMetaData = null;
        try {
            processMetaData = [select Account_Submission_Sub_Type__c, Account_Submission_Type__c, Business_Process__c, 
                               Create_Manaual_Eligibility__c, Create_Membership__c, Create_Eligibility_Process__c,  
                               Create_ID_Card__c from GEMS_Process_Metadata__mdt 
                               where Account_Submission_Type__c =: submissionTypeCase and Account_Submission_Sub_Type__c in :submissionSubType and GEMS_Product__c =: productType and Create_Process__c =: true
                              ];
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_Utility.retriveCustomMetaDataByProductTypeIndividual(String submissionTypeCase, String productType, String submissionSubType)','High');  
        }
        return processMetaData;
    }
    
    /******************************************************************** 
*   @Method Name :   findBusinessAreaInMetaData
*   @description :   This method is to Check whether the businessarea case exists in metadata or not
*   @parameters  :   Case submissionCase, GEMS_Process_Metadata__mdt processMetaData,String businessArea
*   @return type :   Boolean 
***************************************************************/
    public static Boolean findBusinessAreaInMetaData(Case submissionCase, List<GEMS_Process_Metadata__mdt> processMetaDataList,String businessArea) {
        Boolean businessAreaIsInMetadata = false;
        try {
            Set<String> allBusinessProcessSet = new Set<String>();
            
            for(GEMS_Process_Metadata__mdt processMetaData : processMetaDataList) {
                if(businessArea == 'Eligibility Process' && processMetaData.Create_Eligibility_Process__c) {
                    businessAreaIsInMetadata = true;
                    break;
                }
                if(businessArea == 'Membership' && processMetaData.Create_Membership__c) {
                    businessAreaIsInMetadata = true;
                    break;
                }
                if(businessArea == 'Manual Eligibility' && processMetaData.Create_Manaual_Eligibility__c) {
                    businessAreaIsInMetadata = true;
                    break;
                }
                if(businessArea == 'ID Card' && processMetaData.Create_ID_Card__c) {
                    businessAreaIsInMetadata = true;
                    break;
                }
                
            }
            //businessAreaIsInMetadata = (!allBusinessProcessSet.isEmpty() && allBusinessProcessSet.contains(businessArea));
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_Utility.findBusinessAreaInMetaData(Case submissionCase, GEMS_Process_Metadata__mdt processMetaData,String businessArea)','High');  
        }
        return businessAreaIsInMetadata;
    }
    
    /******************************************************************** 
*   @Method Name :   buildSubmissinCaseBusinessAreaToCreate
*   @description :   This method is to Check whether the businessarea case exists in metadata or not
*   @parameters  :   List<Case> submissionCasesList, List<GEMS_Process_Metadata__mdt> processMetaDataList,String businessArea
*   @return type :   Map<Id,Boolean>
***************************************************************/
    public static Boolean buildSubmissinCaseBusinessAreaToCreate(List<GEMS_Process_Metadata__mdt> processMetaDataList,Set<String> subTypes, String businessArea) {
        Boolean businessAreaIsInMetadata = false;
        try {
            Set<String> allBusinessProcessSet = new Set<String>();
            
            for(GEMS_Process_Metadata__mdt processMetaData : processMetaDataList) {
                
                
                if(subTypes != null && subTypes.contains(processMetaData.Account_Submission_Sub_Type__c)) {
                    
                    if(businessArea == 'Eligibility Process' && processMetaData.Create_Eligibility_Process__c) {
                        
                        businessAreaIsInMetadata = true;
                        break;
                    }
                    if(businessArea == 'Membership' && processMetaData.Create_Membership__c) {
                        
                        businessAreaIsInMetadata = true;
                        break;
                    }
                    if(businessArea == 'Manual Eligibility' && processMetaData.Create_Manaual_Eligibility__c) {
                        
                        businessAreaIsInMetadata = true;
                        break;
                    }
                    if(businessArea == 'ID Card' && processMetaData.Create_ID_Card__c) {
                        
                        businessAreaIsInMetadata = true;
                        break;
                    }
                }
            }
            
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_Utility.findBusinessAreaInMetaData(Case submissionCase, GEMS_Process_Metadata__mdt processMetaData,String businessArea)','High');  
        }
        return businessAreaIsInMetadata ;
    }
    
    
    /*
* common utility to create a task instance
* below fields are optional
* - GEMS_Start_Date__c
* - recordTypeId
* - GEMS_Type__C
* 
* Pass null for fields that are optional or you want to overwrite later
*/
    public static Task createTask(String status, Id whatId, Id ownerId, String Subject, String priority, DateTime startDate, Id recordTypeId, String gemsType){
        Task t = new Task();
        t.Status = status;
        t.WhatId = whatId;
        t.OwnerId = ownerId;
        t.Subject = subject;
        t.priority = priority;
        if(startDate != null) t.GEMS_Start_Date__c = startDate;
        if(recordTypeId != null) t.recordTypeId = recordTypeId;
        if(gemsType != null) t.GEMS_Type__C = gemsType;
        return t;       
    }
    
    /******************************************************************** 
*   @Method Name :   getEnvName
*   @description :   This method is to get the server's env name such as PROD, UAT, SIT, GEM1, etc.
*                    It looks up the GEMS_Env__mdt records and maps to appropriate Env name according to its login URL.
*                    If it returns 'UNKNOWN', there is no matched record in GEMS_Env__mdt
*   @parameters  :   None
*   @return type :   String
***************************************************************/
    public static String getEnvName(){
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        List<GEMS_Env__mdt> envList = [select masterlabel, url_keyword__c from GEMS_Env__mdt];
        for(GEMS_Env__mdt anEnv : envList)
            if(baseUrl.contains(anEnv.url_keyword__c))
            return anEnv.masterlabel;
        
        return 'UNKNOWN';
    }
    
    /******************************************************************** 
*   @Method Name :   getEnvAbbrName
*   @description :   This method is to get the server's abbreviate env name such as PR, UA, SI, G1, etc.
*                    It looks up the GEMS_Env__mdt records and maps to appropriate abbreviate Env name according to its login URL.
*                    If it returns 'XX', there is no matched record in GEMS_Env__mdt
*   @parameters  :   None
*   @return type :   String
***************************************************************/
    public static String getEnvAbbrName(){
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm().toUpperCase();
        List<GEMS_Env__mdt> envList = [select abbr__c, url_keyword__c from GEMS_Env__mdt];
        for(GEMS_Env__mdt anEnv : envList)
            if(baseUrl.contains(anEnv.url_keyword__c.toUpperCase()))
            return anEnv.abbr__c;
        
        return 'XX';
    } 
    
    public static List<PermissionSetAssignment> perm{get{
        if(perm==null){
            perm = [select id, permissionset.name from PermissionSetAssignment where permissionset.name = 'Super_User_Permissions' and AssigneeID = :Userinfo.getUserId() LIMIT 1];
            if(perm.size()>0){
                return perm;
            }
            else{
                return null;
            }
        }else{
            return perm;
        }
    }set;}
    
    public static List<Entitlement> entitlements{get{
        if(entitlements==null){
            entitlements = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSProcessEntitlementName];
            return entitlements;
        }else{
            return entitlements;
        }
    }set;}
    
    /******************************************************************** 
*   Method Name : AutoGemsAttSyncOnPageVisit
*   Description : US-7915 Sync File from SharePoint To GEMS Attachment
*                 SFDC-8428 GEMS: Prod Issue - Update Sharepoint logic to check the Actual Share Point File Name
*********************************************************************/
    @future
    public static void AutoGemsAttSyncOnPageVisit(string teamSharePointURL,string sharePointListName,string folderPath,string response,string recordId)
    {
        try{
            
            GEMS_SPFilesJSON2Apex spFilesCon = (GEMS_SPFilesJSON2Apex)System.JSON.deserialize(response,GEMS_SPFilesJSON2Apex.class);
            
            String mainURL;
            mainURL = teamSharePointURL  + sharePointListName + '/' + folderPath; 
            Set<Id> attachmentIds = new Set<Id>();
            
            List<SharePointFilesWrapper> sharePointDocs = new List<SharePointFilesWrapper>();
            //Add the reponse results into the SharePoint File Wrapper.            
            for(GEMS_SPFilesJSON2Apex.Results r : spFilesCon.d.results){
                SharePointFilesWrapper spFile = new SharePointFilesWrapper(r);
                spFile.DownloadURL = mainURL + '/' + r.Name;
                sharePointDocs.add(spFile);
            }
            //Query the GEMS Attachment Object for Last Modified Date Comparision and Upsertion
            List<GEMS_Attachment__c> gemsAttachments = [SELECT Id,File_Name__c,File_Creation_Date__c,File_Last_Modified_Date__c,File_Modified_By__c, Name, SharePointExtId__c,Account_Name__c, Attachment__c, BA_Info__c, Case__c, Description__c
                                                        FROM GEMS_Attachment__c
                                                        WHERE Case__c =: recordId
                                                       ];
            //Map to hold the wrapper and GEMS Attachment Record for comparision.                                       
            Map<String,GEMS_Attachment__c> stringGemsAttachRecMap = new Map<String,GEMS_Attachment__c> ();
            Map<String,SharePointFilesWrapper> stringSharePointRecMap = new Map<String,SharePointFilesWrapper> ();
            
            for(GEMS_Attachment__c attachmntRec: gemsAttachments) {
                stringGemsAttachRecMap.put(attachmntRec.File_Name__c,attachmntRec);
            }
            //SFDC-8428
            for(SharePointFilesWrapper attachmntRec: sharePointDocs) {
                stringSharePointRecMap.put(attachmntRec.Name,attachmntRec);
            }
            //SFDC-8428
            List<GEMS_Attachment__c> gemsAttachmentsToBeInserted = new List<GEMS_Attachment__c>();
            List<GEMS_Attachment__c> gemsAttachmentsToBeDeleted = new List<GEMS_Attachment__c>();
            
            for(SharePointFilesWrapper sharePointDoc: sharePointDocs) {
                String sharePointFileName = sharepointDoc.Name;                
                if(sharePointFileName != null && sharePointFileName.length() > 80) {
                    sharePointFileName = sharePointFileName.subString(0,80);
                }                       
                if (!gemsAttachments.isEmpty() && gemsAttachments != null) {//GEMS Attachment for the CASE exist.
                    if(!stringGemsAttachRecMap.containsKey(sharepointDoc.Name)) {//SharePoint External ID does not exist.                        
                        GEMS_Attachment__c gemsAttachFile = new GEMS_Attachment__c();                        
                        gemsAttachFile.Name = sharePointFileName;
                        gemsAttachFile.File_URL__c= sharepointDoc.DownloadUrl;
                        gemsAttachFile.BA_Info__c = sharepointDoc.BAInfo;
                        gemsAttachFile.Case__c = recordId;
                        gemsAttachFile.Description__c = sharepointDoc.CaseDescription;
                        gemsAttachFile.Type__c = sharepointDoc.DocumentType;
                        gemsAttachFile.Level__c  = sharepointDoc.Level;
                        gemsAttachFile.SharePointExtId__c = sharepointDoc.ExternalId;
                        gemsAttachFile.File_Name__c = sharepointDoc.Name; 
                        gemsAttachFile.File_Creation_Date__c =sharepointDoc.FileCreatedDate;
                        gemsAttachFile.File_Last_Modified_Date__c= sharepointDoc.FileLastModifiedDate;
                        gemsAttachFile.File_Modified_By__c = sharepointDoc.ModifiedBy;
                        gemsAttachmentsToBeInserted.add(gemsAttachFile);
                        
                    } 
                    //SFDC-8428
                    else if(stringGemsAttachRecMap.containsKey(sharepointDoc.Name)){
                        //SFDC-8428
                        string gemsRecFLMD  = stringGemsAttachRecMap.get(sharepointDoc.Name).File_Last_Modified_Date__c!=null?stringGemsAttachRecMap.get(sharepointDoc.Name).File_Last_Modified_Date__c:'';
                        string respRecFLMD = sharepointDoc.FileLastModifiedDate!=null?sharepointDoc.FileLastModifiedDate:''; 
                        //SFDC-8428
                        if(gemsRecFLMD != null && respRecFLMD != null && !String.isBlank(gemsRecFLMD) && !String.isBlank(respRecFLMD)){ 
                            if(DateTime.valueOf(gemsRecFLMD.replace('T',' '))< DateTime.valueOf(respRecFLMD.replace('T',' '))){//SharePoint External ID exist.Current Last Modifed Date and Previous Last Modified Date comparision.                        
                                //SFDC-8428
                                GEMS_Attachment__c gemsAttachFile = new GEMS_Attachment__c();
                                gemsAttachFile.id = stringGemsAttachRecMap.get(sharepointDoc.Name).Id;
                                gemsAttachFile.File_URL__c= sharepointDoc.DownloadUrl;
                                gemsAttachFile.BA_Info__c = sharepointDoc.BAInfo;
                                gemsAttachFile.Case__c = recordId;
                                gemsAttachFile.Description__c = sharepointDoc.CaseDescription;
                                gemsAttachFile.Type__c = sharepointDoc.DocumentType;
                                gemsAttachFile.Level__c  = sharepointDoc.Level;
                                gemsAttachFile.SharePointExtId__c = sharepointDoc.ExternalId;
                                gemsAttachFile.File_Name__c = sharepointDoc.Name;   
                                gemsAttachFile.File_Last_Modified_Date__c=sharepointDoc.FileLastModifiedDate;
                                gemsAttachFile.File_Modified_By__c = sharepointDoc.ModifiedBy;
                                gemsAttachmentsToBeInserted.add(gemsAttachFile);
                            }  
                        }
                    }   
                } else if(gemsAttachments.isEmpty()){//GEMS Attachment for the CASE is empty.
                    GEMS_Attachment__c gemsAttachFile = new GEMS_Attachment__c();
                    gemsAttachFile.Name = sharePointFileName;
                    gemsAttachFile.File_URL__c= sharepointDoc.DownloadUrl;
                    gemsAttachFile.BA_Info__c = sharepointDoc.BAInfo;
                    gemsAttachFile.Case__c = recordId;
                    gemsAttachFile.Description__c = sharepointDoc.CaseDescription;
                    gemsAttachFile.Type__c = sharepointDoc.DocumentType;
                    gemsAttachFile.Level__c  = sharepointDoc.Level;
                    gemsAttachFile.SharePointExtId__c = sharepointDoc.ExternalId;
                    gemsAttachFile.File_Name__c = sharepointDoc.Name;                    
                    gemsAttachFile.File_Creation_Date__c = sharepointDoc.FileCreatedDate;
                    gemsAttachFile.File_Last_Modified_Date__c= sharepointDoc.FileLastModifiedDate;
                    gemsAttachFile.File_Modified_By__c = sharepointDoc.ModifiedBy;
                    gemsAttachmentsToBeInserted.add(gemsAttachFile);
                }                
            }
            if(!gemsAttachmentsToBeInserted.isEmpty()){
                upsert gemsAttachmentsToBeInserted;
                GEMS_AttachmentTriggerHandler.sendNotificationToBenefitCoder(gemsAttachmentsToBeInserted);                              
            }
            
            for(GEMS_Attachment__c attachmntRec: gemsAttachments) {
                if(!stringSharePointRecMap.containsKey(attachmntRec.File_Name__c) && attachmntRec.File_Name__c!= null)
                    gemsAttachmentsToBeDeleted.add(attachmntRec);
            }
            
            if(!gemsAttachmentsToBeDeleted.isEmpty()) {
                delete gemsAttachmentsToBeDeleted;
            }
            
        } catch(Exception ex) {
            System.debug('An Exception has been occured during the AutoGemsAttSyncOnPageVisit'+ ex.getMessage() +'Line Number'+ex.getLineNumber());
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_Utility.AutoGemsAttSyncOnPageVisit(string teamSharePointURL,string sharePointListName,string folderPath,string response,string recordId)','High');                  
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
        public String ModifiedBy {get; set;}          
        public GEMS_SPFilesJSON2Apex.Results file {get;set;}
        public String downloadURL {get; set;}
        public String externalId {get; set;}
        public String FileCreatedDate {get; set;}
        public String FileLastModifiedDate {get; set;}
        
        public SharePointFilesWrapper(GEMS_SPFilesJSON2Apex.Results file){
            this.file = file;
            this.name = file.Name;
            if ( file.Name != null ) {
                this.type = file.Name.substringAfterLast('.');
            }
            this.author = file.Author.Title;
            if ( file.Properties.vti_x005f_timecreated != null ) {
                this.FileCreatedDate = file.Properties.vti_x005f_timecreated;
            }
            if(file.Properties.vti_x005f_timelastmodified !=null)
            {
                this.FileLastModifiedDate=file.Properties.vti_x005f_timelastmodified;
            }
            this.documentType = file.Properties.DocumentType;
            this.level = file.Properties.DocumentLevel;
            this.baInfo = file.Properties.BAInfo;
            this.caseDescription = file.Properties.CaseDescription;
            this.externalId = file.Properties.ODatax005f_dlc_x005f_DocId;
            String modifiedsplit=file.Properties.vti_x005f_modifiedby.substringAfter('membership|');
            modifiedsplit=modifiedsplit.substringBefore('@');
            this.ModifiedBy=modifiedsplit;
            
        }
    }
    
    /******************************************************************** 
*   Method Name : getLocalTimeZoneOffset
*   Description : get the GMT offset for login user's local timezone
*                 In a VF page, if you use apex:outputText to display a dateTime field, you need this offset in your VF page
*                 See example in GEMSScreeningCase360View vfp and GEMS_ScreeningCase360ViewController class
*********************************************************************/
    public static Double getLocalTimeZoneOffset(){
        TimeZone tz = UserInfo.getTimeZone();
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }
    
    /******************************************************************** 
*   Method Name : UserPartOfPermissionSet
*   Description : SFDC-10739:To check current user is part of the given Permission Set
*********************************************************************/ 
    public static Boolean checkUserPermissionSet(string userId,set<String> PermissionSetName){
        if(PermissionSetName!=NULL){
            List<PermissionSetAssignment> perm = [select Id from PermissionSetAssignment where AssigneeId =:userId and PermissionSetId in (select Id from PermissionSet where Name in:PermissionSetName) LIMIT 1];
            if(perm !=NULL && !perm.isEmpty()){
                return true;
            }
        }
        return false;
    }   
    
    /******************************************************************** 
*   Method Name : CurrentUserSystemAdmin
*   Description : SFDC-10739:To check the current user is a system admin 
*********************************************************************/ 
    public static Boolean CurrentUserSysAdmin(){
        List<User> currUser = [select id,Profile.Name from User where Id=:UserInfo.getuserId() LIMIT 1];
        if(currUser!=NULL && !currUser.isEmpty() && currUser[0].Profile.Name.containsIgnoreCase('Admin')){
            return true;
        }
        return false;
    } 
    
}