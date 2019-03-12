({  
    save : function(component, event, helper) {
        helper.save(component);
    },
    
    close : function(component, event, helper) {
        helper.destroyComp(component);
    },
    
    showSuccess : function(component, event, helper) {
        helper.showSuccessMessage(component);
    }
})