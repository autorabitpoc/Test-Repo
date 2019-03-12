({
	// SFDC-4497 - 06/2017 - Shuyler - Begin //
     showCompetitorDetails : function(component, event, helper) {
		helper.showCompetitorDetailsModal (component, event);
	},   
    // SFDC-4497 - 06/2017 - Shuyler - End  //
    
    openNewCompVendModal : function(component, event, helper) {
		helper.openCompVendModal(component);
	},
    
    updateCompVendList : function(component, event, helper) {
        helper.refreshCompVendList(component);
    },
    
    toggleList : function(component, event, helper) {
        helper.toggleCompVendSection(component);
    }
})