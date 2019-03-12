/**************************************************************************************
Apex Class Name     : GEMS_AttachmentTriggerHandler
Version             : 1.0
Function            : This is a handler class for make true updation of required documents added check box on submission case.
Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Ranjit Gandhi       10/11/2017             SFDC 3434 GEMS: Systematic, Actionable Notifications of SharePoint Attachment Changes/Additions
* Offshore            03/29/2016             Original Version
* Gokul Bharati       01/31/2018             SFDC-6946 Auto Close Account Submission Case
* Gokul Bharati       03/12/2018             SFDC-8034  Complete Off-Cycle submission cases as "Completed" instead of "Completed - Without Signed BPA"
* Gokul Bharati       03/13/2018             SFDC-8501 GEMS: Prod Issue - Submission Case Status changing to In Progress when a Sharepoint Doc is added/synced
* Luke Chen			  04/13/2018			 SFDC-7852 GEMS: Dental Benefit Coding – Email Notification when Documents are Added/Modified in SharePoint
*************************************************************************************/
public  class GEMS_AttachmentTriggerHandler {
/******************************************************************** 
*    Method Name : updateRequiredDocumentFlag
*   @description :   This method to make GEMS_All_required_documents_attached__c field true if all required documents attached
*   @parameters  :   List<GEMS_Attachment__c > attachments
*   @return type :   void
*   @Author : Balaram
***************************************************************/
    public static void updateRequiredDocumentFlag(List<GEMS_Attachment__c > attachments,Map<Id,GEMS_Attachment__c> oldAttachmentMap) {
        List<ID> idList = new List<Id>();
        List<Case> casesToUpdateRecDocList = new List<Case>();
        try {
            Id accStructCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
            //Code changed for October release for Attachment type Update.
            for(GEMS_Attachment__c attachmentRecord : attachments) {
                if(oldAttachmentMap != null && oldAttachmentMap.get(attachmentRecord.Id) != null && oldAttachmentMap.get(attachmentRecord.Id).Type__c !=  attachmentRecord.Type__c) {
                    idList.add(attachmentRecord.case__c);             
                }else if(oldAttachmentMap == null) {
                    idList.add(attachmentRecord.case__c); 
                }
            }
            if(!idList.isEmpty()) {
                List<Case> caseList = [select id,Subject,Accountid,account.name, account.External_ID__c, 
                                       type, GEMS_Submission_Type__c,
                                       Account_Executive__c,HCSC_Division__c,
                                       Productid,
                                       GEMS_Submission_Sub_Type__c,GEMS_Medical_Underwriter__c,Sales_Executive__c,GEMS_Ready_to_release_to_screening__c,
                                       FSU_Location__c,GEMS_Effective_Date__c,GEMS_Case_Effective_Date__c,status,GEMS_Products__c,GEMS_Benefit_Booklet_Required__c,GEMS_Line_of_Business__c,GEMS_Additional_Medical_Underwriter__c
                                       ,Opportunity_Name__c,GEMS_All_required_documents_attached__c,Funding_Type__c,Funding_Type_Multiselect__c,GEMS_AEP_Account__c,GEMS_Integrated__c,GEMS_Grandfathered_benefits__c,GEMS_Bank__c,GEMS_Performance_Guarantees__c, (select Attachment__c,Description__c,Type__c from GEMS_Attachments__r), 
                                       (select id, casenumber,Status,recordTypeId, parentId from Cases1__r where recordtypeid =: accStructCaseRecordTypeId ) from case where id =:idList];
                
                Map<String,Set<String>> caseIdRecDocs = GEMS_ShowCaseSubmissionRequiredDocuments.retrieveDocsRequiredForCases(caseList);
                
                for(Case caseSub : caseList) {
                    Set<String> attachmentTypes = new Set<String>();
                    
                    for(GEMS_Attachment__c attachment : caseSub.GEMS_Attachments__r) {                       
                        if(attachment.Type__c != null)
                            attachmentTypes.add(attachment.Type__c.toUpperCase());
                    }
                    if(caseIdRecDocs.get(caseSub.Id) != null) {
                        boolean allAttachmentsFound = true;
                        Set<String> attachmentTypesMetaData = caseIdRecDocs.get(caseSub.Id);
                        List<Case> structureCases = caseSub.Cases1__r;
                        if(caseSub.GEMS_Attachments__r != null && !caseSub.GEMS_Attachments__r.isEmpty() && structureCases != null && !structureCases.isEmpty() ) {
                            Case accStructCase = structureCases.get(0);
                            if(caseSub.GEMS_Ready_to_release_to_screening__c != 'Released' && (accStructCase.status == 'Client Approval Received' || accStructCase.status == 'BlueSTAR Sent' 
                                                                                               || accStructCase.status == 'BlueSTAR Shell Created' || accStructCase.status == 'BlueSTAR Failed' || accStructCase.status == 'BlueSTAR Partially Fail' )) {
                                                                                                   caseSub.GEMS_Ready_to_release_to_screening__c = 'Ready to Release';
                                                                                               }
                        }else if(caseSub.GEMS_Ready_to_release_to_screening__c != 'Released' && caseSub.GEMS_Ready_to_release_to_screening__c != 'Not Ready for release' ) {
                            caseSub.GEMS_Ready_to_release_to_screening__c = 'Not Ready for release';
                        }
                        for(String metaAttachmentType : attachmentTypesMetaData) {
                            if(!attachmentTypes.contains(metaAttachmentType)) {
                                allAttachmentsFound = false;
                                break;
                            }
                        }
                        if(!caseSub.GEMS_All_required_documents_attached__c && allAttachmentsFound) {
                            caseSub.GEMS_All_required_documents_attached__c = true;
                            caseSub.GEMS_allrequired_documents_attached_date__c = System.today();
                            try {                                   
                                integer totalDays = (caseSub.GEMS_Effective_Date__c).daysBetween(System.today());
                                
                                caseSub.GEMS_No_of_Days_released_to_screening__c = totalDays;
                            }catch(Exception e) {
                                
                            }
                            
                        }else if(caseSub.GEMS_All_required_documents_attached__c && !allAttachmentsFound) {
                            caseSub.GEMS_All_required_documents_attached__c = false;
                            
                        }
                        
                        casesToUpdateRecDocList.add(caseSub);
                    }
                }
                if(!casesToUpdateRecDocList.isEmpty()) {
                    
                    update casesToUpdateRecDocList;
                }
          }  
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'updateRequiredDocumentFlag(List<GEMS_Attachment__c > attachments,Map<Id,GEMS_Attachment__c> oldAttachmentMap)','High');              
        }
    }
    
    
/******************************************************************** 
*    Method Name : retrieveDocsRequiredForCases
*   @description :   This method to make Retrieve all required documents for cases
*   @parameters  :   List<Case> casesList
*   @return type :   Map<String,Set<String>>
*   @Author : Balaram
***************************************************************/
    public static Map<String,Set<String>> retrieveDocsRequiredForCases(List<Case> casesList) {
        Set<String> recDocs= null;
        Map<String,Set<String>> caseIdRecDocsMap = new Map<String,Set<String>>();
        Map<String, Schema.SObjectField> caseFieldsMap = Schema.SObjectType.Case.fields.getMap();
        try {
            List<GEMS_Account_Submission_required_doc__mdt> accountSubmissionRequiredDocsList = [SELECT Division__c, Document_Type__c, Fields__c, Funding_Type__c, Products__c, Required_Documents__c, Submission_Sub_type__c, Submission_Type__c FROM GEMS_Account_Submission_required_doc__mdt where Is_Active__c = true];
            
            for(Case caseRecord : casesList) {
                if(!accountSubmissionRequiredDocsList.isEmpty()) {
                    recDocs = new Set<String>();
                    
                    for(GEMS_Account_Submission_required_doc__mdt submissionReqDoc : accountSubmissionRequiredDocsList) {            
                        if(!(caseRecord.GEMS_Submission_Type__c != null && caseRecord.GEMS_Submission_Type__c.contains(submissionReqDoc.Submission_Type__c)) ) {
                            continue;
                        }
                        if((submissionReqDoc.Division__c == 'All' && caseRecord.HCSC_Division__c == null ) || (submissionReqDoc.Division__c != 'All' && submissionReqDoc.Division__c != 'N/A' && caseRecord.HCSC_Division__c != submissionReqDoc.Division__c) ) {
                            continue;
                        }
                        
                        System.debug('caseRecord.GEMS_Products__c===>'+caseRecord.GEMS_Products__c+' submissionReqDoc.Products__c==>'+submissionReqDoc.Products__c);
                        
                        if( (submissionReqDoc.Products__c != 'N/A' && caseRecord.GEMS_Products__c == null) || (submissionReqDoc.Products__c != 'N/A' && caseRecord.GEMS_Products__c != null && !(caseRecord.GEMS_Products__c.contains(submissionReqDoc.Products__c) || submissionReqDoc.Products__c.contains(caseRecord.GEMS_Products__c)) )) {
                            System.debug('Entered----Rec--Docs--');
                            continue;
                        }
                        
                        String SearchstringcaseFundingType = '';
                        String SearchstringMetadataFundingType = '';
                        
                        SearchstringMetadataFundingType = submissionReqDoc.Funding_Type__c;
                        SearchstringcaseFundingType = caseRecord.Funding_Type_Multiselect__c;
                        
                        System.debug('caseRecord.Funding_Type__c ===>'+caseRecord.Funding_Type_Multiselect__c +' submissionReqDoc.Funding_Type__c ==>'+submissionReqDoc.Funding_Type__c );
                        //if( (submissionReqDoc.Funding_Type__c == 'All' && caseRecord.Funding_Type_Multiselect__c == null) || (submissionReqDoc.Funding_Type__c != 'All' && submissionReqDoc.Funding_Type__c != 'N/A' && caseRecord.Funding_Type_Multiselect__c != submissionReqDoc.Funding_Type__c) ) {
                        if( (submissionReqDoc.Funding_Type__c == 'All' && caseRecord.Funding_Type_Multiselect__c == null) || (submissionReqDoc.Funding_Type__c != 'All' && submissionReqDoc.Funding_Type__c != 'N/A' && !SearchstringcaseFundingType .contains(SearchstringMetadataFundingType) ) ) {
                            continue;
                        }   
                        
                        if( submissionReqDoc.Fields__c != 'N/A') {
                            try{
                                String[] fieldMetaDataArray = (submissionReqDoc.Fields__c).split(';');
                                Boolean caseFailed = false;
                                String Searchstring = '';
                                for(String fieldMetaData : fieldMetaDataArray ) {
                                    String[] fieldData = fieldMetaData.split('=');
                                    //Searchstring = (String)caseRecord.get(caseFieldsMap.get(fieldData[0]));
                                    system.debug('field Type: '+fieldData[0]);
                                    system.debug('field Data: '+fieldData[1]);
                                    
                                    if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.MultiPicklist) {
                                        if(caseRecord.get(caseFieldsMap.get(fieldData[0])) != null) {
                                            Searchstring = (String)caseRecord.get(caseFieldsMap.get(fieldData[0]));
                                            system.debug('Picklist :'+(String)caseRecord.get(caseFieldsMap.get(fieldData[0])));
                                        }
                                    }
                                    
                                    if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.BOOLEAN && ( (fieldData[1] == 'TRUE' && !(Boolean)caseRecord.get(caseFieldsMap.get(fieldData[0]))) || (fieldData[1] == 'FALSE' && (Boolean)caseRecord.get(caseFieldsMap.get(fieldData[0]))) ) ){
                                        caseFailed = true;
                                        break;
                                    }
                                    
                                    if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.PICKLIST && ( (fieldData[1] != (String)caseRecord.get(caseFieldsMap.get(fieldData[0]))) ) ){
                                        caseFailed = true;
                                        break;
                                    }
                                    
                                    if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.STRING && ( (fieldData[1] != (String)caseRecord.get(caseFieldsMap.get(fieldData[0]))) ) ){
                                        caseFailed = true;
                                        break;
                                    }
                                    
                                    //if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.MultiPicklist && ( (fieldData[1] != (String)caseRecord.get(caseFieldsMap.get(fieldData[0]))) ) ){
                                    if(caseFieldsMap.get(fieldData[0]).getDescribe().getType() == Schema.DisplayType.MultiPicklist && ( !Searchstring.contains(fieldData[1]) ) ){
                                        caseFailed = true;
                                        break;
                                    }
                                }
                                if(caseFailed) {
                                    continue;
                                }
                            }catch(Exception ex) {
                                System.debug('======Try===Exception==Fields__c ==='+ex.getMessage());
                            }
                        }
                        if(submissionReqDoc.Document_Type__c != '?') {
                            recDocs.add(submissionReqDoc.Document_Type__c);
                        }
                        
                    }
                    System.debug('recDocs====>'+recDocs);
                    caseIdRecDocsMap.put(caseRecord.Id,recDocs); 
              }  
            }
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'updateRequiredDocumentFlag(List<GEMS_Attachment__c > attachments,Map<Id,GEMS_Attachment__c> oldAttachmentMap)','High');              
        }
        return caseIdRecDocsMap;
    }
    
/******************************************************************** 
*   Method Name  :   autoUpdAccSubCaseBPA
*   @description :   Refer - SFDC - 6946   
*   @parameters  :   List<GEMS_Attachment__c > attachments
*   @return type :   void
*   @Author      :   Gokul Bharati
***************************************************************/  
    public static void autoUpdAccSubCaseBPA(Set<Id> attachmentIds){
        set<string> recordTypeIdSet = new set<string>{'GEMS_Eligibility_Process','GEMS_GET','GEMS_Request_Resource'};        
        List<string> docTypes = new List<string>(GEMS_Constants.docTypes); 
        string milestoneTocheck= GEMS_Constants.ServiceReady;        
        List<case> caseList = new List<case>();
        Map<Id,Boolean> caseBPAFound = new Map<Id,Boolean>();
        Map<Id,Boolean> dwnCaseFound = new Map<Id,Boolean>();
        set<Id> caseIds = new set<Id>();
        try{
                for(GEMS_Attachment__c att:[select id,Type__c,Case__c,Case__r.MileStone__c,Case__r.GEMS_Submission_Type__c from GEMS_Attachment__c where Id in:attachmentIds and Case__r.isClosed = false]){
                   if(att.Case__r.MileStone__c != null && att.Case__r.MileStone__c == milestoneTocheck && att.Type__c != '' && (string.join(docTypes,',')).contains(att.Type__c)){
                        caseBPAFound.put(att.Case__c,true); 
                     }
                     else{
                        caseBPAFound.put(att.Case__c,false);
                     }
                }    
                if(!caseBPAFound.isEmpty()){            
                for(Case cse:[select Id,recordType.DeveloperName,Status,isClosed,GEMS_Account_Submission_Info__c  from Case where recordType.DeveloperName in :recordTypeIdSet and GEMS_Account_Submission_Info__c in:caseBPAFound.keySet()]){            
                      if(!dwnCaseFound.containsKey(cse.GEMS_Account_Submission_Info__c)){
                         if(cse.status == GEMS_Constants.StatusCompleted || cse.status == GEMS_Constants.StatusCancelled)  
                         dwnCaseFound.put(cse.GEMS_Account_Submission_Info__c,true); 
                         else
                         dwnCaseFound.put(cse.GEMS_Account_Submission_Info__c,false);
                      }
                      else{
                         Boolean bool = dwnCaseFound.get(cse.GEMS_Account_Submission_Info__c);
                         if(cse.status == GEMS_Constants.StatusCompleted || cse.status == GEMS_Constants.StatusCancelled)  
                         dwnCaseFound.put(cse.GEMS_Account_Submission_Info__c,(bool && true)); 
                         else
                         dwnCaseFound.put(cse.GEMS_Account_Submission_Info__c,(bool && false));                       
                      }    
                   }
                }
                for(Case cse:[select id,MileStone__c,status,GEMS_Submission_Type__c from Case where Id in:caseBPAFound.keySet()]){
                    //SFDC-8034
                    Boolean NonOffCycle = (cse.MileStone__c != null && cse.MileStone__c == milestoneTocheck && caseBPAFound.get(cse.Id) != null && caseBPAFound.get(cse.Id) == true && (dwnCaseFound.get(cse.Id) == null || dwnCaseFound.isEmpty() || dwnCaseFound.get(cse.Id) == true) && cse.GEMS_Submission_Type__c != GEMS_Constants.SubmissionTypeOffCycle);    
                    Boolean OffCycle = (cse.MileStone__c != null && cse.MileStone__c == milestoneTocheck && (dwnCaseFound.get(cse.Id) == null || dwnCaseFound.isEmpty() || dwnCaseFound.get(cse.Id) == true) && cse.GEMS_Submission_Type__c == GEMS_Constants.SubmissionTypeOffCycle);
                    if(NonOffCycle || OffCycle){    
                           cse.Status = GEMS_Constants.StatusCompleted;
                           caseList.add(cse);
                    }
                    //SFDC-8034
                }                
                if(!caseList.isEmpty()){
                    update caseList; 
                }
        }catch(Exception ex){
            System.debug('Exception Message'+ex.getMessage() +'  Line Number'+ex.getLineNumber());
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_AttachmentTriggerHandler.autoUpdAccSubCaseBPA(List<GEMS_Attachment__c > attachments)','High');              
        }           
    }
/******************************************************************** 
*   Method Name :    sendNotificationToBenefitCoder
*   @description :   This method to send Notification to benefit Coder if document attached after medical benefit Coding case created and before it becomes production ready
*   October release hot fix- 2016
*   @parameters  :   List<GEMS_Attachment__c > attachments,Map<Id,GEMS_Attachment__c> oldAttachmentMap
*   @return type :   void
*   Developer        Date            Description
*   ---------------------------------------------------------
*   Balaram         10/12/2016      Original version
*   Praveen         10/18/2016      Added logic for Account Setup and Pharmacy Coding notifications
*   Malathi.K       02/23/2018      SFDC-8045 Add Document Names and Types to Sharepoint Email.  
***************************************************************/
    public static void sendNotificationToBenefitCoder(List<GEMS_Attachment__c > attachments) {
        Set<Id> idList = new Set<Id>();                  
        Map<Id,List<String>> neworUpdFilenameandtype = new Map<Id,List<String>>();
        List<Case> casesToUpdateRecDocList = new List<Case>();
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        List<String> fileInfo;
        String fileDisplay;
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        List<OrgWideEmailAddress> orgEmailAddress =  [select id, Address,displayname from OrgWideEmailAddress where displayname='No Reply GEMS'];       
        try {
            for(GEMS_Attachment__c attachmentRecord : attachments) {  
                if(attachmentRecord.case__c != null){             
                    idList.add(attachmentRecord.case__c);                    
                    if(!neworUpdFilenameandtype.containsKey(attachmentRecord.case__c)){
                      neworUpdFilenameandtype.put(attachmentRecord.case__c,new List<String>());                        
                    } 
                    string documentName = attachmentRecord.File_Name__c != null ? attachmentRecord.File_Name__c:'&nbsp;';
                    string docType = attachmentRecord.Type__c != null ? attachmentRecord.Type__c:'&nbsp';                    
                    neworUpdFilenameandtype.get(attachmentRecord.case__c).add('<tr><td>'+documentName+'</td>'+'<td>'+docType+'</td></tr>');
                 }
            }
            //Query all the downstream cases for the submission case list and retrieve ownerId email address required to send email.
            if(!idList.isEmpty()) {                    
                Id mbcRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
                Id accSetUpRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
                Id pharmacyRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
                Id medicalUWRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
                Id additionalUWRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();
                Id dbcRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId(); // SFDC-7852
                
                Set<Id> recordTypeIdSet= new Set<ID>{accSetUpRecordTypeId,mbcRecordTypeId,pharmacyRecordTypeId,medicalUWRecordTypeId,additionalUWRecordTypeId,dbcRecordTypeId}; // SFDC-7852                                               
                List<Case> accSetUpMedBenfPharmacyCodingCasesList = [select id, ownerId,subject,status,owner.email,Account.Name,Account_Number__c,GEMS_Effective_Date__c, 
                GEMS_Account_Submission_Info__r.caseNumber,GEMS_Account_Submission_Info__r.Id, GEMS_Account_Submission_Info__r.status from case where GEMS_Account_Submission_Info__c in :idList and recordTypeId IN: recordTypeIdSet];
                if(accSetUpMedBenfPharmacyCodingCasesList != null && !accSetUpMedBenfPharmacyCodingCasesList.isEmpty()) { 
                    Set<String> emailIds =new Set<String>(); 
                    Case caseRec;
                    String[] toAddresses;                   
                    for(Case caseTempRec : accSetUpMedBenfPharmacyCodingCasesList) { 
                        caseRec =  caseTempRec ; 
                     If(!(string.valueOf(caseRec.OwnerID).startsWith('00G')))
                            emailIds.add(caseRec.owner.email);
                      }      
                     If (emailIds.size() > 0)
                      {
                         toAddresses = new String[emailIds.size()];
                         Integer i = 0;
                         for (String to: emailIds) {
                          toAddresses[i++] = to;
                         }
                                                                                           
                        DateTime effectiveDate1 = caseRec.GEMS_Effective_Date__c;
                        String subjecttt;
                        String body;                        
                        fileInfo = neworUpdFilenameandtype.get(caseRec.GEMS_Account_Submission_Info__c);
                        fileDisplay = '<html><body><table cellspacing="0" cellpadding="3" width="640" border="1"><thead><tr><td><b>Document Name</b></td><td><b>Document Type</b></td></tr></thead>'+string.join(fileInfo,'')+'</table></body></html>';
                        subjecttt = caseRec.Account.Name+' - '+caseRec.Account_Number__c+' - '+effectiveDate1.format('M/d/yyyy')+'- New document(s) have been added or revised';
                        //SFDC-8916 GEMS: Add Account Submission case status to SharePoint Email Notifications
                        body =  'New document(s) have been added or revised to the Submission case. Please review and take necessary action. </br></br> <b>Account Name : </b>'+ caseRec.Account.Name +'</br> <b>Case Number &nbsp : </b>'+ caseRec.GEMS_Account_Submission_Info__r.caseNumber +'</br> <b>Submission Case Status &nbsp : </b>'+ caseRec.GEMS_Account_Submission_Info__r.status +'</br><b>Case Details&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp: </b><a href="'+baseUrl+'/'+caseRec.GEMS_Account_Submission_Info__r.Id +'" target="_blank">View Case Details</a></br></br>' + fileDisplay + '</br></br>Thanks';
                        GEMS_EmailNotification.createMassEmailMessage(mailList,toAddresses,subjecttt,body,caseRec);                       
                    }
                }
            } 
            //Query all the SBC/BB form for the submission case list and retrieve ownerId email address required to send email.                   
            if(!idList.isEmpty()) {      
                List<GEMS_Contract_Admin_Request__c> contractadminRequestList = [select id,Account_Name__c,Account_Number__c,Effective_Date__c,Case__c,case__r.account.name,case__r.id,case__r.casenumber, case__r.status
                from GEMS_Contract_Admin_Request__c where Case__c=:idlist LIMIT 1];
                if(contractadminRequestList.size() > 0) {
                    List<GEMS_SBC_BB_Form__c> sbcList=[select id, ownerId,owner.email,Account_Name_Text__c,Account_Number__c,Effective_Date__c
                    from GEMS_SBC_BB_Form__c where GEMS_SBC_Request__c= :contractadminRequestList[0].id or GEMS_Benefit_Booklet_Request__c=:contractadminRequestList[0].id];
                    
                    Set<String> emailIds =new Set<String>();                                                                            
                    if(sbcList.size() > 0) {                    
                        for(GEMS_SBC_BB_Form__c sbcRec:sbclist)
                        {
                            If(!(string.valueOf(sbcRec.OwnerID).startsWith('00G')))
                                emailIds.add(sbcRec.ownerId);                           
                        }                                                        
                     If (emailIds.size() > 0)
                      {                                               
                        String[] toAddresses = new String[emailIds.size()];
                        Integer i = 0;
                        for (String to: emailIds) {
                          toAddresses[i++] = to;
                        }                            
                        Datetime effectiveDate1 = contractadminRequestList[0].Effective_Date__c;
                        String subjecttt;
                        String body;                                   
                        fileInfo = neworUpdFilenameandtype.get(contractadminRequestList[0].Case__c);
                        fileDisplay = '<html><body><table cellspacing="0" cellpadding="3" width="640" border="1"><thead><tr><td><b>Document Name</b></td><td><b>Document Type</b></td></tr></thead>'+string.join(fileInfo,'')+'</table></body></html>';
                        subjecttt = contractadminRequestList[0].case__r.account.name+' - '+contractadminRequestList[0].Account_Number__c+' - '+effectiveDate1.format('M/d/yyyy')+' - New document(s) have been added or revised';
                        //SFDC-8916 GEMS: Add Account Submission case status to SharePoint Email Notifications
                        body = 'New document(s) have been added or revised to the Submission case. Please review and take necessary action. </br></br> <b> Account Name : </b>'+ contractadminRequestList[0].case__r.account.name+'</br> <b>Case Number &nbsp : </b>'+ contractadminRequestList[0].Case__r.caseNumber+'</br> <b>Submission Case Status &nbsp : </b>'+ contractadminRequestList[0].Case__r.Status  +'</br><b>                   Case Details&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp: </b><a href="'+baseUrl+'/'+contractadminRequestList[0].Case__r.id +'"target="_blank">View Case Details</a></br></br>' + fileDisplay + '</br></br>Thanks.';                                                       
                        GEMS_EmailNotification.createMassEmailMessageSBCBB(mailList,toAddresses,subjecttt,body);
                     }                              
                    }
                } 
            }
            if(!mailList.isEmpty()) {
                if(orgEmailAddress != null && !orgEmailAddress.isEmpty()) {
                    for(Messaging.SingleEmailMessage mailMessage : mailList) {
                        mailMessage.setOrgWideEmailAddressId(orgEmailAddress.get(0).Id);
                    }
                }
                Messaging.sendEmail(mailList); 
          }   
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_AttachmentTriggerHandler.sendNotificationToBenefitCoder(List<GEMS_Attachment__c > attachments)','High');              
            System.debug('$$$$Exception Message'+ex.getMessage()+'$$$$Line Number'+ex.getLineNumber());
        }
    }
}