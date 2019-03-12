public class BenefitAgreementDAO implements IBenefitAgreementDAO {
	public interface IBenefitAgreementDAO {
		List<Benefit_Agreement__c> getBatchBenefitAgreements(Set<Id> accountIds);
		List<Benefit_Agreement__c> getGroupAccountBenefitAgreements(List<Account> groupAccounts);
		List<Benefit_Agreement__c> getActiveBenefitAgreementsAndCoverages(Map<Id, Account> groupAccounts);
		void updateBenefitAgreements(List<Benefit_Agreement__c> bnftAgrmnts);
		List<Benefit_Agreement__c> getActiveBlueStarBenefitAgreements(Set<Id> baIds, Id BlueSTARRecType);
		List<Benefit_Agreement__c> getBenefitAgreementsForCurrentProds(Id acctId);
	}

	public List<Benefit_Agreement__c> getBatchBenefitAgreements(Set<Id> accountIds) {
		return [Select Id, Group_Account__c, Group_Account__r.Status__c, Product__c, Product__r.Product_Category__c, Product__r.Product_Type__c, Funding_Type__c, Product__r.Simplified_Product__c, Product__r.Name, Business_Type__c, Renewal_Date__c, Members__c, Product__r.Family from Benefit_Agreement__c where  Group_Account__c in :accountIds and Group_Account__c != null and Product__c != null and Group_Account__r.Status__c = 'Active' and Status__c = 'Active' and Effective_Date__c < :System.today() and (Cancellation_Status__c != 'Cancelled' and Status__c != 'Cancelled')];
	}

	public List<Benefit_Agreement__c> getGroupAccountBenefitAgreements(List<Account> groupAccounts) {
		return [SELECT Id, Group_Account__r.Id, Funding_Type__c FROM Benefit_Agreement__c WHERE Group_Account__c IN :groupAccounts];
	}

	public List<Benefit_Agreement__c> getActiveBenefitAgreementsAndCoverages( Map<Id, Account> groupAccounts ) {
		return [SELECT Group_Account__c, Status__c, Stop_Loss__c, Product_Category__c, Plan__r.Name, ComplexityScoreCoverage__c 
					FROM Benefit_Agreement__c WHERE Group_Account__c IN :groupAccounts.keySet() AND Status__c = :Label.Active];
	}

	public void updateBenefitAgreements(List<Benefit_Agreement__c> bnftAgrmnts) {
		update bnftAgrmnts; 
	}

	public List<Benefit_Agreement__c> getActiveBlueStarBenefitAgreements(Set<Id> baIds, Id BlueSTARRecType) {
		return [SELECT ComplexityScoreCoverage__c, RecordTypeId FROM Benefit_Agreement__c WHERE Id 
				IN :baIds AND RecordTypeId =:BlueSTARRecType AND Status__c = :Label.Active];
	}

	public List<Benefit_Agreement__c> getBenefitAgreementsForCurrentProds(Id acctId) {
		return [SELECT Product__c, Product__r.Product_Type__c, Product__r.Simplified_Product__c, Funding_type__c, (SELECT Group_Section__r.Total_Dental_Active_Members__c,
				Group_Section__r.Total_Healthcare_Active_Members__c, Group_Section__r.Total_Active_Subscribers__c
				FROM BA_GS_Assignments__r WHERE Group_Section__r.Status__c = :Label.Active),
				Premium_Type__c FROM Benefit_Agreement__c WHERE Status__c = :Label.Active AND Group_Account__c = :acctId AND Effective_Date__c < :System.today()
				AND(Cancellation_Status__c != :Label.Cancelled AND Status__c != :Label.Cancelled)
				ORDER BY Product__r.Product_Type__c ASC limit :Limits.getLimitQueryRows() - Limits.getQueryRows()];
	}
}