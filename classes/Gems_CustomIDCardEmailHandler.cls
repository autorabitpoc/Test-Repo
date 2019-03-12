/**************************************************************************************
  Apex Class Name     : Gems_CustomIDCardEmailHandler
  Version             : 1.0
  Function            : This is a handler class for GEMS_CustomIDCardTrigger(For GEMS Project).
  Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Praveen             6/27/2016              Original Version
*************************************************************************************/
public class Gems_CustomIDCardEmailHandler
{
    public static void onIdCardSubmitSendNotificationToAccSubmitterCICAccMngmntUsers(List<GEMS_Custom_ID_Request_Form__c> customIdCardFormsNewList,Map<Id,GEMS_Custom_ID_Request_Form__c> customIdCardFormsOldMap)
    {
        Set<ID> customIDCardFormIdsSet = new Set<ID>();
        Set<ID> subCaseIdsSet = new Set<ID>();
        Map<ID,GEMS_Custom_ID_Request_Form__c> accSubCaseIdAndCustomIdFormMap = new Map<ID,GEMS_Custom_ID_Request_Form__c>();
        List<Case> accSubCaseChildCasesAndCaseTeamList = new List<Case>();
        Map<ID, List<String>> accSubCaseIdAndAccSpeclistCicAccSupUserEmailIdMap = new Map<ID, List<String>>();
        List<Messaging.SingleEmailMessage>  submittedReSubmittedIDCardEmailsList = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress[] owea;
        try
        {
            owea = [select Id from OrgWideEmailAddress where Address = 'no-reply@hcsc.com'];
            for(GEMS_Custom_ID_Request_Form__c custIdFormRec: customIdCardFormsNewList)
            {
                if((custIdFormRec.Status__c == 'Submitted' &&  custIdFormRec.Status__c != customIdCardFormsOldMap.get(custIdFormRec.id).Status__c) || custIdFormRec.Status__c=='Re-Submitted')
                {
                    customIDCardFormIdsSet.add(custIdFormRec.Id);
                }
            }
            List<GEMS_Custom_ID_Request_Form__c> submittedOrResubmittedCustomIdFormsList = new List<GEMS_Custom_ID_Request_Form__c>();
            if(customIDCardFormIdsSet!=null && !customIDCardFormIdsSet.isEmpty())
            {
                submittedOrResubmittedCustomIdFormsList = [SELECT ID, Name, Status__c, Custom_ID_Request_Form_Case__r.GEMS_Account_Submission_Info__c, 
                                                            Custom_ID_Request_Form_Case__r.GEMS_Account_Submission_Info__r.OwnerId, 
                                                            Custom_ID_Request_Form_Case__r.CaseNumber, Parent_ID_Card_Case_Number__c 
                                                            FROM GEMS_Custom_ID_Request_Form__c WHERE ID IN: customIDCardFormIdsSet];
            }
            if(!submittedOrResubmittedCustomIdFormsList.isEmpty() && submittedOrResubmittedCustomIdFormsList!=null)
            {
                for(GEMS_Custom_ID_Request_Form__c subCustIdFormCardRec: submittedOrResubmittedCustomIdFormsList)
                {
                    accSubCaseIdAndCustomIdFormMap.put(subCustIdFormCardRec.Custom_ID_Request_Form_Case__r.GEMS_Account_Submission_Info__c, subCustIdFormCardRec);
                    subCaseIdsSet.add(subCustIdFormCardRec.Custom_ID_Request_Form_Case__r.GEMS_Account_Submission_Info__c);
                }
            }
            if(!subCaseIdsSet.isEmpty() || subCaseIdsSet!=null)
            {
                Id getCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS GET').getRecordTypeId();
                accSubCaseChildCasesAndCaseTeamList = [SELECT ID, CaseNumber, Subject, Account.Name, Account.External_ID__c,GEMS_Effective_Date__c, GEMS_Case_Effective_Date__c,
                                        (SELECT Id,RecordTypeId,status, GEMS_Account_Submission_Info__c, Owner.Email from Cases1__r WHERE RecordTypeId=:getCaseRecordTypeId LIMIT 1),
                                        (SELECT parentId,memberid, member.Email,TeamRole.name from TeamMembers)
                                        FROM Case WHERE ID IN: subCaseIdsSet];
            }
            if(!accSubCaseChildCasesAndCaseTeamList.isEmpty() && accSubCaseChildCasesAndCaseTeamList!=null)
            {
                for(Case accSubCaseRec: accSubCaseChildCasesAndCaseTeamList)
                {
                    if(!accSubCaseRec.TeamMembers.isEmpty() && accSubCaseRec.TeamMembers!=null)
                    {
                        for(caseTeamMember casesTeamMem: accSubCaseRec.TeamMembers)
                        {
                            if(casesTeamMem.TeamRole.name=='Account Specialist')
                            {
                                if(accSubCaseIdAndAccSpeclistCicAccSupUserEmailIdMap.containsKey(accSubCaseRec.Id))
                                {
                                    accSubCaseIdAndAccSpeclistCicAccSupUserEmailIdMap.get(accSubCaseRec.Id).add(casesTeamMem.Member.Email);
                                }
                                else
                                {
                                    List<String> caseTeamMemberAccSpecListEmailId = new List<String>();
                                    caseTeamMemberAccSpecListEmailId.add(casesTeamMem.Member.Email);
                                    accSubCaseIdAndAccSpeclistCicAccSupUserEmailIdMap.put(accSubCaseRec.Id,caseTeamMemberAccSpecListEmailId);
                                }
                            }
                            if(accSubCaseRec.Cases1__r != null && !accSubCaseRec.Cases1__r.isEmpty())
                            {
                                if(casesTeamMem.TeamRole.name=='Client Implementation Consultant')
                                {
                                    if(accSubCaseIdAndAccSpeclistCicAccSupUserEmailIdMap.containsKey(accSubCaseRec.Id))
                                    {
                                        accSubCaseIdAndAccSpeclistCicAccSupUserEmailIdMap.get(accSubCaseRec.Id).add(casesTeamMem.Member.Email);
                                    }
                                    else
                                    {
                                        List<String> caseTeamMemberCicEmailId = new List<String>();
                                        caseTeamMemberCicEmailId.add(casesTeamMem.Member.Email);
                                        accSubCaseIdAndAccSpeclistCicAccSupUserEmailIdMap.put(accSubCaseRec.Id, caseTeamMemberCicEmailId);
                                    }
                                }
                            }
                            else if(accSubCaseRec.Cases1__r.isEmpty())
                            {
                                if(casesTeamMem.TeamRole.name=='Account Management Support')
                                {
                                    if(accSubCaseIdAndAccSpeclistCicAccSupUserEmailIdMap.containsKey(accSubCaseRec.Id))
                                    {
                                        accSubCaseIdAndAccSpeclistCicAccSupUserEmailIdMap.get(accSubCaseRec.Id).add(casesTeamMem.Member.Email);
                                    }
                                    else
                                    {
                                        List<String> caseTeamMemberAccMgmtUserEmailId = new List<String>();
                                        caseTeamMemberAccMgmtUserEmailId.add(casesTeamMem.Member.Email);
                                        accSubCaseIdAndAccSpeclistCicAccSupUserEmailIdMap.put(accSubCaseRec.Id, caseTeamMemberAccMgmtUserEmailId);
                                    }
                                }
                            }
                        }
                    }
                    
                    //Build Mesaging Here
                    GEMS_Custom_ID_Request_Form__c customIdCardFormRec = new GEMS_Custom_ID_Request_Form__c();
                    if(accSubCaseIdAndCustomIdFormMap.containsKey(accSubCaseRec.Id))
                    {
                        customIdCardFormRec = accSubCaseIdAndCustomIdFormMap.get(accSubCaseRec.Id);
                    
                        Messaging.SingleEmailMessage idCardMessageToAccountSpecialistCicAccMgntUser = new Messaging.SingleEmailMessage();
                        if ( owea.size() > 0 )
                        {
                            idCardMessageToAccountSpecialistCicAccMgntUser.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        List<String> idCardToAccountSpecialistCicAccMgntUser = accSubCaseIdAndAccSpeclistCicAccSupUserEmailIdMap.get(accSubCaseRec.Id);
                        idCardMessageToAccountSpecialistCicAccMgntUser.setToAddresses(idCardToAccountSpecialistCicAccMgntUser);
                        String EmailBody;
                        DateTime effectiveDate = accSubCaseRec.GEMS_Effective_Date__c;  
                        if(customIdCardFormRec.Status__c=='Submitted' && customIdCardFormRec.Status__c!='' && customIdCardFormRec.Status__c!=null)
                        {
                            idCardMessageToAccountSpecialistCicAccMgntUser.subject = accSubCaseRec.Account.Name+' - '+accSubCaseRec.Account.External_ID__c+' - '+effectiveDate.format('M/d/yyyy')+' - '+'Custom ID Form Request Submitted';
                            EmailBody = '<html><body>'
                                        + 'Custom ID request  form has been submitted.' + '<br/><br/>' +
                                        + '<b>' + 'Account Name : ' + '</b>' +accSubCaseRec.Account.Name + '<br/>' +
                                        + '<b>' + 'Case Number  : ' + '</b>' +customIdCardFormRec.Parent_ID_Card_Case_Number__c + '<br/>' +
                                        + '<b>' + 'Case Details : ' + '</b>' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/'  + customIdCardFormRec.Custom_ID_Request_Form_Case__c+'>'+ customIdCardFormRec.Parent_ID_Card_Case_Number__c+'</a>'+ '<br/><br/>' +
                                        + 'To review form please click on ' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/' + customIdCardFormRec.Id+'>'+ customIdCardFormRec.Name + '</a>'  + '<br/><br/>' +
                                        + 'Thanks'+ '<br/>' +
                                      + '</html>';
                        }
                        if(customIdCardFormRec.Status__c == 'Re-Submitted' && customIdCardFormRec.Status__c != '' && customIdCardFormRec.Status__c != null)
                        {
                            idCardMessageToAccountSpecialistCicAccMgntUser.subject = accSubCaseRec.Account.Name+' - '+accSubCaseRec.Account.External_ID__c+' - '+effectiveDate.format('M/d/yyyy')+' - '+'Custom ID Form Updated';
                            EmailBody = '<html><body>'
                                        + 'Custom ID request  form has been updated.' + '<br/><br/>' +
                                        + '<b>' + 'Account Name : ' + '</b>' +accSubCaseRec.Account.Name + '<br/>' +
                                        + '<b>' + 'Case Number  : ' + '</b>' +customIdCardFormRec.Parent_ID_Card_Case_Number__c + '<br/>' +
                                        + '<b>' + 'Case Details : ' + '</b>' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/'  + customIdCardFormRec.Custom_ID_Request_Form_Case__c+'>'+ customIdCardFormRec.Parent_ID_Card_Case_Number__c+'</a>'+ '<br/><br/>' +
                                        + 'To review form please click on ' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/' + customIdCardFormRec.Id+'>'+ customIdCardFormRec.Name + '</a>'  + '<br/><br/>' +
                                        + 'Thanks'+ '<br/>' +
                                      + '</html>';
                        
                        }
                        idCardMessageToAccountSpecialistCicAccMgntUser.setHtmlBody(EmailBody);
                        submittedReSubmittedIDCardEmailsList.add(idCardMessageToAccountSpecialistCicAccMgntUser);
                    }
                }
            }
            if(submittedReSubmittedIDCardEmailsList!=null && !submittedReSubmittedIDCardEmailsList.isEmpty())
            {
                Messaging.sendEmail(submittedReSubmittedIDCardEmailsList);
            }
        }
        Catch(Exception ex)
        {
            GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', 'Gems_CustomIDCardEmailHandler', 'onIdCardSubmitSendNotificationToAccSubmitterCICAccMngmntUsers(List<GEMS_Custom_ID_Request_Form__c> idCardsList,Map<Id,GEMS_Custom_ID_Request_Form__c> oldIdCardsMap)','High'); 
        }
    }
}