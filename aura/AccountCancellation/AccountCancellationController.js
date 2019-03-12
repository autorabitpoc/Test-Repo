({
    AccountCancellation : function(component, event, helper) {
        var CancellationType = component.get("v.CancellationType");
        if(CancellationType != ""){
            helper.Cancellation(component, event, helper);         
        }
    },
})