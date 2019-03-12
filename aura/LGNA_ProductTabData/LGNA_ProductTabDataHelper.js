({
	helperdoInit : function(component, event, helper) {
        var curAccount = component.get("v.recordId");
        var action = component.get("c.getaccDetails");
        action.setParams({"accountId":curAccount});
        action.setCallback(this, function(response)
                            { 
                                var state = response.getState();                                 
                                if (state === "SUCCESS") 
                                {
                                    if(response.getReturnValue()!==null){  
                                        component.set("v.accDetails" ,response.getReturnValue());
                                       //component.set("v.recordtypename" ,response.getReturnValue().RecordTypeId);
                                        console.log('test today rec'+response.getReturnValue().RecordTypeId); 
                                        //alert('test sujatha'+component.get("v.recordtypename"));
                                    }
                                } 
                            });
         $A.enqueueAction(action);
        
		
	}
})