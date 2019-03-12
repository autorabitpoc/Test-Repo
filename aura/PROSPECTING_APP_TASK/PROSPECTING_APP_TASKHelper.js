({
	setCheckboxValue : function(component) {
        var status = component.get("v.curTask").Status;
        
        if(status === "Completed") {
            component.find("taskDoneBox").set("v.value", true);
        }
        else {
            component.find("taskDoneBox").set("v.value", false);
        }
    },
    
    updateTaskRecord : function(component) {
        if(component.find("taskDoneBox").get("v.value")) {
            component.get("v.curTask").Status = "Completed";
        }
        else {
            component.get("v.curTask").Status = "In Progress";
        }
        
        var action = component.get("c.updateTask");
            
        action.setParams({ 
            curTask : component.get("v.curTask") 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
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
    
    createTaskModal : function(component) {
        var spinner = component.find("taskSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        $A.createComponent(
            "c:PROSPECTING_APP_TASK_DETAILS_MODAL", 
            {
                "curTask" : component.get("v.curTask")
            }, 
            function(responseComponent, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var target = component.find("taskDetails");
                    var body = target.get("v.body");
                    body.push(responseComponent);
                    target.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    alert("No response from server or client is offline.");
                    // Show offline error
                }
                else if (status === "ERROR") {
                	alert("Error: " + errorMessage);
                    // Show error message
                }
                
                $A.util.toggleClass(spinner, "slds-hide");
            }
        );
    }
})