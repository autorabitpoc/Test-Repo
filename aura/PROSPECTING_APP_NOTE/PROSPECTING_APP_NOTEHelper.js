({
	createNoteModal : function(component) {
        var spinner = component.find("noteSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
		$A.createComponent(
            "c:PROSPECTING_APP_NOTE_DETAILS_MODAL", 
            {
                "curNote" : component.get("v.curNote")
            }, 
            function(responseComponent, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var target = component.find("noteDetails");
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
                
                $A.util.toggleClass(spinner, "slds-hide");
            }
        );
	}
})