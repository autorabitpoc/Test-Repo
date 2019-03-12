({
	compInit : function(component, event, helper) {
        helper.initAccount(component, helper);
        helper.setupPicklistValue(component, "Account", "Industry", "accountIndustry");
        helper.setupPicklistValue(component, "Account", "Status__c", "accountStatus");
        
        // SFDC-4752 - 07/2017 - Shuyler - Begin //
        helper.setUpStatePicklist(component,"accountBillingState")
        // SFDC-4752 - 07/2017 - Shuyler - End  //
        
        if(component.get("v.showList")) {
        	helper.createContactsList(component);	
            helper.createCompetitorsAndVendorsList(component);
            helper.createGroupProducersList(component);
            helper.createActivitiesList(component);
            helper.createAttachmentsList(component);    
        }
	},
    
    addNewNoteOrTask : function(component, event, helper) {
        helper.openAddNewNoteOrTaskModal(component);
    },
    
    openLandingPage : function(component, event, helper) {
        helper.openLandingPageHelper(component);
    },
    
    save : function(component, event, helper) {
        helper.saveRecord(component, helper);
    }
})