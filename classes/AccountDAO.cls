public class AccountDAO implements IAccountDAO {
    //TEST 3
    public interface IAccountDAO {
        List<Account> getAccountsForProduct360(Id userId, Set<Id> accountIds);
        void updateAccounts(List<Account> accountsToUpdate);
        List<Account> getAccounts(Set<Id> accountIds);
        List<Account> getCaseComplexityGroupAccounts(Set<Id> parentAccountIds, Id groupAccountRecordType);
        List<Account> getContactComplexityGroupAccounts(Set<Id> parentAccountIds, Id groupAccountRecordType);
        List<Account> getCompetitorRelationshipComplexityGroupAccounts(Set<Id> parentAccountIds, Id groupAccountRecordType);
        List<Account> getBenefitAgreementComplexityGroupAccounts(Set<Id> parentAccountIds, Id groupAccountRecordType);
        List<Account> getContractAdministrationComplexityGroupAccounts(Set<Id> parentAccountIds, Id groupAccountRecordType);
        List<Account> getAccountsForContractSignerAccount(Set<Id> accIds);
        List<Account> getAccountsForContractSignerCase(Set<Id> accIds, Id groupRecordTypeId, Id prospectRecordTypeId);
        List<Account> getProducerAccountsForTicketDistro(Set<Id> producerIds, Id producerRecordTypeId);
        List<Account> getGroupAccountsForTicketDistro(Set<Id> clientIds, Id groupRecordTypeId);
        List<Account> getAccountForPrimaryContactUpdate(Set<Id> accountIds);
         Account getAccountForCustomContractsProdsPage(Id acctId);
    }

    public List<Account> getAccountsForProduct360(Id userId, Set<Id> accountIds) {
        return [SELECT Id, Name, (Select Id, StageName, Requested_Effective_Date__c, Name, RecordType.Name, HCSC_Division__c, Expected_Health_Members__c, Expected_Health_Contracts__c, Expected_Dental_Members__c, Expected_Dental_Contracts__c From Opportunities) FROM Account WHERE (Id IN :accountIds OR OwnerId = :userId) AND Id in (Select AccountId from Opportunity)];
    }

    public List<Account> getAccounts(Set<Id> accountIds) {
        return [SELECT Id, Name, AccountNumber,External_ID__c, Funding_Type__c, RecordTypeId, RecordType.Name FROM Account WHERE Id IN :accountIds];
    }

    public List<Account> getAccountForPrimaryContactUpdate(Set<Id> accountIds){
        return [SELECT Id, Primary_Contact__c FROM Account WHERE Id IN :accountIds];
    }
    public void updateAccounts(List<Account> accountsToUpdate) {
        update accountsToUpdate;
    }

    public List<Account> getCaseComplexityGroupAccounts(Set<Id> parentAccountIds, Id groupAccountRecordType) {
        return [SELECT Id, ComplexityScoreCase__c, RecordTypeId FROM Account WHERE Id IN: parentAccountIds AND RecordTypeId = :groupAccountRecordType];
    }

    public List<Account> getContactComplexityGroupAccounts(Set<Id> parentAccountIds, Id groupAccountRecordType) {
        return [SELECT Id, ComplexityScoreContact__c, RecordTypeId FROM Account WHERE Id IN: parentAccountIds AND RecordTypeId = :groupAccountRecordType];
    }

    public List<Account> getCompetitorRelationshipComplexityGroupAccounts(Set<Id> parentAccountIds, Id groupAccountRecordType) {
        return [SELECT Id, ComplexityScoreCompetitorRelationship__c, RecordTypeId FROM Account WHERE Id IN: parentAccountIds AND RecordTypeId = :groupAccountRecordType];
    }

    public List<Account> getBenefitAgreementComplexityGroupAccounts(Set<Id> parentAccountIds, Id groupAccountRecordType) {
        return [SELECT Id, ComplexityScoreBenefitAgreement__c, RecordTypeId FROM Account WHERE Id IN: parentAccountIds AND RecordTypeId = :groupAccountRecordType];
    }

    public List<Account> getContractAdministrationComplexityGroupAccounts(Set<Id> parentAccountIds, Id groupAccountRecordType) {
        return [SELECT Id, ComplexityScoreContractAdministration__c, RecordTypeId FROM Account WHERE Id IN: parentAccountIds AND RecordTypeId = :groupAccountRecordType];
    }

    public List<Account> getAccountsForContractSignerAccount(Set<Id> accIds) {
        return [SELECT Id, Contract_Signer__r.FirstName, Contract_Signer__r.LastName, Contract_Signer__r.Email, Contract_Signer__r.Phone, Contract_Signer__r.Title, RecordTypeId, Underwriter_Name__c, Underwriter__r.FirstName, Underwriter__r.LastName FROM Account WHERE Id IN :accIds];
    }

    public List<Account> getAccountsForContractSignerCase(Set<Id> accIds, Id groupRecordTypeId, Id prospectRecordTypeId){
        return [SELECT Id, Contract_Signer__c, Contract_Signer__r.FirstName, Contract_Signer__r.LastName, Contract_Signer__r.Email, Contract_Signer__r.Phone,
               Contract_Signer__r.Title, RecordTypeId, Underwriter_Name__c, Underwriter__r.FirstName, Underwriter__r.LastName FROM Account WHERE Id IN :accIds 
               AND (RecordTypeId = :groupRecordTypeId OR RecordTypeId = :prospectRecordTypeId)];
    }

    public Account getAccountForCustomContractsProdsPage(Id acctId) {
        return [SELECT RecordTypeId, Status__c FROM Account WHERE Id = :acctId LIMIT 1];
    }

    public List<Account> getProducerAccountsForTicketDistro(Set<Id> producerIds, Id producerRecordTypeId){
        return [SELECT Id, Tax_ID__c FROM Account WHERE RecordTypeId = :producerRecordTypeId and Id IN :producerIds];
    }

    public List<Account> getGroupAccountsForTicketDistro(Set<Id> clientIds, Id groupRecordTypeId){
        return [SELECT Id, External_ID__c FROM Account WHERE RecordTypeId = :groupRecordTypeId and Id IN :clientIds];
    }
}