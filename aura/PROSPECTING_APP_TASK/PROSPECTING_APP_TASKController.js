({
    compInit : function(component, event, helper) {
        helper.setCheckboxValue(component);
    },
    
	updateTaskStatus : function(component, event, helper) {
        helper.updateTaskRecord(component);
	},
    
    openTaskModal : function(component, event, helper) {
		helper.createTaskModal(component);
	}
})