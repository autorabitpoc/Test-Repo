({
    
    initCompetitor : function(component,event,helper) {
        var curCompetitor = component.get("v.currentCompetitorInModal");  
        console.log('Current val'+curCompetitor.Id);
        component.set("v.currentCompetitorCompleteInModal", curCompetitor);        
    },
    
    destroyComp : function(component) {
        component.destroy();
    },
    
    setupPicklistValue : function(component, objectApi_name, field_name, compId) {
        
        //Calling the ProspectingAppNewCompVendModalController:getPicklistValues() Apex class
        var action = component.get("c.getPicklistValues");
        
        action.setParams({ 
            ObjectApi_name : objectApi_name,
            Field_name : field_name
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var opts = response.getReturnValue();
                
                var cmp = component.find(compId);
                cmp.set("v.body", []); // clear all options
                var body = cmp.get("v.body");
                
                opts.forEach(function (opt) {
                    
                    var selected = "false";
                    
                    //Dynamically build the String for Comparison
                    var str1 = "v.currentCompetitorCompleteInModal.";
                    var theTargetField = str1.concat(field_name);
                    
                    // Set that value as Selected if it is the value currently on Record
                    if (opt == component.get(theTargetField)){
                        selected = "true"
                        }
                    
                    $A.createComponent(
                        "aura:html",
                        {
                            tag: "option",
                            HTMLAttributes: {
                                value: opt,
                                text: opt,
                                selected: selected
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
    }            
})