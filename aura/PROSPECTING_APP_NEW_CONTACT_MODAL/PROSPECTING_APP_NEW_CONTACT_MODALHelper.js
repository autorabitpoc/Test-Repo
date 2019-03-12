({
    
    compSetup : function(component, helper) {
        helper.setupRecordTypePicklist(component, "Contact", "contactRecordType");
        
        var newCon = component.get("v.newContact"); 
        newCon.AccountId = component.get("v.curAccount").Id;
        component.set("v.newContact", newCon);
    },
    
    setupRecordTypePicklist : function(component, objectApi_name, compId) {
        var action = component.get("c.querySobjectRecordtypes");
        
        action.setParams({ 
            sobjectName : objectApi_name
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
                                value: opt.Id,
                                text: opt.Name
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
                
                cmp.set('v.value', defaultValue.Id);
                component.get("v.newContact").RecordTypeId = defaultValue.Id;
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
                            if(errors[0].pageErrors[0])
                                alert("Error message: " + errors[0].pageErrors[0].message);
                            else
                                alert("Error message: Invalid Email format");
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
    
    saveContactToServer : function(component) {
        
        var inputEmailField = component.find("inputEmail");
        var inputEmailFieldValue = inputEmailField.get("v.value");
        var isValidEmail = true;
        
        if(!$A.util.isEmpty(inputEmailFieldValue)){
            inputEmailField.set("v.errors", [{message: null}]);
            $A.util.removeClass(inputEmailField, 'slds-has-error');
            isValidEmail = true;
        }else{                
            $A.util.addClass(inputEmailField, 'slds-has-error');
            inputEmailField.set("v.errors", [{message:"Email Validation Error " + inputEmailFieldValue}]);
            isValidEmail = false;
        }        
        
        if (isValidEmail){            
            component.get("v.newContact").RecordTypeId = component.find("contactRecordType").get("v.value");
            
            var spinner = component.find("contactModalSpinner");
            $A.util.toggleClass(spinner, "slds-hide");
            
            var action = component.get("c.saveNewContact");
            
            action.setParams({ 
                newCon : component.get("v.newContact")
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var updateConListEvent = component.getEvent("updateContactList");
                    updateConListEvent.fire();
                    
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
                                if(errors[0].pageErrors[0])
                                    alert(errors[0].pageErrors[0].message);
                                else
                                    alert("Error message: Invalid email format");
                            }
                        } else {
                            alert("Unknown error");
                        }
                        
                        $A.util.toggleClass(spinner, "slds-hide");
                    }
            });
            
            $A.enqueueAction(action);           
            
        } /* here  */
        
    }
})