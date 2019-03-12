public without sharing class SGR_OpportunitySuppressionClass {

    @AuraEnabled
    public static Opportunity getOpportunityData(Id opportunityId) {
        return [
                SELECT Id, Plan_Change_Needed__c, Rating_Status__c
                FROM Opportunity
                WHERE Id = :opportunityId
                LIMIT 1
        ];
    }
    @AuraEnabled
    public static String updateOpportunityData(Id opportunityId, String updatePlanChange, String ratingStatus) {
        try {
            List<Opportunity> opplist = new List<Opportunity>();
            if (opportunityId != null || opportunityId != '') {
                opplist = [
                        SELECT Id, Rating_Status__c
                        FROM Opportunity
                        WHERE Id = :opportunityId
                        LIMIT 1000
                ];
                Opportunity opp = new Opportunity();
                opp.Id = opportunityId;
                if (String.isNotBlank(updatePlanChange)) {
                    opp.Plan_Change_Needed__c = updatePlanChange;
                }
                if (opp.Plan_Change_Needed__c == 'Yes') {
                    opp.SGR_Workflow_Activity__c = 'Plan Change in Progress';
                } else if (opp.Plan_Change_Needed__c == 'Complete') {
                    if (opplist[0].Rating_Status__c == 'Sold') {
                        opp.Rating_Status__c = 'Finalized';
                    } else if (opplist[0].Rating_Status__c == 'Marketing Release') {
                        opp.Rating_Status__c = 'Sold';
                    }
                }
                update opp;
                if (opp.Rating_Status__c == 'Sold') {
                    opp.Rating_Status__c = 'Finalized';
                    update opp;
                }
            }return 'SUCCESS';
        } catch (Exception e) {
            return e.getMessage();
        }
    }
}