({
    compInit : function(component, event, helper) {
    	helper.initNote(component);    
    },
    
	close : function(component, event, helper) {
		helper.destroyComp(component);
	},
    
    save : function(component, event, helper) {
		helper.saveChanges(component);
	}
})