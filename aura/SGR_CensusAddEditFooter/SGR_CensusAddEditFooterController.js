({
    handleClick : function(component, event, helper) {
        if(event.getSource().get("v.label") === "Cancel"){
            component.find("overlayLib").notifyClose();
        }else{
            var appEvent = $A.get("e.c:SGR_ModalClickEvent");
            appEvent.setParams({
                "data" : {"relayStage" : "click"}
            });
            appEvent.fire();
        }
    },

    handleModalEvent: function (component, event, helper) {
        console.log("SGR_CensusAddEditModalFooterController:handleModalEvent: data = " + JSON.stringify(event.getParam("data")));
        var data = event.getParam("data");
        if(data.relayStage === "success"){
            component.find("overlayLib").notifyClose();
        }
    }
})