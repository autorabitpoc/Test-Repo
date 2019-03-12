({
	doInit : function(component, event, helper) {
        
        var action = component.get("c.getAdditionalInputRequired");
        action.setParams({
            "caseId" : component.get("v.recordId")
        });
        
        action.setCallback(this,function(response){
                        var state = response.getState();
        				if(state ===  "SUCCESS")
            			{
                			$A.get('e.force:refreshView').fire(); 
                			$A.get("e.force:closeQuickAction").fire();
                
            			}	
           		});
        $A.enqueueAction(action);
		
	}
})