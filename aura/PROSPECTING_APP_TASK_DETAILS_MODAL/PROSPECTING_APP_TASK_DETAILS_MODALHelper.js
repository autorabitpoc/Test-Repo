({
    initTask : function(component) {
        var curTask = component.get("v.curTask");
        component.set("v.curTaskComplete", curTask);
    },
    
	setupPicklistValues : function(component, objectApi_name, field_name, compId) {
        var action = component.get("c.getPicklistValues");
        
        action.setParams({ 
            ObjectApi_name : objectApi_name,
            Field_name : field_name
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var opts = response.getReturnValue();
                
                var defaultValue;
                if(component.get("v.curTask")[field_name]){
                    defaultValue = component.get("v.curTask")[field_name].toString();
                }
                else {
                    defaultValue = opts[0];
                }
                var cmp = component.find(compId);
                cmp.set("v.body", []); // clear all options
                var body = cmp.get("v.body");
                
                for(var i=0; i<opts.length; i++) {
                    if(opts[i] === defaultValue) {
                        $A.createComponent(
                        "aura:html",
                        {
                            tag: "option",
                            HTMLAttributes: {
                                value: opts[i],
                                text: opts[i],
                                selected: "selected"
                            }
                        },
                        
                        function (newOption) {
                            //Add options to the body
                            if (component.isValid()) {
                                body.push(newOption);
                                cmp.set("v.body", body);
                            }
                        })
                    }
                    else {
                        $A.createComponent(
                            "aura:html",
                            {
                                tag: "option",
                                HTMLAttributes: {
                                    value: opts[i],
                                    text: opts[i]
                                }
                            },
                            
                            function (newOption) {
                                //Add options to the body
                                if (component.isValid()) {
                                    body.push(newOption);
                                    cmp.set("v.body", body);
                                }
                            })
                    }
                }
                
                cmp.set("v.value", defaultValue);
            }
            else if (state === "INCOMPLETE") {
                alert("Error occurred: Picklist not initialized properly.\n Please close modal and try again.");
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
    
    destroyComp : function(component) {
        component.destroy();
    },
    
    updateTask : function(component) {
        var spinner = component.find("taskModalSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        component.get("v.curTaskComplete").Type = component.find("taskType").get("v.value");
        component.get("v.curTaskComplete").Priority = component.find("taskPriority").get("v.value"); 
        
        var action = component.get("c.updateTask");
            
        action.setParams({ 
            curTask : component.get("v.curTaskComplete") 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var taskUpdatedAppEvent = $A.get("e.c:PROSPECTING_APP_REFRESH_NOTES_TASKS_LIST_EVT");
                taskUpdatedAppEvent.setParams({ "objType" : "Task" });
                taskUpdatedAppEvent.fire();
                
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