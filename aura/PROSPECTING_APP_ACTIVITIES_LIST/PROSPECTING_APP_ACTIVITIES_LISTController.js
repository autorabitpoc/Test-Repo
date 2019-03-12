({
    compInit : function(component, event, helper) {
        helper.formatNoteAndTaskDates(component);
    },
    
	toggleList : function(component, event, helper) {
        helper.toggleActivitySection(component);
    },
    
    updateList : function(component, event, helper) {
        var listToUpdate = event.getParam("objType");
        
        if(listToUpdate === "Note") {
            helper.refreshNotes(component, helper);
        }
        else if(listToUpdate === "Task") {
           	helper.refreshTasks(component, helper); 
        }
    }
})