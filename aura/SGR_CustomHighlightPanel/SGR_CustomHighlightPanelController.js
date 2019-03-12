({
	handleRecordUpdated : function(component, event, helper) {
		var dsAction = event.getParams();
        if (dsAction.changeType === 'LOADED') {
            console.log('Record loaded successfully');
        } else if (dsAction.changeType === 'ERROR') {
            console.log('Error');
        }
	}
})