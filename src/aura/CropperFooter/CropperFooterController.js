({
    handleCancel : function(component, event, helper) {
        //closes the modal or popover from the component
        component.find("overlayLib").notifyClose();
    },
    handleOK : function(component, event, helper) {
        //do something
    },
    handleFinishCropEvent : function(component, event, helper) {
        console.log("CropperFooter:handleFinishCropEvent: FIRE");
        component.find("overlayLib").notifyClose();
    }
})