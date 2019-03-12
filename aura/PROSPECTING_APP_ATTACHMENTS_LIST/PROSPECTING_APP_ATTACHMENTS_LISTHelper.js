({
	createNewAttachmentModal : function(component) {
        var spinner = component.find("attachmentListSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
		$A.createComponent(
            "c:PROSPECTING_APP_UPLOAD_ATTACHMENT_MODAL", 
            {
                "parentId" : component.get("v.curAccount").Id
            }, 
            function(responseComponent, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var target = component.find("attachmentModal");
                    var body = target.get("v.body");
                    body.push(responseComponent);
                    target.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    alert("No response from server or client is offline.");
                    // Show offline error
                }
                else if (status === "ERROR") {
                	alert("Error: " + errorMessage);
                    // Show error message
                }
                
                $A.util.toggleClass(spinner, "slds-hide");
            }
        );
	},
    
    getAccountAttachments : function(component) {
        var action = component.get("c.queryAccountAttachments");
        
        action.setParams({ 
            curAccount : component.get("v.curAccount")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var attachments = response.getReturnValue();
                
                for(var i=0; i<attachments.length; i++) {
                    attachments[i].CreatedDate = attachments[i].CreatedDate.substring(0, 10); 
                }
                
                component.set("v.accountAttachments", attachments);
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
    
    formatAttachmentDates : function(component) {
        var attachments = component.get("v.accountAttachments");
        
        for(var i=0; i<attachments.length; i++) {
            attachments[i].CreatedDate = attachments[i].CreatedDate.substring(0, 10); 
        }
        
        component.set("v.accountAttachments", attachments);
    },
    
    toggleAttachmentSection : function(component) {
		var toggleAttachmentList = component.find("attachmentList");
        $A.util.toggleClass(toggleAttachmentList, "slds-hide");
        $A.util.toggleClass(toggleAttachmentList, "slds-show");
        
        var toggleCollapseBtn = component.find("collapseAttachmentList");
        $A.util.toggleClass(toggleCollapseBtn, "slds-hide");
        $A.util.toggleClass(toggleCollapseBtn, "slds-show");
        
        var toggleExpandBtn = component.find("expandAttachmentList");
        $A.util.toggleClass(toggleExpandBtn, "slds-hide");
        $A.util.toggleClass(toggleExpandBtn, "slds-show");
        
        var toggleLabel = component.find("attachmentListLabel");
        $A.util.toggleClass(toggleLabel, "slds-hide");
        $A.util.toggleClass(toggleLabel, "slds-show");
	}
})