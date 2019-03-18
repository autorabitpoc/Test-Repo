({
    retrieveVfHostUrl: function (component) {
        var helper = this;
        var action = component.get("c.getHostUrl");
        return helper.apexPromise(action);
    },

    retrieveInitialImages: function (component) {
        var helper = this;
        var action = component.get("c.getInitialImageData");
        var recordId = component.get("v.recordId");
        console.log("DealerImageFilesHelper:retrieveDefaultImages: recordId = " + recordId);
        action.setParams({
            "recordId" : recordId
        });
        return helper.apexPromise(action);
    },

    renderInitialComponents: function (component) {
        var helper = this;
        var imageInfoMap = component.get("v.imageInfoMap");
        var iconPromise = null;
        if(imageInfoMap.hasOwnProperty("custom_icon")){
            iconPromise = helper.renderImageWidget(component, "custom_icon", null);
        }else{
            iconPromise = helper.renderImageWidget(component, "automatic_icon", null);
        }
        if(imageInfoMap.hasOwnProperty("custom_hero")){
            return helper.renderImageWidget(component, "custom_hero", iconPromise);
        }
        return helper.renderImageWidget(component, "automatic_hero", iconPromise);
    },

    renderImageWidget: function (component, fileName, followPromise) {
        var helper = this;
        var cmpName = "ImageFileWidget";
        var imageInfoMap = component.get("v.imageInfoMap");
        var cvId = imageInfoMap[fileName];
        var recordId = component.get("v.recordId");
        var attrMap = {
            "fileName" : fileName,
            "recordId" : recordId,
            "contentVersionId" : cvId
        };
        return helper.renderCmp(component, cmpName, attrMap, followPromise);
    },

    renderCmp: function (component, cmpName, attrMap, followPromise) {
        return new Promise(function (resolve, reject) {
            var targetId = (followPromise != null) ? "subContent1" : "subContent2";
            var cmpTarget = component.find(targetId);
            attrMap = (attrMap == null)? {} : attrMap;
            attrMap["aura:id"] = cmpName + "Id" + ((followPromise != null) ? "1" : "2");
            $A.createComponent(
                "c:" + cmpName,
                attrMap,
                function (newCmp, status, errorMessage) {
                    if (status === "SUCCESS") {
                        cmpTarget.set("v.body", newCmp);
                        if(followPromise != null){
                            return followPromise;
                        }else{
                            resolve("FINAL");
                        }
                    } else if (status === "INCOMPLETE") {
                        console.log("DealerImageFilesHelper:renderSplashCmp: No response from server or client is offline.")
                        reject(false)
                    } else if (status === "ERROR") {
                        console.log("DealerImageFilesHelper:renderSplashCmp: Error = " + errorMessage);
                        reject(false)
                    } else {
                        console.log("DealerImageFilesHelper:renderSplashCmp: failed with status = " + status + " and errorMessage = " + errorMessage);
                        reject(false)
                    }
                }
            );
        });
    },

    createPreviewModal: function (component, imgSrc) {
        var modalBody;
        $A.createComponent("c:ImageFileModal", {"imgSrc":imgSrc},
            function (content, status) {
                if (status === "SUCCESS") {
                    modalBody = content;
                    component.find('overlayLib').showCustomModal({
                        header: "Preview File",
                        body: modalBody,
                        showCloseButton: true,
                        cssClass: "modal-styley slds-scrollable_none cImageFileModal slds-modal_large",
                        closeCallback: function () {
                            console.log("DealerImageFilesHelper:createPreviewModal: closed");
                        }
                    })
                }
            });
    },

    createCropperModal: function (component, fileName, contentId) {
        var helper = this;
        var modalBody;
        var modalFooter;
        $A.createComponents([
                ["c:ImageCropper",{
                    "contentId":contentId,
                    "recordId":component.get("v.recordId"),
                    "vfHost":component.get("v.vfHost")
                }],
                ["c:CropperFooter",{}]
            ],
            function(components, status){
                if (status === "SUCCESS") {
                    modalBody = components[0];
                    modalFooter = components[1];
                    component.find('overlayLib').showCustomModal({
                        header: "Crop Image",
                        body: modalBody,
                        footer: modalFooter,
                        showCloseButton: false,
                        cssClass: "modal-styley slds-scrollable_none cImageCropper slds-modal_large",
                        closeCallback: function() {
                            console.log("DealerImageFilesHelper:createCropperModal: closed");
                            component.set("v.isLoading", true);
                            helper.runUpdate(component);
                            /*window.setTimeout(
                                $A.getCallback(function() {
                                    helper.runUpdate(component);
                                }), 1000
                            );*/
                        }
                    })
                }
            }
        );
    },

    runUpdate : function(component) {
        var helper = this;
        helper.updateImage(component).then(

            $A.getCallback(function(result) {
                console.log("DealerImageFilesHelper:runUpdate: result 1 = " + JSON.stringify(result));
                //component.set("v.isLoading", false);
                $A.get('e.force:refreshView').fire();
            }),

            $A.getCallback(function(error) {
                console.log("DealerImageFilesHelper:runUpdate: 1st Promise was rejected: ", error);
                component.set("v.isLoading", false);
            })
        );
    },

    updateImage : function(component) {
        var helper = this;
        var action = component.get("c.updateImageData");
        var contentId = component.get("v.finalContentId");
        var imgSrc = component.get("v.imgSrc");
        var recordId = component.get("v.recordId");
        console.log("ImageCropperHelper:updateImage: Enter");
        action.setParams({
            "contentId" : contentId,
            "recordId" : recordId,
            "baseEncodedData" : imgSrc
        });
        return helper.apexPromise(action);
    }
})