({
    compInit : function(component, event, helper) {
    	helper.compSetup(component, helper);    
    },
    
	closeComp : function(component, event, helper) {
		helper.destroyComp(component);
	},
 
 	saveContact : function(component, event, helper) {
		helper.saveContactToServer(component);
	}
})