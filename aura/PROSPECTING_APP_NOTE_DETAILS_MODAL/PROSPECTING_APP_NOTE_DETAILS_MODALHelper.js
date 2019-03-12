({
    initNote : function(component) {
        var curNote = component.get("v.curNote");
        component.set("v.curNoteComplete", curNote);
    },
    
	destroyComp : function(component) {
		component.destroy();
	},
    
    saveChanges : function(component) {
        var spinner = component.find("noteModalSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        var action = component.get("c.updateNote");
            
        action.setParams({ 
            curNote : component.get("v.curNoteComplete") 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var noteUpdatedAppEvent = $A.get("e.c:PROSPECTING_APP_REFRESH_NOTES_TASKS_LIST_EVT");
                noteUpdatedAppEvent.setParams({ "objType" : "Note" });
                noteUpdatedAppEvent.fire();
                
                $A.util.toggleClass(spinner, "slds-hide");
                
                component.destroy();
            }
            else if (state === "INCOMPLETE") {
                alert("Error occurred: Process did not finish.\n Please try again.");
                $A.util.toggleClass(spinner, "slds-hide");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " + errors[0].message);
                        }
                        else if (errors[0] && errors[0].pageErrors) {
                            alert("Error message: " + errors[0].pageErrors[0].message);
                        }
                    } else {
                        alert("Unknown error");
                    }
                    $A.util.toggleClass(spinner, "slds-hide");
                }
        });
        
        $A.enqueueAction(action);
    }
})