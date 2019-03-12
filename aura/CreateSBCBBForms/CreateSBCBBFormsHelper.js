({
	genericShowToast : function(title,mode,message,type){
        var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": title,
                    "message": message,
                    "mode": mode,
                    "type":type
                });
                toastEvent.fire();        
    },
})