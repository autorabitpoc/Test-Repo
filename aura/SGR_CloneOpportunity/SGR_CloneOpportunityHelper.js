({
    cloneOpportunity: function (component, event, helper) {
        var action = component.get("c.OppNew");
        action.setParams({
            'oppId': component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(response.getReturnValue());
            if (state === 'SUCCESS') {
                component.set("v.newOpportunity", response.getReturnValue());

            }
        });
        $A.enqueueAction(action);
    },
    callEventAuditTrail: function (component, event, helper) {
        var action = component.get("c.createEventAuditLogOld");
        action.setParams({
            'oppId': component.get('v.recordId')
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(response.getReturnValue());
            if (state === 'SUCCESS') {
                component.set("v.newOpportunity", response.getReturnValue());

            }
        });
        $A.enqueueAction(action);
    }
})