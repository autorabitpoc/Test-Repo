({
	toggleActivitySection : function(component) {
		var toggleNoteList = component.find("noteList");
        var toggleTaskList = component.find("taskList");
        $A.util.toggleClass(toggleNoteList, "slds-is-expanded");
        $A.util.toggleClass(toggleTaskList, "slds-is-expanded");
        $A.util.toggleClass(toggleNoteList, "slds-is-collapsed");
        $A.util.toggleClass(toggleTaskList, "slds-is-collapsed");
        
        /* SFDC-3799 07/2017 - BEGIN */
        var toggleHeader = component.find("TaskNoteHeader"); 
        $A.util.toggleClass(toggleHeader, "slds-is-expanded");
        /* SFDC-3799 07/2017 - BEGIN */
        
        var toggleCollapseBtn = component.find("collapseActivityList");
        $A.util.toggleClass(toggleCollapseBtn, "slds-hide");
        $A.util.toggleClass(toggleCollapseBtn, "slds-show");
        
        var toggleExpandBtn = component.find("expandActivityList");
        $A.util.toggleClass(toggleExpandBtn, "slds-hide");
        $A.util.toggleClass(toggleExpandBtn, "slds-show");
        
        var toggleLabel = component.find("activityListLabel");
        $A.util.toggleClass(toggleLabel, "slds-hide");
        $A.util.toggleClass(toggleLabel, "slds-show");
	},
    
    formatNoteAndTaskDates : function(component) {
        var notes = component.get("v.notes");
        var tasks = component.get("v.tasks");
        
        for(var i=0; i<notes.length; i++) {
            notes[i].CreatedDate = notes[i].CreatedDate.substring(0, 10); 
        }
        
        for(var i=0; i<tasks.length; i++) {
            tasks[i].CreatedDate = tasks[i].CreatedDate.substring(0, 10); 
        }
        
        component.set("v.notes", notes);
        component.set("v.tasks", tasks);
    },
    
    refreshNotes : function(component, helper) {
        var action = component.get("c.queryAccountNotes");
        
        action.setParams({ 
            curAccount : component.get("v.curAccount") 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.notes", response.getReturnValue());
                helper.formatNoteAndTaskDates(component);
            }
            else if (state === "INCOMPLETE") {
                alert("Error occurred: Process did not finish.\n Please try again.");
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
                }
        });
        
        $A.enqueueAction(action);
    },
    
    refreshTasks : function(component, helper) {
        var action = component.get("c.queryAccountTasks");
        
        action.setParams({ 
            curAccount : component.get("v.curAccount") 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.tasks", response.getReturnValue());
                helper.formatNoteAndTaskDates(component);
            }
            else if (state === "INCOMPLETE") {
                alert("Error occurred: Process did not finish.\n Please try again.");
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
                }
        });
        
        $A.enqueueAction(action);
    }
})