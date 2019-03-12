public class ContractAdministrationDAO implements IContractAdministrationDAO { 
	
	public Interface IContractAdministrationDAO {
		List<Contract_Administration__c> getContractAdminsByGroupAccounts(Set<Id> groupAccIds);
	}

	public List<Contract_Administration__c> getContractAdminsByGroupAccounts(Set<Id> groupAccIds) {
		return [SELECT Complexity__c, Account__c FROM Contract_Administration__c WHERE Account__c IN :groupAccIds AND Complexity__c IN :ConstantsController.complexities];
	}
}