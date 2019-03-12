({
	callServer : function(component,method,callback,params) {
        console.log("method: "+method);
    var action = component.get(method);
 
    if (params) {
        action.setParams(params);
    }
    
        
   // debugger;
       // console.log("parameter: "+params);
        
      action.setCallback(this, function(response) {
          
        var state = response.getState();
         console.log(state);
        if (state === "SUCCESS") { 
            // pass returned value to callback function
            callback.call(this,response.getReturnValue());   
        } else if (state === "ERROR") {
            // generic error handler
            var errors = response.getError();
            
            if (errors) {
                console.log("Errors", errors);
                if (errors[0] && errors[0].message) {
                    throw new Error("Error" + errors[0].message);
                }
            } else {
                throw new Error("Unknown Error");
            }
        }
    });
    
    $A.enqueueAction(action);
  }
})