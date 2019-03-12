public with sharing class CaseAccountCancellationController {
@AuraEnabled
    public static Case CaseAccountCancellationController(id sCaseId){
        
        Case compcaseObj=[select Status,GEMS_Submission_Type__c,GEMS_Integration_Message__c,isRetrievalRequestSubmitted__c,Account.Id from case where Id=:sCaseId];
        return compcaseObj;
    }
}