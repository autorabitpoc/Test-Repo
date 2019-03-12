({
	fireReturnValueEvent : function(component) {
		var returnValEvent = component.getEvent("modalReturnValueEventFromButton");
        returnValEvent.setParams({"sobjectRecord" : component.get("v.sobjectRecord")});
        returnValEvent.fire();
	}
})