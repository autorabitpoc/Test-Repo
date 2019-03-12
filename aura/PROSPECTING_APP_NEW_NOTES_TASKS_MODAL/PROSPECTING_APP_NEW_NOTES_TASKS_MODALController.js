({
    compInit : function(component, event, helper) {
        helper.setupPicklistValues(component, "Task", "Type", "taskType");
        helper.setupPicklistValues(component, "Task", "Priority", "taskPriority");
    },
    
    togglePicklistFields : function(component, event, helper) {
    	helper.togglePicklistVisibility(component);    
    },
    
	close : function(component, event, helper) {
		helper.destroyComp(component);
	},
    
    save : function(component, event, helper) {
        helper.saveRecord(component);
    }
})