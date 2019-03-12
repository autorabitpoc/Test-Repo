({
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
                
                var defaultValue = opts[0];
                var cmp = component.find(compId);
                cmp.set("v.body", []); // clear all options
                var body = cmp.get("v.body");
                
                opts.forEach(function (opt) {
                    $A.createComponent(
                        "aura:html",
                        {
                            tag: "option",
                            HTMLAttributes: {
                                value: opt,
                                text: opt
                            }
                        },
                        
                        function (newOption) {
                            //Add options to the body
                            if (component.isValid()) {
                                body.push(newOption);
                                cmp.set("v.body", body);
                            }
                        })
                });
                
                cmp.set('v.value', defaultValue);
                component.get("v.newTask")[field_name] = defaultValue;
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
    
    togglePicklistVisibility : function(component) {
        var toggleType = component.find("taskType");
        var togglePriority = component.find("taskPriority");
        
        if(component.find("objType").get("v.value") === "Task") {
			$A.util.removeClass(toggleType, "slds-hide");
            $A.util.removeClass(togglePriority, "slds-hide");
        }
        else {
            $A.util.addClass(toggleType, "slds-hide");
            $A.util.addClass(togglePriority, "slds-hide");
        }
    },
    
	destroyComp : function(component) {
		component.destroy();
	},
    
    saveRecord : function(component) {
        var type = component.find("objType").get("v.value");
        var title = component.find("objTitle").get("v.value");
        var content = component.find("objContent").get("v.value");
        
        var spinner = component.find("notesAndTasksModalSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        if(type==="Note") {
            component.get("v.newNote").Title = title;
            component.get("v.newNote").Body = content;
            component.get("v.newNote").ParentId = component.get("v.curAccount").Id;
            
            var action = component.get("c.saveNote");
            
        	action.setParams({ 
                newNote : component.get("v.newNote") 
            });
			
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var noteCreatedAppEvent = $A.get("e.c:PROSPECTING_APP_REFRESH_NOTES_TASKS_LIST_EVT");
                    noteCreatedAppEvent.setParams({ "objType" : "Note" });
                    noteCreatedAppEvent.fire();
                    
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
        else if(type==="Task") {
            component.get("v.newTask").Subject = title;
            component.get("v.newTask").Description = content;
            component.get("v.newTask").Type = component.find("taskType").get("v.value");
            component.get("v.newTask").Priority = component.find("taskPriority").get("v.value");
            component.get("v.newTask").WhatId = component.get("v.curAccount").Id;
            
            var action = component.get("c.saveTask");
            
        	action.setParams({ 
                newTask : component.get("v.newTask") 
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var taskCreatedAppEvent = $A.get("e.c:PROSPECTING_APP_REFRESH_NOTES_TASKS_LIST_EVT");
                    taskCreatedAppEvent.setParams({ "objType" : "Task" });
                    taskCreatedAppEvent.fire();
                    
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
        else {
        	alert("Unknown Object Type Selected");    
        }
    }
})