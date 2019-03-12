({
    handleModalEvent: function (component, event, helper) {
        console.log("SGR_CensusAddEditModalHeaderController:handleModalEvent: data = " + JSON.stringify(event.getParam("data")));
        var data = event.getParam("data");
        if(data.relayStage === "toast"){
            helper.stopTimer(component);
            component.set("v.showToast", true);
            component.set("v.toastTitle", data.toastPkg.title);
            component.set("v.message", data.toastPkg.message);
            helper.startTimer(component);
        }
    },

    handleCloseClick: function (component, event, helper) {
        console.log("SGR_CensusAddEditModalHeaderController:handleClossClick: fire ");
        component.set("v.showToast", false);
    }
})