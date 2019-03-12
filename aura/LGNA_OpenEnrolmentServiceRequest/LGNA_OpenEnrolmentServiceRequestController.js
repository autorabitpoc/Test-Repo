({ 
   createRecord: function(component, event, helper) {
      var action = component.get("c.getServiceReqRecTypeId");
      var recordTypeLabel = 'Open Enrollment';
      action.setParams({
         "recordTypeLabel": recordTypeLabel,
         
      });
       
      action.setCallback(this, function(response) {
         var opptyId=component.get("v.OpptyId");
         var accountId = component.get("v.AccountId");
         var state = response.getState();
         if (state === "SUCCESS") {
              console.log('test inside success '+state);
            var createRecordEvent = $A.get("e.force:createRecord");
            var RecTypeID  = response.getReturnValue();
            createRecordEvent.setParams({
               "entityApiName": 'Service_Request__c',
               "recordTypeId": RecTypeID,
               "defaultFieldValues": {
            	'Account__c' : accountId,
                   'Opportunity_Name__c' : opptyId,
   		 		}
            });
            createRecordEvent.fire();
             
         } else if (state == "INCOMPLETE") {
              console.log('test inside INCOMPLETE '+state);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               "title": "Oops!",
               "message": "No Internet Connection"
            });
            toastEvent.fire();
             
         } else if (state == "ERROR") {
             console.log('test inside error '+state);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               "title": "Error!",
               "message": "Please contact your administrator"
            });
            toastEvent.fire();
         }
      });
      $A.enqueueAction(action);
   },
})