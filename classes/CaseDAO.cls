public class CaseDAO implements ICaseDAO {

    public interface ICaseDAO {
        Case getRequestTypeParentCase(Id caseId);
        List<Case> getPGCasesAndLineItemReviewChildren(Set<Id> caseIds);
        void updatePGCasesStatuses(List<Case> masterCaseList);
        List<Case> getPGAndGemsCases( Map<Id, Account> groupAccounts, Id performanceGuaranteeRecordType, Id gemsAccountStructRecordType, Id gemsAccountSubmissionRecordType );
        List<Case> getContractSignerCases(Set<Id> accIds, Id customContractsRecordType);
        List<Case> updateContractSignerCases(List<Case> casesToUpdate);
        Case getCaseById(Id caseId);
        //4784
       Quote_Request_Summary__c getQuoteReqById(Id QuoteReqId) ;
       Quote getQuoteById(Id QuoteId) ; 
        
    }

    //SFDC-5096 Malathi.K Added Type
    public Case getCaseById(Id caseId) {
        System.debug('caseid from caseDAO-- ' +caseId);
        return [SELECT Id, CaseNumber, Type,Opportunity_Name__r.Name, Opportunity_Name__r.Id, Account.Name, Account.External_Id__c FROM Case WHERE Id = :caseId];
    }
    //4784
  	public Quote_Request_Summary__c  getQuoteReqById(Id QuoteReqId) {
       // System.debug('caseid from caseDAO-- ' +QuoteId);
        return [SELECT Id, Account_Name_tx__c,Account_Number__c,Opportunity_Name__c, Opportunity_Id__c,Quote_Name__r.name,name	FROM Quote_Request_Summary__c WHERE Id = :QuoteReqId];
    }    
    
    public Quote getQuoteById(Id QuoteId) {
         return [SELECT Id, Account.Name,Account.External_Id__c,Opportunity.Name, Opportunity.Id,name	FROM Quote WHERE Id = :QuoteId];
    }
    public Case getRequestTypeParentCase(Id caseId) {
        return [SELECT Provider_Groups__c, Request_Types__c, Standard_Medical_Access_Criteria__c FROM Case WHERE Id = :caseId];
    }

    public List<Case> getPGCasesAndLineItemReviewChildren(Set<Id> caseIds) {
        return [SELECT Status, (SELECT Disposition_Status__c, Disposition_Date_Time__c, RecordTypeId FROM Line_Item_Reviews__r) FROM Case WHERE Id IN :caseIds];
    }

    public void updatePGCasesStatuses(List<Case> masterCaseList) {
        update masterCaseList;
    }

    public List<Case> getPGAndGemsCases( Map<Id, Account> groupAccounts, Id performanceGuaranteeRecordType, Id gemsAccountStructRecordType, Id gemsAccountSubmissionRecordType ){
        return [SELECT Status, AccountId, RecordTypeId, GEMS_AEP_Account__c, GEMS_Is_Account_Derivated__c FROM Case WHERE AccountId IN :groupAccounts.keySet() AND 
        (RecordTypeId = :performanceGuaranteeRecordType OR RecordTypeId = :gemsAccountStructRecordType OR RecordTypeId = :gemsAccountSubmissionRecordType)];
    }

    public List<case> getContractSignerCases(Set<Id> accIds, Id customContractsRecordType){
        return [SELECT Id, AccountId, Full_Name__c, Phone__c, Email__c, Title__c, Bypass_Validation__c, Account_Type__c, Underwriter_From_Account__c FROM Case WHERE AccountId IN :accIds AND RecordTypeId = :customContractsRecordType];
    }

    public List<Case> updateContractSignerCases(List<Case> casesToUpdate){
        update casesToUpdate;
        return casesToUpdate;
    }
}