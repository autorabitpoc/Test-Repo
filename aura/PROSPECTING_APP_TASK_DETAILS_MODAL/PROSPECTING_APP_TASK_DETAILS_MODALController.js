({
	compInit : function(component, event, helper) {
        helper.initTask(component);
        helper.setupPicklistValues(component, "Task", "Type", "taskType");
        helper.setupPicklistValues(component, "Task", "Priority", "taskPriority");
    },
    
	close : function(component, event, helper) {
		helper.destroyComp(component);
	},
    
    save : function(component, event, helper) {
        helper.updateTask(component);
    }
})