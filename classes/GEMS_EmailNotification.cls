/**************************************************************************************
Apex Class Name     : GEMS_EmailNotification
Version             : 1.0
Function            : This Class is to send email notifications.
Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------  
* Vijay               25/11/2017             SFDC 4263 GEMS: GET Notification / Trigger needs to be updated with correct language and made optional
* Ranjit Gandhi       10/11/2017             SFDC 3434 GEMS: Systematic, Actionable Notifications of SharePoint Attachment Changes/Additions
* Offshore            22/06/2016             Original Version
* Phani Kommareddy    11/27/2017             SFDC-6369 GEMS - ID Card Maintenance: ID Card Case Page Layout & Functionality
* Gokul Bharati       03/20/2018             SFDC-7750 GET Closure Notification needs to be updated with correct language and additional fields need to populate
* Gokul Bharati       05/16/2018             SFDC-9232 GEMS - Move Trigger after updates email notification methods to future callout 
*************************************************************************************/
public class GEMS_EmailNotification {
    
/******************************************************************** 
*    Method Name : sendSingleEmailNotification
Action
*   @description :   This method to send single email message
*   @parameters  :   String[] toAddresses,String subject,String htmlBody, Case caseObj
*   @return type :   void
***************************************************************/
    public static void sendSingleEmailNotification(String[] toAddresses,String subject,String htmlBody, Case caseObj) {
        try {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddress = toAddresses;
            mail.setToAddresses(toAddress);
            mail.subject = subject;
            mail.setHtmlBody(htmlBody);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_EmailNotification.sendSingleEmailNotification(String[] toAddresses,String subject,String htmlBody, Case caseObj)','High');        
        }
    }
    
/******************************************************************** 
*    Method Name : createMassEmailMessage
Action
*   @description :   This method to send single email message
*   @parameters  :   List<Messaging.SingleEmailMessage> mailList,String[] toAddresses,String subject,String htmlBody, Case caseObj
*   @return type :   void
***************************************************************/
    public static List<Messaging.SingleEmailMessage> createMassEmailMessage(List<Messaging.SingleEmailMessage> mailList,String[] toAddresses,String subject,String htmlBody, Case caseObj) {
        try {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddress = toAddresses;
            mail.setToAddresses(toAddress);
            mail.subject = subject;
            mail.setHtmlBody(htmlBody);
            
            mailList.add(mail);
            
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_EmailNotification.sendSingleEmailNotification(String[] toAddresses,String subject,String htmlBody, Case caseObj)','High');        
        }
        return mailList;
    }
    // Ranjit Gandhi       10/11/2017             SFDC 3434 GEMS: Systematic, Actionable Notifications of SharePoint Attachment Changes/Additions
    //createMassEmailMessageSBCBB   - email to SBC/ BB users.
    public static List<Messaging.SingleEmailMessage> createMassEmailMessageSBCBB(List<Messaging.SingleEmailMessage> mailList,String[] toAddresses,String subject,String htmlBody) {
        try {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddress = toAddresses;
            mail.setToAddresses(toAddress);
            mail.subject = subject;
            mail.setHtmlBody(htmlBody);
            
            mailList.add(mail);
            
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_EmailNotification.createMassEmailMessageSBCBB(List<Messaging.SingleEmailMessage> mailList,String[] toAddresses,String subject,String htmlBody)','High');        
        }
        return mailList;
    }    
/******************************************************************** 
*    Method Name : sendEmailNotificationWhenGETCaseImplementationIsClosed
Action
*   @description :   This method to send notification to Account Team and Case Team when GET Case is Closed
*   @parameters  :   List<case> casesList,Map<Id,Case> oldCaseMap
*   @return type :   void
***************************************************************/
    public static void sendEmailNotificationWhenGETCaseImplementationIsClosed(List<Case> casesList,Map<Id,Case> oldCaseMap)
    {
        //Get All the Record Type Ids
        Id getCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(GEMS_Constants.CaseRecdType_GEMSGetCase).getRecordTypeId();
        Id medicalUWCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(GEMS_Constants.CaseRecdType_GEMSMedicalUnderwritingCase).getRecordTypeId();
        Id eligibilityProcessCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(GEMS_Constants.CaseRecdType_GEMSEligibilityCase).getRecordTypeId();
        Id parentIdCardCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(GEMS_Constants.CaseRecdType_GEMSIdCardCase).getRecordTypeId();
        Id parentMedBenfCodingCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(GEMS_Constants.CaseRecdType_GEMSMedicalBenefitCodingCase).getRecordTypeId();
        
        Set<Id> recordTypeIdsToProcess = new Set<Id>{getCaseRecordTypeId,medicalUWCaseRecordTypeId,eligibilityProcessCaseRecordTypeId,parentIdCardCaseRecordTypeId,parentMedBenfCodingCaseRecordTypeId};
        
        Set<Id> accSubCasesIdSet = new Set<Id>();
        Set<Id> accountIdsSet = new Set<Id>();
        List<Case> accSubCasesAndItsChildCasesList = new List<Case>();
        List<Account> accountsList = new List<Account>();
        List<GEMS_Email_Notification__mdt> getCaseEmailNotificationMetaData = new List<GEMS_Email_Notification__mdt>();
        
        Map<Id, Case> accountIdAndSubmissionCaseMap = new Map<Id, Case>();
        Map<Id, Map<String,Case>> accSubIdAndMapOfRecordTypeNamesAndChildCasesMap = new Map<Id, Map<String,Case>>();
        Map<Id, List<CaseTeamMember>> subCaseIdAndCaseTeamMembersMap = new Map<Id, List<CaseTeamMember>>();
        Map<Id, List<AccountTeamMember>> accountIdAndCaseTeamMembersMap = new Map<Id, List<AccountTeamMember>>();
        
        List<Messaging.SingleEmailMessage> singleEmailMessages = new List<Messaging.SingleEmailMessage>();
    
        try
        {
            for(Case cases_new : casesList)
            {
                if(getCaseRecordTypeId == cases_new.recordTypeId && cases_new.GEMS_Implementation_Is_Closed__c && cases_new.GEMS_Implementation_Is_Closed__c != oldCaseMap.get(cases_new.Id).GEMS_Implementation_Is_Closed__c)
                {
                    accSubCasesIdSet.add(cases_new.GEMS_Account_Submission_Info__c);
                    accountIdsSet.add(cases_new.AccountId);
                }
            }
            if(!accSubCasesIdSet.isEmpty())
            {
                accSubCasesAndItsChildCasesList = [SELECT Id, CaseNumber, Status, AccountId, Account.Name, Account.External_ID__c,
                                                    (SELECT Id, CaseNumber, RecordTypeId, RecordType.Name, Status,AccountId, GEMS_Account_Submission_Info__c, Owner.Email,
                                                        Account.Name, Account.External_ID__c, isClosed, ClosedDate, GEMS_Date_Lock_Removed__c, GEMS_ID_card_mailed_date__c,GEMS_Number_of_Cards_Mailed__c
                                                        FROM Cases1__r WHERE RecordTypeId IN: recordTypeIdsToProcess
                                                    ),
                                                    (SELECT parentId,memberid, member.Email,TeamRole.name from TeamMembers)
                                                    FROM Case WHERE Id IN: accSubCasesIdSet
                                                  ];
                
                accountsList = [SELECT ID, Name,
                                (SELECT AccountId,UserID, User.Email,TeamMemberRole from AccountTeamMembers)
                                FROM Account WHERE ID IN: accountIdsSet
                               ];
                
                getCaseEmailNotificationMetaData = [SELECT Business_Area__c, Flag__c,Email__c 
                                                    FROM GEMS_Email_Notification__mdt WHERE Business_Area__c = 'GEMS GET' AND Flag__c=true];
            }
            if(!accountsList.isEmpty())
            {
                for(Account accRec: accountsList)
                {
                    if(!accRec.AccountTeamMembers.isEmpty())
                    {
                        accountIdAndCaseTeamMembersMap.put(accRec.Id, accRec.AccountTeamMembers);
                    }
                }
            }
            set<Id> EligibiltyBenefitCaseIds = new set<Id>();
            if(!accSubCasesAndItsChildCasesList.isEmpty())
            {
                for(Case subCaseRec: accSubCasesAndItsChildCasesList)
                {
                    accountIdAndSubmissionCaseMap.put(subCaseRec.AccountId, subCaseRec);
                    if(!subCaseRec.TeamMembers.isEmpty())
                    {
                        subCaseIdAndCaseTeamMembersMap.put(subCaseRec.Id, subCaseRec.TeamMembers);
                    }
                    Map<String,Case> childCaseRecordtypeNameAndCaseMap = new Map<String, Case>();
                    if(!subCaseRec.Cases1__r.isEmpty())
                    {
                        for(Case childCaseRec: subCaseRec.Cases1__r)
                        {
                            childCaseRecordtypeNameAndCaseMap.put(childCaseRec.RecordType.Name, childCaseRec);
                        }
                    }
                    //US 4263 - Getting Ids of Eligibility and Medical Benefit Coding Cases and fetching the required details
                    if(childCaseRecordtypeNameAndCaseMap.containsKey(GEMS_Constants.CaseRecdType_GEMSEligibilityCase))
                        EligibiltyBenefitCaseIds.add(childCaseRecordtypeNameAndCaseMap.get(GEMS_Constants.CaseRecdType_GEMSEligibilityCase).Id);
                    if(childCaseRecordtypeNameAndCaseMap.containsKey(GEMS_Constants.CaseRecdType_GEMSMedicalBenefitCodingCase))
                        EligibiltyBenefitCaseIds.add(childCaseRecordtypeNameAndCaseMap.get(GEMS_Constants.CaseRecdType_GEMSMedicalBenefitCodingCase).Id);
                       
                    accSubIdAndMapOfRecordTypeNamesAndChildCasesMap.put(subCaseRec.Id, childCaseRecordtypeNameAndCaseMap);
                }
            }
            Map<Id,Case> eligibilityBenefitCasesMap;
            if(!EligibiltyBenefitCaseIds.isEmpty())
                     eligibilityBenefitCasesMap = new Map<Id,Case>([SELECT Id, isClosed, ClosedDate, (SELECT Eligibility_Process_Case__c,Production_Ready_End_Date__c  FROM 
                                                                                  GEMS_Eligibility_AEP_File_Details__r where Production_Ready_End_Date__c != null ORDER BY Production_Ready_End_Date__c DESC LIMIT 1),
                                                                                 (select id,isClosed,GEMS_Coding_Complete_Date__c from cases where GEMS_Coding_Complete_Date__c!=null ORDER BY GEMS_Coding_Complete_Date__c DESC LIMIT 1)
                                                            FROM Case WHERE Id IN: EligibiltyBenefitCaseIds]);
            //US 4263 END                                                   
            // Need to add email logic
            if(!accSubCasesAndItsChildCasesList.isEmpty())
            {
                List<String> toAddresses = new List<String>();
                for(Case subCaseRec: accSubCasesAndItsChildCasesList)
                {
                    if(subCaseIdAndCaseTeamMembersMap.containsKey(subCaseRec.Id) && subCaseIdAndCaseTeamMembersMap.get(subCaseRec.Id) != null )
                    {
                         for(CaseTeamMember caseTeamMem: subCaseIdAndCaseTeamMembersMap.get(subCaseRec.Id))
                         {
                            toAddresses.add(caseTeamMem.Member.Email);
                         }
                    }
                    if(accountIdAndCaseTeamMembersMap.containsKey(subCaseRec.AccountId) && accountIdAndCaseTeamMembersMap.get(subCaseRec.AccountId) != null )
                    {
                        for(AccountTeamMember accTeamMem: accountIdAndCaseTeamMembersMap.get(subCaseRec.AccountId))
                        {
                            toAddresses.add(accTeamMem.User.Email);
                        }
                    }
                    // Build eMail here
                    if(!toAddresses.isEmpty())
                    {
                        System.debug('=====>toAddresses' +toAddresses);
                        Case getCaseRec;
                        if(accSubIdAndMapOfRecordTypeNamesAndChildCasesMap.get(subCaseRec.Id).containsKey(GEMS_Constants.CaseRecdType_GEMSGetCase))
                        {
                            getCaseRec = accSubIdAndMapOfRecordTypeNamesAndChildCasesMap.get(subCaseRec.Id).get(GEMS_Constants.CaseRecdType_GEMSGetCase);
                        }
                        
                        Case medUnderwriterCase;
                        if(accSubIdAndMapOfRecordTypeNamesAndChildCasesMap.get(subCaseRec.Id).containsKey(GEMS_Constants.CaseRecdType_GEMSMedicalUnderwritingCase))
                        {
                            medUnderwriterCase = accSubIdAndMapOfRecordTypeNamesAndChildCasesMap.get(subCaseRec.Id).get(GEMS_Constants.CaseRecdType_GEMSMedicalUnderwritingCase);
                        }
                        
                        Case eligibilityProcessCase;
                        if(accSubIdAndMapOfRecordTypeNamesAndChildCasesMap.get(subCaseRec.Id).containsKey(GEMS_Constants.CaseRecdType_GEMSEligibilityCase))
                        {
                            eligibilityProcessCase = eligibilityBenefitCasesMap.get(accSubIdAndMapOfRecordTypeNamesAndChildCasesMap.get(subCaseRec.Id).get(GEMS_Constants.CaseRecdType_GEMSEligibilityCase).Id);
                        }
                        
                        Case parentIdCardCase;
                        if(accSubIdAndMapOfRecordTypeNamesAndChildCasesMap.get(subCaseRec.Id).containsKey(GEMS_Constants.CaseRecdType_GEMSIdCardCase))
                        {
                            parentIdCardCase = accSubIdAndMapOfRecordTypeNamesAndChildCasesMap.get(subCaseRec.Id).get(GEMS_Constants.CaseRecdType_GEMSIdCardCase);
                        }
                        
                        Case medicalBenfCodingParentCase;
                        if(accSubIdAndMapOfRecordTypeNamesAndChildCasesMap.get(subCaseRec.Id).containsKey(GEMS_Constants.CaseRecdType_GEMSMedicalBenefitCodingCase))
                        {
                            medicalBenfCodingParentCase = eligibilityBenefitCasesMap.get(accSubIdAndMapOfRecordTypeNamesAndChildCasesMap.get(subCaseRec.Id).get(GEMS_Constants.CaseRecdType_GEMSMedicalBenefitCodingCase).Id);
                        }
                        
                        /*Case fsuCliamsCase; Commented as part of US4263
                        if(accSubIdAndMapOfRecordTypeNamesAndChildCasesMap.get(subCaseRec.Id).containsKey('GEMS FSUClaims'))
                        {
                            fsuCliamsCase = accSubIdAndMapOfRecordTypeNamesAndChildCasesMap.get(subCaseRec.Id).get('GEMS FSUClaims');
                        }*/
                        //US 4263 - Template modified as per the requirement
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setToAddresses(toAddresses);
                        mail.subject = subCaseRec.Account.Name+' , ' + subCaseRec.Account.External_ID__c +' Implementation Closure Notification';
                        //SFDC-7750                                                
                        String body = '<html>'+'Our implementation has come to a close with '+ getCaseRec.Account.Name +' '+getCaseRec.Account.External_ID__c+'<br/>'
                                                +'<br/>Here are the implementation details for reference:'+'<br/><br/>';
                                                if(medUnderwriterCase!=null )
                                                {                                                    
                                                    body = body +'Underwriting approved: ';
                                                    if(medUnderwriterCase.isClosed){
                                                       body = body + medUnderwriterCase.ClosedDate.format('M/d/yyyy') ;
                                                    }    
                                                }
                                                if(eligibilityProcessCase!=null)
                                                {
                                                    body = body +'<br/> Eligibility production file processed on: ';
                                                    if(!eligibilityProcessCase.GEMS_Eligibility_AEP_File_Details__r.isEmpty()){
                                                        body = body + eligibilityProcessCase.GEMS_Eligibility_AEP_File_Details__r[0].Production_Ready_End_Date__c.format('M/d/yyyy');
                                                    }
                                                }
                                                if(parentIdCardCase!=null)
                                                {                                                    
                                                    body = body +'<br/> ID cards mailed on: ';
                                                    if(parentIdCardCase.GEMS_ID_card_mailed_date__c!=null){
                                                       body = body + parentIdCardCase.GEMS_ID_card_mailed_date__c.format();
                                                    }                                                    
                                                       body = body +', with ';
                                                    if(parentIdCardCase.GEMS_Number_of_Cards_Mailed__c!=null){
                                                       body = body + parentIdCardCase.GEMS_Number_of_Cards_Mailed__c;
                                                    }
                                                    body = body +' ID cards issued';   
                                                }
                                                
                                                if(medicalBenfCodingParentCase!=null)
                                                {                                       
                                                    body = body +'<br/> Benefit coding completed on: ';
                                                    if(!medicalBenfCodingParentCase.cases.isEmpty()){
                                                        body = body +medicalBenfCodingParentCase.cases[0].GEMS_Coding_Complete_Date__c.format();
                                                    }
                                                        
                                                }
                                                if(medicalBenfCodingParentCase!=null)
                                                {                                                
                                                    body = body +'<br/> Benefit testing completed on: ';
                                                    if(medicalBenfCodingParentCase.isClosed){
                                                       body = body +medicalBenfCodingParentCase.ClosedDate.format('M/d/yyyy');
                                                    }   
                                                }
                                                body = body +'<br/>'+'GET case number: '+getCaseRec.CaseNumber;                                                
                                                body = body +'<br/><br/>Thank you for working together to make this implementation successful. I am transitioning the account to maintenance mode since we are in full production. I am marking the implementation "closed". Please remove me (and your support) from all correspondences for this group.<br/>'
                                                +'<br/>Thank you.';
                                                //SFDC-7750                       
                        //US 4263 END                        
                        mail.setHtmlBody(body);
                        singleEmailMessages.add(mail);
                        System.debug('=====>mail' +mail);
                    }
                }
            }
            if(!singleEmailMessages.isEmpty()) 
            {
                Messaging.sendEmail(singleEmailMessages);
            }
        }
        catch(Exception ex)
        {
            GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', 'GEMS_EmailNotification', 'sendEmailNotificationWhenGETCaseImplementationIsClosed','High'); 
        }
    }
     
    /******************************************************************** 
*    Method Name : sendSingleEmailNotificationWithTemplate
Action
*   @description :   This method to send notification to the specified person 
*                    in toaddress with email template(New method added for october release)
*   @parameters  :   List<Messaging.SingleEmailMessage> mailList,EmailTemplate template, Case caseObj
*   @return type :   List<Messaging.SingleEmailMessage>
***************************************************************/
    public static List<Messaging.SingleEmailMessage> createMassEmailNotificationWithTemplate(List<Messaging.SingleEmailMessage> mailList,String[] toAddresses,EmailTemplate template, Case caseObj, Contact contacttt, List<OrgWideEmailAddress> orgEmailIds ) {
        try {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddress = toAddresses;
            mail.setToAddresses(toAddress);
            
            mail.setTemplateId(template.Id);
            mail.setSaveAsActivity(false);
            mail.setwhatId(caseObj.Id);
            mail.setTargetObjectId(contacttt.id);
            if(orgEmailIds != null && !orgEmailIds.isEmpty()) {
                mail.setOrgWideEmailAddressId(orgEmailIds.get(0).Id);
            }
            mailList.add(mail);
            
        }catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_EmailNotification.createMassEmailNotificationWithTemplate(List<Messaging.SingleEmailMessage> mailList,EmailTemplate template, Case caseObj)','High');        
        }
        return mailList;
    }
    
    /******************************************************************** 
*    Method Name : onCaseOwnerChangeUpdateOwnerOnPharmacyScopeCode
Action
*   @description :   This method to Update the owner of Pharmacy Scope Code record when owner of Pharmacy Coding owner changes.
*   @parameters  :   List<Case> casesList,Map<Id,Case> oldCaseMap
***************************************************************/
    public static void onCaseOwnerChangeUpdateOwnerOnPharmacyScopeCode(List<Case> casesList,Map<Id,Case> oldCaseMap)
    {
        Id pharmacyCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        Set<Id> ownerChangedPharmacyCodingCaseIdsSet = new Set<Id>();
        set<string> statusSet = new set<string>();
        Map<Id,Case> pharmacyCodingCaseIdAndCasemap = new Map<Id,Case>();
        List<GEMS_Pharmacy_Scope_Code__c> pharmacyCodingRecordsList = new List<GEMS_Pharmacy_Scope_Code__c>();
        List<Case> childPharmacyCasesList = new List<Case>();
        List<GEMS_Case_Statuses__c> caseStatusList = GEMS_Case_Statuses__c.getall().values();
        if(caseStatusList.size()>0){
            for(GEMS_Case_Statuses__c cs:caseStatusList){
                statusSet.add(cs.name);
            }
        }
        try
        {
            if(!casesList.isEmpty())
            {
                for(Case pharmacyCodingCase: casesList)
                {
                    if(pharmacyCodingCase.RecordtypeId == pharmacyCodingRecordTypeId && pharmacyCodingCase.OwnerId != oldCaseMap.get(pharmacyCodingCase.Id).OwnerId)
                    {
                        ownerChangedPharmacyCodingCaseIdsSet.add(pharmacyCodingCase.Id);
                        pharmacyCodingCaseIdAndCasemap.put(pharmacyCodingCase.Id,pharmacyCodingCase);
                    }
                }
                if(!ownerChangedPharmacyCodingCaseIdsSet.isEmpty())
                {
                    childPharmacyCasesList = [SELECT Id, OwnerId, ParentId, Status FROM Case WHERE ParentID IN: ownerChangedPharmacyCodingCaseIdsSet AND Status NOT in:statusSet];
                    if(!childPharmacyCasesList.isEmpty())
                    {
                        for(Case childCaseRec: childPharmacyCasesList)
                        {
                            childCaseRec.OwnerId = pharmacyCodingCaseIdAndCasemap.get(childCaseRec.ParentId).OwnerId;
                        }
                        update childPharmacyCasesList;
                    }
                    pharmacyCodingRecordsList = [SELECT Id, OwnerId, Case__c FROM GEMS_Pharmacy_Scope_Code__c WHERE Case__c IN: ownerChangedPharmacyCodingCaseIdsSet AND Status__c != 'AS400 & BlueStar Update Completed'];
                    if(!pharmacyCodingRecordsList.isEmpty())
                    {
                        for(GEMS_Pharmacy_Scope_Code__c pharmacyScopeCodeRec: pharmacyCodingRecordsList)
                        {
                            pharmacyScopeCodeRec.OwnerId = pharmacyCodingCaseIdAndCasemap.get(pharmacyScopeCodeRec.Case__c).OwnerId;
                        }
                        update pharmacyCodingRecordsList;
                    }
                }
            }
        }
        catch(Exception ex)
        {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'onCaseOwnerChangeUpdateOwnerOnPharmacyScopeCode(List<Case> casesList,Map<Id,Case> oldCaseMap)','High');        
        }
    }
    
    
    /******************************************************************** 
*   Method Name  :   assignEntitlementToDBCOnceMedUnderwriterCaseApproved
Action
*   @description :   Assigns Entitlement to DBC Case once the corresponding Underwriter case is approved.
*   @parameters  :   List<Case> casesList,Map<Id,Case> oldCaseMap
***************************************************************/
    public static void assignEntitlementToDBCOnceMedUnderwriterCaseApproved(List<Case> casesList,Map<Id,Case> oldCaseMap)
    {
        Id medicalUnderWriterRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
        Id dentalBenefitCodingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
        List<Case> approvedMedUWCasesList = new List<Case>();
        Set<Id> medUWApprovedCasesSubIdsSet = new Set<Id>();
        List<Case> DBCCasesList = new List<Case>();
        List<Case> dbcCasesUpdateList = new List<Case>();
        try
        {
            for(Case newCase: casesList)
            {
                if(newCase.RecordTypeId == medicalUnderWriterRecordTypeId && newCase.Status == 'Approved' && newCase.Status != oldCaseMap.get(newCase.Id).Status)
                {
                    approvedMedUWCasesList.add(newCase);
                    medUWApprovedCasesSubIdsSet.add(newCase.GEMS_Account_Submission_Info__c);
                }
            }
            if(!medUWApprovedCasesSubIdsSet.isEmpty())
            {
                DBCCasesList = [SELECT ID, EntitlementId,Status FROM Case WHERE GEMS_Account_Submission_Info__c IN: medUWApprovedCasesSubIdsSet AND RecordTypeId =: dentalBenefitCodingRecordTypeId];
            }
            Set<Id> DBCCasesIdSet = new Set<Id>();
            if(!DBCCasesList.isEmpty())
            {
                List<Entitlement> activeEntitlement = [select id, Name from Entitlement where status='Active' AND Name=:System.Label.GEMSProcessEntitlementName];
                for(Case dbcCase: DBCCasesList)
                {
                    dbcCase.EntitlementId = activeEntitlement[0].Id;
                    dbcCase.Status = 'In Progress';
                    DBCCasesIdSet.add(dbcCase.Id);
                    dbcCasesUpdateList.add(dbcCase);
                }
            }
            if(!DBCCasesIdSet.isEmpty())
            {
                List<CaseMilestone> caseMileStoneRecordsToModifyStartDate = [SELECT Id, CaseId, StartDate, TargetDate FROM CaseMilestone WHERE CaseId IN: DBCCasesIdSet];
                if(!caseMileStoneRecordsToModifyStartDate.isEmpty())
                {
                    for(CaseMilestone cmRec: caseMileStoneRecordsToModifyStartDate)
                    {
                        cmRec.StartDate = System.now();
                    }
                    update caseMileStoneRecordsToModifyStartDate;
                }
            }
            if(!dbcCasesUpdateList.isEmpty())
            {
                update dbcCasesUpdateList;
            }
        }
        catch(Exception ex)
        {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'assignEntitlementToDBCOnceMedUnderwriterCaseApproved(List<Case> casesList,Map<Id,Case> oldCaseMap)','High');        
        }
    }
    
    /******************************************************************** 
*   Method Name  :   updateIdCardFormatFieldOnIdCardParentCase
Action
*   @description :   Updates ID Card Format on Parent ID Card Case, once ID Card Format is updated on Account Submission Case.
*   @parameters  :   List<Case> newCaseList, Map<Id,Case> oldCaseMap
***************************************************************/
    public static void updateIdCardFormatFieldOnIdCardParentCase(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
        try {
            Id caseGEMSAccountSubmissionRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Submission').getRecordTypeId();
            Id caseGEMSAccountMaintenanceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Maintenance').getRecordTypeId();
            Id customIdCardParentRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
            set<Id> submissionIds = new set<Id>();
            Map<Id,Case> subCaseIdSubCaseRecMap = new Map<Id,Case>();
            for(Case submissioncase : newCaseList) {
                //SFDC-6369 GEMS - ID Card Maintenance: ID Card Case Page Layout & Functionality
                if((submissioncase.recordTypeId == caseGEMSAccountSubmissionRecordTypeId || submissioncase.recordTypeId == caseGEMSAccountMaintenanceRecordTypeId) && submissioncase.GEMS_ID_Cards_Format__c != oldCaseMap.get(submissioncase.Id).GEMS_ID_Cards_Format__c) {
                    submissionIds.add(submissioncase.id);
                    subCaseIdSubCaseRecMap.put(submissioncase.Id,submissioncase);
                }
            }
            if(!submissionIds.isEmpty()) {
                List<Case> idCardcaseList =[select id,casenumber,recordtypeId, status, parentId,GEMS_Effective_Date__c,Accountid,GEMS_Account_Submission_Info__c,Account.name,Account.External_ID__c,GEMS_ID_Cards_Format__c From Case WHERE GEMS_Account_Submission_Info__c IN :submissionIds and recordTypeId =: customIdCardParentRecordTypeId];
                for(Case idCardRec :idCardcaseList) {
                    idCardRec.GEMS_ID_Cards_Format__c = subCaseIdSubCaseRecMap.get(idCardRec.GEMS_Account_Submission_Info__c).GEMS_ID_Cards_Format__c;
                }
                update idCardcaseList;
            }        
        }
        catch(Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'updateIdCardFormatFieldOnIdCardParentCase(List<Case> casesList,Map<Id,Case> oldCaseMap)','High');        
        }
    } 
/******************************************************************** 
    *    Method Name : sendSubmissionCancelledNotifcationToOwners
    *   @description :   This method to send email notification to all owners when submission/maintenance case is cancelled
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    *   @description : SFDC-6381 GEMS: Upon cancellation of Case, notifications are sent to Case Owners and Case Team
***************************************************************/
    public static void sendSubmissionCancelledNotifcationToOwners(List<Case> casesList,Map<Id,Case> oldCaseMap) {
        Set<ID> submissionCases = new Set<ID>();
        Map<ID,Case> idCaseMap = new Map<ID,Case>();
        Map<ID,Set<String>> caseEmailMap = new Map<ID,Set<String>>();
        Map<ID,Set<String>> sbcBBEmailMap = new Map<ID,Set<String>>();
        
        //get submission cases that are cancelled
        for(case newCase : casesList) {
            
            if(newCase.Status == GEMS_Constants.StatusCancelled && newCase.Status != oldCaseMap.get(newCase.id).Status && 
               (newCase.Type == GEMS_Constants.TypeAccountSubmission ||  newCase.Type == GEMS_Constants.TypeAccountMaintenance)) {
                submissionCases.add(newCase.id);        
                idCaseMap.put(newCase.id,newCase);
            }
        }
        //if found, retrieve case owners and case team members
        List<CaseTeamMember> caseTeamMemberList = new List<CaseTeamMember>();
        List<Case> caseList = new List<Case>();
        List<GEMS_SBC_BB_Form__c> formsList = new List<GEMS_SBC_BB_Form__c>();
        if(!submissionCases.isEmpty()) {
            caseTeamMemberList = new List<CaseTeamMember>([SELECT parentId,member.email FROM CaseTeamMember where parentId in :submissionCases]);
            caseList = new List<Case>([SELECT GEMS_Account_Submission_Info__c, owner.email from Case WHERE GEMS_Account_Submission_Info__c in :submissionCases and GEMS_Benefit_Agreement__c ='' and owner.type = 'User']);
            formsList = new List<GEMS_SBC_BB_Form__c>([SELECT GEMS_SBC_Request__r.Case__r.Id,GEMS_Benefit_Booklet_Request__r.Case__r.Id,owner.email from GEMS_SBC_BB_Form__c where owner.type = 'User' and  
                                                       (GEMS_SBC_Request__r.Case__r.Id in :submissionCases or GEMS_Benefit_Booklet_Request__r.Case__r.Id in :submissionCases)]);
        
            Set<String> emailSet = new Set<String>();
            if(caseTeamMemberList.size() > 0) {
                for(CaseTeamMember ctm : CaseTeamMemberList) {
                    if(ctm.member.email != null) {
                        emailSet = caseEmailMap.get(ctm.ParentId) == null?new Set<String>():caseEmailMap.get(ctm.ParentId);
                        emailSet.add(ctm.member.email);
                        caseEmailMap.put(ctm.parentId,emailSet);
                    }
                }
            }
            if(caseList.size() > 0) {
                for(Case caseowner : caseList) {
                    if(caseowner.owner.email != null) {
                        emailSet = caseEmailMap.get(caseowner.GEMS_Account_Submission_Info__c) == null?new Set<String>():caseEmailMap.get(caseowner.GEMS_Account_Submission_Info__c);
                        emailSet.add(caseowner.owner.email);
                        caseEmailMap.put(caseowner.GEMS_Account_Submission_Info__c,emailSet);
                    }
                }
            }
            
            Set<String> sbcEmailSet = new Set<String>();
            if(formsList.size() > 0) {
                for(GEMS_SBC_BB_Form__c sbcBB: formsList) {
                    if(sbcBB.owner.email != null) {
                        String subCaseId = sbcBB.GEMS_SBC_Request__r.Case__r.Id != null? sbcBB.GEMS_SBC_Request__r.Case__r.Id:sbcBB.GEMS_Benefit_Booklet_Request__r.Case__r.Id;
                        sbcEmailSet = sbcBBEmailMap.get(subCaseId) == null?new Set<String>():sbcBBEmailMap.get(subCaseId);
                        sbcEmailSet.add(sbcBB.owner.email);
                        sbcBBEmailMap.put(subCaseId,sbcEmailSet);
                    }
                }
            }
            
           //System.debug('MassEmailing....'+caseEmailMap);
            List<EmailTemplate> emailTemplates = [SELECT Id FROM EmailTemplate where DeveloperName in ('GEMS_Main_Cancellation_Email_Template','GEMS_SBC_Cancellation_Email_Template') order by DeveloperName asc];
            Contact contact = [select id,name,email from contact where email = 'no-reply@hcsc.com'];
            List<OrgWideEmailAddress> orgEmailAddress =  [select id, Address,displayname from OrgWideEmailAddress where displayname='No Reply GEMS'];
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            for(Id subId :submissionCases){
                if(caseEmailMap.values()!= NULL && caseEmailMap.get(subId) != NULL){//Check map has value
                    mailList.addAll(GEMS_EmailNotification.createMassEmailNotificationWithTemplate(new List<Messaging.SingleEmailMessage>(),new List<String>(caseEmailMap.get(subId)),emailTemplates[0],idCaseMap.get(subId),contact,orgEmailAddress)); 
                 } 
                 if(sbcBBEmailMap.values()!= NULL && sbcBBEmailMap.get(subId) != NULL){//Check map has value
                    mailList.addAll(GEMS_EmailNotification.createMassEmailNotificationWithTemplate(new List<Messaging.SingleEmailMessage>(),new List<String>(sbcBBEmailMap.get(subId)),emailTemplates[1],idCaseMap.get(subId),contact,orgEmailAddress));
                 }
            }
            if(!mailList.isEmpty()){
                Messaging.sendEmail(mailList);//send email method called once.
            }
        }
    }      
/******************************************************************** 
*   Method Name  :   processEmailsinFuture
    Action
*   @description :   SFDC-9232 GEMS: Tech Debt - Update Case Trigger Handler - to avoid SOQL Limit/Error
*   @parameters  :   List<Case> newCaseList, Map<Id,Case> oldCaseMap
***************************************************************/    
    public static void processEmailNotification(List<Case> newCaseList, Map<Id,Case> oldCaseMap){    
        
        string newCases = JSON.serializePretty(newCaseList);        
        string oldCases = JSON.serializePretty(oldCaseMap.values()); 
          
        if(Trigger.isAfter && Trigger.isUpdate){     
           GEMS_EmailNotification.AfterUpdateProcessEmailFuture(newCases,oldCases);
        } 
           
    }
    
    @future
    public static void AfterUpdateProcessEmailFuture(string newCases,string OldCases){    
       
       List<Case> newCaseList = (List<Case>)JSON.deserialize(newCases,List<Case>.class);
       List<Case> oldCaseList = (List<Case>)JSON.deserialize(OldCases,List<Case>.class);
       
       Map<Id,Case> oldCaseMap = new Map<Id,Case>();
       
       for(Case cse:oldCaseList){
           oldCaseMap.put(cse.Id,cse);
       }
       //SFDC-6381 GEMS: Upon cancellation of Case, notifications are sent to Case Owners and Case Team
       GEMS_EmailNotification.sendEmailNotificationWhenGETCaseImplementationIsClosed(newCaseList,oldCaseMap); 
       GEMS_UnderwriterNotification.checkMedicalAdditionalDentalApproval(newCaseList,oldCaseMap);          
       GEMS_EmailNotification.sendSubmissionCancelledNotifcationToOwners(newCaseList,oldCaseMap);    
    }  
}