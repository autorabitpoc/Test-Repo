({
	compInit : function(component, event, helper) {
		helper.loadFirstValue(component, helper);
	},
    
    updateSearch : function(component, event, helper) {
        var globalId = component.getGlobalId();
        var inputElement = jQuery('[id="'+globalId+'_typeahead"]');
        
        helper.searchAction(component, inputElement.val());
    }
})