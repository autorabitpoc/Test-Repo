({
    initComp : function(component, event, helper) {
        helper.initCompetitor(component);        
        
        helper.setupPicklistValue(component, "Competitor_Relationship__c", "Claims_Data_Shared__c", "claimsDataShared");
        helper.setupPicklistValue(component, "Competitor_Relationship__c", "Eligibility_Data_Shared__c", "eligibilityDataShared");
        helper.setupPicklistValue(component, "Competitor_Relationship__c", "Lab_Data_Shared__c", "labDataShared");
        helper.setupPicklistValue(component, "Competitor_Relationship__c", "Discharge_Data_Shared__c", "dischargeDataShared");
        helper.setupPicklistValue(component, "Competitor_Relationship__c", "Accums_Data_Shared__c", "accumsDataShared");
        helper.setupPicklistValue(component, "Competitor_Relationship__c", "Pharmacy_Data_Shared__c", "pharmacyDataShared");
    },   
    
    closeComp : function(component, event, helper) {
        helper.destroyComp(component);
    }
})