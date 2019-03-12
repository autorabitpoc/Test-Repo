({
    getLoggedinUsers : function(component, event) {
        var action = component.get("c.getloggedinuserinfo");
        action.setCallback(this, 
                           function(response){
                               var state = response.getState();
                               if(state === "SUCCESS"){
                                   var storeResponse = response.getReturnValue();
                                   
                                   component.set("v.userinfo", storeResponse);
                               }
                           });
        $A.enqueueAction(action);
    }
})