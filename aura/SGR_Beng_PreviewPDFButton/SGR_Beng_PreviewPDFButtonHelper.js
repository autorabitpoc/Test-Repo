({
    sendToServer :  function(component, event, helper, recId, Docver,accNumber){  
        console.log('recId'+recId);
        var action = component.get("c.oppDetails");
        action.setParams({
            "oppId" : recId,
            "documentVersion" : Docver,
            //"printtype" : null
            "accNumber" : accNumber
        });
        action.setCallback(this, function(response){
            console.log(response.getState());
            if(response.getState() === "SUCCESS"){
                var responseVal = response.getReturnValue();
                var mapKey;
                var message;
                for(var key in responseVal){
                    mapKey = key;
                    message = responseVal[key];
                }
                $A.get("e.force:closeQuickAction").fire();
                if(mapKey!='null'){
                    $A.get('e.lightning:openFiles').fire({
                        recordIds: [mapKey]
                    });
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: message,
                        message: "Failed to send Request to B engaged!",
                        type: "Error"
                    });
                    toastEvent.fire(); 
                }
            }else{
                var cmpTarget = component.find('spinner');
                $A.util.removeClass(cmpTarget, 'slds-show');
                $A.util.addClass(cmpTarget, 'slds-hide');
                $A.get("e.force:closeQuickAction").fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Something went wrong. Please contact your Administrator!",
                    message: "Failed to send Request to B engaged!",
                    type: "Error"
                });
                toastEvent.fire(); 
            }
        });
        $A.enqueueAction(action);
    }
})