({
    doInit: function (component, event, helper) {
        helper.cloneOpportunity(component, event, helper);
        // helper.callEventAuditTrail(component, event, helper);
    },

    closeModel: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }


})