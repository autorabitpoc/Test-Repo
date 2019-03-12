/**************************************************************************************
  Apex Class Name     : GEMS_UnderwriterNotification
  Version             : 1.0
  Function            : Sends email when all the Underwriting cases are Completed(For GEMS Project).
  Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Offshore            06/20/2016             Original Version
* Gokul Bharati       05/17/2018             SFDC-9232 GEMS - clean up commented out methods 
*************************************************************************************/

public  class GEMS_UnderwriterNotification
{
     /******************************************************************** 
    *   Method Name  :   benefitAdhocMeetingMinutesCheckForGetCase
    Action
    *   @description :   This method to send notificaiton to the non prime vendor
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/  
    public static void checkMedicalAdditionalDentalApproval(List<Case> newCaseList,Map<Id,Case> caseOldMap) 
    {        
        Id medicalUnderWrtrRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
        Id dentalUnderWrtrRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
        Id additionalUnderWrtrRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();    
        Set<ID> underwriterRecordIdsSet = new Set<ID>{medicalUnderWrtrRecordTypeId,dentalUnderWrtrRecordTypeId,additionalUnderWrtrRecordTypeId};
        
        List<Case> approvedmedDentlAddCasesList = new List<Case>();
        Set<ID> subCaseIds = new Set<Id>();
        GEMS_Email_Notification__mdt metaData = null;
        List<GEMS_Email_Notification__mdt> nonPrimeVendorMetaDataList = [select  Business_Area__c, Flag__c,Email__c from GEMS_Email_Notification__mdt where  Business_Area__c = 'CDHP Group Non PrimeVendor'];
        if(nonPrimeVendorMetaDataList != null && !nonPrimeVendorMetaDataList.isEmpty()) {
            metaData = nonPrimeVendorMetaDataList[0];
        }
        if(metaData != null && metaData.Flag__c ) {
        for(Case caseRec: newCaseList) {
          if(caseRec.isClosed && caseRec.Status!=caseOldMap.get(caseRec.Id).Status && 
              underwriterRecordIdsSet.contains(caseRec.RecordTypeId)) {
             approvedmedDentlAddCasesList.add(caseRec);
             subCaseIds.add(caseRec.GEMS_Account_Submission_Info__c);
          }
        }
        
        List<Case> subCaseMedDentlAddChildList = new List<Case>();
        subCaseMedDentlAddChildList = [SELECT Id, status,isClosed, caseNumber,GEMS_Products__c,GEMS_Rx_Vendor__c,Subject,
                                        (SELECT Id,isClosed, Status, caseNumber, Subject, GEMS_Account_Submission_Info__c, RecordTypeId, Owner.email from Cases1__r WHERE RecordTypeId IN: underwriterRecordIdsSet ),
                                        (select id, Shared_Accum_ID__c from GEMS_Shared_Accums__r )
                                        FROM Case WHERE Id IN: subCaseIds];
        System.debug('subCaseMedDentlAddChildList====>'+subCaseMedDentlAddChildList);                                        
        List<Case> medDentlAddApprovedSubCaseList = new List<Case>();
        Set<ID> allAprovedSubCaseId = new Set<ID>();
        Boolean allCompleted = null;
        Boolean allApproved = null;
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        If(!subCaseMedDentlAddChildList.isEmpty()) {
        
            for(Case subCaseRec: subCaseMedDentlAddChildList) {
                System.debug('subCaseRec.Cases1__r=====>'+subCaseRec.Cases1__r);
                if(subCaseRec.Cases1__r!=null && !subCaseRec.Cases1__r.isEmpty()) {
                    allCompleted = true;
                  
                    for(Case childCaseRec: subCaseRec.Cases1__r) {
                        if(!childCaseRec.isClosed) {
                            allCompleted = false;
                            break;
                        }
                    }
                    System.debug('subCaseRec.GEMS_Shared_Accums__r=====>'+subCaseRec.GEMS_Shared_Accums__r);
                    System.debug('==Completed=====>'+allCompleted+subCaseRec.GEMS_Rx_Vendor__c);
                    if((allCompleted) && 
                    ((subCaseRec.GEMS_Products__c != null && subCaseRec.GEMS_Products__c.contains('RX') && subCaseRec.GEMS_Products__c.contains('Shared Accums')
                     && subCaseRec.GEMS_Rx_Vendor__c!= null && subCaseRec.GEMS_Rx_Vendor__c.contains('Prime') && subCaseRec.GEMS_Rx_Vendor__c != 'Prime' ))) {
                        String[] toAddresses =metaData.Email__c.split(';');// new String[]{metaData.Email__c};
                        String subject = subCaseRec.subject.replace('Account Submission','Case#'+subCaseRec.casenumber + ' ' +'Underwriting review is complete');
                        //subject = subject.replace('Account Submission',subCaseRec.casenumber + ' ' +'Underwriting review is complete');
                        mailList  = GEMS_EmailNotification.createMassEmailMessage(mailList,toAddresses,subject,' Underwriting Review activity has been completed for Case '+subCaseRec.caseNumber+'.This account is Sharing Accums and a non PRIME vendor was selected in submission process.' ,subCaseRec);
                    }
                }
                     
            }
            if(!mailList.isEmpty() ) {
                Messaging.sendEmail(mailList);
            }
        }
      }
    }
    
    
     /******************************************************************** 
    *    Method Name : sendCaseToAccountSpecialist
    Action
    *   @description :   This method to csend Notification to the account specialist 
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/  
        public static void sendCaseToAccountSpecialist(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
    Id medUnderwritingCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
    Id dentalunderCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
    Id additionalUnderWritCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();
    Set<Id> recordTypeIdsSet = new Set<Id>{medUnderwritingCasesRecordTypeId,dentalunderCasesRecordTypeId,additionalUnderWritCasesRecordTypeId};
    try {
        List<Case> submitterReturningCases = new List<Case>();
        Set<Id> caseSubmissionIds = new Set<Id>();
        Map<Id,CaseTeamMember> caseTeamMemberMap = new Map<Id,CaseTeamMember>();
        Map<Id,Case> subCaseMap = new Map<Id,Case>();
        List<Messaging.SingleEmailMessage> messageList = new List<Messaging.SingleEmailMessage>();
        for(Case caseRec: newCaseList) {
            if( caseRec.GEMS_UW_Acct_Sub_Spec_flag__c && caseRec.Status=='In Progress' && recordTypeIdsSet.contains(caseRec.recordTypeId) 
                && caseRec.Status != oldCaseMap.get(caseRec.Id).status  ) {
                submitterReturningCases.add(caseRec);
                caseSubmissionIds.add(caseRec.GEMS_Account_Submission_Info__c);
            } 
        }
        if(!caseSubmissionIds.isEmpty()) {
            List<Case> submissionAndCaseTeamList = [select id, Status, recordtypeid,Account.Name,Account_Number__c,GEMS_Effective_Date__c, (select parentId,memberid,TeamRole.name,member.email from TeamMembers
                                                        where TeamRole.name ='Account Specialist') from case where id = :caseSubmissionIds ];
            for(Case submissionCase : submissionAndCaseTeamList) {
                if(submissionCase.TeamMembers != null && !submissionCase.TeamMembers.isEmpty()) {
                    caseTeamMemberMap.put(submissionCase.Id,submissionCase.TeamMembers[0] );
                }
                subCaseMap.put(submissionCase.Id,submissionCase);
               
            }
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            for(Case underwriterCase : submitterReturningCases) {
                if(caseTeamMemberMap.get(underwriterCase.GEMS_Account_Submission_Info__c) != null ) {
                    underwriterCase.ownerId = caseTeamMemberMap.get(underwriterCase.GEMS_Account_Submission_Info__c).memberid;
                    underwriterCase.status = 'Return';
                    underwriterCase.GEMS_UW_Acct_Sub_Spec_flag__c = false;
                    String emailBody = 'Underwriting has returned the case due to ASO Billing / BlueSTAR issue </br></br><b>Account Name :</b>' + subCaseMap.get(underwriterCase.GEMS_Account_Submission_Info__c).Account.Name +'</br> <b>Case Number &nbsp : </b>'+ underwriterCase.caseNumber +'</br><b>Case Details&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp: </b><a href="'+baseUrl+'/'+underwriterCase.Id +'" target="_blank">View Case Details</a></br></br></br><b>Thanks</b>';                   
                    String[] toAddresses = new String[] {caseTeamMemberMap.get(underwriterCase.GEMS_Account_Submission_Info__c).member.email};
                    messageList = GEMS_EmailNotification.createMassEmailMessage(messageList,toAddresses,underwriterCase.subject, emailBody ,underwriterCase);                        
                                        
                }
            }
            if(!messageList.isEmpty()) {
                Messaging.sendEmail(messageList);
            }
        }
    }catch(Exception ex) {
        CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.sendCaseToAccountSpecialist(List<Case> newCaseList, Map<Id,Case> oldCaseMap)','High');              
    }
 }
 
  /******************************************************************** 
    *    Method Name : sendCaseToAccountSpecialist
    Action
    *   @description :   This method to csend Notification to the Case owner
    *   @parameters  :   List<Case> newCasesList,Map<Id,Case> oldCaseMap
    *   @return type :   void
    ***************************************************************/ 
 public Static Integer staticExecute = 0;
 public static void sendNotificationToCaseOwner(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {
    Id medUnderwritingCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
    Id dentalunderCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
    Id additionalUnderWritCasesRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();
    Set<Id> recordTypeIdsSet = new Set<Id>{medUnderwritingCasesRecordTypeId,dentalunderCasesRecordTypeId,additionalUnderWritCasesRecordTypeId};
    try {
        Set<Case> submitterReturningCases = new Set<Case>();
        Set<Id> caseSubmissionIds = new Set<Id>();
        Map<Id,CaseTeamMember> caseTeamMemberMap = new Map<Id,CaseTeamMember>();
        List<Messaging.SingleEmailMessage> messageList = new List<Messaging.SingleEmailMessage>();
        Set<String> returnedUserIds = new Set<String>();
        Map<Id,Case> subIdAndCaseMap = new Map<Id,Case>();
        for(Case caseRec: newCaseList) {
            if(staticExecute == 0 && !caseRec.GEMS_UW_Acct_Sub_Spec_flag__c && caseRec.Status=='In Progress' && recordTypeIdsSet.contains(caseRec.recordTypeId) 
                && caseRec.Status != oldCaseMap.get(caseRec.Id).status  && caseRec.GEMS_Returned_user_id__c != null ) {
                submitterReturningCases.add(caseRec);
                caseSubmissionIds.add(caseRec.GEMS_Account_Submission_Info__c);
                returnedUserIds.add(caseRec.GEMS_Returned_user_id__c);
            } 
        }
        
        if(!caseSubmissionIds.isEmpty())
        {
           List<Case> submissionCase =[SELECT ID,Status,Account.Name FROM Case WHERE Id IN: caseSubmissionIds];
           for(Case subCaseRec :submissionCase)
           {
               subIdAndCaseMap.put(subCaseRec.id,subCaseRec);
           }
        }
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        if(!submitterReturningCases.isEmpty()) {
            Map<Id,User> userMap = new Map<Id,User>([select id, email from user where Id in : returnedUserIds]);
            for(Case caseUnder : submitterReturningCases) {
                if(userMap.get(caseUnder.GEMS_Returned_user_id__c) != null && caseUnder.GEMS_Return_Reason__c == 'ASO Billing/BlueSTAR Issue (case sent to Accnt. Specialist)') {
                    String[] toAddresses = new String[] {userMap.get(caseUnder.GEMS_Returned_user_id__c).email};
                    String emailBody = 'Account Setup has completed reviewing the case  </br></br><b>Account Name :</b>' + subIdAndCaseMap.get(caseUnder.GEMS_Account_Submission_Info__c).Account.Name +'</br> <b>Case Number &nbsp : </b>'+ caseUnder.caseNumber +'</br><b>Case Details&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp: </b><a href="'+baseUrl+'/'+caseUnder.id +'" target="_blank">View Case Details</a></br></br></br>Thanks';                   
                    messageList = GEMS_EmailNotification.createMassEmailMessage(messageList,toAddresses,caseUnder.subject,emailBody,caseUnder);                        
                }else if(userMap.get(caseUnder.GEMS_Returned_user_id__c) != null && caseUnder .GEMS_Return_Reason__c.contains('ASO Billing/BlueSTAR Issue (case sent to Accnt. Specialist)')) {
                    String[] toAddresses = new String[] {userMap.get(caseUnder.GEMS_Returned_user_id__c).email};
                    String emailBody1 = 'The Submitter and Account Specialist have completed reviewing the case  </br></br><b>Account Name :</b>' + subIdAndCaseMap.get(caseUnder.GEMS_Account_Submission_Info__c).Account.Name +'</br> <b>Case Number &nbsp : </b>'+ caseUnder.caseNumber +'</br><b>Case Details&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp: </b><a href="'+baseUrl+'/'+caseUnder.id +'" target="_blank">View Case Details</a></br></br></br>Thanks';                   
                    messageList = GEMS_EmailNotification.createMassEmailMessage(messageList,toAddresses,caseUnder.subject,emailBody1,caseUnder);                        
                }else if(userMap.get(caseUnder.GEMS_Returned_user_id__c) != null && !caseUnder.GEMS_Return_Reason__c.contains('ASO Billing/BlueSTAR Issue (case sent to Accnt. Specialist)')) {
                    String[] toAddresses = new String[] {userMap.get(caseUnder.GEMS_Returned_user_id__c).email};
                    String emailBody2 = 'The Submitter has completed reviewing the case </br></br><b>Account Name :</b>' + subIdAndCaseMap.get(caseUnder.GEMS_Account_Submission_Info__c).Account.Name +'</br> <b>Case Number &nbsp : </b>'+ caseUnder.caseNumber +'</br><b>Case Details&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp: </b><a href="'+baseUrl+'/'+caseUnder.id +'" target="_blank">View Case Details</a></br></br></br>Thanks';                   
                    messageList = GEMS_EmailNotification.createMassEmailMessage(messageList,toAddresses,caseUnder.subject,emailBody2,caseUnder);                        
                }
                
            }
            if(!messageList.isEmpty()) {
                Messaging.sendEmail(messageList);
            }
             staticExecute = 1;
        }
               
    }catch(Exception ex) {
        CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_CaseTriggerHandler.sendCaseToAccountSpecialist(List<Case> newCaseList, Map<Id,Case> oldCaseMap)','High');              
    }
 }
}