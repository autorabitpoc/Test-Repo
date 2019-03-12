({
	openNewAttachmentModal : function(component, event, helper) {
		helper.createNewAttachmentModal(component);
	},
    
    refreshAttachmentList : function(component, event, helper) {
        helper.getAccountAttachments(component);
    },
    
    compInit : function(component, event, helper) {
        helper.formatAttachmentDates(component);
    },
    
    toggleList : function(component, event, helper) {
        helper.toggleAttachmentSection(component);
    }
})