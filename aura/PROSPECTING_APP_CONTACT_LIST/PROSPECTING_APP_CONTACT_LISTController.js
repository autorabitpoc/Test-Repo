({    
    // SFDC-4497 - 06/2017 - Shuyler - Begin //
     showContactDetails : function(component, event, helper) {
		helper.showContactDetailsModal (component, event);
	},   
    // SFDC-4497 - 06/2017 - Shuyler - End  //
     
    showRelatedAccounts : function(component, event, helper) {
		helper.showRelatedAccountsModal(component, event);
	},
    
    openAccountContactRelation : function(component, event, helper) {
		helper.showAccountContactRelationModal(component, event);
	},
    
    openNewContactModal : function(component, event, helper) {
        helper.createContactModal(component);
    },
    
    updateContactList : function(component, event, helper) {
        helper.queryAccountContacts(component);
    },
    
    toggleList : function(component, event, helper) {
        helper.toggleContactSection(component);
    }
})