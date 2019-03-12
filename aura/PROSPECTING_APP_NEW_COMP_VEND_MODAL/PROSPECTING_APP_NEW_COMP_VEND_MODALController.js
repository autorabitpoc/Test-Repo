({
	closeComp : function(component, event, helper) {
		helper.destroyComponent(component);
	},
    
    compInit : function(component, event, helper) {
        helper.setupPicklistValue(component, "Competitor_Relationship__c", "Status__c", "compVendStatus");
        helper.setupPicklistValue(component, "Competitor_Relationship__c", "Accums_Data_Shared__c", "claimsDataShared");
        helper.setupPicklistValue(component, "Competitor_Relationship__c", "Claims_Data_Shared__c", "eligibilityDataShared");
        helper.setupPicklistValue(component, "Competitor_Relationship__c", "Discharge_Data_Shared__c", "labDataShared");
        helper.setupPicklistValue(component, "Competitor_Relationship__c", "Eligibility_Data_Shared__c", "dischargeDataShared");
        helper.setupPicklistValue(component, "Competitor_Relationship__c", "Lab_Data_Shared__c", "accumsDataShared");
        helper.setupPicklistValue(component, "Competitor_Relationship__c", "Pharmacy_Data_Shared__c", "pharmacyDataShared");
        helper.setupDefaultMapValues(component);
    },
    
    updateStatusPicklistChosenValue : function(component, event, helper) {
        helper.updateChosenValues(component, event, "Status__c", "compVendStatus");
    },
    
    updateClaimsPicklistChosenValue : function(component, event, helper) {
        helper.updateChosenValues(component, event, "Claims_Data_Shared__c", "claimsDataShared");
    },
    
    updateEligibilityPicklistChosenValue : function(component, event, helper) {
        helper.updateChosenValues(component, event, "Eligibility_Data_Shared__c", "eligibilityDataShared");
    },
    
    updateLabPicklistChosenValue : function(component, event, helper) {
        helper.updateChosenValues(component, event, "Lab_Data_Shared__c", "labDataShared");
    },
    
    updateDischargePicklistChosenValue : function(component, event, helper) {
        helper.updateChosenValues(component, event, "Discharge_Data_Shared__c", "dischargeDataShared");
    },
    
    updateAccumsPicklistChosenValue : function(component, event, helper) {
        helper.updateChosenValues(component, event, "Accums_Data_Shared__c", "accumsDataShared");
    },
    
    updatePharmacyPicklistChosenValue : function(component, event, helper) {
        helper.updateChosenValues(component, event, "Pharmacy_Data_Shared__c", "pharmacyDataShared");
    },
    
    updateFieldInfo : function(component, event, helper) {
        helper.updateTypeMap(component, event);
        helper.updateIdMap(component, event);
    },
    
    save : function(component, event, helper) {
        helper.saveRecord(component);
    }
})