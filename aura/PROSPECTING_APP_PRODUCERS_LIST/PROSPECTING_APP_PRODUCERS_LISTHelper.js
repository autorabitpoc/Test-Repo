({
	createNewProdGrpAssocModal : function(component) {
        var spinner = component.find("producerListSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
		$A.createComponent(
                "c:PROSPECTING_APP_NEW_PROD_ASSOC_MODAL",
                {
                    "curAccount" : component.get("v.curAccount")
                },
                function(responseComponent, status, errorMsg) {                
                    if (status === "SUCCESS") {
                        var target = component.find("prodGroupAssocModal");
                        var body = target.get("v.body");
                        body.push(responseComponent);
                        target.set("v.body", body); 
                    }
                    else if (status === "INCOMPLETE") {
                        alert("No response from server or client is offline.");
                    }
                    else if (status === "ERROR") {
                    	alert("Error: " + errorMsg);
                    }
                    
                    $A.util.toggleClass(spinner, "slds-hide");
                }
            );
	},
    
    refreshProducerGroupAssocList : function(component) {
        var action = component.get("c.queryAccountProdGroupAssocList");
        
        action.setParams({ 
            curAccount : component.get("v.curAccount")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.accountProducers", response.getReturnValue());
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
    
    toggleProducerSection : function(component) {
		var toggleProducerList = component.find("producerList");
        $A.util.toggleClass(toggleProducerList, "slds-hide");
        $A.util.toggleClass(toggleProducerList, "slds-show");
        
        var toggleCollapseBtn = component.find("collapseProducerList");
        $A.util.toggleClass(toggleCollapseBtn, "slds-hide");
        $A.util.toggleClass(toggleCollapseBtn, "slds-show");
        
        var toggleExpandBtn = component.find("expandProducerList");
        $A.util.toggleClass(toggleExpandBtn, "slds-hide");
        $A.util.toggleClass(toggleExpandBtn, "slds-show");
        
        var toggleLabel = component.find("producerListLabel");
        $A.util.toggleClass(toggleLabel, "slds-hide");
        $A.util.toggleClass(toggleLabel, "slds-show");
	}
})