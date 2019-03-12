({
    doInit: function (component, event, helper) {
        var test = component.get("v.recordId");
        var Testing = component.get("c.OppHeader");
        Testing.setParams({
            oppId: component.get("v.recordId")
        });
        Testing.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var OppRecord = response.getReturnValue();
                component.set("v.Opp", OppRecord);
                component.set("v.Renewaldate", OppRecord.Renewal_Date__c);
            }
        });
        $A.enqueueAction(Testing);

    },

    refreshOptyRating: function (cmp, event, helper) {
        var message = event.getParam("message");
        cmp.set("v.messageFromEvent", message);
        var dI = cmp.get("c.doInit");
        $A.enqueueAction(dI);
    },
    refreshRatingStatus: function (cmp, event, helper) {

        var message = event.getParam("message");
        cmp.set("v.messageFromEvent", message);

        var dI = cmp.get("c.doInit");
        $A.enqueueAction(dI);
    },
    refresh: function (component, event, helper) {

        $A.get('e.force:refreshView').fire();

    },


})