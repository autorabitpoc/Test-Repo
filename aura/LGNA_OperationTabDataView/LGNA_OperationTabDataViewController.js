({    
    doInit: function(component) {  
        console.log("View Controller doInit called"); 
    },    
   
    /**
     * Control the component behavior here when record is changed (via any component)
     */
    handleRecordUpdated: function(component, event, helper) {
        
        console.log("View Controller handleRecordUpdated called!");
        
        var eventParams = event.getParams();
        if(eventParams.changeType === "CHANGED") {
            
            console.log('View Controller handleRecordUpdated:CHANGED called');
            
            // get the fields that changed for this record
            var changedFields = eventParams.changedFields;
            console.log('Fields that are changed: ' + JSON.stringify(changedFields));
            
            // record is changed, so refresh the component (or other component logic)            
            component.find("recordHandlerView").reloadRecord();            
            
        } else if(eventParams.changeType === "LOADED") {
            // record is loaded in the cache            
            
            console.log('View Controller handleRecordUpdated:LOADED called');          
            
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted and removed from the cache
            
            console.log('View Controller handleRecordUpdated:REMOVED called');          
             
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving or deleting the record
            
            console.log('View Controller handleRecordUpdated:ERROR called');          
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
    
    editRecordHandler : function(component, event, helper) {
	component.set("v.curView", "editView");
    }
 
})