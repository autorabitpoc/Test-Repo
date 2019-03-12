({
    destroyComponent : function(component) {
        component.destroy();
    },
    
    setupPicklistValue : function(component, objectApi_name, field_name, compId) {
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
                component.get("v.newCompVendRel")[field_name] = defaultValue;
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
    
    updateChosenValues : function(component, event, fieldName, picklistId) {
        component.get("v.newCompVendRel")[fieldName] = component.find(picklistId).get("v.value");
    },
    
    updateTypeMap : function(component, event) {
        var uniqueName = event.getParam('uniqueName');
        var sobjectType = event.getParam('sobjectType');
        
        var typeMap = component.get("v.typeMap");
        typeMap[uniqueName] = sobjectType;
        component.set("v.typeMap", typeMap);
    },
    
    updateIdMap : function(component, event) {
        var uniqueName = event.getParam('uniqueName');
        var recordId = event.getParam('recordId');
        
        var idMap = component.get("v.idMap");
        idMap[uniqueName] = recordId;
        component.set("v.idMap", idMap);
    },
    
    saveRecord : function(component) {
        //Populate fields that need to be manually populated
        component.get("v.newCompVendRel").Competitor_Account__c = component.get("v.idMap")["compVendAccountLookup"];
        component.get("v.newCompVendRel").Group_Account__c = component.get("v.idMap")["groupAccountLookup"];
        component.get("v.newCompVendRel").Producer_Consultant_Firm__c = component.get("v.idMap")["prodConsFirmLookup"];
        component.get("v.newCompVendRel").Producer_Consultant__c = component.get("v.idMap")["prodConsLookup"];
        component.get("v.newCompVendRel").Not_Insured__c = component.find("notInsuredField").get("v.checked");
        component.get("v.newCompVendRel").AFA__c = component.find("afaField").get("v.checked");
        
        var spinner = component.find("newCompVendSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        var action = component.get("c.saveCompVendRelationship");
        
        action.setParams({ 
            compVendRel : component.get("v.newCompVendRel")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var updateCompVendListEvent = component.getEvent("updateCompVendList");
                updateCompVendListEvent.fire();
                
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
                    	alert(errors[0].pageErrors[0].message);
                    }
                } else {
                	alert("Unknown error");
            	}
                
                $A.util.toggleClass(spinner, "slds-hide");
            }
        });
        
        $A.enqueueAction(action);
    },
    
    setupDefaultMapValues : function(component, event) {
        var uniqueName = "groupAccountLookup";
        var sobjectType = "Account";
        var recordId = component.get("v.curAccount").Id;
        
        if(recordId) {
        	var typeMap = component.get("v.typeMap");
            typeMap[uniqueName] = sobjectType;
            component.set("v.typeMap", typeMap);
            
            var idMap = component.get("v.idMap");
            idMap[uniqueName] = recordId;
            component.set("v.idMap", idMap);    
        }
    }
})