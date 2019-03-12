({
	destroyComp : function(component) {
		component.destroy();
	},
    
    saveProducerGroupAssoc : function(component) {
		//Populate fields that need to be manually populated
        component.get("v.newProducerGroupAssoc").Group_Account__c = component.get("v.idMap")["groupAccountLookup"];
        component.get("v.newProducerGroupAssoc").Producer_Account__c = component.get("v.idMap")["producerAccountLookup"];
        component.get("v.newProducerGroupAssoc").Primary__c = component.find("primary").get("v.checked");
        
        var spinner = component.find("newProdGroupAssocSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        var action = component.get("c.saveProdGroupAssoc");
        
        action.setParams({ 
            newProdGrpAssoc : component.get("v.newProducerGroupAssoc")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var updateProdGroupAssocListEvent = component.getEvent("updateProdGroupAssocList");
                updateProdGroupAssocListEvent.fire();
                
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