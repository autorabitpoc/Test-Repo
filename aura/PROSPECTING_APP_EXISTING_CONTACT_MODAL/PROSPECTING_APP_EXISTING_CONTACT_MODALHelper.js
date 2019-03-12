({
	initContact : function(component) {
        var curContact = component.get("v.currentContactInModal");  
        console.log('Current val'+curContact.LastName);
        component.set("v.currentContactCompleteInModal", curContact);
    },  
 
    destroyComp : function(component) {
		component.destroy();
	}
})