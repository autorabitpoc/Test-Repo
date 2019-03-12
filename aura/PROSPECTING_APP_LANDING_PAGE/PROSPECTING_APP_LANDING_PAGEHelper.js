({
	createAccountLookup : function(component) {
		$A.createComponent(
        	"c:PROSPECTING_APP_LOOKUP_COMPONENT",
            {
                "uniqueName" : "accountLookup",
                "sobjectType" : "Account",
                "sobjectName" : "Account",
                "filter" : component.get("v.groupAccSearchFilter")
            },
            function(responseComponent, status, errorMsg){                
                 if (status === "SUCCESS") {
                 	var target = component.find("accountLookup");
                    var body = target.get("v.body");
                    body.push(responseComponent);
                    target.set("v.body", body); 
            	}
                else if (status === "INCOMPLETE") {
                    alert("No response from server or client is offline.");
                }
                else if (status === "ERROR") {
                	alert("Error: " + errorMessage);
                }
            }
   		);
	},
    
    updateTypeMap : function(component, event) {
        var uniqueName = event.getParam('uniqueName');
        var sobjectType = event.getParam('sobjectType');
        
        var typeMap = component.get("v.typeMap");
		typeMap[uniqueName] = sobjectType;
    },
    
    updateIdMap : function(component, event) {
        var uniqueName = event.getParam('uniqueName');
        var recordId = event.getParam('recordId');
        
        var idMap = component.get("v.idMap");
		idMap[uniqueName] = recordId;
    },
    
    createAccountPage : function(component) {
        var typeMap = component.get("v.typeMap");
        var idMap = component.get("v.idMap");
        
        var appEvent = $A.get("e.c:PROSPECTING_APP_CREATE_ACCOUNT_PAGE_EVT");
        appEvent.setParams({"sobjectType" : typeMap['accountLookup'],
                             "recordId" : idMap['accountLookup']});
        appEvent.fire();
    },
    
    destroyPage : function(component) {
        component.destroy();
    }
})