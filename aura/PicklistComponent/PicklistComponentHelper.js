({
    fetchPickListVal: function(component, objectName, fieldName, elementId) {
        console.log('v.objInfo:');
        console.log(objectName);
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objectStr": objectName,
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
 
                /*if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        
                        label: "--- None ---",
                        value: ""
                    });
                }*/
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
})