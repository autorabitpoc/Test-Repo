({
    save: function(component,event,helper)
    {
        var accid= component.get("v.accountId");
        var oppdetailRecord = component.get("v.newopp");
        //console.log('ren  test'+JSON.stringify(oppdetailRecord));
        var saveaction = component.get("c.insertRenewaloppRec");
        saveaction.setParams({
            "accountId" :accid,
            "newRec": oppdetailRecord
        });
        saveaction.setCallback(this, function(response)
                               { 
                                   var state = response.getState();  
                                   //console.log('test suajtha sep18'+state);                               
                                   if (state === "SUCCESS") {
                                       var url= '/'+response.getReturnValue().Id;
                                       console.log('----------->'+url);
                                       window.open(url,"_parent");
                                       $A.get("e.force:closeQuickAction").fire();
                                   }
                                   
                               });
        $A.enqueueAction(saveaction);   
    }
    
})