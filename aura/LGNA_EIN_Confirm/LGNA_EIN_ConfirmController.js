({
	compInit : function(component, event, helper) {
        console.log("value of v.recordId is " + component.get("v.recordId"));
		var action = component.get("c.returnEIN");
        action.setParams({Accid: component.get("v.recordId")});
        action.setCallback(this,function(response){
           var name = response.getState();
            if (name === 'SUCCESS'){
                console.log("first program run is success");
                component.set("v.reg",response.getReturnValue());
                console.log("value of v.reg is :" + component.get("v.reg"));

                if(response.getReturnValue().length>0){
                    component.set("v.disableButton",false);
                } else {
                    component.set("v.noNewRecords",true);
                }
                if(response.getReturnValue().length===1){
                    component.set("v.singleEinOnly",true)
                }
                
                // Retrieve the Send in progress records only after loading the records in progress. This is to allow server to reset the records 
                // stuck with retrieving sequence number for more than an hour and not showing them as in progress. 
        	    var a = component.get('c.getSendProgress');
    			$A.enqueueAction(a);                
            }
        });
        $A.enqueueAction(action);

		var action1 = component.get("c.sentEIN");
        action1.setParams({Accid: component.get("v.recordId")});
        action1.setCallback(this,function(response1){
           var name1 = response1.getState();
            if (name1 === 'SUCCESS'){
                console.log("second program run is success");
                component.set("v.sent",response1.getReturnValue());
                console.log("value of v.sent is :" + component.get("v.sent"));
                if(response1.getReturnValue().length>0){
                    component.set("v.sentRecords",true);
                } else {
                    component.set("v.noSentRecords",true);
                }
            }
        });
        $A.enqueueAction(action1);        
        

	},
    
    getSendProgress : function(component,event,helper){
		var action2 = component.get("c.sendProgress");
        action2.setParams({Accid: component.get("v.recordId")});
        action2.setCallback(this,function(response2){
           var name2 = response2.getState();
            if (name2 === 'SUCCESS'){
                console.log("third program run is success");
                component.set("v.sending",response2.getReturnValue());
                console.log("value of v.sending is :" + component.get("v.sending"));
                if(response2.getReturnValue().length>0){
                    component.set("v.sendingRecords",true);
                } else {
                    component.set("v.noSendingRecords",true);
                }
            } else{
                console.log("third program run is failure");
            }
        });
        $A.enqueueAction(action2);                        
    },
    
    sendEIN : function(component,event,helper){
		component.set("v.srvErrorMsg", '');
        component.set("v.showSrvError", false);
    	var action = component.get("c.transmitEIN");
        action.setParams({Accid: component.get("v.recordId")});
        action.setCallback(this,function(response){
           var state = response.getState();
           console.log("Response state::" + state);
            if (state === 'SUCCESS'){
                component.set("v.disableButton",true);
                component.set("v.showSuccess",true);
                alert("EIN transmission has been initiated successfully.");
            } else if (state === "ERROR") {
                var errors = response.getError();
                var msg = 'Unknown error. Please contact support.';
                if (errors && Array.isArray(errors) && errors.length>0) {
                    msg = errors[0].message;
                    console.log("Transmission error::" + errors[0].message);
                }
                component.set("v.srvErrorMsg", msg);
                component.set("v.showSrvError", true);
            }
        });
        $A.enqueueAction(action);
},
    handleRecordUpdated : function(component,event,helper){
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            component.set("v.showAcctErrors",true);
                console.log('value of v.simpleRecord.Name is ' + component.get("v.simpleRecord.Name"));
                console.log('value of v.simpleRecord.External_ID__c is ' + component.get("v.simpleRecord.External_ID__c"));
                console.log('value of v.simpleRecord.Effective_Date__c is ' + component.get("v.simpleRecord.Effective_Date__c"));
                console.log('value of v.simpleRecord.Market_Segment__c is ' + component.get("v.simpleRecord.Market_Segment__c"));
                console.log('value of v.simpleRecord.HCSC_Division__c is ' + component.get("v.simpleRecord.HCSC_Division__c"));            
         	if(component.get("v.simpleRecord.Name") != null
                   && component.get("v.simpleRecord.External_ID__c") != null
                   && component.get("v.simpleRecord.Effective_Date__c") != null
                   && component.get("v.simpleRecord.Market_Segment__c") != null
                   && component.get("v.simpleRecord.HCSC_Division__c") != null
                  ){
                    component.set("v.disableButton1",false);
                }
        }
},
})