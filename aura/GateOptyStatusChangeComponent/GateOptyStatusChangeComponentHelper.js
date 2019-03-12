({
	initializeRecords : function(component, event) {
		var action = component.get("c.getOptyList");
        action.setParams({"GateId":component.get("v.recordId")});// "a4E4D0000003qrMUAQ"
        action.setCallback(this, function(result){
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                component.set("v.optyList",result.getReturnValue());
                if(component.get("v.optyList").length === 0){
                    component.set("v.disableButton",true);
                }
            }
        });
        $A.enqueueAction(action);
	},
    initializeRecords1 : function(component, event) {
		var action = component.get("c.getSelectedOpty");
        action.setParams({"Ids":component.get("v.SelectedOptyIds")});// "a4E4D0000003qrMUAQ"
        action.setCallback(this, function(result){
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                //var selIds = component.get("v.SelectedOptys");
                var results = result.getReturnValue();
                /*for(var i=0;i<results.length;i++){
                    if(selIds.indexOf(results.OptyId)>-1){
                        results.isSelected=true;
                    }
                }*/
                component.set("v.SelectedOptys",results);
                if(component.get("v.optyList").length === 0){
                    component.set("v.disableButton",true);
                }
            }
        });
        $A.enqueueAction(action);
	}
})