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
  },
    
  removePopover: function(component){
     var closeEvent=component.getEvent("RemoveComponent");
      console.log('ready for closing pop over:'+closeEvent);
      closeEvent.setParams({"comp":component});
      closeEvent.fire();
  },
    closePopover: function(component){
        var popOverComp =component.get('v.hoverComponent');// component.get('v.hoverPromise');//component.get('v.hoverComponent');
         
        console.log('overlayComponent: '+popOverComp);
        if(popOverComp!=null){
            popOverComp.close();
            console.log('closing from Child: '+popOverComp);
        }
    }
})