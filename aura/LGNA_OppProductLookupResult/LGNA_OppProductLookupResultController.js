({
   selectRecord : function(component, event, helper){      
    // get the selected record from list  
      var getSelectRecord = component.get("v.oRecord");
      var getoCondition = component.get("V.oCondition");
    // call the event   
      var compEvent = component.getEvent("oSelectedRecordEvent");
    // set the Selected sObject Record to the event attribute.  
         compEvent.setParams({"recordByEvent" : getSelectRecord });  
         compEvent.setParams({"ProductLookupCondition" : getoCondition });  
       
    // fire the event  
         compEvent.fire();
    },
})