({ 
    createRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Ticket__c"
        });
        createRecordEvent.fire();
    }
})