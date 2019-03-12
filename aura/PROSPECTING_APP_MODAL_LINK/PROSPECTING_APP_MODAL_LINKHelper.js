({
    fireReturnValueEvent : function(component) {
        
        var ThisIsCalledFrom = component.get("v.calledFrom");
        
        if (ThisIsCalledFrom == "Contact Details"){
            var returnValEvent = component.getEvent("modalReturnValueExistingContactFromLink");
            returnValEvent.setParams({"sobjectRecord" : component.get("v.sobjectRecord")});
            returnValEvent.fire();
        } else if (ThisIsCalledFrom == "Competitor Details") {
            var returnValEvent = component.getEvent("modalReturnValueExistingCompetitorFromLink");
            returnValEvent.setParams({"sobjectRecord" : component.get("v.sobjectRecord")});
            returnValEvent.fire();            
        } 
            else {
                var returnValEvent = component.getEvent("modalReturnValueEventFromLink");
                returnValEvent.setParams({"sobjectRecord" : component.get("v.sobjectRecord")});
                returnValEvent.fire();
            }
    }
})