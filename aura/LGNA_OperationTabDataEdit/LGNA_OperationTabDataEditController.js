({
    
    doInit: function(component, event, helper) {  
        console.log("Edit Controller doInit called"); 
        //Rakesh
        helper.callServer(component,
                               "c.getFieldAccess", 
                               function(response){
                                //alert(response);
                                   component.set("v.accountCRUDMap",response);
                                   var z= JSON.stringify(response);
                                 //alert(z);
                               },{ 
                                 }
                              );
       //call server to check if current user has ModifyAll permission, like systm admin
      helper.callServer(component,"c.hasModifyAllPermission",
                          function (response){
                               
                              console.log("has modifyall perm?:::"+response);
                              component.set("v.hasModifyAll",response);
                            
                          });
       
      
    },
    
    handleSaveRecord: function(component, event, helper) {
        
        console.log("Edit Controller handleSaveRecord called!");
        component.set("v.Spinner",true);
        component.find("recordHandlerEdit").saveRecord($A.getCallback(function(saveResult) {
            
            // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful 
            // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
            
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // handle component related logic in event handler
                
                console.log("Edit Controller handleSaveRecord:SUCCESS called!"); 
               component.set("v.Spinner",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been updated successfully.",
                    "type":"success"
                });
                toastEvent.fire(); 
                
                //Clear any previous ERROR messages that might have been set
                 component.set("v.recordEditError", ""); 
                
                component.set("v.curView", "baseView" ); 
                
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                
                console.log("Edit Controller handleSaveRecord:ERROR called!"); 
                
                console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                
                var errMsg = "";
                // saveResult.error is an array of errors, 
                // so collect all errors into one message
                for (var i = 0; i < saveResult.error.length; i++) {
                    errMsg += saveResult.error[i].message + "\n";
                }
                
                console.log('errMsg: ' + errMsg);
                
                // Set into the Lightning Data Service Section on the Component
                component.set("v.recordEditError", errMsg);     
                
                //show ERROR Toast
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": errMsg,
                    "type": "error",
                    "mode": "sticky"
                });
                toastEvent.fire(); 
                
                console.log('Error Toasted');
                
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));        
    },
    
    /**
     * Control the component behavior here when record is changed (via any component)
     */
    handleRecordUpdated: function(component, event, helper) {
        
        console.log("Edit Controller handleRecordUpdated called!");
        
        var eventParams = event.getParams();
        if(eventParams.changeType === "CHANGED") {
            
            console.log("Edit Controller handleRecordUpdated:CHANGED called!");
            
            // get the fields that changed for this record
            var changedFields = eventParams.changedFields;
            console.log('Fields that are changed: ' + JSON.stringify(changedFields));
            
        } else if(eventParams.changeType === "LOADED") {
            
            console.log("Edit Controller handleRecordUpdated:LOADED called!");            
            
            var theRecordId = component.get("v.recordId");
            console.log('v.recordID' + theRecordId);  
            
            helper.fetchPickListVal(component, 'Line_of_business__c', 'lineOfBusiness') 
            helper.fetchPickListVal(component, 'Ceded_From_ICL__c', 'CededFromICL');
            helper.fetchPickListVal(component, 'Ceded_To_ACL__c', 'CededToACL'); 
            helper.fetchPickListVal(component, 'Funding_Type__c', 'fundtype');
            helper.fetchPickListVal(component, 'Premium_Type__c', 'Premtype');
            helper.fetchPickListVal(component, 'COBRA_Administration_Type__c', 'cobratype');
           
            //Rakesh-Start
         /*   helper.callServer(component,
                               "c.getFieldAccess", 
                               function(response){
                                alert(response);
                                   component.set("v.accMap",response);
                                   var z= JSON.stringify(response);
                                 alert(z);
                               },{ 
                                 }
                              );
       
            //Rakesh-End
            //*/
            
            
        } else if(eventParams.changeType === "REMOVED") {
            
            console.log("Edit Controller handleRecordUpdated:REMOVED called!");
            
            // record is deleted and removed from the cache
            
        } else if(eventParams.changeType === "ERROR") {
            
            console.log("Edit Controller handleRecordUpdated:ERROR called!");
            
            // there’s an error while loading, saving or deleting the record
        }
    },
    
    //Expand & Collapse Renewal Information Section 
    RenewalInformationSectionClick : function(component, event, helper) {
        helper.ExpandCollapseSection(component,event,'RenewalInformationSection');
    },
    
    //Expand & Collapse Group Type Information Section 
    GroupTypeSectionClick : function(component, event, helper) {
        helper.ExpandCollapseSection(component,event,'GroupTypeSection');
    },
    
    //Expand & Collapse Address Information Section 
    AddressInformationSectionClick : function(component, event, helper) {
        helper.ExpandCollapseSection(component,event,'AddressInformationSection');
    },
    
    //Expand & Collapse Blue STAR Team Information Section 
    BlueSTARTeamInformationSectionClick : function(component, event, helper) {
        helper.ExpandCollapseSection(component,event,'BlueSTARTeamInformationSection');
    },
    
    //Expand & Collapse Cancellation Information Section 
    CancellationInformationSectionClick : function(component, event, helper) {
        helper.ExpandCollapseSection(component,event,'CancellationInformationSection');
    },
    
      CedeInformationSectionClick : function(component, event, helper) {
        helper.ExpandCollapseSection(component,event,'CedeInformationSection');
    },
    
    cancelSaveRecord : function(component, event, helper){
        
        //Clear any previous ERROR messages that might have been set
        component.set("v.recordEditError", ""); 
        
        component.set("v.curView", "baseView" );
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    }
    
})