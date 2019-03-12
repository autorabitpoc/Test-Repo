({
    closeModel: function (component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        //component.set("v.isOpen", false);
        $A.get("e.force:closeQuickAction").fire();
    },

    Yes: function (component, event, helper) {
        var action = component.get("c.Regatherall");
        action.setParams({

            "oppId": component.get("v.recordId")

        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();

            }

        });

        $A.enqueueAction(action);

    },

})