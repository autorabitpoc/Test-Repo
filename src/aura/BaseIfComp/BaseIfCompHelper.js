({
    apexPromise: function (action) {
        return new Promise(function(resolve, reject){
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    resolve(response.getReturnValue());
                }else{
                    reject(Error("apexPromise failed with state = " + state));
                }
            });
            $A.enqueueAction(action);
        });
    }
})