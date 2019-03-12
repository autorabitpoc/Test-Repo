({
	close : function(component, event, helper) {
		helper.destroyComp(component);
	},
    
    save : function(component, event, helper) {
		helper.saveProducerGroupAssoc(component);
	},
    
    updateFieldInfo : function(component, event, helper) {
        helper.updateTypeMap(component, event);
        helper.updateIdMap(component, event);
    },
    
    compInit : function(component, event, helper) {
        helper.setupDefaultMapValues(component);
    }
})