({
	doInit : function(component, event, helper) {
        helper.getLoggedinUsers(component);
	},
    openModal: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    closeModal: function(component, event, helper) {
        component.set("v.isOpen", false);
    }
})