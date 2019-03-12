({
    destroyComp : function(component) {
        component.destroy();
    },
    
    saveACRelationshipToServer : function(component, lookupFieldName) {
        var spinner = component.find("contactRelModalSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        var roles = component.find("contactRole").getElement().options;
        var rolesChosen = "";
        
        for(var i=0; i<roles.length; i++) {
            if(roles[i].selected) {
                rolesChosen += roles[i].value;
                if(i<roles.length-1) {
                    rolesChosen += "; ";
                }
            }
        }
        
        if(component.get("v.idMap")[lookupFieldName]) {
            var action = component.get("c.upsertAccountContactRelation");
            
            action.setParams({
                "contactId" : component.get("v.currentContact").Id,
                "accountId" : component.get("v.idMap")[lookupFieldName],
                "role" : rolesChosen
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
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
                                if(errors[0].pageErrors[0])
                                	alert(errors[0].pageErrors[0].message);
                                else
                                    alert("Error Message: Contact to Account relationship already exists");
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
            alert("Enter an Account");
            $A.util.toggleClass(spinner, "slds-hide");
        }
    },
    
    setupPicklist : function(component, sobjectType, sobjectField) {
        var action = component.get("c.getPicklistValues");
        
        action.setParams({
            "ObjectApi_name" : sobjectType,
            "Field_name" : sobjectField
        });
        
        action.setCallback(this, function(result) {
            component.set("v.accountContactJunctionRoles", result.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    updateTypeMap : function(component, event) {
        var uniqueName = event.getParam("uniqueName");
        var sobjectType = event.getParam("sobjectType");
        
        var typeMap = component.get("v.typeMap");
        typeMap[uniqueName] = sobjectType;
        component.set("v.typeMap", typeMap);
    },
    
    updateIdMap : function(component, event) {
        var uniqueName = event.getParam("uniqueName");
        var recordId = event.getParam("recordId");
        
        var idMap = component.get("v.idMap");
        idMap[uniqueName] = recordId;
        component.set("v.idMap", idMap);
    }
})