({
    createLandingPage : function(component) {
		//call to apex method for profile access verification
		var action = component.get("c.isLightningProspecting");        
		action.setParams({ found : component.get("v.found") });
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
                
                //accepted verification goes to lightning pages, rejected goes back to classic
                if(response.getReturnValue()){
					if(this.getQueryVariable("id")) {
            			this.createAccountPage(component, null);
        			} else {
            			this.createSearchPage(component);
        			}
        		} else {
            		alert("Access denied due to insufficient profile authority.");
            		history.go(-1);
        		}
			
			//apex method callout error handling
            } else {
                if (state === "INCOMPLETE") {
                    alert("No response from server or client is offline.  Please contact system admin.");
				} else {
                    if (state === "ERROR") {
						var errors = response.getError();
						if (errors) {
							if (errors[0] && errors[0].message) {
								console.log("Error message: " + errors[0].message);
							}
                        }
                    } else {
						console.log("Unknown error");
					}
                }
			}
        });
		$A.enqueueAction(action);
    },
    
	createSearchPage : function(component) {
        var url = window.location.href;
        var newUrl = url.split("?")[0];
        window.history.pushState({path:newUrl},'',newUrl);
        
        $A.createComponent(
            "c:PROSPECTING_APP_LANDING_PAGE", {}, 
            function(responseComponent, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var target = component.find("pageHolder");
                    var body = target.get("v.body");
                    body.push(responseComponent);
                    target.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    alert("No response from server or client is offline.  Please contact system admin.");
					// Show offline error
                }
                else if (status === "ERROR") {
                	alert("Error: " + errorMessage);
                    // Show error message                    
                }
            }
        );
    },
    
    createAccountPage : function(component, event) {
		if(event && event.getParam('recordId') && event.getParam('sobjectType')) {
            component.set("v.accountId", event.getParam('recordId'));  
            component.set("v.sobjectType", event.getParam('sobjectType'));
        }
        else if(this.getQueryVariable("id")) {
            component.set("v.accountId", this.getQueryVariable("id"));
            component.set("v.sobjectType", "Account");
        } 
        else {
            component.set("v.accountId", "");  
            component.set("v.sobjectType", "");
        }
        
        if(!this.getQueryVariable("id")) {
        	var url = window.location.href;
            var newUrl = url.split("?")[0] + "?" + component.get("v.accountId");
            window.history.pushState({path:newUrl},'',newUrl);    
        }
        
        var action = component.get("c.queryRecord");
        action.setParams({
            "sobjectType" : component.get("v.sobjectType"),
            "recordId" : component.get("v.accountId")
        });

        action.setCallback(this, function(result) {
            var account = (result.getReturnValue() ? result.getReturnValue() : component.get('v.defaultAccount'));
            
            $A.createComponent(
                "c:PROSPECTING_APP_ACCOUNT_PAGE",
                {
                    "currentAccount" : account
                },
                function(responseComponent, status, errorMsg){                
                     if (status === "SUCCESS") {
                        var target = component.find("pageHolder");
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
                }
            );
        });
        $A.enqueueAction(action);  
    },
    
    getQueryVariable : function(variable) {
        var query = window.location.search.substring(1);
        var vars = query.split("&");
        for (var i=0;i<vars.length;i++) {
            var pair = vars[i].split("=");
            if(pair[0] == variable){return pair[1];}
        }
        
        return(false);
    }
})