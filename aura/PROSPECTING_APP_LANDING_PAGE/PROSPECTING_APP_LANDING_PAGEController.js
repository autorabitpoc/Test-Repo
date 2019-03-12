({
	compInit : function(component, event, helper) {
		helper.createAccountLookup(component);
	},
    
    updateFieldInfo : function(component, event, helper) {
        helper.updateTypeMap(component, event);
        helper.updateIdMap(component, event);
    },
    
    showAccountPage : function(component, event, helper) {
        helper.createAccountPage(component);
        helper.destroyPage(component);
    }
})