({    
    initComp : function(component, event, helper) {
      helper.initContact(component);  
    },   
    
    closeComp : function(component, event, helper) {
        helper.destroyComp(component);
    }
})