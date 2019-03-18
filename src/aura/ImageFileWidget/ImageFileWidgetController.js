({
    init : function(component, event, helper) {
        var fileName = component.get("v.fileName");
        var parts = fileName.split("_");
        fileName = "custom_" + parts[1];
        console.log("ImageFileWidgetController:init: fileName = " + fileName);
        component.set("v.fileName", fileName);
        var recordId = component.get("v.recordId");
        console.log("ImageFileWidgetController:init: recordId = " + recordId);
        var contentVersionId = component.get("v.contentVersionId");
        console.log("ImageFileWidgetController:init: contentVersionId = " + contentVersionId);
    },

    handleUploadFinished : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        uploadedFiles.forEach(function(item){
            var fileName = component.get("v.fileName");
            var contentId = item.documentId;
            console.log("ImageFileWidgetController:handleUploadFinished: name = " + fileName);
            console.log("ImageFileWidgetController:handleUploadFinished: documentId = " + contentId);
            helper.updateContentDocument(component, contentId, fileName).then(

                $A.getCallback(function(result) {
                    console.log("ImageFileWidgetController:handleUploadFinished: result 1 = " + JSON.stringify(result));
                    var appEvent = $A.get("e.c:ImageUploadEvent");
                    appEvent.setParams({
                        "fileName" : fileName,
                        "contentId" : contentId
                    });
                    appEvent.fire();
                }),

                $A.getCallback(function(error) {
                    console.log("ImageFileWidgetController:handleUploadFinished: 1st Promise was rejected: ", error);
                })
            );
        });
    }
})