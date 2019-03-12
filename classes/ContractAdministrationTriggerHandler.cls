public class ContractAdministrationTriggerHandler { 

    /**
    * @author       Sana Fatima/Slalom
    * @description  Filters the Accounts that need complexity score updates
    */
	public static void updateContractAdministrationComplexityScore(List<Contract_Administration__c> contractAdmins) {
		Id groupAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId();
        AccountDAO.IAccountDAO accountDAOInstance = new AccountDAO();

		Set<Id> parentAccountIds = new Set<Id>();
		Map<Id, Account> groupAccounts = new Map<Id, Account>();

		for ( Contract_Administration__c contractAdmin : contractAdmins ) {
			if( contractAdmin.Account__c != null )
				parentAccountIds.add(contractAdmin.Account__c);
		}
		if( !parentAccountIds.isEmpty() ) {
			groupAccounts = new Map<Id, Account>( accountDAOInstance.getContractAdministrationComplexityGroupAccounts(parentAccountIds, groupAccountRecordType) );
		}
		if( !groupAccounts.isEmpty() ) {
			calculateContractAdministrationComplexityScore(groupAccounts);
		}
	}

	/**
    * @author       Sana Fatima/Slalom
    * @description  Computes the Account Complexity Score for the Contract Administration object
    */
	public static void calculateContractAdministrationComplexityScore(Map<Id, Account> groupAccounts) {
		try{
			List<Contract_Administration__c> contractAdmins = new List<Contract_Administration__c>();
			Map<Id, Integer> numContractAdminsByAccIds = new Map<Id, Integer>();
			List<Account> accountsToUpdate = new List<Account>();
			AccountDAO.IAccountDAO accountDAOInstance = new AccountDAO();
			ContractAdministrationDAO.IContractAdministrationDAO contractAdminDAOInstance = new ContractAdministrationDAO();
			Decimal oldValue;
		
			contractAdmins = contractAdminDAOInstance.getContractAdminsByGroupAccounts( groupAccounts.keySet() );
		
			for( Contract_Administration__c contractAdmin :contractAdmins) {
				if( !numContractAdminsByAccIds.containsKey(contractAdmin.Account__c)) {
					numContractAdminsByAccIds.put(contractAdmin.Account__c, 1);
				} else {
					numContractAdminsByAccIds.put(contractAdmin.Account__c, numContractAdminsByAccIds.get(contractAdmin.Account__c)+ 1 );
				}
			}
			for( Account currAccount: groupAccounts.values() ) {
				oldValue = currAccount.ComplexityScoreContractAdministration__c;
				if ( numContractAdminsByAccIds.containsKey(currAccount.Id) ) {
					if( numContractAdminsByAccIds.get(currAccount.Id) >= 1 ) {
						currAccount.ComplexityScoreContractAdministration__c = 5;
					}
				} else if ( !numContractAdminsByAccIds.containsKey(currAccount.Id) ){
					currAccount.ComplexityScoreContractAdministration__c = 0; 
				}
				if( currAccount.ComplexityScoreContractAdministration__c != oldValue) {
					accountsToUpdate.add(currAccount);
				}
			}
			if( !accountsToUpdate.isEmpty() ) {
				accountDAOInstance.updateAccounts( accountsToUpdate );
			}
		} catch (Exception ex) {
			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Contract Administration', 'ContractAdministrationTrigger', 'ContractAdministrationTriggerHandler.calculateContractAdministrationComplexityScore', 'High');
		}
	}	
}