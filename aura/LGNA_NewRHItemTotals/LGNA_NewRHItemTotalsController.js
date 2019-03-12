({
    doInit : function(component, event, helper) {
        
        var recId = component.get("v.recordId");
        var objectName = component.get("v.sObjectName");
        var itemName = component.get("v.itemName");
        
        console.log("LGNA_NewRHItemTotals doInit: "+recId+ " objectName: "+objectName+" itemName: "+itemName);        
        
        helper.callServer(component,
                          "c.fetchItemTotals",
                          function(response){
                              
                              console.log('fetchItemTotals response: ' + response );
                              component.set("v.JSONString", response);
                              
                              var allValues = response;
                              
                              //convert the String to JSON for parsing
                              var allValuesJSON = JSON.parse(allValues);                              
                              
                              component.set("v.countCurrent",allValuesJSON.Current);
                              component.set("v.countYTD",allValuesJSON.YTD);

                              
                          },{
                              itemName:itemName,
                              theObjectID:recId,
                              theObject:objectName
                          }
                         );
    }    
})