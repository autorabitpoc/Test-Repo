({
	appInit : function(component, event, helper) {
        helper.createLandingPage(component);
	},
    
    openSearchPage : function(component, event, helper) {
        helper.createSearchPage(component);
	},
    
    switchToAccountPage : function(component, event, helper) {
        helper.createAccountPage(component, event);
    }
})