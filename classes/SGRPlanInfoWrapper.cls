public class SGRPlanInfoWrapper {

    @AuraEnabled public String planId {get; set;}
    @AuraEnabled public String planType {get; set;}
    @AuraEnabled public List<SGR_Opportunity_Group_Section__c> groupInfoList {get; set;}

    public SGRPlanInfoWrapper(){
        
    }
}