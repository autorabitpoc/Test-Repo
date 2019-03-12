/**************************************************************************************
 * Apex Class Name     : GEMS_AddressTriggerHandler
 * Version             : 1.0
 * Function            : This is a handler class for Address Trigger which is used to restict user or system to create or update multiple GEMS Address Values for primary. 
 * Modification Log    :
 * Developer           :    Date                   Description
 * ----------------------------------------------------------------------------                 
 * Lakshmi Arigela       06/28/2017                Original Version,SFDC-3913 System should not send duplicate primary address values to BLUESTAR
 * Shankar				 11/08/2017				   SFDC-7238. Added a check to allow changes to existing primarya address by comparing addr seq #
 *************************************************************************************/
public  class GEMS_AddressTriggerHandler {


	/*****************************************************************
  Method: checkPrimaryAddress
  Description: checkPrimaryAddress method is to check the Account Addresses and 
                         create error message if primary address already exists
	 *******************************************************************/
	public static void checkPrimaryAddress(List<GEMS_Address__c> addresses){

		List<Id> AccountIds= new List<Id>();
		Set<Id> addresscheck = new Set<Id>();

		for(GEMS_Address__c addr : addresses){



			//Adding only the Accounts only that have Primary address.
			if(addr.Usage__c!=null && !string.isEmpty(addr.Usage__c)){
				if(addr.Usage__c.contains('Primary')){
					AccountIds.add(addr.Account__c);
					addresscheck.add(addr.Id);
				}
			}     
		}


		Map<Id,GEMS_Address__c> Account_AddressMap = new Map<Id,GEMS_Address__c>();

		// SFDC-7238. Added Address_Sequence__c to query
		for(GEMS_Address__c addrss: [Select id ,Usage__c, Address_Sequence__c, Account__c from GEMS_Address__c where Account__c in: AccountIds and Usage__c includes('Primary')]){
			if(!addresscheck.contains(addrss.id)){
				Account_AddressMap.put(addrss.Account__c,addrss);
			}
		}
		// SFDC-7238 End

		// SFDC-7238. Error out if a primary address (with a different address sequence #) is being inserted and if one exists already
		for(GEMS_Address__c addr : addresses){
			GEMS_Address__c a = Account_AddressMap.get(addr.account__c);
			if(Account_AddressMap.containskey(addr.account__c) && a.Address_Sequence__c != addr.Address_Sequence__c){
				addr.Usage__c.adderror('Primary address already exists for this account');
			}

		} 
		// SFDC-7238 End




	}
}