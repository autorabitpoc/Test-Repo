({
    showRelatedAccountsModal : function(component, event) {
        var spinner = component.find("contactListSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        var action = component.get("c.queryContactAccountsInfo");
        
        action.setParams({
            'contactId' : event.getParam("sobjectRecord").Id
        });
        
        action.setCallback(this, function(result) {            
            
            var accountContactRelations = (result.getReturnValue().AccountContactRelations ? 
                                           result.getReturnValue().AccountContactRelations : 
                                           component.get('v.emptyAccountContactRelations'));
            
            $A.createComponent(
                "c:PROSPECTING_APP_RELATED_ACCOUNTS_MODAL",
                {
                    "accountContactRelations" : accountContactRelations
                },
                function(responseComponent, status, errorMsg){                
                    if (status === "SUCCESS") {
                        var target = component.find("relatedAccountsModal");
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
        });
        $A.enqueueAction(action); 
    },
    
    showAccountContactRelationModal : function(component, event) {
        var spinner = component.find("contactListSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        $A.createComponent(
            "c:PROSPECTING_APP_NEW_CONTACT_RELATIONSHIP_MODAL",
            {
                "currentContact" : event.getParam("sobjectRecord")
            },
            function(responseComponent, status, errorMsg) {                
                if (status === "SUCCESS") {
                    var target = component.find("newAccountContactRelationshipModal");
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
    
    createContactModal : function(component) {
        var spinner = component.find("contactListSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        $A.createComponent(
            "c:PROSPECTING_APP_NEW_CONTACT_MODAL",
            {
                "curAccount" : component.get("v.curAccount")
            },
            function(responseComponent, status, errorMsg) {                
                if (status === "SUCCESS") {
                    var target = component.find("newContactModal");
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
    
    queryAccountContacts : function(component) {
        var action = component.get("c.getAccountContacts");
        
        action.setParams({
            "curAccount" : component.get("v.curAccount")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.accountContacts", response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                alert("Error occurred: Contact list did not update.\n Refresh the app.");
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
                }
        });
        
        $A.enqueueAction(action);
    },
    
    toggleContactSection : function(component) {
        var toggleContactList = component.find("contactList");
        $A.util.toggleClass(toggleContactList, "slds-hide");
        $A.util.toggleClass(toggleContactList, "slds-show");
        
        var toggleCollapseBtn = component.find("collapseContactList");
        $A.util.toggleClass(toggleCollapseBtn, "slds-hide");
        $A.util.toggleClass(toggleCollapseBtn, "slds-show");
        
        var toggleExpandBtn = component.find("expandContactList");
        $A.util.toggleClass(toggleExpandBtn, "slds-hide");
        $A.util.toggleClass(toggleExpandBtn, "slds-show");
        
        var toggleLabel = component.find("contactListLabel");
        $A.util.toggleClass(toggleLabel, "slds-hide");
        $A.util.toggleClass(toggleLabel, "slds-show");
    },
    
    //--- SFDC-4497 - 06/2017 - SHUYLER - BEGIN -
    showContactDetailsModal : function(component, event) {
        
        console.log('**** INSIDE PROSPECTING_APP_CONTACT_LIST:Helper:showContactDetailsModal');
        
        var spinner = component.find("contactListSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        //-- Call ProspectingAppContactListContoller>ProspectingAppUtilityClass.queryContactInfo() --
        var action = component.get("c.queryContactDetailsInfo");
        
        action.setParams({
            'contactId' : event.getParam("sobjectRecord").Id
        });
        
        action.setCallback(this, function(result) {
            var aContactWithDetails;
            
            
            if (result.getState() === "SUCCESS") {
                console.log('Success');
                aContactWithDetails = result.getReturnValue();
                console.log('Contact Detials'+aContactWithDetails);
            }else{
                aContactWithDetails = component.get('v.emptyContact');
            }
            
            $A.createComponent(
                "c:PROSPECTING_APP_EXISTING_CONTACT_MODAL",
                {
                    "currentContactInModal" : aContactWithDetails
                },
                function(responseComponent, status, errorMsg){
                    if (status === "SUCCESS") {
                        var target = component.find("contactDetailsModal");
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