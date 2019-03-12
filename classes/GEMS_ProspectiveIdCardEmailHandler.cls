public class GEMS_ProspectiveIdCardEmailHandler
{
    public static void onIdCardUpdateSendNotificationToAccSubmitterCICAccMngmntUsers(List<GEMS_Prospective_ID_Card__c> prospectiveIdCardNewList,Map<Id,GEMS_Prospective_ID_Card__c> prospectiveIdCardsOldMap)
    {
        Set<ID> prospectiveIDCardIdsSet = new Set<ID>();
        Set<ID> subCaseIdsSet = new Set<ID>();
        Map<ID,GEMS_Prospective_ID_Card__c> accSubCaseIdAndProspectiveIdCardMap = new Map<ID,GEMS_Prospective_ID_Card__c>();
        List<Case> accSubCaseChildCasesAndCaseTeamList = new List<Case>();
        Map<ID, List<String>> accSubCaseIdAndAccSpeclistCicAccSupUserEmailIdMap = new Map<ID, List<String>>();
        List<Messaging.SingleEmailMessage> updatedProspectiveIDCardsEmailsList = new List<Messaging.SingleEmailMessage>();
        try
        {
            for(GEMS_Prospective_ID_Card__c prospectiveIdCardrec: prospectiveIdCardNewList)
            {
                if((prospectiveIdCardrec.Status__c == 'Request for prospective ID' || prospectiveIdCardrec.Status__c=='Prospective ID Card Completed' ) &&  prospectiveIdCardrec.Status__c != prospectiveIdCardsOldMap.get(prospectiveIdCardrec.id).Status__c )
                {
                    prospectiveIDCardIdsSet.add(prospectiveIdCardrec.Id);
                }
            }
            List<GEMS_Prospective_ID_Card__c> statusUpdatedProspectiveIdCardsList = new List<GEMS_Prospective_ID_Card__c>();
            if(prospectiveIDCardIdsSet!=null && !prospectiveIDCardIdsSet.isEmpty())
            {
                statusUpdatedProspectiveIdCardsList = [SELECT ID, Name, Status__c, Parent_ID_Card_Case__r.GEMS_Account_Submission_Info__c,
                                                        Parent_ID_Card_Case__r.GEMS_Account_Submission_Info__r.OwnerId,
                                                        Parent_ID_Card_Case__r.CaseNumber, Parent_ID_Card_Case_Number__c,
                                                        Parent_ID_Card_Case__c
                                                        FROM GEMS_Prospective_ID_Card__c WHERE ID IN: prospectiveIDCardIdsSet];
            }
            if(!statusUpdatedProspectiveIdCardsList.isEmpty() && statusUpdatedProspectiveIdCardsList!=null)
            {
                for(GEMS_Prospective_ID_Card__c prospectiveIdCardrec: statusUpdatedProspectiveIdCardsList)
                {
                    accSubCaseIdAndProspectiveIdCardMap.put(prospectiveIdCardrec.Parent_ID_Card_Case__r.GEMS_Account_Submission_Info__c, prospectiveIdCardrec);
                    subCaseIdsSet.add(prospectiveIdCardrec.Parent_ID_Card_Case__r.GEMS_Account_Submission_Info__c);
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
                    GEMS_Prospective_ID_Card__c prospectiveIdCardrec = new GEMS_Prospective_ID_Card__c();
                    if(accSubCaseIdAndProspectiveIdCardMap.containsKey(accSubCaseRec.Id))
                    {
                        prospectiveIdCardrec = accSubCaseIdAndProspectiveIdCardMap.get(accSubCaseRec.Id);
                    
                        Messaging.SingleEmailMessage idCardMessageToAccountSpecialistCicAccMgntUser = new Messaging.SingleEmailMessage();
                        List<String> idCardToAccountSpecialistCicAccMgntUser = accSubCaseIdAndAccSpeclistCicAccSupUserEmailIdMap.get(accSubCaseRec.Id);
                        idCardMessageToAccountSpecialistCicAccMgntUser.setToAddresses(idCardToAccountSpecialistCicAccMgntUser);
                        String EmailBody;
                        if(prospectiveIdCardrec.Status__c=='Request for prospective ID' && prospectiveIdCardrec.Status__c!='' && prospectiveIdCardrec.Status__c!=null)
                        {
                            idCardMessageToAccountSpecialistCicAccMgntUser.subject = accSubCaseRec.Account.Name+' : '+prospectiveIdCardrec.Name;
                            EmailBody = '<html><body>'
                                        + 'Hi,' + '<br/><br/>' +
                                        +'Please note Prospective ID Card is requested for ' + '<b>' + accSubCaseRec.Account.Name + '</b>' + '<br/><br/>' +
                                        + 'To review Case please click on ' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/'  + prospectiveIdCardrec.Parent_ID_Card_Case__c+'>'+ prospectiveIdCardrec.Parent_ID_Card_Case_Number__c+'</a>'+ '<br/>' +
                                        + 'To review form please click on ' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/' + prospectiveIdCardrec.Id+'>'+ prospectiveIdCardrec.Name + '</a>'  + '<br/><br/>' +
                                        + 'Regards,'+ '<br/>' +
                                        +'GEMS System' + '<br/>'+
                                      + '</html>';
                        }
                        if(prospectiveIdCardrec.Status__c == 'Prospective ID Card Completed' && prospectiveIdCardrec.Status__c != '' && prospectiveIdCardrec.Status__c != null)
                        {
                            idCardMessageToAccountSpecialistCicAccMgntUser.subject = accSubCaseRec.Account.Name+' : Custom ID Request Form Updated';
                            EmailBody = '<html><body>'
                                        + 'Hi,' + '<br/><br/>' +
                                        +'Please note Prospective ID Card is completed for ' + '<b>' + accSubCaseRec.Account.Name + '</b>' + '<br/><br/>' +
                                        + 'To review Case please click on ' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/'  + prospectiveIdCardrec.Parent_ID_Card_Case__c+'>'+ prospectiveIdCardrec.Parent_ID_Card_Case_Number__c+'</a>'+ '<br/>' +
                                        + 'To review form please click on ' + '<a href='+URL.getSalesforceBaseUrl().toExternalForm() + '/' + prospectiveIdCardrec.Id+'>'+ prospectiveIdCardrec.Name + '</a>'  + '<br/><br/>' +
                                        + 'Regards,'+ '<br/>' +
                                        +'GEMS System' + '<br/>'+
                                      + '</html>';
                        
                        }
                        idCardMessageToAccountSpecialistCicAccMgntUser.setHtmlBody(EmailBody);
                        updatedProspectiveIDCardsEmailsList.add(idCardMessageToAccountSpecialistCicAccMgntUser);
                    }
                }
            }
            if(updatedProspectiveIDCardsEmailsList!=null && !updatedProspectiveIDCardsEmailsList.isEmpty())
            {
                Messaging.sendEmail(updatedProspectiveIDCardsEmailsList);
            }
        }
        Catch(Exception ex)
        {
            GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', 'GEMS_ProspectiveIdCardEmailHandler', 'onIdCardUpdateSendNotificationToAccSubmitterCICAccMngmntUsers(List<GEMS_Prospective_ID_Card__c> idCardsList,Map<Id,GEMS_Prospective_ID_Card__c> oldIdCardsMap)','High'); 
        }
    }
}