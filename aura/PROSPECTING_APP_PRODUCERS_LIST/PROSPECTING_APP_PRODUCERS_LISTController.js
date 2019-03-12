({
	openNewProdGrpAssocModal : function(component, event, helper) {
		helper.createNewProdGrpAssocModal(component);
	},
    
    updateProducerGroupAssocList : function(component, event, helper) {
        helper.refreshProducerGroupAssocList(component);
    },
    
    toggleList : function(component, event, helper) {
        helper.toggleProducerSection(component);
    }
})