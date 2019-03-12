({
    compInit : function(component, event, helper) {
        helper.setupPicklist(component, "AccountContactRelation", "Roles");
    },
    
	closeComp : function(component, event, helper) {
		helper.destroyComp(component);
	},
    
    addRelationship : function(component, event, helper) {
        helper.saveACRelationshipToServer(component, "accountLookup");
    },
    
    updateFieldInfo : function(component, event, helper) {
        helper.updateTypeMap(component, event);
        helper.updateIdMap(component, event);
    }
})