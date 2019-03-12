({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
     var action = component.get("c.fetchLookUpValues");
     if(component.get("v.isCarrier")){
          action=component.get("c.fetchLookUpWiningCarrierValues");
       }
      // set param to method  
        action.setParams({
            'searchfilter' : component.get("v.conditionval"),
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName")
          });
        var tempval =component.get("v.objectAPIName");
        console.log('The objectAPIName is:'+tempval);
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            if(response!=null){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                //alert(storeResponse);
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse!=null && storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
           }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
})