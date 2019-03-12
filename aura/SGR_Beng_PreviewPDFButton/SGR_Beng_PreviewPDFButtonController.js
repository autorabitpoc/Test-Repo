({
    doInit : function(component, event, helper) {
        //$A.get("e.force:closeQuickAction").fire();
        console.log(component.get("v.recordId"));
        var action = component.get("c.getOppData");
        action.setParams({
            "oppId" : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var OppRecord = response.getReturnValue();
            
                // get Rating Status Value
                var getRStatus = OppRecord.Rating_Status__c;
                //console.log(getRStatus+ 'checktheRatingstatus');
                var getDocversion = 'DRAFT';
                
                // Start - JIRA # SFDC - 15909 - Verify Logged in user profile name to perform the Preview PDF action- by Balasubramanyam.Peri(Accenture)
                var loggedInUserProfileName = OppRecord.CurrentUserProfileName__c;
                if((getRStatus =="Finalized" || getRStatus == "Closed" || getRStatus == "Sold" || getRStatus == "Pended" || getRStatus == "Initiated" || getRStatus == "Not Defined") && ( loggedInUserProfileName == "SGR UW User" || loggedInUserProfileName =="SGR Actuary User" ))
                {  
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error",
                        message: "Preview PDF is not available in this Oportunity Rating Status!",
                        type: "Error"
                    });
                    toastEvent.fire();
                    // End - JIRA # SFDC-15909 
                    
                }else if((getRStatus == "Rated" || getRStatus == "Actuarial-Released"|| getRStatus == "Underwriting-Released"|| getRStatus == "Marketing Release"|| getRStatus == "Closed")){
                    helper.sendToServer(component, event, helper,component.get("v.recordId"), getDocversion,OppRecord.Account.External_ID__c); 
                }else{
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Draft Renewal is not available in this Oportunity Rating Status!",
                        message: "Failed to send Request to B engaged!",
                        type: "Error"
                    });
                    toastEvent.fire(); 
                }
            }
        });
        $A.enqueueAction(action);   
        // End - JIRA # SFDC - 15909 
    }
})