({
    init: function (component, event, helper) {
        window.name = "ImageFilePreview";
        helper.retrieveVersionData(component).then(
            $A.getCallback(function (result) {
                console.log("ImageFilePreviewController:init: result 1 = success...");
                component.set("v.versionDataMap", result);
                component.set("v.imgSrc", result["VersionData"]);
                component.set("v.imgTitle", result["Title"]);
                console.log("imgTitle = " + component.get("v.imgTitle"));
            }),

            $A.getCallback(function (error) {
                console.log("ImageFilePreviewController:init: 1st Promise was rejected: ", error);
            })
        )
    },

    handleImageClick: function (component, event, helper) {
        console.log("ImageFilePreviewController:handleImageClick: fire");
        var appEvent = $A.get("e.c:ImagePreviewClickEvent");
        appEvent.setParams({
            "location" : "image",
            "data" : component.get("v.imgSrc")
        });
        appEvent.fire();
    },

    handleDownloadClick: function (component, event, helper) {
        console.log("ImageFilePreviewController:handleDownloadClick: fire");
        var appEvent = $A.get("e.c:ImagePreviewClickEvent");
        appEvent.setParams({
            "location" : "download"
        });
        appEvent.fire();
    },

    handleOptionsClick: function (component, event, helper) {
        console.log("ImageFilePreviewController:handleOptionsClick: fire");
        var appEvent = $A.get("e.c:ImagePreviewClickEvent");
        appEvent.setParams({
            "location" : "options"
        });
        appEvent.fire();
    }
})