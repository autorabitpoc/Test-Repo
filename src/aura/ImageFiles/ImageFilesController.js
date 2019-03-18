({
    init : function(component, event, helper) {
        console.log("ImageFilesController:init:ENTER ");
        helper.retrieveVfHostUrl(component).then(
            $A.getCallback(function(result) {
                console.log("DealerImageFilesController:init: result 1 = " + JSON.stringify(result));
                component.set("v.vfHost", result);
            }),

            $A.getCallback(function(error) {
                console.log("DealerImageFilesController:init: 1st Promise was rejected: ", error);

            })
        );
        //window.name = "DealerImageFiles";
        //DELETE THIS RECORD ID CLAUSE
        /*var recordId = component.get("v.recordId");
        if(typeof(recordId) === "undefined" || recordId === null){
            component.set("v.recordId", "0011k000007z8VwAAI");
        }*/
        /*helper.retrieveVfHostUrl(component).then(

            $A.getCallback(function(result) {
                console.log("DealerImageFilesController:init: result 1 = " + JSON.stringify(result));
                //temp disabled so can test outside of community
                component.set("v.vfHost", result);
                return helper.retrieveInitialImages(component);
            }),

            $A.getCallback(function(error) {
                console.log("DealerImageFilesController:init: 1st Promise was rejected: ", error);

            })
        ).then(

            $A.getCallback(function(result) {
                console.log("DealerImageFilesController:init: result 2 = " + JSON.stringify(result));
                component.set("v.imageInfoMap", result);
                if(result != null && Object.keys(result).length > 0){
                    console.log("DealerImageFilesController:init: imageInfoMap = " + JSON.stringify(component.get("v.imageInfoMap")));
                    component.set("v.isLoading", false);
                    return helper.renderInitialComponents(component);
                }else{
                    component.set("v.isLoading", false);
                }
            }),

            $A.getCallback(function(error) {
                console.log("DealerImageFilesController:init: 2nd Promise was rejected: ", error);

            })
        ).then(

            $A.getCallback(function(result) {
                console.log("DealerImageFilesController:init: result 3 = " + JSON.stringify(result));
            }),

            $A.getCallback(function(error) {
                console.log("DealerImageFilesController:init: 3rd Promise was rejected: ", error);

            })
        );*/
    },

    handleIpClickEvent : function(component, event, helper) {
        var location = event.getParam("location");
        var data = event.getParam("data");
        console.log("DealerImageFilesController:handleIpClickEvent: location = " + location);
        console.log("DealerImageFilesController:handleIpClickEvent: data = " + JSON.stringify(data));
        if(location.toLowerCase() === "image"){
            helper.createPreviewModal(component, data);
        }
    },

    handleUploadEvent : function(component, event, helper) {
        var fileName = event.getParam("fileName");
        var contentId = event.getParam("contentId");
        component.set("v.finalContentId", contentId);
        console.log("DealerImageFilesController:handleUploadEvent: fileName = " + fileName);
        console.log("DealerImageFilesController:handleUploadEvent: contentId = " + contentId);
        helper.createCropperModal(component, fileName, contentId);
    },

    handleCropEvent : function(component, event, helper) {
        component.set("v.isLoading", true);
        var baseEncodedData = event.getParam("baseEncodedData");
        component.set("v.imgSrc", baseEncodedData);
        console.log("DealerImageFilesController:handleCropEvent: baseEncodedData = " + baseEncodedData);
        var appEvent = $A.get("e.c:FinishCropEvent");
        appEvent.fire();
    }
})