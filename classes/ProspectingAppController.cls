/*******************************************************************************************
* Apex Class Name     : ProspectingAppController
* Version             : 1.0
* Function            : This controller pulls the account information related to the recordID
*						and determins if the user profile is in the authorized profile list.
* Modification Log    :
* Developer				Date		Description
* ------------------------------------------------------------------------------
* Zachary Campbell		6/09/2017	Testing for queryRecord method and created 
*									isLightningProspecting method.
*******************************************************************************************/
public with sharing class ProspectingAppController {

    @AuraEnabled
    public static sObject queryRecord(String sobjectType, Id recordId) { 
        if(sobjectType.toLowerCase() == 'account'){ 
			return ProspectingAppUtilityClass.queryAccount(recordId);
        } else { 
			return null; 
		}
    }
    
	@AuraEnabled
	public static boolean isLightningProspecting(boolean found) {
		found = false;
        if (Lightning_Prospecting_Pilot_Names__c.getAll().size() > 0) {
            if (ProspectingAppUtilityClass.findName() && ProspectingAppUtilityClass.findProfile()) {
                found = true;
            }
        } else {
            if (ProspectingAppUtilityClass.findProfile()) {
                found = true;
            }
        }
        return found;
    } 
}

// End Class ProspectingAppController