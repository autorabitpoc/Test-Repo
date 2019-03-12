public with sharing class ProspectingAppCompVendListController {
	@AuraEnabled
    public static List<Competitor_Relationship__c> queryAccountCompetitorsAndVendorsList(Account curAcc) {
        return ProspectingAppUtilityClass.queryAccountCompetitorsAndVendorsList(curAcc);
    }  
    
    //<!-- SFDC-4497 - 06/2017 - SHUYLER - Begin  -->
     @AuraEnabled
    public static Competitor_Relationship__c getExistingCompetitorDetails(id competitorId){
        return ProspectingAppUtilityClass.queryCompetitorInfo(competitorId);
    }    
   //<!-- SFDC-4497 - 06/2017 - SHUYLER - End     -->
    
}