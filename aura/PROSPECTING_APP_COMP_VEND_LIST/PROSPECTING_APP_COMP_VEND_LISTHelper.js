({
    openCompVendModal : function(component) {
        var spinner = component.find("compVendListSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        $A.createComponent(
            "c:PROSPECTING_APP_NEW_COMP_VEND_MODAL",
            {
                "curAccount" : component.get("v.curAccount")    
            },
            function(responseComponent, status, errorMsg){                
                if (status === "SUCCESS") {
                    var target = component.find("newCompAndVendsModal");
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
    
    refreshCompVendList : function(component) {
        var action = component.get("c.queryAccountCompetitorsAndVendorsList");
        
        action.setParams({ 
            curAcc : component.get("v.curAccount")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.accountCompetitorsAndVendors", response.getReturnValue());
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
    
    toggleCompVendSection : function(component) {
		var toggleContactList = component.find("compVendList");
        $A.util.toggleClass(toggleContactList, "slds-hide");
        $A.util.toggleClass(toggleContactList, "slds-show");
        
        var toggleCollapseBtn = component.find("collapseCompVendList");
        $A.util.toggleClass(toggleCollapseBtn, "slds-hide");
        $A.util.toggleClass(toggleCollapseBtn, "slds-show");
        
        var toggleExpandBtn = component.find("expandCompVendList");
        $A.util.toggleClass(toggleExpandBtn, "slds-hide");
        $A.util.toggleClass(toggleExpandBtn, "slds-show");
        
        var toggleLabel = component.find("compVendListLabel");
        $A.util.toggleClass(toggleLabel, "slds-hide");
        $A.util.toggleClass(toggleLabel, "slds-show");
	},
    
    //--- SFDC-4497 - 06/2017 - SHUYLER - BEGIN -    
    showCompetitorDetailsModal : function(component, event) {
        
        console.log('**** INSIDE PROSPECTING_APP_CONTACT_LIST:Helper:showCompetitorDetailsModal');
        
        var spinner = component.find("contactListSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        //-- Call ProspectingAppContactListContoller>ProspectingAppUtilityClass.queryContactInfo() --
        var action = component.get("c.getExistingCompetitorDetails");
        
        action.setParams({
            'competitorId' : event.getParam("sobjectRecord").Id
        });
        
        action.setCallback(this, function(result) {
            var aCompetitorWithDetails;
            
            
            if (result.getState() === "SUCCESS") {
                console.log('Success');
                aCompetitorWithDetails = result.getReturnValue();
                console.log('Competitor Detials'+aCompetitorWithDetails);
            }else{
                aCompetitorWithDetails = component.get('v.emptyCompetitor');
            }
            
            $A.createComponent(
                "c:PROSPECTING_APP_EXISTING_COMPETITOR_MODAL",
                {
                    "currentCompetitorInModal" : aCompetitorWithDetails
                },
                function(responseComponent, status, errorMsg){
                    if (status === "SUCCESS") {
                        var target = component.find("competitorDetailsModal");
                        var body = target.get("v.body");                    
                        body.push(responseComponent);                    
                        target.set("v.body", body);                        
                    } 
                    else if (status === "INCOMPLETE") {
                        alert("No response from server or client is offline.");
                    } 
                        else if (status === "ERROR"){
                            alert("Error: " + errorMsg);                                   
                        }
                    
                    $A.util.toggleClass(spinner, "slds-hide"); 
                }
            );
        });
        $A.enqueueAction(action); 
    }    
    //--- SFDC-4497 - 06/2017 - SHUYLER - END -    
})