// Project:  GEMS Project - Wave 1.0b
// Release:  09/16/2016
// Author :  Malathi Kethireddy 
// Comments: New Apex class called from Apex Trigger - GEMSIdCardSuppTrigger.

public class Gems_IDCardSuppEmailHandler
{
    public static void onIdCardUpdateSendNotificationToAccSubmitterCICAccMngmntUsers(List<GEMS_ID_Card_Suppression__c> IdCardSuppNewList,Map<Id,GEMS_ID_Card_Suppression__c> IdCardsSuppOldMap)
    {
        Set<ID> IDCardSuppIdsSet = new Set<ID>();
        Set<ID> subCaseIdsSet = new Set<ID>();
        Map<ID,GEMS_ID_Card_Suppression__c> accSubCaseIdAndIdCardSuppMap = new Map<ID,GEMS_ID_Card_Suppression__c>();
        List<Case> accSubCaseChildCasesAndCaseTeamList = new List<Case>();
        Map<ID, List<String>> accSubCaseIdAndAccSpeclistCicAccSupUserEmailIdMap = new Map<ID, List<String>>();
        List<Messaging.SingleEmailMessage> updatedIDCardsSuppEmailsList = new List<Messaging.SingleEmailMessage>();
        try
        {
            for(GEMS_ID_Card_Suppression__c IdCardSuppressionrec:IdCardSuppNewList)
            {
                if((IdCardSuppressionrec.Status__c == 'Request for Suppression' || IdCardSuppressionrec.Status__c=='Suppression Completed' || IdCardSuppressionrec.Status__c == 'Removal Of Suppression Completed' || IdCardSuppressionrec.Status__c == 'Request for Removal Of Suppression') &&  IdCardSuppressionrec.Status__c != IdCardsSuppOldMap.get(IdCardSuppressionrec.id).Status__c )
                {
                    IDCardSuppIdsSet.add(IdCardSuppressionrec.Id);
                }                
            }
            List<GEMS_ID_Card_Suppression__c> statusUpdatedIdCardSuppList = new List<GEMS_ID_Card_Suppression__c>();
            if(IDCardSuppIdsSet!=null && !IDCardSuppIdsSet.isEmpty())
            {
                statusUpdatedIdCardSuppList = [SELECT ID, Name, Status__c, Parent_ID_Card_Case__r.GEMS_Account_Submission_Info__c,
                                                        Parent_ID_Card_Case__r.GEMS_Account_Submission_Info__r.OwnerId,
                                                        Parent_ID_Card_Case__r.CaseNumber,Parent_ID_Card_Case_Number__c,
                                                        Parent_ID_Card_Case__c
                                                        FROM GEMS_ID_Card_Suppression__c WHERE ID IN: IDCardSuppIdsSet];                                                        
            }             
            if(!statusUpdatedIdCardSuppList.isEmpty() && statusUpdatedIdCardSuppList !=null)              
            {                
                for(GEMS_ID_Card_Suppression__c IdCardSuppressionrec:statusUpdatedIdCardSuppList )
                {
                    accSubCaseIdAndIdCardSuppMap.put(IdCardSuppressionrec.Parent_ID_Card_Case__r.GEMS_Account_Submission_Info__c, IdCardSuppressionrec);
                    subCaseIdsSet.add(IdCardSuppressionrec.Parent_ID_Card_Case__r.GEMS_Account_Submission_Info__c);
                }
            }
            if(!subCaseIdsSet.isEmpty() || subCaseIdsSet!=null)
            {                
                Id getCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS GET').getRecordTypeId();
                accSubCaseChildCasesAndCaseTeamList = [SELECT ID, CaseNumber, Subject, Account.Name,
                                        (SELECT Id,RecordTypeId,status, GEMS_Account_Submission_Info__c, Owner.Email 
                                        FROM Cases1__r WHERE RecordTypeId=:getCaseRecordTypeId LIMIT 1),
                                        (SELECT parentId,memberid, member.Email,TeamRole.name FROM TeamMembers)
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
                    GEMS_ID_Card_Suppression__c IdCardSuppressionrec = new GEMS_ID_Card_Suppression__c();
                    if(accSubCaseIdAndIdCardSuppMap.containsKey(accSubCaseRec.Id))
                    {
                        IdCardSuppressionrec = accSubCaseIdAndIdCardSuppMap.get(accSubCaseRec.Id);
                        System.debug('IdCardSuppressionrec.Status__c:'+IdCardSuppressionrec.Status__c);
                    
                        Messaging.SingleEmailMessage idCardMessageToAccountSpecialistCicAccMgntUser = new Messaging.SingleEmailMessage();
                        List<String> idCardToAccountSpecialistCicAccMgntUser = accSubCaseIdAndAccSpeclistCicAccSupUserEmailIdMap.get(accSubCaseRec.Id);
                        idCardMessageToAccountSpecialistCicAccMgntUser.setToAddresses(idCardToAccountSpecialistCicAccMgntUser);
                        String EmailBody;
                        if(IdCardSuppressionrec.Status__c == 'Request for Suppression' && IdCardSuppressionrec.Status__c !='' && IdCardSuppressionrec.Status__c !=null)
                        {
                            idCardMessageToAccountSpecialistCicAccMgntUser.subject = 'ID Card Suppression Request: ' +accSubCaseRec.Account.Name;
                            EmailBody = '<html><body>'
                                        + 'Hi,' + '<br/><br/>' +
                                        +'Please note ID Card Suppression is requested for ' + '<b>' + accSubCaseRec.Account.Name + '</b>' + '<br/><br/>' +
                                        + 'To review Case please click on ' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/'  + IdCardSuppressionrec.Parent_ID_Card_Case__c+'>' + IdCardSuppressionrec.Parent_ID_Card_Case_Number__c+'</a>'+ '<br/>' +
                                        + 'To review form please click on ' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/' + IdCardSuppressionrec.Id+'>'+ IdCardSuppressionrec.Name + '</a>'  + '<br/><br/>' +
                                        + 'Regards,'+ '<br/>' +
                                        +'GEMS System' + '<br/>'+
                                      + '</html>';
                        }
                        if(IdCardSuppressionrec.Status__c == 'Suppression Completed' && IdCardSuppressionrec.Status__c != '' && IdCardSuppressionrec.Status__c != null)
                        {
                            idCardMessageToAccountSpecialistCicAccMgntUser.subject = accSubCaseRec.Account.Name+' : ID Card Suppression Completed';
                            EmailBody = '<html><body>'
                                        + 'Hi,' + '<br/><br/>' +
                                        +'Please note ID Card Suppression is completed for ' + '<b>' + accSubCaseRec.Account.Name + '</b>' + '<br/><br/>' +
                                        + 'To review Case please click on ' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/'  + IdCardSuppressionrec.Parent_ID_Card_Case__c+'>'+ IdCardSuppressionrec.Parent_ID_Card_Case_Number__c+'</a>'+ '<br/>' +
                                        + 'To review form please click on ' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/' + IdCardSuppressionrec.Id+'>'+ IdCardSuppressionrec.Name + '</a>'  + '<br/><br/>' +
                                        + 'Regards,'+ '<br/>' +
                                        +'GEMS System' + '<br/>'+
                                      + '</html>';
                        
                        }
                        if(IdCardSuppressionrec.Status__c == 'Request for Removal Of Suppression' && IdCardSuppressionrec.Status__c !='' && IdCardSuppressionrec.Status__c !=null)
                        {
                            System.debug(IdCardSuppressionrec.Status__c);
                            System.debug('Removal request'); 
                            idCardMessageToAccountSpecialistCicAccMgntUser.subject = 'ID Card Removal Of Suppression Request: ' +accSubCaseRec.Account.Name;
                            EmailBody = '<html><body>'
                                        + 'Hi,' + '<br/><br/>' +
                                        +'Please note ID Card Removal Of Suppression is requested for ' + '<b>' + accSubCaseRec.Account.Name + '</b>' + '<br/><br/>' +
                                        + 'To review Case please click on ' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/'  + IdCardSuppressionrec.Parent_ID_Card_Case__c+'>' + IdCardSuppressionrec.Parent_ID_Card_Case_Number__c+'</a>'+ '<br/>' +
                                        + 'To review form please click on ' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/' + IdCardSuppressionrec.Id+'>'+ IdCardSuppressionrec.Name + '</a>'  + '<br/><br/>' +
                                        + 'Regards,'+ '<br/>' +
                                        +'GEMS System' + '<br/>'+
                                      + '</html>';
                        }
                        if(IdCardSuppressionrec.Status__c == 'Removal Of Suppression Completed' && IdCardSuppressionrec.Status__c != '' && IdCardSuppressionrec.Status__c != null)
                        {
                            System.debug(IdCardSuppressionrec.Status__c);
                            System.debug('Removal of Suppression Completed'); 
                            idCardMessageToAccountSpecialistCicAccMgntUser.subject = accSubCaseRec.Account.Name+' : ID Card Removal Of Suppression Completed';
                            EmailBody = '<html><body>'
                                        + 'Hi,' + '<br/><br/>' +
                                        +'Please note ID Card Suppression Removal is completed for ' + '<b>' + accSubCaseRec.Account.Name + '</b>' + '<br/><br/>' +
                                        + 'To review Case please click on ' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/'  + IdCardSuppressionrec.Parent_ID_Card_Case__c+'>'+ IdCardSuppressionrec.Parent_ID_Card_Case_Number__c+'</a>'+ '<br/>' +
                                        + 'To review form please click on ' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/' + IdCardSuppressionrec.Id+'>'+ IdCardSuppressionrec.Name + '</a>'  + '<br/><br/>' +
                                        + 'Regards,'+ '<br/>' +
                                        +'GEMS System' + '<br/>'+
                                      + '</html>';
                        
                        }
                        idCardMessageToAccountSpecialistCicAccMgntUser.setHtmlBody(EmailBody);
                        updatedIDCardsSuppEmailsList.add(idCardMessageToAccountSpecialistCicAccMgntUser);
                    }
                }
            }
            if(updatedIDCardsSuppEmailsList!=null && !updatedIDCardsSuppEmailsList.isEmpty())
            {
                Messaging.sendEmail(updatedIDCardsSuppEmailsList);
            }
        }
        Catch(Exception ex)
        {
            GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', 'Gems_IDCardSuppEmailHandler', 'onIdCardUpdateSendNotificationToAccSubmitterCICAccMngmntUsers(List<GEMS_ID_Card_Suppression__c> idCardsList,Map<Id,GEMS_ID_Card_Suppression__c> oldIdCardsMap)','High'); 
        }
    }
}