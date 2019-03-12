({
    // Show and Hide Sections 
    ExpandCollapseSection : function(component,event,secId) {
        var acc = component.find(secId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },    
    
    fetchPickListVal: function(component, fieldName, elementId) {
        
        console.log('loading options for---> '+fieldName);
        
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
             //   console.log('allValues: test' + allValues);
                
                //convert the String to JSON for parsing
                var allValuesJSON = JSON.parse(allValues);                
                
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                
                for (var i=0; i < allValuesJSON.length; i++) { 
                  //   console.log('allValuesJSON: test' + allValuesJSON);
                    if(allValuesJSON[i].value === component.get("v.editRecord").fieldName){
                        opts.push({
                            class: "optionClass",
                            label: allValuesJSON[i].label,
                            value: allValuesJSON[i].value,
                            selected: "true"                        
                        });
                    }else{
                        opts.push({
                            class: "optionClass",
                            label: allValuesJSON[i].label,
                            value: allValuesJSON[i].value
                        });                            
                    }
                }                
                component.find(elementId).set("v.options", opts);
            }else{
               console.log('Not Success - response.getState: ' + response.getState()); 
            }
        });
        $A.enqueueAction(action);
    },
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