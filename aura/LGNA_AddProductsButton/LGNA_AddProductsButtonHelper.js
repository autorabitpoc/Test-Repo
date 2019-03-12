({
	getData : function(cmp) {

        var opprec = cmp.get("v.Opportunityrecord"); 
       // alert(opprec);
        var hcscdivision = opprec.HCSC_Division__c;
        //alert(hcscdivision);
        var action = cmp.get("c.getOppProducts");
        action.setParams({
            "hcscSate":hcscdivision
        })
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert(state);
                //alert("mydata"+ JSON.stringify(response.getReturnValue()));
                var res = response.getReturnValue();
                cmp.set('v.productData', response.getReturnValue());//oppProduct
                cmp.set('v.mydataTempList',res);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getCustomOrderList: function(cmp){
        var action =cmp.get("c.getCustomMetadataAccountProductsOrder");
        
         action.setCallback(this, function (response) {
            var state = response.getState();
             var orderMap=new Map();
            if (state === "SUCCESS") {
                //alert(state);
                //alert("mydata"+ JSON.stringify(response.getReturnValue()));
               var res = response.getReturnValue();
                if(response!==null){
                    for(var key in res){
                        console.log('map key::'+key+'value::'+res[key]);
                        orderMap.set(key,res[key]);
                    }
                    console.log('orderMap::'+orderMap);
                  cmp.set("v.customOrderMap", orderMap);
                
                  console.log("order info:::"+JSON.stringify(response.getReturnValue()));
                  }
                            
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },
    /*
    callServer : function(component,method,callback,params) {
        console.log("method: "+method);
        var action = component.get(method);
        
        if (params) {
            action.setParams(params);
        }
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") { 
                // pass returned value to callback function
                callback.call(this,response.getReturnValue()); 
                var todaylist =response.getReturnValue();
                console.log('test response final'+JSON.stringify(todaylist));
               //   console.log('Record is saved successfully');
           component.destroy();
                
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
    }*/

  
    sortCurrentTable :function(cmp, currentTableMap){
        
      var orderMap=cmp.get("v.customOrderMap");
      var orderList=[];
      var indexMap=new Map();
      var sortedTable=[];
        
        if(currentTableMap!==null && currentTableMap.length>0 && orderMap!==null){
            console.log(" orderMap::"+orderMap.size);
            orderMap.forEach(function (value, key, mapObj)  {
                console.log("key::"+key);
               // orderList.push({value:orderMap[key], key:key});
                for(var index in currentTableMap){
                    if(currentTableMap[index].key===key){
                        console.log("currentMap Key::"+currentTableMap[index].key);
                        sortedTable.push({value:currentTableMap[index].value, key:currentTableMap[index].key});
                        indexMap.set(index,index);
                        console.log('addIndex to indexMap:::'+index);
                    }
                }   
            });
            
            //get the remaine data
         
            for(var i in currentTableMap){
                console.log(' index i:'+i);
                if(!indexMap.has(i)){//not being added
                   
                    sortedTable.push({value:currentTableMap[i].value, key:currentTableMap[i].key});
                    console.log('adding remaining::'+currentTableMap[i].key);
                }
            }
            
            console.log('sortedtable size:'+sortedTable.length);
            cmp.set("v.currentOppProductsMapFinal", sortedTable); 
        }
   }   
})